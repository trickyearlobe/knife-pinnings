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
    # This class knife pinnings set auto ['environment'] ['cookbook_regex']
    class PinningsSetAuto < Chef::Knife
      require 'chef/knife/pinnings_mixin'
      banner 'knife pinnings set auto ENVIRONMENT [COOKBOOK_VERSION_CONSTRAINTS]'

      def run
        case name_args.length
        when 1 # Just environment was specified
          @environment_name = name_args[0]
        when 2 # Environment, and cookbook version constraints specified
          @environment_name = name_args[0]
          @cookbook_version_constraints_string = name_args[1]
          @cookbook_version_constraints = @cookbook_version_constraints_string.split(",")
        else
          ui.fatal('You must specify ENVIRONMENT or ENVIRONMENT COOKBOOK_CONSTRAINTS (constraints example: "foo","bar","zed@0.0.1")')
          exit 255
        end
        @environment = Environment.load(@environment_name)
        nodes = nodes_in(rest, @environment)  
        ui.info("#{nodes.length} nodes have been found in environment #{@environment_name}: #{nodes.to_s}")
        cookbooks = cookbooks_used_by(rest, @environment_name, nodes)
        ui.info("#{cookbooks.length} recipes have been found for the nodes: #{cookbooks.to_s}")
        if @cookbook_version_constraints != nil
          cookbooks_with_contraints = cookbooks_merged_with_version_constraints(cookbooks, @cookbook_version_constraints)
          ui.info("the cookbook version constraints are as follow: #{cookbooks_with_contraints.to_s}")
        else
          ui.info("No version constraint have been specified as input")
          cookbooks_with_contraints = cookbooks
        end
        ui.info("will attempt resolving the dependencies with chef resolver...")
        solution_pinnings = solve_recipes(rest, @environment, cookbooks_with_contraints)
        ui.msg('')
        ui.info("chef resolved the cokkbook dependencies for all nodes from #{@environment_name} as follow:")
        solution_pinnings.map{|key,val| "#{key} --- #{val}"}.each{|entry| ui.info(entry)}
        
        ui.msg('')
        ui.confirm("Do you want to set these cookbook versions on chef environment:#{@environment_name} ")
        ui.msg('')

        set_environnment_pinnings(@environment, solution_pinnings)
        ui.info("pinnings have been set on #{@environment_name}")

      end
    end
  end
end
