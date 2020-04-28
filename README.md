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
date_format: '%d-%b-%y'
```

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
