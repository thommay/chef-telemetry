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

  OPT_OUT_FILE = "telemetry_opt_out"

  attr_writer :endpoint, :origin
  attr_reader :session, :event, :client

  attr_accessor :product

  def origin
    @origin ||= "command-line"
  end

  def opted_out?
    @opted_out.nil? ? find_opt_out : @opted_out
  end

  def find_opt_out
    @opted_out = false

    if ENV["CHEF_TELEMETRY_OPT_OUT"]
      @opted_out = true
      return @opted_out
    end

    full_path = working_directory.split(File::SEPARATOR)
    (full_path.length - 1).downto(0) do |i|
      candidate = File.join(full_path[0..i], ".chef", OPT_OUT_FILE)
      if File.exist?(candidate)
        puts "Found opt out at: #{candidate}"
        @opted_out = true
        break
      end
    end
    @opted_out
  end

  def working_directory
    a = if windows?
          ENV["CD"]
        else
          ENV["PWD"]
        end || Dir.pwd

    a
  end

  def windows?
    if RUBY_PLATFORM =~ /mswin|mingw|windows/
      true
    else
      false
    end
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
