require 'shoppe/purchasing'

class InvoicePaymentSucceeded
  include Purchasing

  def call(event)
    ActiveRecord::Base.transaction do
      # Handle the incoming invoice succeeded webhook

      invoice = event.data.object

      # We can't look up the subscriber object from customer, we have to record both the
      # customer ID and subscription ID when creating the subscription, so we can
      # look them back up here.
      customer = Shoppe::Customer.find_by stripe_id: invoice.customer

      # The subscription is left blank if the line item is an invoiceitem
      # First try to look up the subscription from supplied webhook data
      subscription_id = invoice.subscription || invoice.lines.data.first.try(:subscription)

      # We can no longer fall back on the customer subscriber association as this is now a has_many. That means if
      # a subscription Stripe ID's changes (for example if it is cancelled and reinstated), then we need to make
      # sure the Stripe ID in our Subscriber object is updated.
      # We now raise an error if we can't find the susbcriber so Stripe will retry, giving us a chance to get the
      # Stripe ID right in our DB.
      subscriber = Shoppe::Subscriber.find_by(stripe_id: subscription_id)

      # Add amount to balance for relevant subscription
      if subscriber.present?
        total = Shoppe::ApiHandler.native_amount invoice.total
        subtotal = Shoppe::ApiHandler.native_amount invoice.subtotal
        # Subtotal is "Total of all subscriptions, invoice items, and prorations on the invoice before any discount is applied".
        # By using subtotal means we are taking into account any discount when deciding whether there are sufficient funs
        # to trigger a purchase below.
        subscriber.update_attributes!(balance: (subscriber.balance + subtotal))

        discount_code = invoice.discount.present? ? invoice.discount.coupon.id : nil

        # Record the transaction for accounting later
        subscriber.transactions.create(total: total,
                                       subtotal: subtotal,
                                       discount_code: discount_code,
                                       transaction_type: Shoppe::SubscriberTransaction::TYPES[0])

        # Auto order the product if the balance now matches (or exceeds) product cost
        product = subscriber.subscription_plan.product

        # We can only auto order if we correctly retrieve the product price, which fails if there are
        # variants but no default variant (as Shoppe returns the 0 priced parent product!)
        product = product.variants.first if product.has_variants? && product.default_variant.nil?

        if subscriber.balance >= product.price(subscriber.currency)
          purchase(customer, subscriber, invoice)
        end
      else
        Rails.logger.warn "Cannot find subscriber with id #{subscription_id}"
        raise AddressNotAcceptableError.new("Cannot find subscriber with ID #{subscription_id}")
      end
    end
  end
end
