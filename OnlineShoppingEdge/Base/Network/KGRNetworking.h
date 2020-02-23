//
//  KGRNetworking.h
//
//  Created by luting on 2017/9/15.
//  Copyright © 2017年 lufeng. All rights reserved.
//

@import Foundation;
#import "WWNetwoorking.h"
#import "AFHTTPSessionManager.h"

@interface KGRNetworking : WWNetwoorking

@property (nonatomic,strong) NSMutableDictionary * _Nullable taskDict;

// RequestCancel
- (void)cancelAllRequest ;

- (void)cancelRequestWithURL:(NSString *_Nonnull)urlStr ;

@end

