//
//  OSEMutableDictionary.m
//  OnlineShoppingEdge
//
//  Created by luting on 20/2/9.
//  Copyright © 2020 luting. All rights reserved.
//

#import "OSEMutableDictionary.h"

@implementation OSEMutableDictionary
static OSEMutableDictionary * obj = nil;
static NSMutableDictionary * contentData = nil;

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [[OSEMutableDictionary alloc]init];
    });
    return obj;
}

- (instancetype)init {
    if (self = [super init]) {
        contentData = [[NSMutableDictionary alloc]initWithCapacity:4];
        [contentData setObject:@{PlatformName     :@"天猫",
                          HistoricalPriceData:@"detail.tmallvvv.com"}
                 forKey:@"detail.tmall.com"];
        [contentData setObject:@{PlatformName       :@"天猫",
                          HistoricalPriceData:@"detail.m.tmallvvv.com"}
                 forKey:@"detail.m.tmall.com"];
                      
        [contentData setObject:@{PlatformName       :@"淘宝",
                          HistoricalPriceData:@"item.taobaovvv.com"}
                 forKey:@"item.taobao.com"];
        [contentData setObject:@{PlatformName       :@"淘宝",
                          HistoricalPriceData:@"h5.m.taobaovvv.com"}
                 forKey:@"h5.m.taobao.com"];
                      
        [contentData setObject:@{PlatformName       :@"京东",
                          HistoricalPriceData:@"item.jdvvv.com"}
                 forKey:@"item.jd.com"];
        [contentData setObject:@{PlatformName       :@"京东",
                          HistoricalPriceData:@"item.m.jdvvv.com"}
                 forKey:@"item.m.jd.com"];
                      
        [contentData setObject:@{PlatformName       :@"亚马逊",
                          HistoricalPriceData:@"www.amazonvvv.cn"}
                 forKey:@"www.amazon.cn"];
                      
        [contentData setObject:@{PlatformName       :@"当当",
                          HistoricalPriceData:@"product.dangdangvvv.com"}
                 forKey:@"product.dangdang.com"];
        [contentData setObject:@{PlatformName       :@"当当",
                          HistoricalPriceData:@"product.dangdangvvv.com"}
                 forKey:@"product.m.dangdang.com"];
                                            
        [contentData setObject:@{PlatformName       :@"苏宁易购",
                          HistoricalPriceData:@"product.suningvvv.com"}
                 forKey:@"product.suning.com"];
                                                   
        [contentData setObject:@{PlatformName       :@"国美",
                          HistoricalPriceData:@"item.gomevvv.com.cn"}
                 forKey:@"item.gome.com.cn"];
                                                   
        [contentData setObject:@{PlatformName       :@"考拉海购",
                          HistoricalPriceData:@"goods.kaolavvv.com"}
                 forKey:@"goods.kaola.com"];
        [contentData setObject:@{PlatformName       :@"考拉海购",
                          HistoricalPriceData:@"goods.kaolavvv.com"}
                 forKey:@"m-goods.kaola.com"];
                                                   
        // 暂不支持
        [contentData setObject:@{PlatformName       :@"苏宁易购",
                          HistoricalPriceData:@"m.suning.com"}
                 forKey:@"m.suning.com"];
        [contentData setObject:@{PlatformName       :@"国美",
                          HistoricalPriceData:@"item.m.gome.com.cn"}
                 forKey:@"item.m.gome.com.cn"];
    }
    return self;
}

+ (NSArray *)allKeys {
    [OSEMutableDictionary shareInstance];
    return contentData.allKeys;
}

+ (NSDictionary *)contentData {
    return contentData;
}

+ (NSString *)histroyDeatailUrl:(NSString *)url {
    NSString * host = [NSURL URLWithString:url].host;
    if ([contentData.allKeys containsObject:host]) {
        NSString * historicalPrice = [[contentData objectForKey:host] objectForKey:HistoricalPriceData];
        url = [url stringByReplacingOccurrencesOfString:host withString:historicalPrice];
    }
    return url;
}

@end
