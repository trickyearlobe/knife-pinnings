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
    class PinningsSet < Chef::Knife
      banner 'knife pinnings set ENVIRONMENT [COOKBOOK VERSION]'

      def run
        case name_args.length
        when 1 # Just environment was specified so get name/version from metadata
          @metadata = Chef::Cookbook::Metadata.new
          @metadata.from_file(File.join(Dir.pwd,'metadata.rb'))
          @cookbook_name    = @metadata.name
          @cookbook_version = @metadata.version
        when 3 # Environment, Cookbook and Version explicitly specified so use those
          @cookbook_name    = name_args[1]
          @cookbook_version = name_args[2]
        else
          ui.fatal('You must specify ENVIRONMENT (to take COOKBOOK/VERSION from matadata.rb) or ENVIRONMENT COOKBOOK VERSION')
          exit 255
        end
        @environment_name   = name_args[0]
        @environment = Environment.load(@environment_name)

        cookbook_data = rest.get_rest("/cookbooks/#{@cookbook_name}").to_hash
        cookbook_version_exists = false
        cookbook_data[@cookbook_name]['versions'].each do |item|
          cookbook_version_exists = true if item['version'] == @cookbook_version
        end

        unless cookbook_version_exists
          ui.fatal("Cookbook #{@cookbook_name} version #{@cookbook_version} is not on Chef server. Cannot pin in #{@environment_name}")
          exit 127
        end

        if @environment.cookbook_versions[@cookbook_name]
          ui.info("Existing pinning for #{@cookbook_name} in #{@environment_name } #{@environment.cookbook_versions[@cookbook_name]}")
        end

        ui.info("Pinning #{@cookbook_name} to version #{@cookbook_version} in #{@environment_name}")
        @environment.cookbook_versions[@cookbook_name] = "= #{@cookbook_version}"
        @environment.save
      end
    end
  end
end
