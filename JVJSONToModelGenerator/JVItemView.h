//
//  JVItemView.h
//  JVRuntimeExample-Mac
//
//  Created by JarvanZhang on 2017/4/11.
//  Copyright © 2017年 JarvanZhang. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "JVUpdateKeyModel.h"
@interface JVItemView : NSView<NSTextFieldDelegate>
@property(strong,nonatomic)NSTextField *oldTextField;
@property(strong,nonatomic)NSTextField *updateTextField;

@property(strong,nonatomic)JVUpdateKeyModel *model;

-(void)setCurrentModel:(JVUpdateKeyModel *)currentModel;
@end
