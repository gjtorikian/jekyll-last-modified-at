# Last Modified At Plugin

A liquid tag for Jekyll to indicate the last time a file was modified.

## Setting up

Add the following to your site's `_config.yml` file

```yml
gems:
  - jekyll-last-modified-at
```

## Usage

Place the following tag somewhere within your layout:

`{% last_modified_at %}`

By default, this creates a time format matching `"%d-%b-%y"` (like "04-Jan-14").

You can choose to pass along your own time format. For example: 
`{% last_modified_at %Y:%B:%A:%d:%S:%R %}` produces "2014:January:Saturday:04."
