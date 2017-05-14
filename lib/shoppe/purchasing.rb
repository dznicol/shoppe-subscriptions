module Purchasing
  def purchase(customer, subscriber, invoice)
    product = subscriber.subscription_plan.product
    if product.has_variants?
      product = if product.default_variant.present?
                  product.default_variant
                else
                  product.variants.last
                end
    end

    ActiveRecord::Base.transaction do
      # Allow exception to propogate up so that Stripe queues and retries, as that saves us
      # having to build a queuing and failed order workflow, thanks Stripe.com.
      note = if invoice.present?
               "Created for Stripe invoice #{invoice.id}"
             elsif subscriber.stripe_id.present?
               "Created for Stripe subscriber #{subscriber.stripe_id}"
             else
               "Created for customer #{customer.id}"
             end

      order = Shoppe::Order.create(notes: note, currency: subscriber.currency)
      order.customer = customer

      # All billing and delivery details need to be copied to the order. Shoppe requirement.
      order.first_name = customer.first_name.presence || '-'
      order.last_name = customer.last_name.presence || '-'

      # Try to use the billing address if there is one, otherwise use the first address registered
      address = customer.addresses.billing.first || customer.addresses.ordered.first

      order.billing_address1 = address.address1
      order.billing_address2 = address.address2
      order.billing_address3 = address.address3
      order.billing_address4 = address.address4
      order.billing_postcode = address.postcode
      order.billing_country = address.country

      # Try to use the delivery address, if there is none and there is more than 1 address use the last address
      address = customer.addresses.delivery.first
      if address.nil?
        address = customer.addresses.last if customer.addresses.count > 1
      end

      if address.present?
        order.delivery_name = subscriber.recipient_name.presence || customer.full_name
        order.delivery_address1 = address.address1
        order.delivery_address2 = address.address2
        order.delivery_address3 = address.address3
        order.delivery_address4 = address.address4
        order.delivery_postcode = address.postcode
        order.delivery_country = address.country

        order.separate_delivery_address = true
      end

      order.email_address = subscriber.recipient_email.presence || customer.email
      order.phone_number = subscriber.recipient_phone.presence || customer.phone

      order.order_items.add_item(product, 1)

      # Add any unclaimed gifts
      subscriber.gifts.unclaimed.each do |gift|
        order.order_items.add_item(gift.product, 1)
        gift.update claimed: true
      end

      order.delivery_service = order.available_delivery_services.first
      delivery_service_price = order.delivery_service_prices.first
      if delivery_service_price.present?
        order.delivery_price = delivery_service_price.try(:price) || 0
        order.delivery_tax_rate = delivery_service_price.tax_rate.try(:rate) || 0
      end

      # Allow errors to propogate back to Stripe so we don't silently forget this order
      order.save
      # Need to reload the order as the order_items do not instantly get mapped
      order.reload

      order.payments.create(amount: subscriber.subscription_plan.product.price(subscriber.currency),
                            method: 'Subscription Reallocation',
                            reference: subscriber.stripe_id,
                            refundable: false,
                            confirmed: true)

      subscriber.update balance: subscriber.balance - subscriber.subscription_plan.product.price(subscriber.currency)

      order.proceed_to_confirm
      order.confirm!
    end
  end
end
