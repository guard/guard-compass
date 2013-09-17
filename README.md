# Guard::Compass

[![Gem Version](https://badge.fury.io/rb/guard-compass.png)](http://badge.fury.io/rb/guard-compass) [![Build Status](https://travis-ci.org/guard/guard-compass.png?branch=master)](https://travis-ci.org/guard/guard-compass) [![Dependency Status](https://gemnasium.com/guard/guard-compass.png)](https://gemnasium.com/guard/guard-compass) [![Code Climate](https://codeclimate.com/github/guard/guard-compass.png)](https://codeclimate.com/github/guard/guard-compass) [![Coverage Status](https://coveralls.io/repos/guard/guard-compass/badge.png?branch=master)](https://coveralls.io/r/guard/guard-compass)

Guard::Compass allows to automatically run [Compass](https://github.com/chriseppstein/compass)
whenever a stylesheet file is modified.

* Tested against Ruby 1.8.7, 1.9.3, 2.0.0, JRuby (1.8 mode & 1.9 mode) & Rubinius (1.8 mode & 1.9 mode).

## Install

Please be sure to have [Guard](http://github.com/guard/guard) installed before continue.

The simplest way to install Guard::Compass is to use [Bundler](http://gembundler.com/).

Add Guard::Compass to your `Gemfile`:

```ruby
group :development do
  gem 'guard-compass'
end
```

and install it by running Bundler:

```bash
$ bundle
```

Add guard definition to your Guardfile by running the following command:

```bash
guard init compass
```

## Usage

Please read [Guard usage doc](http://github.com/guard/guard#readme)

```ruby
guard :compass, :configuration_file => 'config/compass_config.rb', :project_path => 'public', 
      :compile_on_start => true do
  watch(%r{..\/foo\/bar\/sass\/.*\.sass$})
end
```

## Configure Guard::Compass plug-in

The default configuration generated by 'guard init compass' looks like this

```ruby
guard :compass
```

## Options

### List of available options

```ruby
:project_path => 'public'                          # path to the compass project directory (from guard working directory)
:configuration_file => 'config/compass_config.rb'  # path to your compass configuration file (from guard working directory)
:compile_on_start => true                          # compile stylesheets when guard starts
```

By default, the project path is equal to the guard working directory (the folder from where you start Guard).
Compass will look into some default location for the config file from there.

The configuration_file is computed by compass. You don't need to define watchers like
in other Guard plug-in because they are generated from the Compass configuration files, cool!

For the complete list of options, please refer to the Compass documentation.

## Development

* Documentation hosted at [RubyDoc](http://rubydoc.info/github/guard/guard-compass/master/frames).
* Source hosted at [GitHub](https://github.com/guard/guard-compass).

Pull requests are very welcome! Please try to follow these simple rules if applicable:

* Please create a topic branch for every separate change you make.
* Make sure your patches are well tested. All specs run by Travis CI must pass.
* Update the [README](https://github.com/guard/guard-compass/blob/master/README.md).
* Please **do not change** the version number.

For questions please join us in our [Google group](http://groups.google.com/group/guard-dev) or on
`#guard` (irc.freenode.net).

## Maintainer

[Rémy Coutable](https://github.com/rymai) ([@rymai](http://twitter.com/rymai), [rymai.me](http://rymai.me))

## Author

[Olivier Amblet](https://github.com/oliamb)
