# frozen_string_literal: true

require "spec_helper"

describe(Jekyll::LastModifiedAt::Tag) do
  subject { dest.join("file.txt").to_s }

  let(:source) { @fixtures_path }
  let(:dest)   { source.join("_site") }
  let(:site)   do
    Site.new(Configuration::DEFAULTS.merge(
      "source" => source.to_s,
      "destination" => dest.to_s,
    ))
  end

  it "understands happiness" do
    expect(File.read(subject)).to(match(/12\-Sep\-14/))
  end
end
