require "http"
require "concurrent"

class Telemetry
  class Client
    include Concurrent::Async

    attr_reader :http
    def initialize(endpoint)
      super()
      @http = HTTP.persistent("https://telemetry-acceptance.chef.io")
    end

    def fire(event)
      http.post("/events", json: event).flush
    end
  end
end
