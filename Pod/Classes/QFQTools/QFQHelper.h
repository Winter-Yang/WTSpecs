//
//  ProgramHelper.h
//  ReceiveAPP
//
//  Created by yangwende on 14-12-24.
//  Copyright (c) 2014年 即刻. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface QFQHelper : NSObject

/**
 *  快速返回文件大小
 *
 *  @param font      字体
 *  @param text      字符串
 *  @param scopesize 显示区间
 *
 *  @return CGSize object
 */
+(CGSize)sizeForTextWithFont:(UIFont *)font
                    withText:(NSString *)string
                    withSIze:(CGSize)scopesize;
/**
 *  普通字符串转换为十六进制
 *
 *  @param string           字符串
 *
 *  @return return          十六进制字符串
 */
+ (NSString *)hexStringFromString:(NSString *)string;

/**
 *  获取Label
 *
 *  @param aText            Label显示文字
 *  @param fontName         Label显示文字字体
 *  @param fontSize         Label显示文字字体大小
 *  @param aColor           Label显示文字颜色
 *  @param aBColor          Label背景颜色
 *  @param aCGrect          Label大小
 *  @param aAligment        Label文字位置属性
 *
 *  @return return Label
 */
+(UILabel *)labelBulidWithText:(NSString *)aText
                      fontName:(NSString *)fontName
                          size:(CGFloat)fontSize
                  andTextColor:(UIColor *)aColor
            andBackgroundColor:(UIColor *)aBColor
                       andFram:(CGRect )aCGrect
                  andAlignment:(NSTextAlignment )aAligment;
/**
 *  获取Button
 *
 *  @param aTitle           Button显示正常文字
 *  @param selectTitle      Button显示选中文字
 *  @param atColor          Button显示文字正常颜色
 *  @param selectColor      Button显示文字选中颜色
 *  @param abColor          Button背景颜色
 *  @param aRect            Button大小
 *
 *  @return return Button
 */
+(UIButton *)buttonBuildWithTitle:(NSString *)aTitle
                      selectTitle:(NSString *)selectTitle
                        textColor:(UIColor *)atColor
                      selectColor:(UIColor *)selectColor
                  backgroundColor:(UIColor *)abColor
                            frome:(CGRect)aRect
                           Target:(id)target
                         Selector:(SEL)selector;
/**
 *  获取ImageView
 *
 *  @param abColor          ImageView背景颜色
 *  @param insets           ImageView图片拉伸属性
 *  @param image            ImageView图片
 *  @param aRect            ImageView大小
 *
 *  @return return ImageView
 */
+(UIImageView *)imageViewBuildWithfrome:(CGRect)aRect
                                  image:(UIImage *)image
                        backgroundColor:(UIColor *)abColor
                                 insets:(UIEdgeInsets) insets;

/**
 *  获取年或月或日或星期
 *
 *  @param component         设置需要返回的属性   YEAR/MONTH/DAY/WEEK
 *
 *  @return return           年或月活日或星期
 */
+ (unsigned long)detailedDateOfDevieWithComponents:(NSString *)component;
/**
 *  获取当前时间时间戳
 *
 *  @return return 时间戳字符串
 */
+ (NSString *)dateIimeStapStr;
/**
 *  获取时间差
 *
 *  @param timestamp 时间戳
 *
 *  @return 与当前时间时间差
 */
+ (NSString *)changDateWithString:(NSString *)aString;
/**
 *  获取日期
 *
 *  @param timeString           时间戳
 *
 *  @return return              昨天/今天/
 */
+(NSString *)compareDate:(NSString *)timeString;
/**
 *  时间戳输出格式时间
 *
 *  @param timeString           时间戳
 *  @param formatter            时间格式
 *
 *  @return return              格式时间字符串
 */
+(NSString *)timestampConversionForsec:(NSString *)timeString
                            withFormat:(NSString *)formatter;


/**
 *  裁剪图片
 *
 *  @param image 原图片
 *  @param rect  裁剪区域
 *
 *  @return 截图后图片
 */
+ (UIImage *)cropWithImage:(UIImage *)image Rect:(CGRect)rect;

/**
 *  锁定比例缩放
 *
 *  @param image  原图片
 *  @param width  图片宽
 *  @param height 图片高
 *  @param rotate 旋转
 *
 *  @return 缩放后图片
 */
+ (UIImage*)transformWithLockedRatio:(UIImage *)image
                               width:(CGFloat)width
                              height:(CGFloat)height
                              rotate:(BOOL)rotate;

/**
 *  返回NSString
 *
 *  @param url                  文件连接url
 *  @param path                 文件存储路径
 *
 *  @return return              文件存储路径
 */
+(NSString *)saveFileToDocuments:(NSString *)url toPath:(NSString *)path;


/**
 *  获取docunment路径
 *
 *  @return docunment路径
 */
+(NSString *)docunment;
/**
 *  获取docunment下子文件路径
 *
 *  @param subpath 子文件名称
 *
 *  @return 子文件路径
 */
+(NSString *)filePathSubpath:(NSString *)subpath;

/**
 *  向plist文件写入数据
 *
 *  @param dic  元数据
 *  @param path plist路径
 *
 *  @return BOOL
 */
+(BOOL)write:(NSDictionary *)dic  toPlist:(NSString*)path;
/**
 *  读取Plist文件内容
 *
 *  @param path plist路径
 *
 *  @return plist数据
 */
+(NSDictionary *)readPlist:(NSString*)path;
/**
 *  清理缓存
 *
 */
+(BOOL)cleanCache;
/**
 *  手机存储使用详情
 *
 *  @return 储存空间 已用/剩余
 */
+(NSString *)usedSpaceAndfreeSpace;
/**
 *  图片旋转0°
 *
 *  @param image 原图片
 *
 *  @return 旋转矫正后图片
 */
+(UIImage *)fixOrientation:(UIImage *)image;
/**
 *  淡入淡出动画
 *
 *  @return CATransition
 */
+(CATransition *)catransition;

/**
 *  根据颜色生成图片
 *
 *  @param color 颜色值
 *
 *  @return Iamge
 */
+ (UIImage *) imageWithColor:(UIColor *)color;

/*
 * 页面跳转
 */
+ (void)openURL:(NSString *)URL;
/*
 * 获取idfa
 */
+ (NSString *)getIDFA;
/*
 * 获取当前应用版本
 */
+ (NSString *)getVersion;
/*
 * 获取系统版本号
 */
+ (NSString *)getSystemVersion;

/**
 *  判断字符串
 *
 *  @param input 输入源
 *
 *  @return bool
 */
+ (BOOL) isValidString:(id)input;
/**
 *  判断字典
 *
 *  @param input 输入源
 *
 *  @return bool
 */
+ (BOOL) isValidDictionary:(id)input;
/**
 *  判断数组
 *
 *  @param input 输入源
 *
 *  @return bool
 */
+ (BOOL) isValidArray:(id)input;
/**
 *  判断邮箱
 *
 *  @param email 输入源
 *
 *  @return bool
 */
+ (BOOL) isValidateEmail:(NSString *)email;
/**
 *  判断手机号
 *
 *  @param string 输入源
 *
 *  @return bool
 */
+ (BOOL) isValidatePhone:(NSString *)string;
/**
 *  判断纯数字
 *
 *  @param string 输入源
 *
 *  @return bool
 */
+ (BOOL) isInteger:(NSString *)string;
/**
 *  判断是否包含中文
 *
 *  @param string 输入源
 *
 *  @return bool
 */
+ (BOOL) isContainChinese:(NSString *)string;
/**
 *  判断是否包含特殊字符
 *
 *  @param string 输入源
 *
 *  @return bool
 */
+ (BOOL) isIncludeSpecialCharact: (NSString *)string;
/**
 *  判断是否标准URL
 *
 *  @param urlString url字符串
 *
 *  @return BOOL
 */
+ (BOOL)isHttpURL:(NSString *)urlString;
/**
 *  是否8-29位数字和字母组合
 *
 *  @param password 字符串
 *
 *  @return BOOL
 */
+ (BOOL)isValidatePassword:(NSString *)password;
/**
 *  是否有效身份证号
 *
 *  @param value 身份证号
 *
 *  @return BOOL
 */
+ (BOOL)isValidateIDCardNumber:(NSString *)value;

/**
 *  重新设置图片尺寸
 *
 *  @param image  需要操作的图片
 *  @param reSize 需要输出图片的尺寸
 *
 *  @return 修改尺寸后的图片
 */
+ (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize;

@end
