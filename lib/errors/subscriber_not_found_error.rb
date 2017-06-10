class SubscriberNotFoundError < StandardError
  def initialize(message)
    @message = message
  end

  def to_s
    @message
  end
end
