//
//  JVSetNameViewController.m
//  JVRuntimeExample-Mac
//
//  Created by JarvanZhang on 2017/4/11.
//  Copyright © 2017年 JarvanZhang. All rights reserved.
//

#import "JVSetNameViewController.h"
#import "JVItemView.h"
@interface JVSetNameViewController ()
@property (weak) IBOutlet NSLayoutConstraint *heightConstraint;
@property (weak) IBOutlet NSView *stackView;

@end

@implementation JVSetNameViewController
- (IBAction)cancel:(NSButton *)sender {
    if (self.presentingViewController) {
        [self.presentingViewController dismissViewController:self];
    } else {
        //for the 'show' transition
        [self.view.window close];
    }
}
- (IBAction)finish:(NSButton *)sender {
    
    if (self.presentingViewController) {
        [self.presentingViewController dismissViewController:self];
    } else {
        //for the 'show' transition
        [self.view.window close];
    }
    if (self.finishBlcok) {
        self.finishBlcok();
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


-(void)viewDidAppear{
    [super viewDidAppear];
    CGFloat height=30.f;
    CGFloat width=self.stackView.frame.size.width;
    CGFloat constant=height*self.dataArray.count>232?height*self.dataArray.count:232;
    self.heightConstraint.constant=constant;
    
    [self.dataArray enumerateObjectsUsingBlock:^(__kindof JVUpdateKeyModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat y=height*idx;
        JVItemView *item=[[JVItemView alloc]initWithFrame:NSMakeRect(0, y, width, height)];
        [item setCurrentModel:obj];
        [self.stackView addSubview:item];
    }];
    
    
}



@end
