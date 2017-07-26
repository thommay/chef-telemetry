require "securerandom"

class Telemetry
  class Session
    def self.id
      SecureRandom.uuid
    end
  end
end
