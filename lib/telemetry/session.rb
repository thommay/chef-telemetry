require "securerandom"

class Telemetry
  class Session
    SESSION_FILE = File.expand_path "~/.chef/TELEMETRY_SESSION_ID"

    def initialize
      @id = if live_session?
              File.read(SESSION_FILE).chomp
            else
              new_session!
            end
    end

    def live_session?
      # a session expires after 10 minutes of inactivity
      expiry = Time.now - (600)
      File.file?(SESSION_FILE) && File.stat(SESSION_FILE).mtime > expiry
    end

    def new_session!
      id = SecureRandom.uuid
      FileUtils.mkdir_p(File.dirname(SESSION_FILE))
      File.open(SESSION_FILE, "w") { |f| f.write(id) }
      id
    end

    def id
      FileUtils.touch SESSION_FILE
      @id
    end
  end
end
