//
//  ViewController.h
//  JVRuntimeExample-Mac
//
//  Created by JarvanZhang on 2017/4/6.
//  Copyright © 2017年 JarvanZhang. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController



@property (unsafe_unretained) IBOutlet NSTextView *textView;

@property (weak) IBOutlet NSTextField *fileName;

@property (weak) IBOutlet NSSegmentedControl *segmentControl;

@end

