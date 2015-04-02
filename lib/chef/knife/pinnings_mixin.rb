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

# This method strips the = off Chef "= xxx.yyy.zzz" versions numbers
def version_strip(version_string)
  version_string.match(/()[0-9]*\.[0-9]*\.[0-9]*/).to_s
end

# This method takes an array of environments and filters them using a REGEX
def filter_environments(environments, environment_regex)
  filtered_environments = []
  environments.each do |name, environment|
    filtered_environments << environment  if name =~ /#{environment_regex}/
  end
  filtered_environments
end

def filter_cookbooks(cookbooks, cookbook_regex)
  filtered_cookbooks = []
  cookbooks.each do |name, version|
    filtered_cookbooks << [name, version] if name =~ /#{cookbook_regex}/
  end
  filtered_cookbooks
end

# This method generates a color coded table of cookbook versions across environments
def display_pinnings_table(environments, cookbook_regex)
  ui.msg(
    ui.list(
      build_pinnings_table(environments, cookbook_regex),
      :uneven_columns_across,
      environments.length + 1
    )
  )
end

def build_pinnings_table(environments, cookbook_regex)
  cookbooks = {}

  # Get the cookbooks into a sparse hash of hashes
  environments.each do |environment|
    environment.cookbook_versions.each do |name, version|
      if name =~ /#{cookbook_regex}/
        cookbooks[name] ||= {}
        cookbooks[name][environment.name] = version_strip(version)
      end
    end
  end

  # Make a grid header
  cookbooks_grid = ['']
  environments.each do |environment|
    cookbooks_grid << environment.name
  end

  cookbooks.each do |cookbook_name, versions|
    row = [cookbook_name]
    environments.each do |environment|
      row << (versions[environment.name] || '---')
    end
    row = add_color(row)
    cookbooks_grid += row
  end
  cookbooks_grid
end

def add_color(row)
  # The first element in the row is the cookbook name so skip that
  row[0] = ui.color(row[0], :white)
  row_color = 'green'
  row[2..row.size].each do |version|
    row_color = 'red' unless version == row[1]
  end
  for i in 1..row.size - 1
    row[i] = ui.color(row[i], row_color.to_sym)
  end
  row
end

def display_environments(environments, cookbook_regex)
  environments.each do |environment|
    ui.msg(ui.color(environment.name, :yellow))
    display_cookbooks(environment.cookbook_versions, cookbook_regex)
  end
end

def display_cookbooks(cookbooks, cookbook_regex)
  rows = []
  filter_cookbooks(cookbooks, cookbook_regex).each do |name, version|
    rows << "  #{name}" << version_strip(version)
  end
  ui.msg(ui.list(rows, :uneven_columns_across, 2)) if rows.length > 0
end
