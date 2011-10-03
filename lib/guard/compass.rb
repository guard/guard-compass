require 'guard'
require 'guard/guard'
require 'guard/reporter'

require 'compass'
require 'compass/commands'
require 'compass/logger'
require 'compass/compiler'

module Compass
  class Compiler
    alias :old_handle_exception :handle_exception
    def handle_exception(sass_filename, css_filename, e)
      old_handle_exception(sass_filename, css_filename, e)
      # rethrow the exception, we need it to notificate the user!
      raise Sass::SyntaxError, "[#{File.basename(sass_filename)}:#{e.sass_line}] #{e.message}"
    end
  end
end

module Guard
  class Compass < Guard
    attr_reader :updater, :options
    attr_accessor :reporter

    def initialize(watchers = [], options = {})
      super
      @reporter = Reporter.new
      @options[:workdir] ||= File.expand_path(File.dirname("."))
    end

    # Guard Interface Implementation

    # Compile all the sass|scss stylesheets
    def start
      create_updater
      reporter.announce "Guard::Compass is watching at your stylesheets."
      true
    end

    def stop
      @updater = nil
      true
    end

    # Reload the configuration
    def reload
      create_updater
      true
    end

    # Compile all the sass|scss stylesheets
    def run_all
      perform
    end

    # Compile the changed stylesheets
    def run_on_change(paths)
      perform
    end

    private
      def perform
        if valid_sass_path?
          begin
            @updater.execute
            Notifier.notify("No errors.", :title => "Compass")
            true
          rescue Sass::SyntaxError => e
            Notifier.notify(e.message, :image => :failed, :title => "Compass")
            reporter.failure "#{e.message}"
            false
          end
        else
          false
        end
      end

      def create_updater
        if(options[:configuration_file])
          filepath = Pathname.new(options[:configuration_file])
          if(filepath.relative?)
            filepath = Pathname.new([options[:workdir], options[:configuration_file]].join("/"))
          end
          if(filepath.exist?)
            ::Compass.add_configuration filepath
            options[:configuration_file] = filepath
          else
            reporter.failure "Compass configuration file not found: #{filepath}\nPlease check Guard configuration."
          end
        end
        @updater = ::Compass::Commands::UpdateProject.new(@options[:workdir] , @options)
        valid_sass_path?
      end

      def valid_sass_path?
        unless File.exists? ::Compass.configuration.sass_path
          reporter.failure("Sass files src directory not found: #{::Compass.configuration.sass_path}\nPlease check your Compass configuration.")
          false
        else
          true
        end
      end
  end
end