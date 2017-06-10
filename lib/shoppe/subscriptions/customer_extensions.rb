Shoppe::Customer.class_eval do
  has_many :subscribers, class_name: 'Shoppe::Subscriber', inverse_of: 'customer'
end
