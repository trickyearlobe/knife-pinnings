## Change log for knife-pinnings

This GEM is versioned according to "Semantic versioning".
More information at <http://semver.org/>

Given a version xx.yy.zz

* A change in zz is a bug fix
* A change in yy is a non-breaking change (usually a new feature)
* A change in zz is a major change which likely breaks stuff that depends on us.

## 1.1.0
* Improved performance by using search instead of iteration to get environment detail.
* Added support for comparing pinnings between environments with color highlighting
* Added support for promoting pinnings between environments
* Added support for regex based wiping pinnings in a single environment
* Stop Rubocop whining about code formatting and complexity

## 1.0.0
* Initial release to view pinnings in different Chef environments
* REGEX support for filtering lists of environments and cookbooks