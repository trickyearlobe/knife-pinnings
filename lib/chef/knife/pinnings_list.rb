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
    class PinningsList < Chef::Knife

      banner "knife pinnings list [environment_regex] [cookbook_regex]"

      def run
        rest = Chef::REST.new(Chef::Config[:chef_server_url])
        environment_regex = "#{name_args[0] || '.*'}"
        cookbook_regex = "#{name_args[1] || '.*'}"

        # Grab a list of environments from Chef and iterate through them
        environments = rest.get_rest("/environments").to_hash
        environments.each do |env_name,env_url|
          
          # Did the user want to see this environment?
          if (env_name =~ /#{environment_regex}/ )

            # If so grab the environment detail and display it
            env_detail = rest.get_rest("/environments/#{env_name}").to_hash
            ui.msg(ui.color("Environment: #{env_name}", :yellow))

            # Iterate through the pinnings in this environment
            env_detail['cookbook_versions'].each do |cookbook_name,cookbook_version|

              # Did the user want to see this cookbook pinning?
              if (cookbook_name =~ /#{cookbook_regex}/)
                ui.msg("  #{cookbook_name} #{cookbook_version}")
              end
            end
            
          end
        end
      end
    end
  end
end