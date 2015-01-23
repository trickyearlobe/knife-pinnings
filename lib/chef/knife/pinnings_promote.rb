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
    # This class copies cookbook pinnings between environments
    class PinningsPromote < Chef::Knife
      require 'chef/knife/pinnings_mixin'
      banner 'knife pinnings promote <SOURCE_ENV> <TARGET_ENV>'

      def run
        unless name_args.length > 2
          ui.fatal('You must specify a source and target environment.')
          exit 255
        end
        source_env = Environment.load(name_args[0])
        target_env = Environment.load(name_args[1])
        cookbook_regex = name_args || '.*'
        display_pinnings_table([source_env, target_env], '.*')
        copy_pinnings(source_env, target_env)
      end

      def copy_pinnings(source_env, target_env)
        ui.msg('')
        ui.confirm("Do you want to write to #{target_env.name}")
        ui.msg('')

        source_env.cookbook_versions.each do |name, version|
          target_env.cookbook_versions[name] = version if name =~ /#{cookbook_regex}/
        end

        target_env.save
        ui.msg('Done!')
      end
    end
  end
end
