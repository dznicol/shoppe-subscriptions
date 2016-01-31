# require 'nifty/key_value_store'
#
# module Shoppe
#   module Subscriptions
#     module CustomerExtensions
#
#       key_value_store properties
#
#       def accept_stripe_token(stripe_customer_token)
#         self.properties['stripe_customer_token'] = stripe_customer_token
#         self.save
#       end
#
#       def stripe_token
#         @stripe_token ||= self.properties['stripe_customer_token']
#       end
#     end
#   end
# end
