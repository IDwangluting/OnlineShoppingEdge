//
//  WWNetwoorking.h
//  Kangaroo
//
//  Created by luting on 2019/11/20.
//  Copyright © 2019 bocai. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "WWJsonToModelTool.h"
#import <YYCache/YYCache.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ProgressBlock)(NSProgress * _Nonnull);
typedef void(^SuccessBlock)(NSURLSessionDataTask * _Nullable task, id _Nullable result);
typedef void(^FailureBlock)(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error);
typedef void(^DataCache)(id _Nullable result);
typedef void(^CompletionHandlerBlock)(NSURLResponse * _Nullable response, id _Nullable responseObject,  NSError * _Nullable error);

@interface WWNetwoorking : AFHTTPSessionManager

@property (nonatomic,strong)WWJsonToModelTool * jsonToModelTool;
@property (nonatomic,strong)YYCache * dataCache ;

- (void)networkSetting;

- (NSDictionary *_Nullable)getRequestHearder;

- (double)validateLocalTime:(NSString * _Nonnull)dateStr;

- (void)setValue:(NSString * _Nonnull)value forHTTPHeaderField:(NSString * _Nonnull)field;

- (void)presentLogin:(UIViewController *)viewController;

- (NSError *)dealWithError:(NSError * _Nullable)error url:(NSString * _Nonnull)url;

- (NSString *)dealWithUrl:(NSString *_Nonnull)url;

// DealWtihRequestResult

- (void)requestWithUrl:(NSString * _Nonnull)url
               failure:(FailureBlock _Nullable)failures
                  task:(NSURLSessionDataTask * _Nonnull)task
                 error:(NSError * _Nonnull)error ;

- (void)requestWithUrl:(NSString * _Nonnull)url
            parameters:(id _Nullable)parameters
               success:(SuccessBlock _Nonnull)success
                  task:(NSURLSessionDataTask * _Nonnull)task
                result:(id _Nullable)result ;

// MethodPackage

- (void)WWHEAD:(NSString *_Nonnull)url
    parameters:(id _Nullable)parameters
       success:(void (^_Nullable)(NSURLSessionDataTask * _Nonnull task))success
       failure:(FailureBlock _Nullable)failure;

- (void)WWPUT:(NSString * _Nonnull)url
   parameters:(id _Nullable)parameters
      success:(SuccessBlock _Nullable)success
      failure:(FailureBlock _Nullable)failure ;

- (void)WWPATCH:(NSString * _Nonnull)url
     parameters:(id _Nullable)parameters
        success:(SuccessBlock _Nullable)success
        failure:(FailureBlock _Nullable)failure ;

- (void)WWDELETE:(NSString * _Nonnull)url
      parameters:(id _Nullable)parameters
         success:(SuccessBlock _Nullable)success
         failure:(FailureBlock _Nullable)failure ;

- (void)WWGET:(NSString * _Nonnull)url
   parameters:(id _Nullable)parameters
     progress:(ProgressBlock _Nullable)downloadProgress
      success:(SuccessBlock _Nullable)success
      failure:(FailureBlock _Nullable)failure ;

- (void)WWPOST:(NSString * _Nonnull)url
    parameters:(id _Nullable)parameters
      progress:(ProgressBlock _Nullable)progress
       success:(SuccessBlock _Nullable)success
       failure:(FailureBlock _Nullable)failure ;

- (NSURLSessionDataTask *_Nonnull)dataTaskWithHTTPMethod:(NSString *_Nonnull)method
                                                     url:(NSString * _Nonnull)url
                                              parameters:(id _Nullable)parameters
                                          uploadProgress:(ProgressBlock _Nullable)uploadProgress
                                        downloadProgress:(ProgressBlock _Nullable)downloadProgress
                                                 success:(SuccessBlock _Nullable)success
                                                 failure:(FailureBlock _Nullable)failure;

// OtherRequest
- (void)patchRequest:(NSString * _Nonnull)url
          parameters:(id _Nullable)parameters
             success:(SuccessBlock _Nullable)success
             failure:(FailureBlock _Nullable)failure ;

- (void)deleteRequest:(NSString * _Nonnull)url
           parameters:(id _Nullable)parameters
              success:(SuccessBlock _Nullable)success
              failure:(FailureBlock _Nullable)failure ;

- (void)headRequest:(NSString *_Nonnull)url
         parameters:(id _Nullable)parameters
            success:(void (^ _Nullable)(NSURLSessionDataTask * _Nonnull task))success
            failure:(FailureBlock _Nullable)failure ;

- (void)putRequest:(NSString *_Nonnull)url
        parameters:(id _Nullable)parameters
           success:(SuccessBlock _Nullable)success
           failure:(FailureBlock _Nullable)failure ;

- (void)putRequest:(NSString *_Nonnull)url
        parameters:(id _Nullable)parameters
          useCache:(DataCache _Nullable)cache
           success:(SuccessBlock _Nullable)success
           failure:(FailureBlock _Nullable)failure ;

// GetRequest
- (void)getRequest:(NSString * _Nonnull)url
           success:(SuccessBlock _Nullable)success
           failure:(FailureBlock _Nullable)failures;

- (void)getRequest:(NSString * _Nonnull)url
        parameters:(id _Nullable)parameters
           success:(SuccessBlock _Nullable)success
           failure:(FailureBlock _Nullable)failures;

- (void)getRequest:(NSString *_Nonnull)url
        parameters:(id _Nullable)parameters
          useCache:(DataCache _Nullable)cache
           success:(SuccessBlock _Nullable)success
           failure:(FailureBlock _Nullable)failures ;

- (void)getRequest:(NSString * _Nonnull)url
        parameters:(id _Nullable)parameters
          useCache:(DataCache _Nullable)cache
          progress:(ProgressBlock _Nullable)progress
           success:(SuccessBlock _Nullable)success
           failure:(FailureBlock _Nullable)failures ;

- (void)getRequest:(NSString * _Nonnull)url
        parameters:(id _Nullable)parameters
          progress:(ProgressBlock _Nullable)progress
           success:(SuccessBlock _Nullable)success
           failure:(FailureBlock _Nullable)failures;

// PostRequest
- (void)postRequest:(NSString * _Nonnull)url
         parameters:(id _Nullable)parameters
            success:(SuccessBlock _Nullable )success
            failure:(FailureBlock _Nullable)failures;

- (void)postRequest:(NSString * _Nonnull)url
         parameters:(id _Nullable)parameters
           progress:(ProgressBlock _Nullable)progress
            success:(SuccessBlock _Nullable)success
            failure:(FailureBlock _Nullable)failures;

- (void)postRequest:(NSString * _Nonnull)url
         parameters:(id _Nullable)parameters
           useCache:(DataCache _Nullable)cache
            success:(SuccessBlock _Nullable)success
            failure:(FailureBlock _Nullable)failures;

- (void)postRequest:(NSString * _Nonnull)url
         parameters:(id _Nullable)parameters
           useCache:(DataCache _Nullable)cache
           progress:(ProgressBlock _Nullable)progress
            success:(SuccessBlock _Nullable )success
            failure:(FailureBlock _Nullable)failures;

// Cache
- (id _Nullable)getCacheWithKey:(NSString * _Nonnull)key
                            url:(NSString * _Nonnull)url;

- (id _Nullable )getCacheWithUrl:(NSString *_Nonnull)url
                      parameters:(id _Nullable)parameters ;

- (NSString *_Nonnull)cacheKeyWtihUrl:(NSString * _Nonnull)url
                           parameters:(id _Nullable)parameters ;

- (void)cacheData:(id _Nonnull)data key:(NSString * _Nonnull)key;

- (void)cacheData:(id _Nonnull )data
              url:(NSString *_Nonnull)url
       parameters:(id _Nullable)parameters ;

- (void)clearCache;

@end

NS_ASSUME_NONNULL_END
