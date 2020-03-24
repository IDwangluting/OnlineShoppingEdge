//
//  CustomActivity.m
//  UIActivityViewController
//
//  Created by 王双龙 on 16/8/30.
//  Copyright © 2016年 http://www.jianshu.com/users/e15d1f644bea All rights reserved.
//

#import "CustomActivity.h"

@implementation CustomActivity {
    NSString * _title;
    UIImage  * _image;
    NSURL    * _url  ;
    NSString * _type ;
    NSArray  * _shareContexts;
}

- (instancetype)initWithTitie:(NSString *)title
                        image:(UIImage *)image
                          url:(NSURL   *)url
                         type:(NSString *)type
                      context:(NSArray *)shareContexts{
    if(self == [super init]){
        _title         = title;
        _image         = image;
        _url           = url;
        _type          = type;
        _shareContexts = shareContexts;
    }
    return self;
}

- (UIActivityCategory)activityCategory{
    return UIActivityCategoryAction;
}

- (NSString *)activityType{
    return _type;
}

- (NSString *)activityTitle {
    return _title;
}

- (UIImage *)activityImage {
    return _image;
}

- (NSURL *)activityUrl{
    return _url;
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
    return activityItems.count > 0 ;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems {
    //准备分享所进行的方法，通常在这个方法里面，把item中的东西保存下来,items就是要传输的数据
}

- (void)performActivity {
    [self activityDidFinish:YES];
    if (![[UIApplication sharedApplication] canOpenURL:_url]) return ;
    
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:_url options:@{} completionHandler:nil];
    } else {
        [[UIApplication sharedApplication] openURL:_url];
    }
}

@end
