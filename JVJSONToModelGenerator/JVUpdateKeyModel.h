//
//  JVUpdateKeyModel.h
//  JVRuntimeExample-Mac
//
//  Created by JarvanZhang on 2017/4/10.
//  Copyright © 2017年 JarvanZhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JVUpdateKeyModel : NSObject
//原始的key
@property(strong,nonatomic)NSString *arrayKey;
//中间代替Key
@property(strong,nonatomic)NSString *replaceKey;
//替换key
@property(strong,nonatomic)NSString *updatedKey;
@end
