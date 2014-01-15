require "spec_helper"

describe "Last Modified At Tag" do
  context "A committed post file" do
  def setup(file, layout)
    @post = setup_post(file)
    do_render(@post, layout)
  end

    it "has last revised date" do
      setup("1984-03-06-last-modified-at.md", "last_modified_at.html")
      expect(@post.output).to match /Article last updated on 03-Jan-14/
    end

    it "passes along last revised date format" do
      setup("1984-03-06-last-modified-at-with-format.md", "last_modified_at_with_format.html")
      expect(@post.output).to match /Article last updated on 2014:January:Saturday:04/
    end

    it "ignores files that do not exist" do
      expect { setup("1984-03-06-what-the-eff.md", "last_modified_at_with_format.html") }.to raise_error
    end
  end
  
  context "An uncommitted post file" do
    before(:all) do
      cheater_file = "1984-03-06-last-modified-at.md"
      uncommitted_file = "1992-09-11-last-modified-at.md"
      duplicate_post(cheater_file, uncommitted_file)
      @post = setup_post(uncommitted_file)
      do_render(@post, "last_modified_at.html")
    end

    it "has last revised date" do
      expect(@post.output).to match(Regexp.new("Article last updated on #{Time.new.strftime('%d-%b-%y')}"))
    end
  end
end
