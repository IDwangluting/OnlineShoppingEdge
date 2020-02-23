//
//  WWNetwoorking.m
//  Kangaroo
//
//  Created by luting on 2019/11/20.
//  Copyright © 2019 bocai. All rights reserved.
//

#import "WWNetwoorking.h"
#import <YYCategories/YYCategories.h>

typedef NSString * REQUSTMETHOD ;

REQUSTMETHOD  PostMethod   = @"POST";
REQUSTMETHOD  GetMethod    = @"GET";
REQUSTMETHOD  HeadMethod   = @"HEAD";
REQUSTMETHOD  PutMethod    = @"PUT";
REQUSTMETHOD  PatchMethod  = @"PATCH";
REQUSTMETHOD  DeleteMethod = @"DELETE";

#define  Difftime    @"Difftime"

@implementation WWNetwoorking {
    NSCache * _HTTPRequestCache;
}

+ (instancetype)manager {
    static WWNetwoorking * manager ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[WWNetwoorking alloc]initWithBaseURL:nil];
    });
    return manager;
}

- (instancetype)initWithBaseURL:(NSURL *)url  {
    if (self = [super initWithBaseURL:url]) {
        [self networkSetting];
        self.requestSerializer = [AFHTTPRequestSerializer serializer];
        self.responseSerializer = [AFHTTPResponseSerializer serializer];
        self.dataCache = [YYCache cacheWithName:[[NSBundle mainBundle] bundleIdentifier]];
        self.jsonToModelTool = [WWJsonToModelTool new];
        self.jsonToModelTool.prefix = @"";
        self.jsonToModelTool.suffix = @"Model";
        
        _HTTPRequestCache                = [[NSCache alloc]init];
        _HTTPRequestCache.countLimit     = 50;
        _HTTPRequestCache.totalCostLimit = 5*1024*1024;
    }
    return self;
}

- (void)networkSetting {
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                      @"text/html",
                                                      @"text/json",
                                                      @"text/plain",
                                                      @"text/javascript",
                                                      @"text/xml",
                                                      @"image/jpeg",
                                                      @"image/*",nil];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.allowInvalidCertificates = YES;
    securityPolicy.validatesDomainName = NO;
    self.securityPolicy = securityPolicy;
    self.requestSerializer.timeoutInterval = 10;
    self.completionQueue = dispatch_queue_create([[NSBundle mainBundle] bundleIdentifier].UTF8String, DISPATCH_QUEUE_SERIAL);
}

- (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field {
    [self.requestSerializer setValue:value forHTTPHeaderField:field];
}

- (NSDictionary *)getRequestHearder{
    return [self.requestSerializer HTTPRequestHeaders];
}

- (NSError *)dealWithError:(NSError *)error url:(NSString *)url{
    return error ;
}

- (NSString *)dealWithUrl:(NSString *)url {
    return url;
}

- (void)presentLogin:(UIViewController *)viewController {
    dispatch_block_t presentBlock = ^{
        UIViewController * vc = [UIApplication sharedApplication].keyWindow.rootViewController;
        while ([vc isKindOfClass:[UITabBarController class]] ||
               [vc isKindOfClass:[UINavigationController class]]||
               vc.presentedViewController ) {
            while ([vc isKindOfClass:[UITabBarController class]]) {
                vc = ((UITabBarController *)vc).selectedViewController;
            }
            while ([vc isKindOfClass:[UINavigationController class]]) {
                vc = ((UINavigationController *)vc).viewControllers.lastObject;
            }
            while (vc.presentedViewController) {
                vc = vc.presentedViewController;
            }
        }
        if ([vc isKindOfClass:viewController.class])  return ;
        [vc presentViewController:viewController animated:YES completion:nil];
    };
    
    if ([[NSThread currentThread] isMainThread]) {
        presentBlock();
        return ;
    }
    
    dispatch_async(dispatch_get_main_queue(),presentBlock);
}

- (double)validateLocalTime:(NSString *)dateStr {
    if(!dateStr && dateStr.length < 1) return 0;
    
    dateStr = [dateStr substringFromIndex:5];
    dateStr = [dateStr substringToIndex:[dateStr length]-4];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [formatter setDateFormat:@"dd MMM yyyy HH:mm:ss"];
    NSDate *serverDate = [[formatter dateFromString:dateStr] dateByAddingHours:8];
    NSTimeInterval difftime = serverDate.timeIntervalSince1970 - [NSDate date].timeIntervalSince1970;
    [[NSUserDefaults standardUserDefaults] setDouble:difftime forKey:Difftime];
    return difftime;
}

// DealWtihRequestResult
- (void)requestWithUrl:(NSString *)url
               failure:(FailureBlock)failures
                  task:(NSURLSessionDataTask *)task
                 error:(NSError *)error {
    if (!error) return  ;
    error = [self dealWithError:error url:url];
    dispatch_async(dispatch_get_main_queue(),^{
        if (failures)  failures(task,error);
    });
}

- (void)requestWithUrl:(NSString *)url
            parameters:(id)parameters
               success:(SuccessBlock)success
                  task:(NSURLSessionDataTask *)task
                result:(id)result {
    if (!success) return  ;
    
    if (result) {
        id data = [self.jsonToModelTool jsonToModelWithData:result url:url];
        dispatch_async(dispatch_get_main_queue(),^{
            success(task,data);
        });
        return ;
    }
}

// MethodPackage
- (void)WWHEAD:(NSString *)url
    parameters:(id)parameters
       success:(void (^)(NSURLSessionDataTask *task))success
       failure:(FailureBlock _Nullable)failure {
    [self dataTaskWithHTTPMethod:HeadMethod
                             url:url
                      parameters:parameters
                  uploadProgress:nil
                downloadProgress:nil
                         success:^(NSURLSessionDataTask *task, __unused id responseObject) {
                             if (success)  success(task);
                         }failure:failure];
}

- (void)WWPUT:(NSString *)url
   parameters:(id)parameters
      success:(SuccessBlock _Nullable)success
      failure:(FailureBlock _Nullable)failure {
    [self dataTaskWithHTTPMethod:PutMethod
                             url:url
                      parameters:parameters
                  uploadProgress:nil
                downloadProgress:nil
                         success:success
                         failure:failure];
}

- (void)WWPATCH:(NSString *)url
     parameters:(id)parameters
        success:(SuccessBlock _Nullable)success
        failure:(FailureBlock _Nullable)failure{
    [self dataTaskWithHTTPMethod:PatchMethod
                             url:url
                      parameters:parameters
                  uploadProgress:nil
                downloadProgress:nil
                         success:success
                         failure:failure];
}

- (void)WWDELETE:(NSString *)url
      parameters:(id)parameters
         success:(SuccessBlock _Nullable)success
         failure:(FailureBlock _Nullable)failure {
    [self dataTaskWithHTTPMethod:DeleteMethod
                             url:url
                      parameters:parameters
                  uploadProgress:nil
                downloadProgress:nil
                         success:success
                         failure:failure];
}

- (void)WWGET:(NSString *)url
   parameters:(id)parameters
     progress:(ProgressBlock _Nullable)downloadProgress
      success:(SuccessBlock _Nullable)success
      failure:(FailureBlock _Nullable)failure {
    [self dataTaskWithHTTPMethod:GetMethod
                             url:url
                      parameters:parameters
                  uploadProgress:nil
                downloadProgress:downloadProgress
                         success:success failure:failure];
}

- (void)WWPOST:(NSString *)url
    parameters:(id)parameters
      progress:(ProgressBlock _Nullable)progress
       success:(SuccessBlock _Nullable)success
       failure:(FailureBlock _Nullable)failure {
    [self dataTaskWithHTTPMethod:PostMethod
                             url:url
                      parameters:parameters
                  uploadProgress:progress
                downloadProgress:nil
                         success:success
                         failure:failure];
}

- (NSURLSessionDataTask *_Nonnull)dataTaskWithHTTPMethod:(NSString *_Nonnull)method
                                                     url:(NSString * _Nonnull)url
                                              parameters:(id _Nullable)parameters
                                          uploadProgress:(ProgressBlock _Nullable)uploadProgress
                                        downloadProgress:(ProgressBlock _Nullable)downloadProgress
                                                 success:(SuccessBlock _Nullable)success
                                                 failure:(FailureBlock _Nullable)failure {
    NSString * key = [[NSString stringWithFormat:@"%@_%@_%@",method?:@"",url?:@"",parameters?:@""] md5String];
    NSMutableURLRequest *HTTPRequest = [_HTTPRequestCache objectForKey:key];
    if (!HTTPRequest) {
        NSError *serializationError = nil;
        NSString * URLString = [[NSURL URLWithString:url relativeToURL:self.baseURL] absoluteString];
        HTTPRequest = [self.requestSerializer requestWithMethod:method
                                                      URLString:URLString
                                                     parameters:parameters
                                                          error:&serializationError];
        if (serializationError) {
            if (failure) {
                dispatch_async(self.completionQueue ?: dispatch_get_main_queue(), ^{
                    failure(nil, serializationError);
                });
            }
            return nil;
        }
        [_HTTPRequestCache setObject:HTTPRequest forKey:key];
    }

    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [self dataTaskWithRequest:HTTPRequest
                          uploadProgress:uploadProgress
                        downloadProgress:downloadProgress
                       completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
                           if (error && failure) {
                               failure(dataTask, error);
                           } else if (success) {
                               success(dataTask, responseObject);
                           }
                       }];
    return dataTask;
}

- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest * _Nonnull)request
                               uploadProgress:(ProgressBlock _Nullable)uploadProgress
                             downloadProgress:(ProgressBlock _Nullable)downloadProgress
                            completionHandler:(CompletionHandlerBlock _Nullable)completionHandler {
    NSURLSessionDataTask * dataTask = [super dataTaskWithRequest:request
                                                  uploadProgress:uploadProgress
                                                downloadProgress:downloadProgress
                                               completionHandler:completionHandler];
    [dataTask resume];
    return dataTask;
}

// OtherRequest
- (void)patchRequest:(NSString *)url
          parameters:(id)parameters
             success:(SuccessBlock _Nullable)success
             failure:(FailureBlock _Nullable)failure{
    [self WWPATCH:url parameters:parameters success:success failure:failure];
}

- (void)deleteRequest:(NSString *)url
           parameters:(id)parameters
              success:(SuccessBlock _Nullable)success
              failure:(FailureBlock _Nullable)failure {
    [self WWDELETE:url parameters:parameters success:success failure:failure];
}

- (void)headRequest:(NSString *)url
         parameters:(id)parameters
            success:(void (^)(NSURLSessionDataTask *task))success
            failure:(FailureBlock _Nullable)failure {
    [self WWHEAD:url parameters:parameters success:success failure:failure];
}

- (void)putRequest:(NSString *)url
        parameters:(id)parameters
           success:(SuccessBlock _Nullable)success
           failure:(FailureBlock _Nullable)failure {
    [self WWPUT:url parameters:parameters success:success failure:failure];
}

- (void)putRequest:(NSString *)url
        parameters:(id)parameters
          useCache:(DataCache _Nullable)cache
           success:(SuccessBlock _Nullable)success
           failure:(FailureBlock _Nullable)failure {
    @weakify(self);
    dispatch_async(dispatch_get_main_queue(), ^{
        @strongify(self);
        if (cache)  cache([self getCacheWithUrl:url parameters:parameters]);
    });
    [self WWPUT:url parameters:parameters success:success failure:failure];
}

// GetRequest
- (void)getRequest:(NSString * _Nonnull)url
           success:(SuccessBlock _Nullable)success
           failure:(FailureBlock _Nullable)failures{
    [self getRequest:url
          parameters:nil
            useCache:nil
            progress:nil
             success:success
             failure:failures];
}

- (void)getRequest:(NSString * _Nonnull)url
        parameters:(id _Nullable)parameters
           success:(SuccessBlock _Nullable)success
           failure:(FailureBlock _Nullable)failures{
    [self getRequest:url
          parameters:parameters
            useCache:nil
            progress:nil
             success:success
             failure:failures];
}

- (void)getRequest:(NSString *_Nonnull)url
        parameters:(id _Nullable)parameters
          useCache:(DataCache _Nullable)cache
           success:(SuccessBlock _Nullable)success
           failure:(FailureBlock _Nullable)failures {
    [self getRequest:url
          parameters:parameters
            useCache:cache
            progress:nil
             success:success
             failure:failures];
}

- (void)getRequest:(NSString * _Nonnull)url
        parameters:(id _Nullable)parameters
          useCache:(DataCache _Nullable)cache
          progress:(ProgressBlock _Nullable)downloadProgress
           success:(SuccessBlock _Nullable)success
           failure:(FailureBlock _Nullable)failures {
    @weakify(self);
    dispatch_async(dispatch_get_main_queue(), ^{
        @strongify(self);
        if (cache)  cache([self getCacheWithUrl:url parameters:parameters]);
    });
    [self getRequest:url
          parameters:parameters
            progress:downloadProgress
             success:success
             failure:failures];
}

- (void)getRequest:(NSString * _Nonnull)url
        parameters:(id _Nullable)parameters
          progress:(ProgressBlock _Nullable)downloadProgress
           success:(SuccessBlock _Nullable)success
           failure:(FailureBlock _Nullable)failures {
    if (!url || url.length < 1) return ;
    
    @weakify(self);
    [self WWGET:[self dealWithUrl:url]
     parameters:parameters
       progress:downloadProgress
        success:^(NSURLSessionDataTask *  task, id  result) {
            @strongify(self);
        if ([result isKindOfClass:[NSData class]]) {
            success(task,result);
            return ;
        }
            [self requestWithUrl:url
                      parameters:parameters
                         success:success
                            task:task
                          result:result];
        }failure:^(NSURLSessionDataTask *  task, NSError *  error) {
            @strongify(self);
            [self requestWithUrl:url failure:failures task:task error:error];
        }];
}

// PostRequest
- (void)postRequest:(NSString *)url
         parameters:(id)parameters
            success:(SuccessBlock _Nullable )success
            failure:(FailureBlock _Nullable)failures  {
    [self postRequest:url
           parameters:parameters
             useCache:nil
             progress:nil
              success:success
              failure:failures];
}

- (void)postRequest:(NSString *)url
         parameters:(id)parameters
           useCache:(DataCache)cache
            success:(SuccessBlock _Nullable )success
            failure:(FailureBlock _Nullable)failures{
    [self postRequest:url
           parameters:parameters
             useCache:cache
             progress:nil
              success:success
              failure:failures];
}

- (void)postRequest:(NSString *)url
         parameters:(id)parameters
           useCache:(DataCache)cache
           progress:(ProgressBlock _Nullable )uploadProgress
            success:(SuccessBlock _Nullable )success
            failure:(FailureBlock _Nullable)failures{
    @weakify(self);
    dispatch_async(dispatch_get_main_queue(), ^{
        @strongify(self);
        if (cache) cache([self getCacheWithUrl:url parameters:parameters]);
    });
    [self postRequest:url
           parameters:parameters
             progress:uploadProgress
              success:success
              failure:failures];
}


- (void)postRequest:(NSString *)url
         parameters:(id)parameters
           progress:(ProgressBlock _Nullable )progress
            success:(SuccessBlock _Nullable )success
            failure:(FailureBlock _Nullable)failures {
    if (!url || url.length < 1) return ;
    
    @weakify(self);
    [self WWPOST:[self dealWithUrl:url]
      parameters:parameters
        progress:progress
         success:^(NSURLSessionDataTask * task, id  result) {
             @strongify(self);
             [self requestWithUrl:url
                       parameters:parameters
                          success:success
                             task:task
                           result:result];
         }failure:^(NSURLSessionDataTask *  task, NSError *  error) {
             @strongify(self);
             [self requestWithUrl:url failure:failures task:task error:error];
         }];
}

//Cache
- (id)getCacheWithUrl:(NSString *)url parameters:(id)parameters{
    NSString * cacheKey = [self cacheKeyWtihUrl:url parameters:parameters];
    return [self getCacheWithKey:cacheKey url:url];
}

- (id)getCacheWithKey:(NSString *)key url:(NSString *)url{
    if ([_dataCache containsObjectForKey:key]) {
        id data = [_dataCache objectForKey:key];
        return [_jsonToModelTool jsonToModelWithData:data url:url];
    }
    return nil;
}

- (NSString *)cacheKeyWtihUrl:(NSString *)url parameters:(id)parameters {
    return  [[NSString stringWithFormat:@"%@%@",url?:@"",parameters?:@""]md5String];
}

- (void)cacheData:(id)data key:(NSString *)key {
    [_dataCache setObject:data forKey:key];
}

- (void)cacheData:(id)data
              url:(NSString *)url
       parameters:(id)parameters {
    if (!data || !url ||url.length < 1)  return ;
    
    NSString * cacheKey = [self cacheKeyWtihUrl:url parameters:parameters];
    [self cacheData:data key:cacheKey];
}

- (void)clearCache {
    [_dataCache.memoryCache removeAllObjects];
    [_dataCache.diskCache removeAllObjects];
}

@end
