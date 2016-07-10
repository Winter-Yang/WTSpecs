//
//  QFQNetworkManager.h
//  QFQNetwork
//
//  Created by 张艳飞 on 16/5/26.
//  Copyright © 2016年 张艳飞. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

typedef NS_ENUM(NSInteger, ResponseSerializerType) {
    Json = 0,//Json
    Data = 1,//NSData
    Image = 2,//UIImage
};

//请求成功回调block
typedef void (^SuccessBlock)(NSDictionary *dic);
//请求失败回调block
typedef void (^FailureBlock)(NSString*code,NSString *errorMsg);

@interface QFQNetworkManager : NSObject

@property (nonatomic,assign)NSTimeInterval timeoutInterval;//超时时间
@property (nonatomic,assign)BOOL shouldHandleCookies;
@property (nonatomic,assign)ResponseSerializerType responseSerializerType;//请求内容类型
@property (nonatomic,strong)NSDictionary *headerField;//请求头内容

//**需要单独设定超时时间、请求headerField等参数，使用此实例方法**//
//POST
-(void)postWithURL:(NSString *)url
            WithParams:(NSDictionary*)params
      WithSuccessBlock:(SuccessBlock)success
       WithFailurBlock:(FailureBlock)netFailure;
//GET
-(void)getWithURL:(NSString *)url
           WithParams:(NSDictionary*)params
     WithSuccessBlock:(SuccessBlock)success
      WithFailurBlock:(FailureBlock)netFailure;

//**使用默认请求参数，使用此类方法**//
//POST
+(void)postWithURL:(NSString *)url
        WithParams:(NSDictionary*)params
  WithSuccessBlock:(SuccessBlock)success
   WithFailurBlock:(FailureBlock)netFailure;
//GET
+(void)getWithURL:(NSString *)url
       WithParams:(NSDictionary*)params
 WithSuccessBlock:(SuccessBlock)success
  WithFailurBlock:(FailureBlock)netFailure;
//**检测网络状态**//

+(BOOL)isReachable;

@end
