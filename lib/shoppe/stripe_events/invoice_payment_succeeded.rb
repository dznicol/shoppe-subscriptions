require 'shoppe/purchasing'

class InvoicePaymentSucceeded
  include Purchasing

  def call(event)
    # Handle the incoming invoice succeeded webhook

    invoice = event.data.object

    # We can't look up the subscriber object from customer, we have to record both the
    # customer token and subscription token when creating the subscription, so we can
    # look them back up here.
    customer = Shoppe::Customer.find_by_stripe_token invoice.customer
    subscriber = Shoppe::Subscriber.find_by_stripe_token invoice.subscription

    # Add amount to balance for relevant subscription
    if subscriber.present?
      amount = invoice.total / 100.0
      subscriber.update_attribute(:balance, (subscriber.balance + amount))
    end

    # Auto order the product if the balance now matches (or exceeds) product cost
    if subscriber.balance >= subscriber.subscription_plan.product.price
      purchase(customer, subscriber, invoice)
    end
  end
end
