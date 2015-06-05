//
//  Utils.m
//  shoutAPP
//
//  Created by Miguel Garcia Topete on 5/27/15.
//  Copyright (c) 2015 Miguel Garcia Topete. All rights reserved.
//

#import "Utils.h"



@implementation Utils

/*
 TAKE THE SCREEN WIDTH
 */
+(float)screenWidth
{
    CGRect screen = [[UIScreen mainScreen] bounds];
    return screen.size.width;
}

/*
 TAKE THE SCREEN HEIGHT
 */
+(float)screenHeigth
{
    CGRect screen = [[UIScreen mainScreen] bounds];
    return screen.size.height;

}

/*
 Check if there is an iPhone 5
 */
+(BOOL)isPhone5
{
    CGRect screen = [[UIScreen mainScreen] bounds];
    return (screen.size.height>480);
    //jkjkl

}

/*
  The device is Retina Display
 */

+(BOOL)isRetinaDisplay
{
    BOOL isRetina = NO;
    
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]
        && [[UIScreen mainScreen] scale] == 2.0) {
        // Retina
        isRetina = YES;
    } else {
        // Not Retina
        isRetina = NO;
    }
    
    return isRetina;
}


/*
 Get Rect Screen
 */
+(CGRect)getRectScreen
{
    return [[UIScreen mainScreen] bounds];
}

/*
 Get the color of the Recomendacion
 */

/*
 Get The string Correct
 */

+(NSString*)getStringWithRightEnconded:(NSString*)source
{
    if(!source)
        return @"";
    
   return [NSString stringWithCString:[source cStringUsingEncoding:NSISOLatin1StringEncoding] encoding:NSUTF8StringEncoding];
}

/*
 Get Url String without www parameter
 */

+(NSString*)removeWWWofString:(NSString*)text
{
    NSString *nURL = [text stringByReplacingOccurrencesOfString:@"http://www." withString:@""];
    nURL = [nURL stringByReplacingOccurrencesOfString:@"http://" withString:@""];
    nURL = [nURL stringByReplacingOccurrencesOfString:@"https://www." withString:@""];
    nURL = [nURL stringByReplacingOccurrencesOfString:@"https://" withString:@""];
    return nURL;
    
}

/*
 Get facebook Url with reference
 */

+(NSString*)facebookString:(NSString*)text
{
    
    return  [NSString stringWithFormat:@"f/%@", text];
    
}

/*
 Get Componentes of the String
 */
//+(NSMutableDictionary*)getComponentsDate:(NSString*)date
//{
//    NSMutableDictionary * dateData = [[NSMutableDictionary alloc] init];
//    
//    
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"yyyy-MM-dd"];
//    NSDate *dateFormatted = [formatter dateFromString:date];
//    
//    NSInteger day = 0;
//    NSInteger month = 0;
//    NSInteger year = 0;
//    
//    if(date!=nil) {
//        NSDateComponents *components = [[NSCalendar currentCalendar] components:kCFCalendarUnitDay | kCFCalendarUnitMonth | kCFCalendarUnitYear fromDate:dateFormatted];
//         day = [components day];
//         month = [components month];
//         year = [components year];
//        
//    }
//        [dateData setObject:[NSNumber numberWithInteger:day] forKey:KEY_DATE_COMPONENT_DAY];
//        [dateData setObject:[NSNumber numberWithInteger:month] forKey:KEY_DATE_COMPONENT_MONTH];
//        [dateData setObject:[NSNumber numberWithInteger:year] forKey:KEY_DATE_COMPONENT_YEAR];
//    
//    return dateData;
//}
//

+(void)frameLog:(NSString*)tagName view:(UIView *)vista;
{
    NSLog(@"%@:X:%.2f,Y:%.2f,Width:%.2f,Height:%.2f",tagName,vista.frame.origin.x, vista.frame.origin.y,vista.frame.size.width,vista.frame.size.height);
}

+(void)contentSizeLog:(NSString*)tagName view:(UIScrollView *)vista
{

       NSLog(@"%@::Width:%.2f,Height:%.2f",tagName,vista.contentSize.width,vista.contentSize.height);
}

+(CGRect)changePosition:(UIView*)viewName moveToX:(float)pointX moveToY:(float)pointY
{
    CGRect tmpFrame = CGRectMake(pointX, pointY, viewName.frame.size.width, viewName.frame.size.height);
    return tmpFrame;
}
+(CGRect)changeSize:(UIView*)viewName resizeWidth:(float)width resizeHeight:(float)height
{
    CGRect tmpFrame = CGRectMake(viewName.frame.origin.x, viewName.frame.origin.y, width, height);
    return tmpFrame;
}


+(CGSize)changeScrollViewContentSize:(UIScrollView*)viewName resizeWidth:(float)width resizeHeight:(float)height
{
    CGSize content = CGSizeMake(width,height);
    return content;
    
}

+(CGRect)XstretchToLeft:(UIView*)viewName toXPosition:(float)x resizeWidth:(float)width
{
    return CGRectMake(x, viewName.frame.origin.y, width, viewName.frame.size.height);
}

+(NSString *)getFormattedStringWithDate:(NSDate *)date withFormat:(NSString *)format{
    NSDateFormatter *formatter = [NSDateFormatter new];
    
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [formatter setDateFormat:format];
    
    return  [formatter stringFromDate:date];
}

+(NSDate *)getDateWithString:(NSString *)date withFormat:(NSString *)format{
    NSDateFormatter *formatter = [NSDateFormatter new];
    
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [formatter setDateFormat:format];
    
    return  [formatter dateFromString:date];
}
@end
