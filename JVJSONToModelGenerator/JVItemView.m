//
//  JVItemView.m
//  JVRuntimeExample-Mac
//
//  Created by JarvanZhang on 2017/4/11.
//  Copyright © 2017年 JarvanZhang. All rights reserved.
//

#import "JVItemView.h"

@implementation JVItemView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

-(instancetype)initWithFrame:(NSRect)frameRect{
    if (self=[super initWithFrame:frameRect]) {
        CGFloat gap=10.f,width=(frameRect.size.width-3*gap)/2.f,gapTop=5;
        self.oldTextField=[[NSTextField alloc]initWithFrame:NSMakeRect(gap, gapTop, width, frameRect.size.height-gapTop)];
        self.oldTextField.editable=NO;
        self.oldTextField.bordered=NO;
        self.oldTextField.textColor=[NSColor grayColor];
        [self addSubview:self.oldTextField];
        
        NSTextField *gapTextField =[[NSTextField alloc]initWithFrame:NSMakeRect(gap+width-25, gapTop, 50, frameRect.size.height-gapTop)];
        gapTextField.editable=NO;
        gapTextField.bordered=NO;
        gapTextField.textColor=[NSColor greenColor];
        gapTextField.stringValue=@">";
        gapTextField.font=[NSFont systemFontOfSize:20];
        [self addSubview:gapTextField];

        self.updateTextField=[[NSTextField alloc]initWithFrame:NSMakeRect(2*gap+width, gapTop, width, frameRect.size.height-gapTop)];
        self.updateTextField.delegate=self;
        [self addSubview:self.updateTextField];
    }
    return self;
}

-(void)setCurrentModel:(JVUpdateKeyModel *)currentModel{

    self.model=currentModel;
    
    self.oldTextField.stringValue=currentModel.arrayKey;
    
    self.updateTextField.stringValue=currentModel.updatedKey;
}


- (void)controlTextDidChange:(NSNotification *)notification {
    NSTextField *textField = [notification object];
//    NSLog(@"[%@ %@] stringValue == %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), [textField stringValue]);
    self.model.updatedKey=[textField stringValue];
}
@end
