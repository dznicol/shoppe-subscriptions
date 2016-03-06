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
      total = Shoppe::ApiHandler.native_amount invoice.total
      subtotal = Shoppe::ApiHandler.native_amount invoice.subtotal
      # Subtotal is "Total of all subscriptions, invoice items, and prorations on the invoice before any discount is applied".
      # By using subtotal means we are taking into account any discount when deciding whether there are sufficient funs
      # to trigger a purchase below.
      subscriber.update_attribute(:balance, (subscriber.balance + subtotal))

      discount_code = invoice.discount.present? ? invoice.discount.coupon.id : nil

      # Record the transaction for accounting later
      subscriber.transactions.create({total: total,
                                      subtotal: subtotal,
                                      discount_code: discount_code,
                                      type: Shoppe::SubscriberTransaction::TYPES[0]})
    end

    # Auto order the product if the balance now matches (or exceeds) product cost
    if subscriber.balance >= subscriber.subscription_plan.product.price
      purchase(customer, subscriber, invoice)
    end
  end
end
