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
    class PinningsCompare < Chef::Knife
      require 'chef/knife/pinnings_mixin'
      banner "knife pinnings compare ['environment_regex'] ['cookbook_regex']"

      def run
        environment_regex = "#{name_args[0] || '.*'}"
        cookbook_regex = "#{name_args[1] || '.*'}"
        environments = filter_environments(Environment.list(true), environment_regex)
        display_pinnings_table(environments, cookbook_regex)
      end
    end
  end
end
