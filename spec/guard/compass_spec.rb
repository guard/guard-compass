require 'fileutils'
require 'spec_helper'

describe Guard::Compass do

  after do
    ::Compass.reset_configuration!
  end

  describe "In a standard project" do
    before do
      create_fixture(:compass_prj)
      @guard = Guard::Compass.new
    end

    after do
      remove_fixtures
      ::Compass.reset_configuration!
    end

    it "has a reporter" do
      @guard.reporter.should_not be_nil
    end

    it "might be initialized with options" do
      g = Guard::Compass.new([], project_path: 'test', configuration_file: 'test_also')
      g.options[:project_path].should eq 'test'
      g.options[:configuration_file].should eq 'test_also'
    end

    describe "start" do
      it "supports creation of the updater instance" do
        @guard.updater.should be_nil
        @guard.start.should be_true
        @guard.updater.should_not be_nil
      end

      it "should not generate anything" do
        File.exists?(@project_dir + "/stylesheets/screen.css").should be_false
      end
    end

    describe "default options" do
      it "should have a default path mathching the run location" do
        @guard.root_path.should == @project_path
        @guard.working_path.should == @project_path
        @guard.start.should be_true
      end
    end

    describe "after start" do
      before do
        @guard.start
      end

      after do
        @guard.stop
        ::Compass.reset_configuration!
      end

      describe "the updater" do
        it "should contains an options hashmap with config file values" do
          ::Compass.configuration.sass_path.should_not be_nil
          ::Compass.configuration.sass_path.should eq "#{@project_dir}/src"
        end
      end

      describe "stop" do
        it "Stop remove the updater" do
          @guard.updater.should_not be_nil
          @guard.stop.should be_true
          @guard.updater.should be_nil
        end
      end

      describe "run_on_change" do
        it "rebuilds all scss files in compass path" do
          File.exists?(@project_dir + "/src/screen.scss").should(be_true)
          File.exists?(@project_dir + "/stylesheets/screen.css").should be_false
          @guard.run_on_change(@project_dir + "/src/screen.scss").should(be_true) rescue raise inspect_configuration
          File.exists?(@project_dir + "/stylesheets/screen.css").should be_true
        end
      end

      describe "run all" do
        it "rebuilds all scss files in compass path" do
          File.exists?(@project_dir + "/src/screen.scss").should(be_true)
          File.exists?(@project_dir + "/stylesheets/screen.css").should be_false
          @guard.run_all.should be_true
          File.exists?(@project_dir + "/stylesheets/screen.css").should be_true
        end
      end

    end
  end

  describe "with custom configuration and locations" do
    before do
      create_fixture(:custom_config_file)
      @guard = Guard::Compass.new
    end

    after do
      remove_fixtures
      @guard.stop
      ::Compass.reset_configuration!
    end

    it "configure Compass correctly with an absolute path" do
      @guard.options[:configuration_file] = "#{@project_dir}/another_config_location/config.rb"
      @guard.options.should_not be_include(:project_path)
      Pathname.pwd.to_s.should eq @project_dir
      @guard.start
      ::Compass.configuration.sass_path.should eq "#{@project_dir}/another_src_location"
    end

    it "configure Compass correctly with a path relative to the workdir" do
      @guard.options[:configuration_file] = "./another_config_location/config.rb"
      @guard.options[:project_path] = @project_dir

      @guard.root_path.should eql @guard.working_path

      @guard.start

      ::Compass.configuration.sass_path.should eql("#{@project_dir}/another_src_location"), inspect_configuration
      ::Compass.configuration.project_path.should eq @project_dir

      @guard.options[:project_path].should eq @project_dir
      @guard.options[:configuration_file].should eq "#{@project_dir}/another_config_location/config.rb"
    end

    it "rebuilds all scss files in compass path" do
      @guard.options[:configuration_file] = "#{@project_dir}/another_config_location/config.rb"
      @guard.start
      File.exists?("#{@project_dir}/another_src_location/screen.scss").should(be_true)
      File.exists?("#{@project_dir}/another_stylesheets_location/screen.css").should be_false
      @guard.run_on_change(@project_dir + "/another_src_location/screen.scss").should be_true
      File.exists?(@project_dir + "/another_stylesheets_location/screen.css").should be_true
    end
  end

  describe "without config file" do
    before do
      ::Compass.reset_configuration!
      create_fixture(:no_config_file)
      @guard = Guard::Compass.new
      @guard.reporter.stub(:failure)
    end

    after do
      remove_fixtures
      @guard.stop
      ::Compass.reset_configuration!
    end

    it "fails to build sass" do
      @guard.reporter.should_receive(:failure).with("Cannot find a Compass configuration file, please add information to your Guardfile guard 'compass' declaration.")
      @guard.start
      File.exists?(@project_dir + "/src/screen.scss").should(be_true)
      File.exists?(@project_dir + "/stylesheets/screen.css").should be_false

      @guard.run_on_change(@project_dir + "/bad_src/screen.scss")
    end
  end

  describe "with a bad directory configuration" do
    before do
      create_fixture(:bad_src_directory)
      @guard = Guard::Compass.new
      @guard.reporter.stub(:failure).with("Sass files src directory not found: #{@project_dir}/src\nPlease check your Compass configuration.")
      @guard.start
    end

    after do
      remove_fixtures
      @guard.stop
      ::Compass.reset_configuration!
    end

    it "fails to build sass" do
      File.exists?(@project_dir + "/bad_src/screen.scss").should(be_true)
      File.exists?(@project_dir + "/stylesheets/screen.css").should be_false

      @guard.run_on_change(@project_dir + "/bad_src/screen.scss")
    end
  end

  describe "with a bad configuration file parameter" do
    before do
      create_fixture(:custom_config_file)
      @guard = Guard::Compass.new([], configuration_file: 'invalid.rb')
    end

    after do
      @guard.stop
      remove_fixtures
      ::Compass.reset_configuration!
    end

    it "reports an error" do
      @guard.options[:configuration_file].should eq 'invalid.rb'
      @guard.reporter.stub(:failure)
      @guard.reporter.should_receive(:failure).with("Compass configuration file not found: #{@project_dir}/invalid.rb\nPlease check Guard configuration.")
      @guard.start
    end

  end

  describe "Watchers creation" do
    describe "in standard project" do
      before do
        create_fixture :compass_prj
        @guard = Guard::Compass.new
      end

      after do
        remove_fixtures
        ::Compass.reset_configuration!
      end

      it "should have some watchers" do
        @guard.start
        @guard.watchers.size.should(eql(2), @guard.watchers.inspect)
        @guard.watchers.first.pattern.should eq %r{^src/.*}
        @guard.watchers.last.pattern.should eq %r{^config.rb$}
      end
    end

    describe "in customized project" do
      before do
        create_fixture :custom_config_file
        @guard = Guard::Compass.new([], project_path: "#{TMP_PATH}/custom_config_file", configuration_file: 'another_config_location/config.rb')
      end

      after do
        remove_fixtures
        ::Compass.reset_configuration!
      end

      it "should have some watchers" do
        @guard.start
        @guard.watchers.size.should(eql(2), @guard.watchers.inspect)
        @guard.watchers.first.pattern.should eq %r{^another_src_location/.*}
        @guard.watchers.last.pattern.should eq %r{^another_config_location/config.rb$}
      end
    end

    describe "with relative return in working_directory" do
      before do
        create_fixture :custom_config_file_2
        @guard = Guard::Compass.new([], project_path: "..", configuration_file: 'another_config_location/config.rb')
      end

      after do
        remove_fixtures
        ::Compass.reset_configuration!
      end

      it "should have some watchers" do
        @guard.reporter.should_not_receive(:failure)
        @guard.options[:project_path].should eq ".."
        @guard.options[:configuration_file].should eq 'another_config_location/config.rb'

        @guard.start

        @guard.options[:project_path].should eq ".."
        @guard.options[:configuration_file].should eq "#{@project_path}/another_config_location/config.rb"

        @guard.watchers.size.should eq(2), @guard.watchers.inspect
        @guard.watchers.last.pattern.should eq %r{^another_config_location/config.rb$}
        @guard.watchers.first.pattern.should eq(%r{^another_src_location/.*}), ::Compass.configuration.sass_dir
      end
    end
  end
end

def create_fixture(name)
  FileUtils.mkdir(TMP_PATH) unless File.exists?(TMP_PATH)
  @project_dir = "#{TMP_PATH}/#{name}"
  @project_path = Pathname.new(@project_dir)
  FileUtils.cp_r("#{FIXTURES_PATH}/#{name}", TMP_PATH)

  ## Fake the current directory.
  Dir.stub(:pwd).and_return(@project_dir)
  Pathname.stub(:pwd).and_return(@project_path)
end

def remove_fixtures
  FileUtils.rm_rf(TMP_PATH)
end

def inspect_configuration
  result = "Compass Configuration:\n"
  ::Compass::Configuration::ATTRIBUTES.each do |a|
    result << " * #{a.inspect} => #{::Compass.configuration.send(a).inspect}\n" rescue result << " ! error for #{a}"
  end
  return result
end
