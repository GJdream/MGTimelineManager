# MGTimelineManager
- Visually unique and customizable TabBarController.

MGTabBarController uses SVSegmentedControl for the actual TabBar view.  For customizing the TabBar view itself (fairly easy btw), check out SVSegmentedControl source code here: https://github.com/samvermette/

## Setup
- Add the "MGTabBarController" folder to your project

## Example Usage

Check the demo for full code and visual example

```objc
#import "MGTabBarController.h"

//init tabBarController
self.tabBarController = [[MGTabBarController alloc] initWithTabNames:[NSArray arrayWithObjects:@"View Controller1", @"View Controller 2", nil]];

self.tabBarController.viewControllers = [NSArray arrayWithObjects:viewController1, viewController2, nil];
```

You can also customize the look and feel
```objc
//customizing
//for more customizing check out SVSegmentedControl.h
self.tabBarController.segmentedControl.crossFadeLabelsOnDrag = YES;
self.tabBarController.segmentedControl.font = [UIFont fontWithName:@"Helvetica" size:16];
self.tabBarController.segmentedControl.titleEdgeInsets = UIEdgeInsetsMake(0, 14, 0, 14);
	
self.tabBarController.segmentedControl.thumb.tintColor = [UIColor colorWithRed:.5 green:0 blue:0 alpha:1];
self.tabBarController.segmentedControl.thumb.textColor = [UIColor whiteColor];
```

## Example Screenshots
![ScreenShot 1](http://cloud.github.com/downloads/mglagola/MGTabBarController/1.PNG)

![ScreenShot 2](http://cloud.github.com/downloads/mglagola/MGTabBarController/2.PNG)