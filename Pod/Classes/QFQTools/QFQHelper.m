//
//  ProgramHelper.m
//  ReceiveAPP
//
//  Created by yangwende on 14-12-24.
//  Copyright (c) 2014年 即刻. All rights reserved.
//

#import "QFQHelper.h"
#import <AdSupport/AdSupport.h>

@implementation QFQHelper
#pragma mark - 快速返回字符串大小   做自适应判断
+(CGSize)sizeForTextWithFont:(UIFont *)font
                    withText:(NSString *)text
                    withSIze:(CGSize)scopesize
{
    NSDictionary *dic =   [NSMutableDictionary dictionary];
    [dic setValue:font forKey:NSFontAttributeName];
    
    
    CGSize  size = [text boundingRectWithSize:scopesize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    return size;
}

#pragma mark-----普通字符串转换为十六进制的。
+ (NSString *)hexStringFromString:(NSString *)string
{
    NSData *myD = [string dataUsingEncoding:NSUTF8StringEncoding];
    Byte *bytes = (Byte *)[myD bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"";
    for(int i=0;i<[myD length];i++)
        
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        
        if([newHexStr length]==1)
            
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        
        else
            
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    return hexStr;
}

#pragma mark - 便利构造器label
+(UILabel *)labelBulidWithText:(NSString *)aText
                      fontName:(NSString *)fontName
                          size:(CGFloat)fontSize
                  andTextColor:(UIColor *)aColor
            andBackgroundColor:(UIColor *)aBColor
                       andFram:(CGRect )aCGrect
                  andAlignment:(NSTextAlignment )aAligment
{
    
    UILabel* tepLabel = [[UILabel alloc]initWithFrame:aCGrect];
    
    //传值
    tepLabel.text = aText;
    tepLabel.font = [UIFont fontWithName:fontName size:fontSize];
    tepLabel.textColor = aColor;
    tepLabel.backgroundColor =aBColor;
    tepLabel.userInteractionEnabled = YES;
    //设置默认值
    tepLabel.textAlignment =  aAligment;
    if (aColor == nil) {
        tepLabel.textColor = [UIColor blackColor];
    }
    if (aBColor == nil) {
        tepLabel.backgroundColor = [UIColor clearColor];
    }
    
    tepLabel.numberOfLines = 0;
    
    return tepLabel;
}
#pragma mark - 便利构造器UIButton
+(UIButton *)buttonBuildWithTitle:(NSString *)aTitle
                      selectTitle:(NSString *)selectTitle
                        textColor:(UIColor *)atColor
                      selectColor:(UIColor *)selectColor
                  backgroundColor:(UIColor *)abColor
                            frome:(CGRect)aRect
                           Target:(id)target
                         Selector:(SEL)selector
{
    
    UIButton *tepButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tepButton.userInteractionEnabled= YES;
    tepButton.frame = aRect;
    if (aTitle) {
        
        [tepButton setTitle:aTitle forState:UIControlStateNormal];
        [tepButton setTitleColor:(atColor ?atColor:[UIColor blackColor]) forState:UIControlStateNormal];
    }
    if (selectTitle) {
        
        [tepButton setTitle:selectTitle forState:UIControlStateSelected];
        [tepButton setTitleColor:(selectColor ?selectColor:[UIColor whiteColor]) forState:UIControlStateSelected];
    }
    [tepButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    tepButton.backgroundColor = abColor ? abColor : [UIColor clearColor];
    
    
    return tepButton;
}

#pragma mark -便利构造器imageView
+(UIImageView *)imageViewBuildWithfrome:(CGRect)aRect
                                  image:(UIImage *)image
                        backgroundColor:(UIColor *)abColor
                                 insets:(UIEdgeInsets) insets
{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:aRect];
    imageView.image =[image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    imageView.userInteractionEnabled = YES;
    
    if (abColor) {
        imageView.backgroundColor = abColor;
    }
    return imageView;
}

#pragma mark - 获取设备当前年 月  日 星期
+ (unsigned long)detailedDateOfDevieWithComponents:(NSString *)component
{
    //    NSCalendarIdentifierGregorian
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *now;
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    now=[NSDate date];
    NSDateComponents * comps = [calendar components:unitFlags fromDate:now];
    if ([component isEqualToString:@"YEAR"]) {
        unsigned long  week = [comps year];
        return week;
    }else if ([component isEqualToString:@"MONTH"]){
        unsigned long  week = [comps month];
        return week;
        
    }else if ([component isEqualToString:@"DAY"]){
        unsigned long  week = [comps day];
        return week;
    }else if ([component isEqualToString:@"WEEK"]){
        unsigned long  week = [comps weekday];
        return week;
    }else{
        return 0;
    }
    
}
#pragma mark -获取当前时间戳
+ (NSString *)dateIimeStapStr
{
    NSTimeInterval time = [[NSDate date]  timeIntervalSince1970];
    long long int timesc= (long long int)time;
    NSString *timestamp = [NSString stringWithFormat:@"%lld",timesc];
    return timestamp;
}
#pragma mark -主页时间转换
+ (NSString *)changDateWithString:(NSString *)aString
{
    
    //初始化一个日期格式
    NSDateFormatter *iosDateFormater=[[NSDateFormatter alloc]init];
    iosDateFormater.dateFormat=@"yyyy-MM-dd HH:mm:ss.S";
    //强制设置为美国时间 必须设置，否则无法解析
    iosDateFormater.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
    //转换微博时间为日期格式
    NSDate *date=[iosDateFormater dateFromString:aString];
    
    //获取当前时间     ///// 2013-11-30 05:57:01 +0000
    NSDate *myDate = [NSDate date];
    
    //获取时间间隔
    NSTimeInterval secondsBetweenDates= [myDate timeIntervalSinceDate:date];
    secondsBetweenDates /= 60;
    
    if (secondsBetweenDates<30) {
        return [NSString stringWithFormat:@"%d分钟前",(int)secondsBetweenDates];
    }
    else if (secondsBetweenDates>=30&&secondsBetweenDates<=40)
    {
        return @"半小时前" ;
    }
    else if (secondsBetweenDates>40&&secondsBetweenDates<60 )
    {
        return [NSString stringWithFormat:@"%d分钟前",(int)secondsBetweenDates];
    }
    else if (secondsBetweenDates>=60&&secondsBetweenDates<60*24)
    {
        return [NSString stringWithFormat:@"%d小时前",(int)(secondsBetweenDates/60)];
    }
    else if (secondsBetweenDates>=60*24&&secondsBetweenDates<60*24*10)
    {
        return [NSString stringWithFormat:@"%d天前",(int)(secondsBetweenDates/60/24)];
    }
    else{
        // 目的格式
        NSDateFormatter *resultFormatter=[[NSDateFormatter alloc]init];
        //[resultFormatter setDateFormat:@"MM月dd日 HH:mm"];
        [resultFormatter setDateFormat:@"MM月dd日"];
        NSString    *dateString=[resultFormatter stringFromDate:date];
        return dateString;
    }
    
}
#pragma mark -时间戳输出格式时间
+ (NSString *)timestampConversionForsec:(NSString *)timeString
                             withFormat:(NSString *)formatter
{
    if (timeString.length>=10) {
        NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[timeString intValue]];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:formatter];
        NSString *currentDateStr = [dateFormatter stringFromDate:confromTimesp];
        return currentDateStr;
    }
    else
        return @"";
    
}
#pragma mark-----时间判断
+ (NSString *)compareDate:(NSString *)timeString;
{
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[timeString intValue]];
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *today = [NSDate date];
    NSDate *tomorrow, *yesterday;
    
    tomorrow = [today dateByAddingTimeInterval: secondsPerDay];
    yesterday = [today dateByAddingTimeInterval: -secondsPerDay];
    
    // 10 first characters of description is the calendar date:
    NSString * todayString = [[today description] substringToIndex:10];
    NSString * yesterdayString = [[yesterday description] substringToIndex:10];
    NSString * tomorrowString = [[tomorrow description] substringToIndex:10];
    
    NSString * dateString = [[confromTimesp description] substringToIndex:10];
    
    if ([dateString isEqualToString:todayString])
    {
        return @"今天";
    } else if ([dateString isEqualToString:yesterdayString])
    {
        return @"昨天";
    }else if ([dateString isEqualToString:tomorrowString])
    {
        return @"明天";
    }
    else
    {
        return dateString;
    }
    
}


#pragma mark-----裁剪图片
+ (UIImage *)cropWithImage:(UIImage *)image Rect:(CGRect)rect
{
    CGImageRef imageref = CGImageCreateWithImageInRect(image.CGImage, rect);
    image = [UIImage imageWithCGImage:imageref];
    CGImageRelease(imageref);
    return image;
}

#pragma mark----- 锁定比例缩放
+ (UIImage*)transformWithLockedRatio:(UIImage *)image
                               width:(CGFloat)width
                              height:(CGFloat)height
                              rotate:(BOOL)rotate
{
    float sourceWidth = image.size.width;
    float sourceHeight = image.size.height;
    
    float widthRatio = width / sourceWidth;
    float heightRatio = height / sourceHeight;
    
    if (widthRatio >= 1 && heightRatio >= 1) {
        return image;
    }
    
    float destWidth, destHeight;
    if (widthRatio > heightRatio) {
        destWidth = sourceWidth * heightRatio;
        destHeight = height;
    } else {
        destWidth = width;
        destHeight = sourceHeight * widthRatio;
    }
    
    return [QFQHelper transform:image width:destWidth height:destHeight rotate:rotate];
}

+ (UIImage*)transform:(UIImage *)image
                width:(CGFloat)width
               height:(CGFloat)height
               rotate:(BOOL)rotate
{
    CGFloat destW = roundf(width);
    CGFloat destH = roundf(height);
    CGFloat sourceW = roundf(width);
    CGFloat sourceH = roundf(height);
    
    if (rotate) {
        if (image.imageOrientation == UIImageOrientationRight
            || image.imageOrientation == UIImageOrientationLeft) {
            sourceW = height;
            sourceH = width;
        }
    }
    
    CGImageRef imageRef = image.CGImage;
    
    int bytesPerRow = destW * (CGImageGetBitsPerPixel(imageRef) >> 3);
    
    CGContextRef bitmap = CGBitmapContextCreate(NULL,
                                                destW,
                                                destH,
                                                CGImageGetBitsPerComponent(imageRef),
                                                bytesPerRow,
                                                CGImageGetColorSpace(imageRef),
                                                CGImageGetBitmapInfo(imageRef));
    
    if (rotate) {
        if (image.imageOrientation == UIImageOrientationDown) {
            CGContextTranslateCTM(bitmap, sourceW, sourceH);
            CGContextRotateCTM(bitmap, 180 * (M_PI/180));
            
        } else if (image.imageOrientation == UIImageOrientationLeft) {
            CGContextTranslateCTM(bitmap, sourceH, 0);
            CGContextRotateCTM(bitmap, 90 * (M_PI/180));
            
        } else if (image.imageOrientation == UIImageOrientationRight) {
            CGContextTranslateCTM(bitmap, 0, sourceW);
            CGContextRotateCTM(bitmap, -90 * (M_PI/180));
        }
    }
    
    CGContextDrawImage(bitmap, CGRectMake(0, 0, sourceW, sourceH), imageRef);
    
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    UIImage *result = [UIImage imageWithCGImage:ref];
    CGContextRelease(bitmap);
    CGImageRelease(ref);
    
    return result;
}
#pragma mark 文件存储
+ (NSString *)saveFileToDocuments:(NSString *)url toPath:(NSString *)path
{
    NSString *destFilePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/file"] stringByAppendingPathComponent:path];
    
    NSString *destFolderPath = [destFilePath stringByDeletingLastPathComponent];
    
    // 判断路径文件夹是否存在不存在则创建
    if (! [[NSFileManager defaultManager] fileExistsAtPath:destFolderPath]) {
        
        [[NSFileManager defaultManager] createDirectoryAtPath:destFolderPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *resultFilePath = @"";
    // 判断该文件是否已经下载过
    if ([[NSFileManager defaultManager] fileExistsAtPath:destFilePath]) {
        
        resultFilePath = destFilePath;
    } else {
        
        
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        if ([imageData writeToFile:destFilePath atomically:YES]) {
            resultFilePath = destFilePath;
        }

    }
    return resultFilePath;
}

#pragma mark 获取docunment路径
+ (NSString *)docunment
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *docunment = [paths objectAtIndex:0];
    return docunment;
}
#pragma mark 获取docunment下子文件路径
+ (NSString *)filePathSubpath:(NSString *)subpath
{
    return [[self docunment] stringByAppendingPathComponent:subpath];
}
#pragma mark 向plist文件写入数据
+ (BOOL)write:(NSDictionary *)dic  toPlist:(NSString*)path{
    
    return  [dic writeToFile:path atomically:YES];
    
}
#pragma mark 读取Plist文件内容
+ (NSDictionary *)readPlist:(NSString*)path
{
    NSDictionary *dic = [[NSDictionary alloc]initWithContentsOfFile:path];
    return dic;
    
}

#pragma mark 转换单位后的数据G M K B
+ (float)calculateSize:(long long)contentLength{
    if(contentLength >= pow(1024, 3))
        return (float) (contentLength / (float)pow(1024, 3));
    else if(contentLength >= pow(1024, 2))
        return (float) (contentLength / (float)pow(1024, 2));
    else if(contentLength >= 1024)
        return (float) (contentLength / (float)1024);
    else
        return (float) (contentLength);
}

#pragma mark 转换内存单位
+ (NSString *)calculateUnit:(long long)contentLength{
    
    if(contentLength >= pow(1024, 3))
        return @"GB";
    else if(contentLength >= pow(1024, 2))
        return @"M";
    else if(contentLength >= 1024)
        return @"K";
    else
        return @"B";
}

#pragma mark 清理缓存
+(BOOL)cleanCache
{

        NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
        
        NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
        for (NSString *p in files) {
            NSError *error;
            NSString *path = [cachPath stringByAppendingPathComponent:p];
            if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
            }
        }
    return YES;
}

#pragma mark 旋转矫正图片
+ (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;  
    }  
    
    // And now we just create a new UIImage from the drawing context  
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);  
    UIImage *img = [UIImage imageWithCGImage:cgimg];  
    CGContextRelease(ctx);  
    CGImageRelease(cgimg);  
    return img;  
}


#pragma mark 淡入淡出动画
+(CATransition *)catransition
{
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.7];
    [animation setType:kCATransitionFade]; //淡入淡出
    [animation setSubtype:kCATransitionFromLeft];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    return animation;
}

#pragma mark 手机存储使用详情
+ (NSString * )usedSpaceAndfreeSpace {
    NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] ;
    NSFileManager* fileManager = [[NSFileManager alloc ]init];
    NSDictionary *fileSysAttributes = [fileManager attributesOfFileSystemForPath:path error:nil];
    NSNumber *freeSpace = [fileSysAttributes objectForKey:NSFileSystemFreeSize];
    NSNumber *totalSpace = [fileSysAttributes objectForKey:NSFileSystemSize];
    NSString  * str= [NSString stringWithFormat:@"已占用%0.1fG/剩余%0.1fG",([totalSpace longLongValue] - [freeSpace longLongValue])/1024.0/1024.0/1024.0,[freeSpace longLongValue]/1024.0/1024.0/1024.0];
    return str;
}


+ (UIImage *) imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return theImage;
}

+ (void)openURL:(NSString *)URL
{
    NSString *str = URL ;
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];

}

+ (NSString*)getIDFA{
    NSString * IDFA = [[ASIdentifierManager sharedManager]advertisingIdentifier].UUIDString;
    return IDFA;
}

+ (NSString *)getVersion{

    NSString * version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    return version;
}

+ (NSString *)getSystemVersion{
    return [UIDevice currentDevice].systemVersion;
}
#pragma  mark 数据检测
//是否字符串
+ (BOOL) isValidString:(id)input
{
    if (!input) {
        return NO;
    }

    if ((NSNull *)input == [NSNull null]) {
        return NO;
    }

    if (![input isKindOfClass:[NSString class]]) {
        return NO;
    }

    if ([input isEqualToString:@""]) {
        return NO;
    }

    return YES;
}
//是否字典
+ (BOOL) isValidDictionary:(id)input
{
    if (!input) {
        return NO;
    }

    if ((NSNull *)input == [NSNull null]) {
        return NO;
    }

    if (![input isKindOfClass:[NSDictionary class]]) {
        return NO;
    }

    if ([input count] <= 0) {
        return NO;
    }

    return YES;
}
//是否数组
+ (BOOL) isValidArray:(id)input
{
    if (!input) {
        return NO;
    }

    if ((NSNull *)input == [NSNull null]) {
        return NO;
    }

    if (![input isKindOfClass:[NSArray class]]) {
        return NO;
    }

    return YES;
}

//邮箱判断

+(BOOL)isValidateEmail:(NSString *)email
{
    if (!(email.length >0)) {
        return NO;
    }
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

//手机号判断
+ (BOOL)isValidatePhone:(NSString *)string
{
    if (!(string.length >0)) {
        return NO;
    }
    NSString *regex = @"^((13[0-9])|(147)|(17[0-9])|(15[^4,\\D])|(18[0-9]))\\d{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:string];
    if (!isMatch) {
        return NO;
    }
    return YES;
}
//纯数字判断
+(BOOL) isInteger:(NSString *)string
{
    NSString *regex = @"[0-9]{1,9}";
    NSPredicate *regTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [regTest evaluateWithObject:string];

}
//是否包含中文
+ (BOOL) isContainChinese:(NSString *)string
{
    for(NSInteger i=0; i< [string length]; i++)
    {
        NSRange range = NSMakeRange(i, 1);
        NSString *subString = [string substringWithRange:range];
        const char *cString = [subString UTF8String];
        if (strlen(cString) == 3)
        {
            return YES;
        }

    }
    return NO;
}
//是否包含特殊字符
+(BOOL)isIncludeSpecialCharact: (NSString *)string {
    //***需要过滤的特殊字符：~￥#&*<>《》()[]{}【】^@/￡¤￥|§¨「」『』￠￢￣~@#￥&*（）——+|《》$_€。
    NSRange urgentRange = [string rangeOfCharacterFromSet: [NSCharacterSet characterSetWithCharactersInString: @"~￥#&*<>《》()[]{}【】^@/￡¤￥|§¨「」『』￠￢￣~@#￥&*（）——+|《》$_€"]];
    if (urgentRange.location == NSNotFound)
    {
        return NO;
    }
    return YES;
}
#pragma mark - 判断是否HTTP URL
+ (BOOL)isHttpURL:(NSString *)urlString
{
    if (!urlString) {
        return NO;
    }
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"http+:[^\\s]*" options:0 error:&error];

    if (regex != nil) {
        NSTextCheckingResult *firstMatch=[regex firstMatchInString:urlString options:0 range:NSMakeRange(0, [urlString length])];

        if (firstMatch) {
            //NSRange resultRange = [firstMatch rangeAtIndex:0];
            return YES;
        }
        else        {
            return NO;
        }
    }
    else    {
        return NO;
    }
}
+ (BOOL)isValidatePassword:(NSString *)password
{
    NSString *pattern = @"^[a-zA-Z0-9]{6,20}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:password];
    return isMatch;
}

+ (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize {
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return reSizeImage;
}



+ (BOOL)isValidateIDCardNumber:(NSString *)value {
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    NSInteger length =0;
    if (!value) {
        return NO;
    }else {
        length = value.length;

        if (length !=15 && length !=18) {
            return NO;
        }
    }
    // 省份代码
    NSArray *areasArray =@[@"11",@"12", @"13",@"14", @"15",@"21", @"22",@"23", @"31",@"32", @"33",@"34", @"35",@"36", @"37",@"41", @"42",@"43", @"44",@"45", @"46",@"50", @"51",@"52", @"53",@"54", @"61",@"62", @"63",@"64", @"65",@"71", @"81",@"82", @"91"];

    NSString *valueStart2 = [value substringToIndex:2];
    BOOL areaFlag =NO;
    for (NSString *areaCode in areasArray) {
        if ([areaCode isEqualToString:valueStart2]) {
            areaFlag =YES;
            break;
        }
    }

    if (!areaFlag) {
        return false;
    }


    NSRegularExpression *regularExpression;
    NSUInteger numberofMatch;

    int year =0;
    switch (length) {
        case 15:
            year = [value substringWithRange:NSMakeRange(6,2)].intValue +1900;

            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {

                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$"
                                                                       options:NSRegularExpressionCaseInsensitive
                                                                         error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$"
                                                                       options:NSRegularExpressionCaseInsensitive
                                                                         error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                              options:NSMatchingReportProgress
                                                                range:NSMakeRange(0, value.length)];


            if(numberofMatch >0) {
                return YES;
            }else {
                return NO;
            }
        case 18:

            year = [value substringWithRange:NSMakeRange(6,4)].intValue;
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {

                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$"
                                                                       options:NSRegularExpressionCaseInsensitive
                                                                         error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$"
                                                                       options:NSRegularExpressionCaseInsensitive
                                                                         error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                              options:NSMatchingReportProgress
                                                                range:NSMakeRange(0, value.length)];


            if(numberofMatch >0) {
                int S = ([value substringWithRange:NSMakeRange(0,1)].intValue +
                         [value substringWithRange:NSMakeRange(10,1)].intValue) *7 +
                ([value substringWithRange:NSMakeRange(1,1)].intValue +
                 [value substringWithRange:NSMakeRange(11,1)].intValue) *9 +
                ([value substringWithRange:NSMakeRange(2,1)].intValue +
                 [value substringWithRange:NSMakeRange(12,1)].intValue) *10 +
                ([value substringWithRange:NSMakeRange(3,1)].intValue +
                 [value substringWithRange:NSMakeRange(13,1)].intValue) *5 +
                ([value substringWithRange:NSMakeRange(4,1)].intValue +
                 [value substringWithRange:NSMakeRange(14,1)].intValue) *8 +
                ([value substringWithRange:NSMakeRange(5,1)].intValue +
                 [value substringWithRange:NSMakeRange(15,1)].intValue) *4 +
                ([value substringWithRange:NSMakeRange(6,1)].intValue +
                 [value substringWithRange:NSMakeRange(16,1)].intValue) *2 +
                [value substringWithRange:NSMakeRange(7,1)].intValue *1 +
                [value substringWithRange:NSMakeRange(8,1)].intValue *6 +
                [value substringWithRange:NSMakeRange(9,1)].intValue *3;
                int Y = S %11;
                NSString *M =@"F";
                NSString *JYM =@"10X98765432";
                M = [JYM substringWithRange:NSMakeRange(Y,1)];// 判断校验位
                if ([M isEqualToString:[value substringWithRange:NSMakeRange(17,1)]]) {
                    return YES;// 检测ID的校验位
                }else {
                    return NO;
                }

            }else {
                return NO;
            }
        default:
            return false;
    }
}
@end
