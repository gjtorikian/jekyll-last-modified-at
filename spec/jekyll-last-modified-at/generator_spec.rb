require 'spec_helper'

describe(Jekyll::LastModifiedAt::Generator) do
  let(:source) { @fixtures_path }
  let(:dest)   { source.join("_site") }
  let(:site)   { Site.new(Configuration::DEFAULTS.merge({
    "source" => source.to_s,
    "destination" => dest.to_s
  })) }
  subject { site.posts.sample.to_liquid['last_modified_at'] }

  before(:each) { site.reset; site.read; site.generate }

  it "sets the last_modified_at date to a determinator to delay I/O" do
    expect(subject).to be_a(Jekyll::LastModifiedAt::Determinator)
  end

  it "fetches the last modified date if transformed to liquid" do
    expect(subject.to_liquid).to be_a(String)
  end
end
