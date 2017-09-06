class Telemetry
  class Event

    def initialize(product, session, origin = "command-line")
      @product = product
      @session = session
      @origin = origin
    end

    SKELETON = {
      instance_id: "00000000-0000-0000-0000-000000000000",
      message_version: 1.0,
      payload_version: 1.0,
      license_id: "00000000-0000-0000-0000-000000000000",
      type:  "track",
    }

    def prepare(event)
      body = SKELETON.dup
      ts = Time.now.utc.strftime("%FT%TZ")
      event[:properties][:timestamp] = ts
      puts "product is #{@product}"
      body.tap do |c|
        c[:session_id] = @session.id
        c[:origin] = @origin
        c[:product] = @product
        c[:timestamp] = ts
        c[:payload] = event
      end
    end
  end
end
