class InvoicePaymentSucceeded
  def call(event)
    # Handle the incoming invoice succeeded webhook

    customer = event.data.object.customer

    # Add amount to subcriber_amount for relevant subscription

    # Auto order the product if the balance now matches (or exceeds) product cost
  end
end
