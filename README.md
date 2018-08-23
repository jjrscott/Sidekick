# Sidekick

A set of useful scripts I've written to add me in developing iOS apps over the years. Most of these scripts solve problems in either the project itself or other non-code files, eg strings files.

Note, the scripts have all been taken from my own projects, then cleaned up. Scripts marked with ⚠️ are either experimental or haven't gone through much testing.

Treat with care.

## Scripts

### check_storyboard.pl ⚠️

Checks for issues in storyboards that ibtool does not worry about. For example, that the storyboard has an entry point.

#### Example

	Sidekick/check_storyboard.pl "${SOURCE_ROOT}"

### imageset_generator ⚠️

Fills an appiconset with correctly sized images from a single PDF. Handy if you're not working with a graphic designer.

#### Usage

```
Sidekick/imageset_generator -imageset_path <imageset path>  -source_path <source image path>
```

#### Example

	Sidekick/imageset_generator -imageset_path ${TARGET_NAME}/Assets.xcassets/AppIcon.appiconset -source_path ${TARGET_NAME}/AppIcon.pdf
	
### manage_localizations ⚠️

**This script is currently Objective-C only**

Manages all your localization files, including Info.plist. The script will also handle the production of `.stringsdict` files so you don't need to manage them yourself.

You will need to add `ManageLocalizations.h` and `ManageLocalizations.m` to your project.

#### Example

```
Sidekick/manage_localizations -source-root $SRCROOT -strings-root $SRCROOT/${TARGET_NAME} -infoplist-file $INFOPLIST_FILE
```
### registernibs_generator ⚠️

Enables conpile time connection to the internals of TableViewCell based XIBs.

It achieves this by generating a category/extension for registering XIBs with a table view, and constants for each reuse identifier. It should be run thus:

#### Usage

```
Sidekick/registernibs_generator [--swift-output] [--objc-output] --output <output path prefix> -- <list of XIB files>
```

#### Example

```
Sidekick/registernibs_generator -output ${TARGET_NAME} -objc-output ${TARGET_NAME}/*.xib
```

Then add this kind of thing to your view controller

```objc
#import "UITableView+RegisterNibs.h"

- (void)viewDidLoad
{
	[super viewDidLoad];
	[self.tableView registerNibs];
}

```

### storyboard_constants ⚠️

Enables conpile time connection to the internals of a storyboard. It achieves this by generating files containing constants for:

- segue identifiers
- storyboard identifiers
- table view cell reuse identifiers

Remove a view from a storyboard and the constant will also be removed. Any code still using that constant will now fail to compile.

#### Usage

	Sidekick/storyboard_constants -storyboard <storyboard path> -output <output path prefix>

#### Example

	Scripts/storyboard_constants -storyboard ${TARGET_NAME}/Base.lproj/Main.storyboard -output ${TARGET_NAME}/MainStoryboard
