# frozen_string_literal: true

RSpec.describe ActionCsv do
  it "has a version number" do
    expect(ActionCsv::VERSION).not_to be nil
  end

  it "has config dir" do
    a1 = Dir.exist? "config"
    expect(a1).to eq(true)
  end

  it "has db dir" do
    a1 = Dir.exist? "db"
    expect(a1).to eq(true)
  end
end
