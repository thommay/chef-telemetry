require "http"
require "concurrent"
require "pp"

class Telemetry
  class Client
    include Concurrent::Async

    attr_reader :http
    def initialize(endpoint)
      super()
      @http = HTTP.persistent("https://telemetry-acceptance.chef.io")
    end

    def fire(event)
      pp event
      http.post("/events", json: event).flush
    end
  end
end
