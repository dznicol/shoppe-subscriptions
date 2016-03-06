module Shoppe::Subscriptions
  class SubscriberTransaction < ActiveRecord::Base

    TYPES = ['invoice']

    belongs_to :subscriber
  end
end
