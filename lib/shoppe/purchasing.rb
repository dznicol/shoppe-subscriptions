module Purchasing
  def purchase(customer, subscriber, invoice)
    product = subscriber.subscription_plan.product
    if product.has_variants?
      if product.default_variant.present?
        product = product.default_variant
      else
        product = product.variants.last
      end
    end

    ActiveRecord::Base.transaction do
      # Allow exception to propogate up so that Stripe queues and retries, as that saves us
      # having to build a queuing and failed order workflow, thanks Stripe.com.
      if invoice.present?
        note = "Created for Stripe invoice #{invoice.id}"
      elsif subscriber.stripe_id.present?
        note = "Created for Stripe subscriber #{subscriber.stripe_id}"
      else
        note = "Created for customer #{customer.id}"
      end

      order = Shoppe::Order.create(notes: note)
      order.customer = customer

      # All billing and delivery details need to be copied to the order. Shoppe requirement.
      order.first_name = customer.first_name.presence || '-'
      order.last_name = customer.last_name.presence || '-'

      address = customer.addresses.billing.first
      order.billing_address1 = address.address1
      order.billing_address2 = address.address2
      order.billing_address3 = address.address3
      order.billing_address4 = address.address4
      order.billing_postcode = address.postcode
      order.billing_country = address.country

      address = customer.addresses.delivery.first
      order.delivery_name = customer.full_name
      order.delivery_address1 = address.address1
      order.delivery_address2 = address.address2
      order.delivery_address3 = address.address3
      order.delivery_address4 = address.address4
      order.delivery_postcode = address.postcode
      order.delivery_country = address.country

      # FIXME - Detect separate delivery address
      order.separate_delivery_address = true

      order.email_address = customer.email
      order.phone_number = customer.phone

      order.order_items.add_item(product, 1)
      # Need to reload the order as he order_items do not instantly get mapped
      order.reload

      order.payments.create(amount: subscriber.subscription_plan.product.price,
                            method: 'Subscription Reallocation',
                            reference: subscriber.stripe_id,
                            refundable: false,
                            confirmed: true)

      subscriber.update balance: subscriber.balance - subscriber.subscription_plan.product.price

      order.proceed_to_confirm
      order.confirm!
    end
  end
end
