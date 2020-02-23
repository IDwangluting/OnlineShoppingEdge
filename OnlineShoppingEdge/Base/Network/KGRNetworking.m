//
//  KGRNetworking.m
//
//  Created by luting on 2017/9/15.
//  Copyright © 2017年 lufeng. All rights reserved.
//x

#import "KGRNetworking.h"
//#import "KGRTextDefine.h"
//#import "AppInfoMananger.h"
//#import "KGRUserInfoManager.h"
//#import "KGRURLDefine.h"
//#import "KGRJsonTool.h"

#import <YYModel/YYModel.h>
#import <MMKV/MMKV.h>

@interface OrignalRequestData : NSObject

@property (nonatomic, copy) NSString * msg;
@property (nonatomic, strong) id data;
@property (nonatomic, assign) long code;

@end

@implementation OrignalRequestData @end

@implementation KGRNetworking

+ (instancetype)manager {
    static KGRNetworking * manager ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[KGRNetworking alloc]initWithBaseURL:nil];
    });
    return manager;
}

- (instancetype)initWithBaseURL:(NSURL *)url  {
    if (self = [super initWithBaseURL:url]) {
        [self networkSetting];
        [self httpHeadSetting];
        _taskDict = @{}.mutableCopy;
        self.jsonToModelTool.prefix = @"KGR";
//        self.jsonToModelTool.acceptDomains = @[Java_SchemHost,Php_SchemHost,Gateway_SchemHost];
    }
    return self;
}

- (void)httpHeadSetting {
//    NSDictionary * appInfoDic = [[AppInfoMananger manager] appInfoDic];
//    for (NSString * key in appInfoDic.allKeys) {
//        [self setValue:[appInfoDic objectForKey:key] forHTTPHeaderField:key];
//    }
}

- (NSString *)dealWithUrl:(NSString *)url {
//    if (url && [url isKindOfClass:[NSString class]] && url.length > 0) {
//        if(![url hasPrefix:HTTP] && ![url hasPrefix:HTTPS]) {
//            if (![url hasPrefix:Php_SchemHost]){
//                url = [NSString stringWithFormat:@"%@%@",Php_SchemHost,url];
//            }
//        }
//    }
    return url;
}

- (NSError *)dealWithError:(NSError *)error url:(NSString *)url{
#if DEBUG
    NSLog(@"\n\n method:%@ url:%@ error:%@",NSStringFromSelector(_cmd),url,error.debugDescription);
#endif
    NSString *message = @"";
    switch (error.code) {
        case 3840:  //AFN3.0以后用的UTF-8，而返回的数据用的GBK，指定了json解析但是json解析不出来，这样就会报3840的错误。
            break ;
        case -1001:
            message = @"当前网络状态不佳";
            break ;
        case -1003: //  未能找到使用指定主机名的服务器
            break ;
        case -1009:
            message = @"网络已断开";
            break;
        case -1011:
            break;
        case 404:
        case 504:
            message = @"当前网络状态不佳";
        default:
            break;
    }
    if (message.length <1) message = error.localizedDescription;
    return [NSError errorWithDomain:message
                               code:error.code
                           userInfo:@{NSLocalizedDescriptionKey:message}];
}

 // DealWtihRequestResult
- (void)requestWithUrl:(NSString * _Nonnull)url
               failure:(FailureBlock)failures
                  task:(NSURLSessionDataTask *)task
                 error:(NSError *)error {
    [_taskDict removeObjectForKey:url];
    [super requestWithUrl:url failure:failures task:task error:error];
}

- (void)requestWithUrl:(NSString * _Nonnull)url
            parameters:(id)parameters
               success:(SuccessBlock)success
                  task:(NSURLSessionDataTask *)task
                result:(id )result {
    if (!success) return  ;
#if DEBUG
//    NSLog(@"\n url:%@ receiveData:%@",url,[KGRJsonTool dictionaryToJSONString:result]);
#endif
    if ([result isKindOfClass:[NSData class]]) {
        success(task,result);
        return ;
    }
    OrignalRequestData * orignaldata = [OrignalRequestData yy_modelWithJSON:result];
    [self cacheData:orignaldata.data url:url parameters:parameters];
    NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response ;
//    [self validateLocalTime:[response.allHeaderFields objectForKey:Date]];
    [self repaceToken:response.allHeaderFields];
    
    if (orignaldata.code == 0) {
        [_taskDict removeObjectForKey:url];
        id data = [self.jsonToModelTool jsonToModelWithData:orignaldata.data url:url];
        dispatch_async(dispatch_get_main_queue(),^{
            success(task,data);
        });
        return ;
    }
    NSError * error = [NSError errorWithDomain:orignaldata.msg code:orignaldata.code userInfo:nil];
    [self requestWithUrl:url failure:nil task:task error:error];
    
    dispatch_async(dispatch_get_main_queue(),^{
        success(task,error);
    });
}

- (NSURLSessionDataTask *_Nonnull)dataTaskWithHTTPMethod:(NSString *_Nonnull)method
                                                     url:(NSString * _Nonnull)url
                                              parameters:(id _Nullable)parameters
                                          uploadProgress:(ProgressBlock _Nullable)uploadProgress
                                        downloadProgress:(ProgressBlock _Nullable)downloadProgress
                                                 success:(SuccessBlock _Nullable)success
                                                 failure:(FailureBlock _Nullable)failure{

//    NSString * token = [KGRUserInfoManager sharedUserManager].userInfo.token ?: @"";
//    [self setValue:token forHTTPHeaderField:Authorization];
//    NSString * userId = [KGRUserInfoManager sharedUserManager].userInfo.userId;
//    if (userId != nil) {
//        [self setValue:userId forHTTPHeaderField:@"userId"];
//        [self setValue:[[MMKV defaultMMKV] getStringForKey:CurrentStuID] forHTTPHeaderField:@"studentId"];
//    }
    return [super dataTaskWithHTTPMethod:method
                                     url:url
                              parameters:parameters
                          uploadProgress:uploadProgress
                        downloadProgress:downloadProgress
                                 success:success
                                 failure:failure];
}

- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest * _Nonnull)request
                               uploadProgress:(ProgressBlock _Nullable)uploadProgress
                             downloadProgress:(ProgressBlock _Nullable)downloadProgress
                            completionHandler:(CompletionHandlerBlock _Nullable)completionHandler {
    NSURLSessionDataTask * dataTask = [super dataTaskWithRequest:request
                                                  uploadProgress:uploadProgress
                                                downloadProgress:downloadProgress
                                               completionHandler:completionHandler];
    [self.taskDict setValue:dataTask forKey:request.URL.absoluteString];
    return dataTask;
}


- (void)getRequest:(NSString * _Nonnull)url
        parameters:(id _Nullable)parameters
          progress:(ProgressBlock _Nullable)progress
           success:(SuccessBlock _Nullable)success
           failure:(FailureBlock _Nullable)failures {
    
    NSURLSessionDataTask *originalTask = [_taskDict valueForKeyPath:url];
    if (originalTask && originalTask.state == NSURLSessionTaskStateRunning)  return ;
    [super getRequest:url parameters:parameters progress:progress success:success failure:failures];
}

- (void)postRequest:(NSString *)url
         parameters:(id)parameters
           progress:(ProgressBlock _Nullable )progress
            success:(SuccessBlock _Nullable )success
            failure:(FailureBlock _Nullable)failures {
    
    NSURLSessionDataTask *originalTask = [_taskDict valueForKeyPath:url];
    if (originalTask && originalTask.state == NSURLSessionTaskStateRunning)  return ;

    [super postRequest:url
            parameters:parameters
              progress:progress
               success:success
               failure:failures];
}

// RequestCancel
- (void)cancelRequestWithURL:(NSString *)urlStr{
    if (!urlStr || urlStr.length <1) return ;
    
    NSURLSessionDataTask * task = [_taskDict objectForKey:urlStr];
    [task cancel];
}

- (void)cancelAllRequest {
    for (NSURLSessionDataTask * task in [_taskDict allValues]) {
        NSURLSessionTaskState state = task.state;
        if (state == NSURLSessionTaskStateRunning || state == NSURLSessionTaskStateSuspended) {
            [task cancel];
        }
    }
    [_taskDict removeAllObjects];
}

// Other
- (void)repaceToken:(NSDictionary *)allHeaderFields {
//    NSString *authorization = [allHeaderFields objectForKey:Authorization];
//    if (authorization && authorization.length > 0) {
//        [self setValue:authorization forHTTPHeaderField:Authorization];
//        [KGRUserInfoManager sharedUserManager].userInfo.token = authorization;
//        [[KGRUserInfoManager sharedUserManager] setUserInfo:[KGRUserInfoManager sharedUserManager].userInfo];
//    }
}

- (double)validateLocalTime:(NSString *)dateStr {
    double difftime = [super validateLocalTime:dateStr];
//    [[MMKV defaultMMKV] setDouble:difftime forKey:Difftime];
//    [[MMKV defaultMMKV] sync];
    return  difftime;
}

- (void)loginOutWithError:(NSError *)error {
#if DEBUG
    NSLog(@"\n\n method:%@ error:%@",NSStringFromSelector(_cmd),error.debugDescription);
#endif
    if (error.code != 9999 ) return ;
//    [[KGRUserInfoManager sharedUserManager] clearUserInfo];
    dispatch_block_t presentBlock = ^{
        Class loginClass = NSClassFromString(@"KLoginViewController");
        UIViewController * loginViewController = [[loginClass alloc]init];
        __block UIViewController * vc;
        vc = [UIApplication sharedApplication].keyWindow.rootViewController;
        
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
        if ([vc isKindOfClass:loginClass])  return ;
        [vc presentViewController:loginViewController animated:YES completion:nil];
    };
    
    if ([[NSThread currentThread] isMainThread]) {
        presentBlock();
        return ;
    }
    
    dispatch_async(dispatch_get_main_queue(),presentBlock);
}

@end
