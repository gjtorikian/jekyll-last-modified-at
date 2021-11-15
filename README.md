# Last Modified At Plugin

A liquid tag for Jekyll to indicate the last time a file was modified.

This plugin determines a page's last modified date by checking the last Git commit date of source files. In the event Git is not available, the file's `mtime` is used.

## Setting up

Open your Gemfile in your Jekyll root folder and add the following:

``` ruby
group :jekyll_plugins do
  gem "jekyll-last-modified-at"
end
```

Add the following to your site's `_config.yml` file

```yml
plugins:
  - jekyll-last-modified-at

# Optional. The default date format, used if none is specified in the tag.
last-modified-at:
    date-format: '%d-%b-%y'
```
For sites with lots of documents using `last_modified_at`, there may be render
performance improvement via:

```yml
plugins:
  - jekyll-last-modified-at

last-modified-at:
    use-git-cache: true
```

If `use-git-cache` is `false` (the default), every committed file using
`last_modified_at` will generate a separate spawned process to check the git log
for time data. So if you have 10 documents, this will result in 10 spawned calls.

If `use-git-cache` is `true`, a single spawned process is generated that reads
the entire git log history and caches the time data. This cache is then read
from during the rest of the site generation process. So if you have 10 (or 1000)
documents, this will result in 1 spawned call. The cache is flushed on site
reset, allowing for a long-lived server to correctly reflect `last_modified_at`
of files modified and committed while it has been running.

Note: there may be performance issues for repositories with very large
histories, in which case the default behavior is likely preferred.

## Usage

There are a few ways to use this gem.

You can place the following tag somewhere within your layout:

``` liquid
{% last_modified_at %}
```

By default, this creates a time format matching `"%d-%b-%y"` (like "04-Jan-14").

You can also choose to pass along your own time format. For example:

```liquid
{% last_modified_at %Y:%B:%A:%d:%S:%R %}
```
That produces "2014:January:Saturday:04."

You can also call the method directly on a Jekyll "object," like so:

``` liquid
{{ page.last_modified_at }}
```

To format such a time, you'll need to rely on Liquid's `date` filter:

``` liquid
{{ page.last_modified_at | date: '%Y:%B:%A:%d:%S:%R' }}
```

(It's generally [more performant to use the `page.last_modified_at` version](https://github.com/gjtorikian/jekyll-last-modified-at/issues/24#issuecomment-55431108) of this plugin.)

## `page.date`

Additionally, you can have this plugin automatically set a default `date` value on every page based on when the file was **first** commited in git. To enable this, set `set-page-date` to `true` in your config yaml:

 ```yml
plugins:
  - jekyll-last-modified-at

last-modified-at:
    set-page-date: true
```

If a post's date is already set via [the filename](https://jekyllrb.com/docs/posts/#creating-posts) or a page's date is set in its [frontmatter](https://jekyllrb.com/docs/variables/#page-variables), those values will override the value provided by this plugin. If a git date isn't available, `ctime` is used.

