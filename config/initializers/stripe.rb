require 'stripe_event'

StripeEvent.configure do |events|
  events.subscribe 'charge.failed' do |event|
    # Define subscriber behavior based on the event object
    event.subscribe     'customer.created', CustomerCreated.new
  end

  events.all do |event|
    # Handle all event types - logging, etc.
  end
end
