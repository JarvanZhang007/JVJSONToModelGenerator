//
//  ViewController.m
//  JVRuntimeExample-Mac
//
//  Created by JarvanZhang on 2017/4/6.
//  Copyright © 2017年 JarvanZhang. All rights reserved.
//

#import "ViewController.h"
#import "JVUpdateKeyModel.h"
#import "JVSetNameViewController.h"
@interface ViewController()
@property(strong,nonatomic)NSMutableArray<__kindof NSString *> *urlArray;

/**
 key: fileName value:fileStr
 */
@property(strong,nonatomic)NSMutableDictionary *willWriteDictionary;

@property(strong,nonatomic)NSMutableArray<__kindof JVUpdateKeyModel *> *updataArray;

@property(strong,nonatomic)NSString *annotationStr;
@end

@implementation ViewController
-(NSString *)annotationStr{
    if (!_annotationStr) {
        _annotationStr=[NSString stringWithFormat:@"/*\
                                 \nCopyright (c) 2017 Models Class Generated from JSON powered by http://www.jianshu.com/u/\e9d493009a3f\
                        \nPermission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the 'Software'), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\
                        \nThe above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.\
                        \nTHE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.\
                                 \n*/"];

    }
    return _annotationStr;
}

-(NSMutableArray<JVUpdateKeyModel *> *)updataArray{
    if (!_updataArray) {
        _updataArray=[NSMutableArray array];
    }
    return _updataArray;
}

-(NSMutableDictionary *)willWriteDictionary{
    if (!_willWriteDictionary) {
        _willWriteDictionary=[NSMutableDictionary dictionary];
    }
    return _willWriteDictionary;
}

-(NSMutableArray<NSString *> *)urlArray{
    if (!_urlArray) {
        _urlArray=[NSMutableArray array];
    }
    return _urlArray;
}


#pragma mark-
#pragma mark--life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatDirectory];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
}

#pragma mark--Event
- (IBAction)createAction:(NSButton *)sender {
    
    if ([self.fileName.stringValue isEqualToString:@""]) {
        NSLog(@"请出入文件名");
    }else{
        [self.urlArray removeAllObjects];
        [self.willWriteDictionary removeAllObjects];
        [self.updataArray removeAllObjects];
        [self createFileWithJson];
    }
}

- (IBAction)gotoDocument:(NSButton *)sender {
    
    NSMutableArray *fileURLs=[NSMutableArray array];
    for (NSString *str in self.urlArray) {
        NSURL *url=[NSURL fileURLWithPath:str];
        [fileURLs addObject:url];
    }
    [[NSWorkspace sharedWorkspace] activateFileViewerSelectingURLs:fileURLs];
}


#pragma mark--JSON Serialization
-(void)createFileWithJson{

    NSData *data =[self.textView.string dataUsingEncoding:NSUTF8StringEncoding];
    
    id jsonObject=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

    NSUInteger i=self.segmentControl.selectedSegment;
    if (i==0) {
         [self createObjCFileJsonObject:jsonObject fileName:self.fileName.stringValue];
    }else{
       [self createSwiftFileJsonObject:jsonObject fileName:self.fileName.stringValue];
    }
    
//    指定Array item 的moddel name
    if (self.updataArray.count>0) {
//        NSAlert
        NSStoryboard *storyboard=[NSStoryboard storyboardWithName:@"Main" bundle:nil];
        JVSetNameViewController *vc=[storyboard instantiateControllerWithIdentifier:@"updateNameVC"];
        
        vc.dataArray=self.updataArray;
        
         [self presentViewControllerAsSheet:vc];
        
        vc.finishBlcok=^(){
                [self replaceFileString];
                [self writeFiles];
                [self gotoDocument:nil];
        };
        
    }else{
    
//        [self replaceFileString];
        [self writeFiles];
        [self gotoDocument:nil];
    }
}

#pragma mark--CreatFileStr
-(void)createObjCFileJsonObject:(NSDictionary *)dict fileName:(NSString *)name{
    
    
    NSMutableString *fileStrH=[NSMutableString stringWithFormat:@"\n%@\n#import <Foundation/Foundation.h>\n",self.annotationStr];
    

    NSMutableString *fileStrContentH=[NSMutableString stringWithFormat:
                              @"\n@interface %@ : NSObject",name];
    
    // 遍历字典，把字典中的所有key取出来，生成对应的属性代码
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        
        NSLog(@"数据类型:%@",[obj class]);
        NSString *type;
        
        NSString *objClass=NSStringFromClass([obj class]);
        
        if ([objClass rangeOfString:@"String"].location != NSNotFound) {
            type = @"NSString";
        }else if ([obj isKindOfClass:NSClassFromString(@"__NSArrayI")]||[obj isKindOfClass:NSClassFromString(@"__NSSingleObjectArrayI")]){
            type = @"NSArray";
        }else if ([objClass rangeOfString:@"Number"].location != NSNotFound){
            type = @"NSNumber";
        }else if ([obj isKindOfClass:NSClassFromString(@"__NSDictionaryI")]){
            type = @"NSDictionary";
        }
        
        // 属性字符串
        NSString *str;
        if ([type isEqualToString:@"NSDictionary"]) {
            
            NSString *newKey=[key capitalizedString];
             str = [NSString stringWithFormat:@"@property (nonatomic, strong) %@ *%@;",newKey,key];
            [fileStrH appendFormat:@"#import \"%@.h\"\n",newKey];
            [self createObjCFileJsonObject:obj fileName:newKey];
        }
        else if ([type isEqualToString:@"NSArray"]){
            NSArray *array=(NSArray *)obj;
            if (array.count>0) {
                id item=array[0];
                if ([item isKindOfClass:NSClassFromString(@"__NSDictionaryI")]) {
                    NSString *replaceKey=[NSString stringWithFormat:@"%@&&&&",[key capitalizedString]];
                    str = [NSString stringWithFormat:@"@property (nonatomic, strong)NSArray<__kindof %@*> *%@;",replaceKey,key];
                    [fileStrH appendFormat:@"#import \"%@.h\"\n",replaceKey];
                    
                    JVUpdateKeyModel *model=[JVUpdateKeyModel new];
                    model.arrayKey=key;
                    model.replaceKey=replaceKey;
                    model.updatedKey=[NSString stringWithFormat:@"%@Model",[key capitalizedString]];
                    [self.updataArray addObject:model];
                    
                    
                    [self createObjCFileJsonObject:item fileName:replaceKey];
                }else{
                str = [NSString stringWithFormat:@"@property (nonatomic, strong) %@ *%@;",type,key];
                }
            }else{
                    str = [NSString stringWithFormat:@"@property (nonatomic, strong) %@ *%@;",type,key];
            }
        }
        else{
            str = [NSString stringWithFormat:@"@property (nonatomic, strong) %@ *%@;",type,key];
        }
        // 每生成属性字符串，就自动换行。
        [fileStrContentH appendFormat:@"\n%@\n",str];
        
    }];
    
    
    [fileStrContentH appendString:@"@end"];
    
    [fileStrH appendString:fileStrContentH];
    
    [self.willWriteDictionary setObject:fileStrH forKey:[NSString stringWithFormat:@"%@.h",name]];
    
    
    
    NSString *fileStrM = [NSString stringWithFormat:@"#import \"%@.h\" \n\
                          \n@implementation %@ \n\
                         \n@end",name,name];

    [self.willWriteDictionary setObject:fileStrM forKey:[NSString stringWithFormat:@"%@.m",name]];
    
    
}








-(void)createSwiftFileJsonObject:(NSDictionary *)dict fileName:(NSString *)name{
    
    
    
}



#pragma mark--Replace File Str
-(void)replaceFileString{

    __block NSMutableDictionary *dictionary=[NSMutableDictionary dictionary];
    [self.willWriteDictionary enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, NSString* fileStr, BOOL * _Nonnull stop) {
        
        
        for (JVUpdateKeyModel *model in self.updataArray) {
            fileStr = [fileStr stringByReplacingOccurrencesOfString:model.replaceKey                                                         withString:model.updatedKey];
            [dictionary setObject:fileStr forKey:key];
        }
    }];
    
    __block NSMutableDictionary *newDict=[NSMutableDictionary dictionary];
    [dictionary enumerateKeysAndObjectsUsingBlock:^(NSString* key,NSString* obj, BOOL * _Nonnull stop) {
        
        [newDict setObject:obj forKey:key];
        for (JVUpdateKeyModel *model in self.updataArray) {
            
            NSMutableString *reKey = [[NSMutableString  alloc]initWithString:key];
            
            NSString *str=[reKey substringWithRange:NSMakeRange(reKey.length-2, 2)];
            
            [reKey deleteCharactersInRange:NSMakeRange(reKey.length-2, 2)];
            
            if ([model.replaceKey isEqualToString:reKey]) {
             NSString*   newkey = [NSString stringWithFormat:@"%@%@",model.updatedKey,str];
                [newDict removeObjectForKey:key];
                [newDict setObject:obj forKey:newkey];
                
            }
        }
        
    }];
    
    self.willWriteDictionary=newDict;
}

#pragma mark--Write File str
-(void)writeFiles{

    for (NSString *key in self.willWriteDictionary.allKeys) {
        NSString *fileStr = [self.willWriteDictionary objectForKey:key];
        [self writeFileWithName:key string:fileStr];
    }
}

-(void)creatDirectory{

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents directory
    NSError *error;
    NSString *fullUrl=[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"JVModels"]];
    
    NSFileManager *manager=[NSFileManager defaultManager];
    
    BOOL a = [manager createDirectoryAtPath:fullUrl withIntermediateDirectories:YES attributes:nil error:&error];
    
    if (!a) {
        NSLog(@"错误%@",error);
    }

}

-(void)writeFileWithName:(NSString *)name string:(NSString *)str{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents directory
    NSError *error;
    NSString *fullUrl=[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"JVModels/%@",name]];
    
    BOOL succeed = [str writeToFile:fullUrl
                         atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if (!succeed){
        // Handle error here
        NSLog(@"错误");
    }else{
        [self.urlArray addObject:fullUrl];
    }
}


@end
