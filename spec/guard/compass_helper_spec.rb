require 'spec_helper'

describe Guard::CompassHelper do

  class GuardCompassHelperTest
    include Guard::CompassHelper
  end

  let(:guard) { GuardCompassHelperTest.new }

  before do
    Pathname.stub(:pwd).and_return(Pathname.new('/test/me'))
  end

  describe "pathname method" do
    it "retrieve pwd when nothing given" do
      guard.pathname.should eq Pathname.new('/test/me')
    end

    it "retrieve the absolut path as it" do
      guard.pathname('/hello/boy').should eq Pathname.new('/hello/boy')
    end

    it "computes the relative path" do
      guard.pathname('a', 'b', 'c').should eq Pathname.new('/test/me/a/b/c')
    end

    it "takes the absolute path in middle of the run" do
      guard.pathname('a', '/another/test', 'c').should eq Pathname.new('/another/test/c')
    end

    it "understand double dot notation" do
      guard.pathname('..').should eq Pathname.new('/test')
      guard.pathname('..').to_s.should eq '/test'
      guard.pathname('..', 'a/d/c').should eq Pathname.new('/test/a/d/c')


      guard.pathname('..', 'custom_config_file/another_config_location/config.rb').to_s.should eq '/test/custom_config_file/another_config_location/config.rb'
    end
  end

end
