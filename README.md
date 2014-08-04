# Whiteboard

An intellectually satisfying way to start new rails projects. Figure out the basics of your app in a file, then run it to generate a basic rails skeleton with all the config options, gems, models, views, and controllers you want.

## Installation

It's simple.

    $ gem install whiteboard

## Usage

Run `$ whiteboard new` to generate a sample `Whiteboard` file. Edit that file then run `$ whiteboard run` to generate your Rails app. If you want to see the commands we generate without really running them, run `$ whiteboard run --test`.

## Example Whiteboard file

```ruby
require "whiteboard"
include Whiteboard

# Generate app
Whiteboard::App.new do
  name 'TestApp'                          # the only required field
  # skip_bundle!                            # skip individual options
  # skip! ['git', 'test-unit']              # skip multiple things
  database 'postgresql'                   # defaults to sqlite, possible options are
                                          # the rails defaults (not mongo, unfortunately)
  ruby_version '2.1.2'                    # generates .ruby-version file
  ruby_gemset 'testapp-gemset'            # generates .ruby-gemset file
  gems ['omniauth', 'omniauth-twitter']   # appends to Gemfile
  gems ['twitter', ['rack', '>=1.0']]     # appends gem with version specified
end

# Generate User model
Whiteboard::Model.new do
  name 'User'
  field :name,            :string
  field :email,           :string
  field :password_digest, :string
end

# Generate Post Model
Whiteboard::Model.new do
  name 'Post'
  field :title,           :string
  field :body,            :text
  field :user_id,         :references, :index
end

# User controller
Whiteboard::Controller.new do
  name 'Users'
  actions [:index, :new, :show]
end
```

## Contributing

1. [Fork this repo](https://github.com/whiteboard-gem/whiteboard/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
