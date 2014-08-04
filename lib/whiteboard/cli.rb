include Whiteboard

module Whiteboard
  module CLI

  def file_string
<<-eos
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
eos
  end
  end
end

