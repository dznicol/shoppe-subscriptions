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
      order = Shoppe::Order.create(notes: "Created for Stripe invoice #{invoice.id}")
      order.customer = customer

      # All billing and delivery details need to be copied to the order. Shoppe requirement.
      order.first_name = customer.first_name
      order.last_name = customer.last_name

      address = customer.addresses.first

      order.billing_address1 = address.address1
      order.billing_address2 = address.address2
      order.billing_address3 = address.address3
      order.billing_address4 = address.address4
      order.billing_postcode = address.postcode
      order.billing_country = address.country
      order.delivery_name = customer.full_name
      order.delivery_address1 = address.address1
      order.delivery_address2 = address.address2
      order.delivery_address3 = address.address3
      order.delivery_address4 = address.address4
      order.delivery_postcode = address.postcode
      order.delivery_country = address.country
      order.email_address = customer.email
      order.phone_number = customer.phone

      order.order_items.add_item(product, 1)

      order.payments.create(amount: subscriber.subscription_plan.product.price,
                            method: 'Subscription Reallocation',
                            reference: subscriber.stripe_token,
                            refundable: false,
                            confirmed: true)

      subscriber.update balance: subscriber.balance - subscriber.subscription_plan.product.price

      order.proceed_to_confirm
      order.confirm!
    end
  end
end
