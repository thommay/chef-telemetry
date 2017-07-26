require "telemetry/client"
require "telemetry/event"
require "telemetry/no_op"
require "telemetry/session"
require "telemetry/version"

class Telemetry
  def initialize(&block)
    yield self if block_given?
    @client = if opted_out?
                NoOp.new
              else
                Client.new(endpoint)
              end
    @session = Session.id
    @event = Event.new(product, session, origin)
  end

  attr_writer :endpoint, :origin
  attr_reader :session, :event, :client

  attr_accessor :product

  def origin
    @origin ||= "command-line"
  end

  def opted_out?
    # FIXME: opt out handling
    false
  end

  def send(data = {})
    return if opted_out?
    payload = event.format(data)
    client.await.fire(payload)
  end

  def endpoint
    # FIXME: Use production URL
    @endpoint ||= ENV.key?("CHEF_TELEMETRY_ENDPOINT") ? ENV["CHEF_TELEMETRY_ENDPOINT"] : "https://telemetry-acceptance.chef.io/events"
  end
end
