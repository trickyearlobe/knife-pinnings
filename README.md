# knife-pinnings

[![Gem Version](https://badge.fury.io/rb/knife-pinnings.svg)](http://badge.fury.io/rb/knife-pinnings)

This gem extends Chef's knife command to manage version pinnings in your Chef environments

* Get a list of all pinnings in all environments
* Compare pinnings across multiple environments
* Promote pinnings between environments
* Wipe pinnings from environments

## Installation
Pretty standard stuff....

    $ gem install knife-pinnings

## Usage

A lot of `knife pinning` commands use the power of ruby's REGEX matching for flexible matching of environment and cookbook names.

* You can try out REGEX expressions in this editor <http://rubular.com>
* You can learn about ruby REGEX here <http://www.tutorialspoint.com/ruby/ruby_regular_expressions.htm>
* REGEX with wildcards may need to be wrapped in single quotes to hide them from the shell

### Getting a list of pinnings in multiple environments
In general you can use
```bash
$ knife pinnings list ['environment_regex'] ['cookbook_regex']
```

To find cookbooks begining with app_ in any environment

    $ knife pinnings '.*' '^app_.*'

To find cookbooks beginning with app_ but only in production

    $ knife pinnings list '^production$' '^app_.*$'

To find cookbooks in acceptance or production with names beginning with app_

    $ knife pinnings list '(^accept.*|^production$)' '^app_.*'

### Comparing environments
To get a color coded comparison grid showing whats not up to date and whats missing.

    knife compare ENV1 ENV2


### Promoting pinnings between environments
Promote pinnings from one environment to another.

    knife pinnings promote ENV1 ENV2

NOTE: Pinnings which are missing in the source environment will NOT be deleted from the target.

### Wiping pinnings in an environment

To wipe pinnings in a single environment

    knife pinnings wipe ENVIRONMENT ['cookbook_regex']

To wipe the pinnings from development

    knife pinnings wipe development

To wipe my skunk app cookbooks from development

    knife pinnings wipe development '^skunk_app.*'

## Contributing

1. Fork it ( <https://github.com/trickyearlobe/knife-pinnings/fork> )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Licence

Copyright 2015 Richard Nixon

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

  <http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
