# ELK Stack

This is an attempt to create infrastructure that will allow us to easily visualize and analyze test metrics, log files, etc using the ELK stack.

The solution at the moment is elasticsearch with kibana running on a single Ubuntu node for data storage and visualization.

The data feed can come from a logstash instance or by implementing data push plugins in our CI infrastructure.

## Usage

You can use it via the provided `Vagrantfile` as an example, simply run `vagrant up elk-stack`:

 * Elasticsearch is accessible via http://192.168.33.15:9200/
 * Also the elasticsearch-head plugin is installed, which you can find under http://192.168.33.15:9200/_plugin/head
 * Kibana can be reached under http://192.168.33.15/
 * Logstash is listening for remote syslog messages on tcp/udp 10514

There is also an exemplary client VM that you can bring up via `vagrant up log-client`:

 * send a syslog message via `logger -p local0.info "here goes my message!"`

## Development

You need [ChefDK](https://downloads.chef.io/chef-dk/), [Vagrant](https://www.vagrantup.com/) and either VMWare Workstation + Vagrant VMWare plugin or just VirtualBox.

First, you need to install the required gems:
```
$ bundle install
...
```

Next, you can look at the predefined Rake tasks:
```
$ rake -T
rake chefspec     # run chefspec examples
rake foodcritic   # run foodcritic lint checks
rake integration  # run test-kitchen integration tests
rake rubocop      # check Ruby code style with rubocop
rake unit         # run all unit-level tests
```

Now create a new branch, make your changes, add test, send us a pull request...

## Testing

We use the "standard" set of chef testing frameworks:

 * [rubocop](https://github.com/bbatsov/rubocop) is a Ruby-level linting tool
 * [foodcritic](https://acrmp.github.io/foodcritic/) is a linting tool on Chef level
 * [chefspec](https://github.com/sethvargo/chefspec) + [fauxhai](https://github.com/customink/fauxhai) is for unit testing Chef cookbooks / mocking platforms
 * [test-kitchen](https://github.com/test-kitchen/test-kitchen) + [serverspec](http://serverspec.org) is an integration testing framework / library for testing servers

For example, you can run `rake test` to run all the unit level spec tests and linting checks.
```
$ rake test
...
```

Or you run `rake integration` to run all the test-kitchen integration tests.
```
$ rake integration
...
```

## Elasticsearch data

This vm comes preconfigured with a logstash config for feeding elasticsearch with the logfiles of this vm.

Adjust these accordingly.

Have a look at cookbooks/vm/templates/default/logstash/ .
