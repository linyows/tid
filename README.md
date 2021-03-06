TID
===

Easy to test in the docker container.

[![ruby gem](https://img.shields.io/gem/v/tid.svg?style=flat-square)][gem]
[![wercker status](https://img.shields.io/wercker/ci/54e28c8577795a6f61078b9e.svg?style=flat-square)][wercker]

[gem]: https://rubygems.org/gems/tid
[wercker]: https://app.wercker.com/project/bykey/f6e5ba503e4a1f062c6b012ff77d87d0

Requirements
------------

linux:

```sh
$ curl -s http://get.docker.io/ubuntu/ | sudo sh
```

mac:

```sh
$ brew update
$ brew install docker boot2docker
```

Installation
------------

Add this line to your application's Gemfile:

```ruby
gem 'tid'
```

And then execute:

```sh
$ bundle
```

Or install it yourself as:

```sh
$ gem install tid
```

Usage
-----

```sh
$ tid init
  create   spec/tid/Dockerfile
  create   spec/tid/id_rsa
  create   spec/tid/id_rsa.pub
```

example this.

### RSpec

spec_helper.rb:

```ruby
require 'tid'

RSpec.configure do |config|
  ...
  config.include(Tid)
  config.before(:all) { Tid.prepare }
  config.after(:all) { Tid.clear }
end
```

foo_spec.rb:

```ruby
describe 'ssh to docker container' do
  it 'successful' do
    out, _, ex = cmd "ssh root@#{ENV['TID_HOSTNAME']} -p #{ENV['TID_PORT']} \
      -i #{ENV['TID_BASE_PATH']}/id_rsa 'echo yo'"
    expect(ex.exitstatus).to eq 0
    expect(out).to eq "yo\n"
  end
end
```

Contributing
------------

1. Fork it ( https://github.com/linyows/tid/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

Author
------

[linyows](https://github.com/linyows)

License
-------

The MIT License (MIT)
