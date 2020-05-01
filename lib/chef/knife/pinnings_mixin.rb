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

def set_environnment_pinnings(environment, pinnings)
  pinnings.each do |name,pinning|
    environment.cookbook_versions[name] = pinning
  end
  environment.save
end

def add_color(row)
  label, *elements = row
  label = ui.color(label, :white)

  element_color = elements_identical?(elements) ? :green : :red

  row = [label]
  elements.each do |element|
    row << ui.color(element, element_color)
  end
  row
end

def elements_identical?(elements)
  elements.each do |element|
    return false unless element == elements.first
  end
  true
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

def nodes_in(rest, environment)
  rest.get_rest("/environments/#{environment}/nodes").keys
end

def cookbooks_used_by(rest, environment)
  recipes = []
  roles = []
  nodes = nodes_in(rest, environment)
  nodes.each do |node|
    response=Chef::RunList.new(rest.get_rest("/nodes/#{node}")['run_list'].join(','))
    _recipes = response.recipe_names
    _roles = response.role_names
    recipes = recipes | (if (_recipes==nil) then [] else _recipes end)
    roles = roles | (if (_roles==nil) then [] else _roles end)
  end
  recipes_from_roles = []
  roles.each do |role|
    run_list = [Chef::RunList::RunListItem.new("role[#{role}]")]
    expansion = Chef::RunList::RunListExpansionFromAPI.new(environment, run_list, rest)
    expansion.expand
    recipes_from_roles = recipes_from_roles | expansion.recipes
  end
  recipes.delete ""
  recipes_from_roles.delete ""
  (recipes | recipes_from_roles).map { |r| r.split('@').first.split('::').first }
end



def cookbooks_merged_with_version_constraints(cookbooks, cookbook_version_constraints)
  cookbooks_with_contraints = cookbooks.dup
  cookbook_version_constraints.each do |cookbook_version_constraint|
    if (not cookbook_version_constraint_valid?(cookbook_version_constraint))
      raise "cookbook constraint #{cookbook_version_constraint} is not valid, it should have format like zed@1.2.3"
    else
      cookbook_name = cookbook_version_constraint.split('@')[0]
      if(cookbooks_with_contraints.include?(cookbook_name))
        cookbooks_with_contraints.delete(cookbook_name)
      end
      cookbooks_with_contraints.push(cookbook_version_constraint)
    end
  end
  cookbooks_with_contraints
end

def cookbook_version_constraint_valid?(cookbook_constraint)
  if (not cookbook_constraint.include?('@'))
    ui.fatal("cookbook constraint #{cookbook_constraint} should include @")
    false
  end
  if ( ( cookbook_constraint.split('@')[1] =~ /\A\d+(?:\.\d+)*\z/) != 0 )
    ui.fatal("cookbook constraint #{cookbook_constraint} does not have valid version number")
    false
  end
  true
end

def solve_recipes(rest, environment, cookbooks_with_contraints)
  run_list = Hash.new
  run_list["run_list"] = cookbooks_with_contraints
  response = rest.post_rest("/environments/#{environment}/cookbook_versions",{:run_list => cookbooks_with_contraints})
  solution = Hash.new
  response.sort.each do |name, cb|
    solution[name]=cb.version
  end
  return solution
end
