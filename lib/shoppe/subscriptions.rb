require 'shoppe/subscriptions/version'
require 'shoppe/subscriptions/engine'

require 'shoppe/stripe_events/invoice_payment_succeeded'

require 'stripe_event'

StripeEvent.configure do |events|
  events.subscribe     'invoice.payment_succeeded', InvoicePaymentSucceeded.new
end
