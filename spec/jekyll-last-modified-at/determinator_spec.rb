# frozen_string_literal: true

require "spec_helper"
require "tempfile"

describe(Jekyll::LastModifiedAt::Determinator) do
  subject { described_class.new(site_source.to_s, page_path.to_s) }

  let(:site_source) { @fixtures_path }
  let(:page_path)   { @fixtures_path.join("_posts").join("1984-03-06-command.md") }
  let(:mod_time)    { Time.new(2019, 11, 17, 15, 35, 32, "+00:00") }

  it "determines it is a git repo" do
    expect(subject.git.git_repo?).to(be(true))
    expect(subject.git.site_source).to(end_with("spec/fixtures"))
    expect(subject.git.top_level_directory).to(end_with("/.git"))
  end

  it "knows the last modified date of the file in question" do
    expect(subject.formatted_last_modified_date).to(eql("17-Nov-19"))
  end

  it "knows the last modified time (as a time object) of the file" do
    expect(subject.last_modified_at_time).to(eql(mod_time))
  end

  it "knows the last modified time of the file in question" do
    expect(subject.last_modified_at_unix).to(eql("1574004932"))
  end

  context "not in a git repo" do
    let(:file) { Tempfile.new("some_file.txt") }
    let(:site_source) { File.dirname(file) }
    let(:page_path)   { file.path }
    let(:mod_time)    { Time.now }

    it "determines it is not a git repo" do
      expect(subject.git.git_repo?).to(be(false))
      expect(subject.git.site_source).to(eql(File.dirname(Tempfile.new)))
      expect(subject.git.top_level_directory).to(be_nil)
    end

    it "uses the write time" do
      expect(subject.last_modified_at_time.to_i).to(eql(mod_time.to_i))
    end

    it "uses the write time for the date, too" do
      expect(subject.formatted_last_modified_date).to(eql(mod_time.strftime("%d-%b-%y")))
    end
  end

  describe "#to_s" do
    it "returns the formatted date" do
      expect(subject.to_s).to(eql("17-Nov-19"))
    end
  end

  describe "#to_liquid" do
    it "returns a Time object" do
      expect(subject.to_liquid).to(be_a(Time))
    end

    it "returns the correct time" do
      expect(subject.to_liquid).to(eql(mod_time))
    end
  end

  context "without a format set" do
    it "has a default format" do
      expect(subject.format).to(eql("%d-%b-%y"))
    end
  end

  context "with a format set" do
    before { subject.format = "%Y-%m-%d" }

    it "honors the custom format" do
      expect(subject.format).to(eql("%Y-%m-%d"))
    end
  end
end
