//
//  GeoPost.h
//  shoutAPP
//
//  Created by Mac on 5/30/15.
//  Copyright (c) 2015 Miguel Garcia Topete. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GeoPost : NSObject

@property long post_id;
@property long content_id;
@property long user_id;
@property double latitude;
@property double longitude;
@property int popularity;
@property int likes_count;
@property int favs_count;
@property int content_type;
@property BOOL is_subscribed;
@property BOOL is_liked;
@property BOOL is_faved;
@property (nonatomic, strong) NSString * user_profile;
@property (nonatomic, strong) NSString * display_image;
@property (nonatomic, strong) NSString * contents;
@property (nonatomic, strong) NSDate * post_date;

-(id) initWithDictionary:(NSDictionary*)keys;

@end
