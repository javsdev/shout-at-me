//
//  Utils.h
//  shoutAPP
//
//  Created by Miguel Garcia Topete on 5/27/15.
//  Copyright (c) 2015 Miguel Garcia Topete. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface Utils : NSObject


+(float)screenWidth;
+(float)screenHeigth;
+(BOOL)isPhone5;
+(BOOL)isRetinaDisplay;
+(CGRect)getRectScreen;
+(NSString*)getStringWithRightEnconded:(NSString*)source;
+(NSString*)removeWWWofString:(NSString*)text;
+(NSString*)facebookString:(NSString*)text;
//+(NSMutableDictionary*)getComponentsDate:(NSString*)date;
+(void)frameLog:(NSString*)tagName view:(UIView *)vista;
+(void)contentSizeLog:(NSString*)tagName view:(UIScrollView *)vista;
+(CGRect)changePosition:(UIView*)viewName moveToX:(float)pointX moveToY:(float)pointY;
+(CGRect)changeSize:(UIView*)viewName resizeWidth:(float)width resizeHeight:(float)height;
+(CGSize)changeScrollViewContentSize:(UIScrollView*)viewName resizeWidth:(float)width resizeHeight:(float)height;
+(CGRect)XstretchToLeft:(UIView*)viewName toXPosition:(float)x resizeWidth:(float)width;

+(NSString *)getFormattedStringWithDate:(NSDate *)date withFormat:(NSString *) format;
+(NSDate *)getDateWithString:(NSString *)date withFormat:(NSString *) format;
@end
