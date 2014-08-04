# Whiteboard

An intellectually satisfying way to start new rails projects. Figure out the basics of your app in a file, then run it to generate a basic rails skeleton with all the config options, gems, models, views, and controllers you want.

## Installation

It's simple.

    $ gem install whiteboard

## Usage

Run `$ whiteboard new` to generate a sample `Whiteboard` file. Edit that file then run `$ whiteboard` to generate your app.

## Example Whiteboard file

```ruby
require "whiteboard"
include Whiteboard

Whiteboard.test_run! # Prints commands without actually running them

# Generate app
Whiteboard::App.new do |app|
  app.name 'TestApp'                          # the only required field
  # app.skip_bundle!                            # skip individual options
  # app.skip! ['git', 'test-unit']              # skip multiple things
  app.database 'postgresql'                   # defaults to sqlite, possible options are
                                              # sqlite3, mysql, or postgresql
  app.ruby_version '2.1.2'                    # generates .ruby-version file
  app.ruby_gemset 'testapp-gemset'            # generates .ruby-gemset file
  app.gems ['omniauth', 'omniauth-twitter']   # appends to Gemfile
  app.gems ['twitter', ['rack', '>=1.0']]     # appends gem with version specified
end

# Generate User model
Whiteboard::Model.new do |m|
  m.name 'User'
  m.field :name,            :string
  m.field :email,           :string
  m.field :password_digest, :string
end

# Generate Post Model
Whiteboard::Model.new do |m|
  m.name 'Post'
  m.field :title,           :string
  m.field :body,            :text
  m.field :user_id,         :references, :index
end

# User controller
Whiteboard::Controller.new do |c|
  c.name 'Users'
  c.actions [:index, :new, :show]
end
```

## Contributing

1. [Fork this repo](https://github.com/whiteboard-gem/whiteboard/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
