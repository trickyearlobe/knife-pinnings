# knife-pinnings

This gem extends Chef's knife command to manage version pinnings in your Chef environments

* Set a cookbook pinning explicitly or by using metadata.rb
* Get a list of all pinnings in all environments
* Compare pinnings across multiple environments
* Promote pinnings between environments
* Wipe pinnings from environments

## Installation
Pretty standard stuff....

    $ gem install knife-pinnings

## Usage

A lot of knife-pinnings commands use ruby's regular expressions flexible filtering.

* You can learn about regular expressions here <http://www.tutorialspoint.com/ruby/ruby_regular_expressions.htm>
* You can try out regular expressions in this editor <http://rubular.com>
* Wildcards in regular expressions may need to be wrapped in single quotes to hide them from shell globbing.

### Set pinnings
To explicitly specify the cookbook name and version

	$ knife pinnings set <environment> <cookbook> <version>

To take the name and version from the metadata.rb in the current directory use

	$ knife pinnings set <environment>


### List pinnings
In general you can use

	$ knife pinnings list ['environment_regex'] ['cookbook_regex']

To find cookbooks begining with app_ in any environment

    $ knife pinnings '.*' '^app_.*'

To find cookbooks beginning with app_ but only in production

    $ knife pinnings list '^production$' '^app_.*$'

To find cookbooks in acceptance or production with names beginning with app_

    $ knife pinnings list '(^accept.*|^production$)' '^app_.*'

### Compare pinnings
To get a color coded comparison grid showing what's pinned in different environments

    knife pinnings compare ['environmnet_regex'] ['cookbook_regex']

To compare the versions of skunk app cookbooks in dev, acceptance and production

    knife pinnings compare '(^dev$|^acceptance$|^production$)' '^skunk_app.*'

### Promote pinnings
Promote pinnings from one environment to another (eg. from acceptance to pre-prod).

    knife pinnings promote ENV1 ENV2 ['cookbook_regex']

NOTE: Pinnings which are missing in the source environment will NOT be deleted from the target.

### Wipe pinnings

To wipe pinnings in a single environment

    knife pinnings wipe ENVIRONMENT ['cookbook_regex']

To wipe the pinnings from development

    knife pinnings wipe development

To wipe my skunk app cookbooks from development

    knife pinnings wipe development '^skunk_app.*'


### Local cookbook metadata

To get local cookbook metadata for use in shell scripts

	knife pinnings local cookbook [name|version]


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
