//
//  GeoPost.m
//  shoutAPP
//
//  Created by Mac on 5/30/15.
//  Copyright (c) 2015 Miguel Garcia Topete. All rights reserved.
//

#import "GeoPost.h"

static NSDateFormatter * frmater;

@implementation GeoPost

-(id) initWithDictionary:(NSDictionary*)keys {
    self = [super init];
    
    if (!frmater){
        frmater = [NSDateFormatter new];
        
        [frmater setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        [frmater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    
    if (self){
        _post_id        = [(NSString*)[keys objectForKey:@"post_id"] integerValue];
        _user_id        = [(NSString*)[keys objectForKey:@"user_id"] integerValue];
        _content_id     = [(NSString*)[keys objectForKey:@"content_id"] integerValue];
        _latitude       = [(NSString*)[keys objectForKey:@"lat"] integerValue];
        _longitude      = [(NSString*)[keys objectForKey:@"lng"] integerValue];
        _popularity     = [(NSString*)[keys objectForKey:@"popularity"] intValue];
        _likes_count    = [(NSString*)[keys objectForKey:@"likes_count"] intValue];
        _favs_count     = [(NSString*)[keys objectForKey:@"favs_count"] intValue];
        _content_type   = [(NSString*)[keys objectForKey:@"content_type"] intValue];
        _contents       = (NSString*)[keys objectForKey:@"contents"];
        _user_profile   = (NSString*)[keys objectForKey:@"profile_name"];
        _display_image  = [[keys objectForKey:@"display_image"] isEqual:[NSNull null]]?@"":(NSString*)[keys objectForKey:@"display_image"];
        _is_subscribed  = ![[keys objectForKey:@"is_subscribed"] isEqual:[NSNull null]];
        _is_liked       = ![[keys objectForKey:@"is_liked"] isEqual:[NSNull null]];
        _is_faved       = ![[keys objectForKey:@"is_faved"] isEqual:[NSNull null]];
        _post_date      = [frmater dateFromString:(NSString *)[keys objectForKey:@"post_date"]];
        
    }
    
    return self;
}

@end
