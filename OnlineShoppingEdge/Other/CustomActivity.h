//
//  CustomActivity.h
//  UIActivityViewController
//
//  Created by 王双龙 on 16/8/30.
//  Copyright © 2016年 http://www.jianshu.com/users/e15d1f644bea All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomActivity : UIActivity

- (instancetype)initWithTitie:(NSString *)title
                        image:(UIImage *)image
                          url:(NSURL *)url
                         type:(NSString *)type
                      context:(NSArray *)shareContexts;

@end
