require 'spork'
require 'rspec'

Spork.prefork do
  # Loading more in this block will cause your tests to run faster. However,
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.

  require "jekyll"
  require "liquid"

  include Jekyll
end

Spork.each_run do
  # This code will be run each time you run your specs.
  require File.expand_path("lib/jekyll-last-modified-at.rb")
end

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:all) do
    if Jekyll::VERSION >= "2"
      Jekyll.logger.log_level = :error
    else
      Jekyll.logger.log_level = Jekyll::Stevenson::ERROR
    end

    original_stderr = $stderr
    original_stdout = $stdout

    @fixtures_path = Pathname.new(__FILE__).parent.join("fixtures")
    @dest = @fixtures_path.join("_site")
    @posts_src = File.join(@fixtures_path, "_posts")
    @layouts_src = File.join(@fixtures_path, "_layouts")
    @plugins_src = File.join(@fixtures_path, "_plugins")

    $stderr = File.new(File.join(File.dirname(__FILE__), 'dev', 'err.txt'), 'w')
    $stdout = File.new(File.join(File.dirname(__FILE__), 'dev', 'out.txt'), 'w')

    @site = Jekyll::Site.new(Jekyll.configuration({
      "source"      => @fixtures_path.to_s,
      "destination" => @dest.to_s,
      "plugins"     => @plugins_src
    }))

    @dest.rmtree if @dest.exist?
    @site.process
  end

  def post_path(file)
    File.join(@posts_src, file)
  end

  def duplicate_post(source, destination)
    File.open(post_path(destination), "w") do |f|
      f.puts(File.read(post_path(source)))
    end
  end

  def setup_post(file)
    Document.new(@site.in_source_dir(File.join('_posts', file)), {
      site: @site,
      collection: @site.posts
    }).tap(&:read)
  end

  def do_render(post, layout)
    @site.layouts = { layout.sub(/\.html/, '') => Layout.new(@site, @layouts_src, layout) }
    post.output = Renderer.new(@site, post, @site.site_payload).run
  end
end
