//
//  JVSetNameViewController.h
//  JVRuntimeExample-Mac
//
//  Created by JarvanZhang on 2017/4/11.
//  Copyright © 2017年 JarvanZhang. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "JVUpdateKeyModel.h"
@interface JVSetNameViewController : NSViewController
@property(strong,nonatomic)NSMutableArray<__kindof JVUpdateKeyModel *> *dataArray;
@property (weak) IBOutlet NSScrollView *scrollView;

@property(copy,nonatomic)void(^finishBlcok)(void);
@end
