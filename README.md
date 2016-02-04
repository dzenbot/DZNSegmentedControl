DZNSegmentedControl
========================
[![Pod Version](http://img.shields.io/cocoapods/v/DZNSegmentedControl.svg)](https://cocoadocs.org/docsets/DZNSegmentedControl)
[![Gittip](http://img.shields.io/gittip/dzenbot.svg)](https://www.gittip.com/dzenbot/)
[![License](http://img.shields.io/badge/license-MIT-blue.svg)](http://opensource.org/licenses/MIT)


A drop-in replacement for UISegmentedControl for showing counts, to be used typically on a user profile.

![Demo Gif](Screenshots/segmentedcontrol_demo.gif)

### Features
* Customizable control with tint color, font, sizes and animation duration.
* Animated and width auto-adjusting selection indicator.
* UIBarPositioning support.
* UIAppearance support.
* ARC & 64bits.
<br>

## Installation

Available in [Cocoa Pods](http://cocoapods.org/?q=DZNSegmentedControl)
```
pod 'DZNSegmentedControl'
```

## How to use
For complete documentation, [visit CocoaPods' auto-generated doc](http://cocoadocs.org/docsets/DZNSegmentedControl/)

### Step 1

```
Import "DZNSegmentedControl.h"
```

### Step 2
Creating a new instance of DZNSegmentedControl is very similar to what you would do with UISegmentedControl:
```
NSArray *items = @[@"Tweets", @"Following", @"Followers"];
    
DZNSegmentedControl *control = [[DZNSegmentedControl alloc] initWithItems:items];
control.tintColor = [UIColor blueColor];
control.delegate = self;
control.selectedSegmentIndex = 1;
    
[control addTarget:self action:@selector(selectedSegment:) forControlEvents:UIControlEventValueChanged];
````

You can additionally set more properties:
```
[control setCount:@(12) forSegmentAtIndex:0];
[control setTitle:@"Hello" forSegmentAtIndex:1];
[control setEnabled:NO forSegmentAtIndex:2];
````

### Sample project
Take a look into the sample project. Everything is there.<br>


## License
(The MIT License)

Copyright (c) 2015 Ignacio Romero Zurbuchen iromero@dzen.cl

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the 'Software'), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
