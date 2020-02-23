//
//  WWJsonToModelTool.m
//  Kangaroo
//
//  Created by luting on 2019/12/31.
//  Copyright © 2019 bocai. All rights reserved.
//

#import "WWJsonToModelTool.h"
#import <YYModel/YYModel.h>

@implementation WWJsonToModelTool {
    NSCache * _modelClsCache;
}

- (instancetype)init {
    if (self = [super init]) {
        _modelClsCache                = [[NSCache alloc]init];
        _modelClsCache.countLimit     = 50;
        _modelClsCache.totalCostLimit = 5*1024*1024;
    }
    return self;
}

- (id _Nullable)jsonToModelWithData:(id _Nonnull)jsonData url:(NSString * _Nonnull)url {
    if (![jsonData isKindOfClass:[NSDictionary class]] &&
        ![jsonData isKindOfClass:[NSArray class]])  return  jsonData;
    Class modelCls = [_modelClsCache objectForKey:url];
    if (!modelCls) {
        modelCls = [self getModelClassWithUrl:url];
        if (modelCls == nil) return jsonData;
        [_modelClsCache setObject:modelCls forKey:url];
    }
    if (modelCls == nil) return jsonData;
    if ([jsonData isKindOfClass:[NSArray class]]) {
        NSArray *array = [NSArray yy_modelArrayWithClass:modelCls json:jsonData];
        if (array && array.count > 0) return array;
        return jsonData;
    } else if ([jsonData isKindOfClass:[NSDictionary class]]) {
        return [modelCls yy_modelWithDictionary:jsonData];
    }
    return nil;
}

- (Class _Nullable)getModelClassWithUrl:(NSString * _Nonnull)url {
    NSString * tmpUrl = url;
    for (NSString * domain in self.acceptDomains) {
        if ([tmpUrl containsString:domain]) {
            tmpUrl = [tmpUrl stringByReplacingOccurrencesOfString:domain withString:@""];
        }
    }
    NSArray * array = [tmpUrl componentsSeparatedByString:@"/"];
    tmpUrl = @"";
    for (NSString * str in array) {
        if (!str || str.length < 1 )  continue ;
        NSString * capitalizedString = [[str substringToIndex:1] capitalizedString];
        NSString * resultStr = [str stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:capitalizedString];
        tmpUrl = [NSString stringWithFormat:@"%@%@",tmpUrl,resultStr];
    }
    
    NSString * className = [NSString stringWithFormat:@"%@%@%@",self.prefix?:@"",tmpUrl,self.suffix?:@""];
    if (!objc_lookUpClass(className.UTF8String)) return nil;
    return NSClassFromString(className);
}

- (void)clearCache {
    [_modelClsCache removeAllObjects];
}

@end
