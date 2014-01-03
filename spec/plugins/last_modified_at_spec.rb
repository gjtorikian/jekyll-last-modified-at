require "spec_helper"

describe "Last Modified At Tag" do
  context "A Post file" do
    before(:all) do
      file = "1984-03-06-last-modified-at.md"
      @post = setup_post(file)
      do_render(@post, "last_modified_at.html")
    end

    it "has last revised date" do
      @post.output.should match /Article last updated on 03-Jan-14/
    end
  end
end
