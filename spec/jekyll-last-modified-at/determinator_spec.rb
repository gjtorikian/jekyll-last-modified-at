require "spec_helper"

describe(Jekyll::LastModifiedAt::Determinator) do
  let(:site_source) { @fixtures_path }
  let(:page_path)   { @fixtures_path.join("_posts").join("1984-03-06-command.md|whoami>.bogus") }
  let(:mod_time)    { Time.new(2014, 01, 15, 13, 00, 44, "-08:00") }
  subject { described_class.new(site_source.to_s, page_path.to_s) }

  it "knows the last modified date of the file in question" do
    expect(subject.formatted_last_modified_date).to eql("15-Jan-14")
  end

  it "knows the last modified time (as a time object) of the file" do
    expect(subject.last_modified_at_time).to eql(mod_time)
  end

  it "knows the last modified time of the file in question" do
    expect(subject.last_modified_at_unix).to eql("1389819644")
  end

  context "not in a git repo" do
    let(:site_source) { Pathname.new("/tmp") }
    let(:page_path)   { site_source.join("some_file.txt") }
    let(:mod_time)    { Time.now }
    before(:each) do
      File.stub(:mtime).and_return(mod_time)
      File.stub(:exists?).and_return(true)
    end

    it "uses the write time" do
      expect(subject.last_modified_at_time.to_i).to eql(mod_time.to_i)
    end

    it "uses the write time for the date, too" do
      expect(subject.formatted_last_modified_date).to eql(mod_time.strftime("%d-%b-%y"))
    end
  end

  context "#to_s" do
    it "returns the formatted date" do
      expect(subject.to_s).to eql("15-Jan-14")
    end
  end

  context "#to_liquid" do
    it "returns a Time object" do
      expect(subject.to_liquid).to be_a(Time)
    end

    it "returns the correct time" do
      expect(subject.to_liquid).to eql(mod_time)
    end
  end

  context "without a format set" do
    it "has a default format" do
      expect(subject.format).to eql("%d-%b-%y")
    end
  end

  context "with a format set" do
    before(:each) { subject.format = "%Y-%m-%d" }
    it "honors the custom format" do
      expect(subject.format).to eql("%Y-%m-%d")
    end
  end
end
