require 'compass'
require 'compass/commands'
require 'compass/commands/project_base'
require 'compass/compiler'

module Guard
  module CompassHelper
    # Build a path agains components that might be relative or absolute.
    # Whenever an absolute component is found, it became the new 
    # base path on which next relative components are built.
    def pathname(*components)
      result = Pathname.pwd
      components.each do |c|
        pc = Pathname.new(c)
        if(pc.relative?)
          result = result + pc
        else
          result = pc
        end
      end
      return result
    rescue
      raise "Cannot process #{components.inspect}: #{$!}"
    end
    
    # Excerpt from Compass updater commands #

    def check_for_sass_files!(compiler)
      if compiler.sass_files.empty?
        message = "Nothing to compile. If you're trying to start a new project, you have left off the directory argument.\n"
        message << "Run \"compass -h\" to get help."
        raise Compass::Error, message
      end
    end

    def new_compiler_instance(working_path)
      compiler_opts = ::Compass.sass_engine_options
      compiler_opts.merge!(quiet: options[:quiet],
                           force: options[:force],
                           dry_run: options[:dry_run])
      ::Compass::Compiler.new(working_path,
        ::Compass.configuration.sass_path,
        ::Compass.configuration.css_path,
        compiler_opts)
    end
  end
end