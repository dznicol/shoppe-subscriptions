# require 'nifty/key_value_store'
#
# module Shoppe
#   module Subscriptions
#     module CustomerExtensions
#
#       key_value_store properties
#
#       def accept_stripe_token(stripe_customer_id)
#         self.properties['stripe_customer_id] = stripe_customer_id
#         self.save
#       end
#
#       def stripe_id
#         @stripe_id ||= self.properties['stripe_customer_id']
#       end
#     end
#   end
# end
