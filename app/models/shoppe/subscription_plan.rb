module Shoppe
  class SubscriptionPlan < ActiveRecord::Base
    include ApiHandler

    self.table_name = 'shoppe_subscription_plans'

    # Validations
    validates :name, presence: true
    validates :amount, presence: true
    validates :interval, presence: true

    # Attachments for this product
    has_one :product, class_name: "Shoppe::Product"

    # # Orders which are assigned to this delivery service
    # has_many :orders, dependent: :restrict_with_exception, class_name: 'Shoppe::Order'
    #
    # # Prices for the different levels of service within this delivery service
    # has_many :delivery_service_prices, dependent: :destroy, class_name: 'Shoppe::DeliveryServicePrice'
    #
    # # All active delivery services
    # scope :active, -> { where(active: true)}
    #
    # # Returns a tracking URL for the passed order
    # #
    # # @param order [Shoppe::Order]
    # # @return [String] the full URL for the order.
    # def tracking_url_for(order)
    #   return nil if self.tracking_url.blank?
    #   tracking_url = self.tracking_url.dup
    #   tracking_url.gsub!("{{consignment_number}}", CGI.escape(order.consignment_number.to_s))
    #   tracking_url.gsub!("{{delivery_postcode}}", CGI.escape(order.delivery_postcode.to_s))
    #   tracking_url.gsub!("{{billing_postcode}}", CGI.escape(order.billing_postcode.to_s))
    #   tracking_url
    # end

  end
end
