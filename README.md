# Breadcrumb Trail
[![Code Climate](https://codeclimate.com/github/medcat/breadcrumb_trail/badges/gpa.svg)](https://codeclimate.com/github/medcat/breadcrumb_trail) [![Build Status](https://travis-ci.org/medcat/breadcrumb_trail.svg)](https://travis-ci.org/medcat/breadcrumb_trail)

Helps you create a breadcrumb system for your Rails application.
Better than any other library, guarenteed<sup>*</sup>.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'breadcrumb_trail'
```

And you're done!

## Usage

The gem adds some nice methods to your controller:

```Ruby
# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base

  breadcrumb name: "Home", path: :root_path
end
```

```Ruby
# app/controllers/articles_controller.rb
class ArticlesController < ApplicationController
  breadcrumb name: "Articles", path: :articles_path

  def show
    @article = Article.find(params[:id])
    breadcrumb name: @article.name, path: article_path(@article)
    breadcrumbs # => returns all of your breadcrumbs
  end
end
```

```HTML
<!-- app/views/layouts/application.html.erb -->
<!-- ... -->
<%= render_breadcrumbs outer: "ul" %>
<!-- ... -->
```

...all results in _(with some assumptions)_:

```HTML
<!-- ... -->
<ul>
  <li><a href="/">Home</a></li>
  <li><a href="/articles">Articles</a></li>
  <li><a href="/articles/1">Hello, World</a></li>
</ul>
<!-- ... -->
```

You can pass `#breadcrumb` some options, which it'll use as
HTML options by default.

Simple, right?

### Builders

`#render_breadcrumbs` takes an option for a builder, or defaults to
one if you don't provide it.  There are two default builders:
`HTMLBuilder` and `BlockBuilder`.  If you provide a block to
`#render_breadcrumbs`, then `BlockBuilder` is used; otherwise,
`HTMLBuilder` is used.

#### `HTMLBuilder`

`HTMLBuilder` builds a sensible block of HTML based on some options.
The exact options you can provide are:

- `outer`: The outer tag that is used.  The default for this is `ol`.
  If this is `nil`, then no outer tag is rendered.
- `inner`: The inner tag that is used.  The default for this is `li`.
  If this is `nil`, then no inner tag is rendered.
- `outer_options`: The html attributes that are used for the outer
  tag.  By default, there are no options.  If you want to add
  `class="some-class"`, this is the place to provide it.
- `inner_options`: The html attributes that are used for the inner
  tag.  By default, there are no options.  If you want to add
  `class="some-class"`, this is the place to provide it.

That's it!

#### `BlockBuilder`

`BlockBuilder` yields each breadcrumb to the given block.  Each
breadcrumb has three attributes: `name`, `path`, and `options`.
To recreate the default output of `HTMLBuilder`, you'd have to do
this with `BlockBuilder`:

```
<!-- ... -->
<ol>
<%= render_breadcrumbs do |breadcrumb| %>
  <li><%= link_to(breadcrumb.name, breadcrumb.path, breadcrumb.options) %></li>
<%= end %>
</ol>
<!-- ... -->
```

#### Your Own Builder

You don't have to use one of these.  You can use your own builder.
However, if you're using a builder because the default builders don't
provide a feature you like, open an issue!

Your builder only needs to subclass `BreadcrumbTrail::Builder` and
define the method `#call`, and that's it!  Then, you pass the builder
to `#render_breadcrumbs` with the `builder` option:

```
<!-- ... -->
<%= render_breadcrumbs builder: MyCustomBuilder %>
<!-- ... -->
```

Any options passed to `#render_breadcrumbs` are passed to your
builder's `#initialize` via the last argument.

## Contributing

1. Fork it (<https://github.com/medcat/breadcrumb_trail/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

<sup>*</sup>: Not guarenteed.
