require "whiteboard/version"

module Whiteboard

  # Need to fix all this stuff and put it inside a class
  # or something else that's not globally scoped. Not sure
  # how to do that though. Help?

  $command_queue = []

  if ARGV[0] == '--test'
    $test_run = true
  end

  def test_run!
    $test_run = true
  end

  def queue_cmd(cmd)
    $command_queue << cmd
  end

  def execute!(commands)
    $command_queue.each do |cmd|
      if $test_run
        puts cmd
      else
        system cmd
      end
    end
    $command_queue = []
  end

  class App

    def initialize(&block)
      # Everything must be in the initialization block
      if block_given?
        instance_eval(&block)
        generate_app!
      else
        raise "You need to use a block to specify your app, like this: \n\nApp.new do |app|\n  app.name 'twitter'\nend"
      end
    end

    def name(name)
      @app_name = name
      $app_name = name
    end

    def database(db)
      @db = db
    end

    # Skipping things

    def skip!(skip_list)
      skip_list.each do |item|
        case item
        when 'gemfile'
          @skip_gemfile = true
        when 'bundle'
          @skip_bundle = true
        when 'active-record'
          @skip_active_record = true
        when 'git'
          @skip_git = true
        when 'javascript'
          @skip_javascript = true
        when 'test-unit'
          @skip_test_unit = true
        end
      end
    end

    def skip_bundle!
      @skip_bundle = true
    end

    def skip_gemfile!
      @skip_gemfile = true
    end

    def skip_active_record!
      @skip_active_record = true
    end

    def skip_javascript!
      @skip_javascript = true
    end

    def skip_git!
      @skip_git = true
    end

    def skip_test_unit!
      @skip_test_unit = true
    end

    # Ruby version & gemset

    def ruby_version(v)
      @ruby_version = v
    end

    def ruby_gemset(g)
      @ruby_gemset = g
    end

    def gems(gemlist)
      @gemlist = gemlist
    end

    private

    def generate_app!
      rails_new!
      add_ruby_version! if @ruby_version
      add_ruby_gemset! if @ruby_gemset
      add_gems! if @gemlist
      install_gems!
      execute! $command_queue
    end

    def rails_new!

      # Check to make sure we've specified an app name
      if @app_name

        # Basic app stuff
        cmd = "rails new #{@app_name}"
        cmd += " --database=#{@db}" if @db

        # Skip things
        cmd += " --skip-bundle" if @skip_bundle
        cmd += " --skip-gemfile" if @skip_gemfile
        cmd += " --skip-active-record" if @skip_active_record
        cmd += " --skip-javascript" if @skip_javascript
        cmd += " --skip-git" if @skip_git
        cmd += " --skip-test-unit" if @skip_test_unit
        queue_cmd cmd
      else
        raise "You need to specify your app's name."
      end
    end

    def add_ruby_version!
      cmd = "echo '#{@ruby_version}' >> #{@app_name}/.ruby-version"
      queue_cmd cmd
    end

    def add_ruby_gemset!
      cmd = "echo '#{@ruby_gemset}' >> #{@app_name}/.ruby-gemset"
      queue_cmd cmd
    end

    def add_gems!
      raise 'You can\'t skip the Gemfile AND specify gems.' if @skip_gemfile
      @gemlist.each do |g|
        if g.is_a? String
          queue_cmd 'echo "gem \''+g+'\'" >> '+@app_name+'/Gemfile'
        elsif g.is_a? Array
          queue_cmd 'echo "gem \''+g[0]+'\', \''+g[1]+'\'" >> '+@app_name+'/Gemfile'
        else
          raise "Gem #{g}'s format needs to be a String or an Array."
        end
      end
    end

    def install_gems!
      queue_cmd "cd #{$app_name} && spring stop" # Hack to fix spring bug
      queue_cmd "cd #{$app_name} && bundle"
    end
  end

  class Model
    def initialize(&block)
      # Everything must be in the initialization block
      @fields = []
      if block_given?
        instance_eval(&block)
        generate_model!
      else
        raise "You need to use a block to specify your app, like this: \n\nApp.new do |app|\n  app.name 'twitter'\nend"
      end
    end

    def name(model_name)
      @model_name = model_name
    end

    def field(name, type, index = nil)
      @fields << [name, type, index]
    end

    private

    def generate_model!
      if @model_name
        cmd = "cd #{$app_name} && "
        cmd += "rails g model #{@model_name}"
        @fields.each do |field|
          cmd += " #{field[0]}:#{field[1]}"
          cmd += ":index" if field[2]
        end
        queue_cmd cmd
        execute! $command_queue
      else
        raise "You need to specify the model name."
      end
    end

  end

  class Controller
    def initialize(&block)
      # Everything must be in the initialization block
      @action_list = []
      if block_given?
        instance_eval(&block)
        generate_controller!
      else
        raise "You need to use a block to specify your app, like this: \n\nApp.new do |app|\n  app.name 'twitter'\nend"
      end
    end

    def name(controller_name)
      if controller_name.split('').last != 's'
        raise 'Rails controller names should be plural'
      else
        @controller_name = controller_name
      end
    end

    def actions(action_list)
      if action_list.is_a? Array
        @action_list = action_list
      else
        raise 'The controller action must be in an array.'
      end
    end

    private

    def generate_controller!
      cmd = "rails g controller #{@controller_name}"
      @action_list.each do |action|
        cmd += " #{action}"
      end
      puts cmd
    end

  end

end
