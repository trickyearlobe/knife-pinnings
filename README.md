# knife-pinnings

This gem extends Chef's knife command to view cookbook pinnings in all your different chef environments

## Installation

Add this line to your application's Gemfile:


    gem 'knife-pinnings'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install knife-pinnings

## Usage

The knife-pinnings plugin uses ruby (PCRE) regex for environment and cookbook filtering

    $ knife pinnings list ['cookbook_regex'] ['environment_regex']

Note: It can take a long time to get results if you have a lot of environments as `knife pinnings` has to make individual API requests to get details on each environment.


To find cookbooks begining with app_
(Note the use of '' around wildcards to prevent interpretation by the shell)

    $ knife pinnings '.*' '^app_.*'

To find cookbooks in production with names beginning with app_

    $ knife pinnings list '^production$' '^app_.*$'

To find cookbooks in acceptance or production with names beginning with app_

    $ knife pinnings list '(^accept.*|^production$)' '^app_.*'

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
