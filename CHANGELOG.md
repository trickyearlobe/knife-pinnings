## Change log for knife-pinnings

This GEM is versioned according to "Semantic versioning".
More information at <http://semver.org/>

Given a version xx.yy.zz

* A change in xx is a major change which likely breaks stuff that depends on us.
* A change in yy is a non-breaking change (usually a new feature)
* A change in zz is a bug fix

## 1.4.0
* Add a pinnings 'set auto' command that discover policies from a chef  environment and solve versions

## 1.3.0
* Add `knife pinnings local cookbook [name|version]`
* Clean up some complexity in grid code

## 1.1.2
* Use variable column spacing in grid (reduces width of grid)

## 1.1.1
* Fix documentation to show regex options
* Fix regex processing for display in pinnings wipe
* Fix banner text to display regex options

## 1.1.0
* Improved performance by using search instead of iteration to get environment detail.
* Added support for comparing pinnings between environments with color highlighting
* Added support for promoting pinnings between environments
* Added support for regex based wiping pinnings in a single environment
* Stop Rubocop whining about code formatting and complexity

## 1.0.0
* Initial release to view pinnings in different Chef environments
* REGEX support for filtering lists of environments and cookbooks