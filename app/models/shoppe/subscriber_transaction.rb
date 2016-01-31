module Shoppe::Subscriptions
  class SubscriberTransaction < ActiveRecord::Base
    belongs_to :subscriber
  end
end
