//
//  QFQNetworkManager.m
//  QFQNetwork
//
//  Created by 张艳飞 on 16/5/26.
//  Copyright © 2016年 张艳飞. All rights reserved.
//

#import "QFQNetworkManager.h"
static NSString * const NetErrorCode = @"999";//网络原因，请求失败

@implementation QFQNetworkManager

-(id)init{
    self = [super init];
    if (self) {
        self.timeoutInterval = 25;
        self.shouldHandleCookies = NO;
        self.responseSerializerType = Json;
    }
    return self;
}
-(void)setTimeoutInterval:(NSTimeInterval)timeoutInterval{
    _timeoutInterval = timeoutInterval;
}
-(void)setShouldHandleCookies:(BOOL)shouldHandleCookies{
    _shouldHandleCookies = shouldHandleCookies;
}
-(void)setHeaderField:(NSDictionary *)headerField{
    _headerField = headerField;
}
- (AFHTTPSessionManager*)requestConfigWithUrl:(NSString*)urlString{
    NSURL *url = [NSURL URLWithString:urlString];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]init];
    manager.requestSerializer.timeoutInterval = _timeoutInterval;
    manager.requestSerializer.HTTPShouldHandleCookies = _shouldHandleCookies;
    manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:url.absoluteString forHTTPHeaderField:@"Referer"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", nil];
    for (NSString*key in self.headerField) {
        NSString *value = self.headerField[key];
        [manager.requestSerializer setValue:value forHTTPHeaderField:key];
    }
    switch (self.responseSerializerType) {
        case Image:
            manager.responseSerializer = [AFImageResponseSerializer serializer];
            break;
        case Data:
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        default:
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            break;
    }
    manager.securityPolicy.allowInvalidCertificates = YES;
    return manager;
}

- (void)postWithURL:(NSString *)url WithParams:(NSDictionary*)params
   WithSuccessBlock:(SuccessBlock)success
    WithFailurBlock:(FailureBlock)netFailure{
    AFHTTPSessionManager *manager=[self requestConfigWithUrl:url];
    [manager POST:url parameters:params progress:nil success:^(NSURLSessionTask *task, NSDictionary * responseObject) {
        NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
        NSString *msg = [responseObject objectForKey:@"msg"];
        if ([code isEqualToString:@"0"]) {
            success(responseObject);
        }else{
            netFailure(code,msg);
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSDictionary *errorUserInfo =error.userInfo;
        NSString *errorMsg = [errorUserInfo objectForKey:@"NSLocalizedDescription"];
        netFailure(NetErrorCode,errorMsg);
    }];
}

- (void)getWithURL:(NSString *)url WithParams:(NSDictionary*)params
  WithSuccessBlock:(SuccessBlock)success
   WithFailurBlock:(FailureBlock)netFailure{
    AFHTTPSessionManager *manager=[self requestConfigWithUrl:url];
    [manager GET:url parameters:params progress:nil success:^(NSURLSessionTask *task, NSDictionary * responseObject) {
        NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
        NSString *msg = [responseObject objectForKey:@"msg"];
        if ([code isEqualToString:@"0"]) {
            success(responseObject);
        }else{
            netFailure(code,msg);
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSDictionary *errorUserInfo =error.userInfo;
        NSString *errorMsg = [errorUserInfo objectForKey:@"NSLocalizedDescription"];
        netFailure(NetErrorCode,errorMsg);
    }];
}

+ (void)postWithURL:(NSString *)url WithParams:(NSDictionary*)params
   WithSuccessBlock:(SuccessBlock)success
    WithFailurBlock:(FailureBlock)netFailure{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]init];
    manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    NSURL *URL = [NSURL URLWithString:url];
    [manager.requestSerializer setValue:URL.absoluteString forHTTPHeaderField:@"Referer"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", nil];
    [manager POST:url parameters:params progress:nil success:^(NSURLSessionTask *task, NSDictionary * responseObject) {
        NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
        NSString *msg = [responseObject objectForKey:@"msg"];
        if ([code isEqualToString:@"0"]) {
            success(responseObject);
        }else{
            netFailure(code,msg);
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSDictionary *errorUserInfo =error.userInfo;
        NSString *errorMsg = [errorUserInfo objectForKey:@"NSLocalizedDescription"];
        netFailure(NetErrorCode,errorMsg);
    }];
}

+ (void)getWithURL:(NSString *)url WithParams:(NSDictionary*)params
  WithSuccessBlock:(SuccessBlock)success
   WithFailurBlock:(FailureBlock)netFailure{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]init];
    manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    NSURL *URL = [NSURL URLWithString:url];
    [manager.requestSerializer setValue:URL.absoluteString forHTTPHeaderField:@"Referer"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", nil];
    [manager GET:url parameters:params progress:nil success:^(NSURLSessionTask *task, NSDictionary * responseObject) {
        NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
        NSString *msg = [responseObject objectForKey:@"msg"];
        if ([code isEqualToString:@"0"]) {
            success(responseObject);
        }else{
            netFailure(code,msg);
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSDictionary *errorUserInfo =error.userInfo;
        NSString *errorMsg = [errorUserInfo objectForKey:@"NSLocalizedDescription"];
        netFailure(NetErrorCode,errorMsg);
    }];
}

+(BOOL)isReachable{
    return  [AFNetworkReachabilityManager sharedManager].reachable;
}
@end
