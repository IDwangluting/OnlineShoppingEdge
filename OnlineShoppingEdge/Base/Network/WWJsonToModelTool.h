//
//  WWJsonToModelTool.h
//  Kangaroo
//
//  Created by luting on 2019/12/31.
//  Copyright © 2019 bocai. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WWJsonToModelTool : NSObject

@property (nonatomic,copy)NSString * _Nullable prefix;

@property (nonatomic,copy)NSString * _Nullable suffix;

@property (nonatomic,strong)NSArray * _Nullable acceptDomains;

- (id _Nullable)jsonToModelWithData:(id _Nonnull)jsonData url:(NSString * _Nonnull)url;

- (Class _Nullable)getModelClassWithUrl:(NSString * _Nonnull)url;

- (void)clearCache;

@end

NS_ASSUME_NONNULL_END
