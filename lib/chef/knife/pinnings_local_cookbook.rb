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

require 'chef/cookbook/metadata'

class Chef
  class Knife
    # This class implements knife pinnings get local METADATA_ITEM
    class PinningsLocalCookbook < Chef::Knife
      banner 'knife pinnings local cookbook METADATA_ITEM'

      def run
        @metadata = Chef::Cookbook::Metadata.new
        @metadata.from_file(File.join(Dir.pwd, 'metadata.rb'))

        result = ''
        name_args.each do |name|
          if @metadata.respond_to?(name)
            result += @metadata.send(name).to_s + ' '
          else
            result += '_undefined_ '
          end
        end
        ui.info result.chomp
      end
    end
  end
end
