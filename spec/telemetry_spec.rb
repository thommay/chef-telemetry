require "spec_helper"

RSpec.describe Chef::Telemetry do
  it "has a version number" do
    expect(Chef::Telemetry::VERSION).not_to be nil
  end

  it "does something useful" do
    expect(false).to eq(true)
  end
end
