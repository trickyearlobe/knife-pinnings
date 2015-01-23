# Copyright 2015 Richard Nixon
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

class Chef
  class Knife
    # This class implements knife pinnings list ['environment_regex'] ['cookbook_regex']
    class PinningsWipe < Chef::Knife
      require 'chef/knife/pinnings_mixin'
      banner "knife pinnings wipe ENVIRONMENT ['cookbook_regex']"

      def run
        if name_args.length < 1
          ui.fatal('You must specify an environment to wipe (and optionally a cookbook regex)')
          exit 255
        end
        cookbook_regex = name_args[1] || '.*'

        environment = Environment.load(name_args[0])
        display_environments([environment], cookbook_regex)
        ui.msg('')
        ui.confirm("Do you want to wipe cookbooks in #{environment.name}")
        ui.msg('')
        wipe(environment,cookbook_regex)
      end

      def wipe(environment, cookbook_regex)
        environment.cookbook_versions.delete_if do |name,version|
          name =~ /#{cookbook_regex}/
        end
        environment.save
        ui.msg('Done')
      end

    end
  end
end
