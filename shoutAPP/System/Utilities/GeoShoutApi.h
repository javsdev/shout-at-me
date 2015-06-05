//
//  GeoShoutApi.h
//  shoutAPP
//
//  Created by MAC01 on 5/28/15.
//  Copyright (c) 2015 Miguel Garcia Topete. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestResult.h"
#import "Credentials.h"
#import "Profile.h"
#import "Region.h"

extern long GEO_LOGGED_USER;
extern dispatch_queue_t MEDIA_DISPATCH;
extern dispatch_queue_t PROCESSING_DISPATCH;

@interface GeoShoutApi : NSObject

// Makes api calls with parameters in a dictionary and a completion block, in parameters at least the act one should be included
/*+(void)makeApiRequestWithParameters:(NSDictionary *)parameters
                         withScript:(NSString*)script
                       onCompletion:(void (^)(RequestResult * result)) completion;*/

@end

// User helper methods {usr.php}
@interface Users : NSObject

+(void)createUserWithProfile:(Profile *)profile
                 credentials:(Credentials *)credentials
                onCompletion:(void (^)(RequestResult * result)) completion;

+(void)loginWithUserId:(NSString*) user
           credentials:(Credentials *)credentials
          onCompletion:(void (^)(RequestResult * result)) completion;

+(void) logoutUserId:(long)userId
        onCompletion:(void (^)(RequestResult * result)) completion;

+(void) addCredential:(Credentials *)credentials toUserId:(long)userId
         onCompletion:(void (^)(RequestResult * result)) completion;

+(void) deactiveUser:(long)userId
        onCompletion:(void (^)(RequestResult * result)) completion;

+(void) reactiveUser:(long)userId
        onCompletion:(void (^)(RequestResult * result)) completion;

+(void)getProfileWithUserId:(long)userId
               onCompletion:(void (^)(RequestResult * result)) completion;

+(void)updateUserWithProfile:(Profile *)profile
                  withUserId:(long)userId
                onCompletion:(void (^)(RequestResult * result)) completion;

+(void) getUserRegionWithName:(int)filter
                       forLat:(double)lat
                       forLng:(double)lng
                 onCompletion:(void(^)(Region * region))completionl;



@end;

// Suscribing helper methods {subs.php}
@interface Subscriptions : NSObject

+(void) subscribeToUser:(long) userId
                toOwner:(long) ownerId
           onCompletion:(void (^)(RequestResult * result)) completion;
+(void) unsubscribeToUser:(long)userId
                 fromOwner:(long)ownerId
              onCompletion:(void (^)(RequestResult *))completion;
@end

// Posts helper methods {posts.php}
@interface Posts : NSObject

+(void)postMedia:(NSData*)content
         forUser:(long)userId
             lat:(double)lat
             lng:(double)lng
 withContentType:(int)content_type
contentTypeString:(NSString*)typeString
      contentExt:(NSString*)ext
    onCompletion:(void (^)(RequestResult *))completion;

+(void)postMedia:(NSData*)content
         forUser:(long)userId
 withContentType:(int)content_type
contentTypeString:(NSString*)typeString
      contentExt:(NSString*)ext
    onCompletion:(void (^)(RequestResult *))completion;

+(void) postText:(NSString*)posts forUser:(long)usr
                    withLattitude:(double)lat
                    withLongitude:(double)lng
                    onCompletion:(void (^)(RequestResult * result)) completion;
//+(void) postMedia:(NSObject *)content forUser:(long)userId lat:(double)lat lng:(double)lng;
//+(void) postUrlContent:(NSObject *)content forUser:(long)userId lat:(double)lat lng:(double)lng;
//+(void) likeTogglePost:(long)postId forUser:(long)userId;
//+(void) favoriteTogglePost:(long)postId forUser:(long)userId;
//+(void) dislikeTogglePost:(long)postId forUser:(long)userId;

+(void) postUrlContent:(NSObject *)content forUser:(long)userId lat:(double)lat lng:(double)lng
          onCompletion:(void (^)(RequestResult * result)) completion;

+(void) likeTogglePost:(long)postId
               forUser:(long)userId
                   lat:(double)lat
                   lng:(double)lng
          onCompletion:(void (^)(RequestResult * result)) completion;

+(void) favoriteTogglePost:(long)postId
                   forUser:(long)userId
                       lat:(double)lat
                       lng:(double)lng
              onCompletion:(void (^)(RequestResult * result)) completion;

//+(void) dislikeTogglePost:(long)postId
//                  forUser:(long)userId
//                      lat:(double)lat
//                      lng:(double)lng
//             activityType:(int)activityType
//             onCompletion:(void (^)(RequestResult * result)) completion;

+(void) locInfo:(double)lat
        withLat:(double)lng
   onCompletion:(void (^)(RequestResult *))completion;


@end

// Contents {views.php}
@interface Contents : NSObject

+(void) contentForUser:(long)userId
               withLat:(double)lat
               withLng:(double)lng
               inRange:(NSString*)range
           sortingType:(NSString*)sorting
    forPlaceHolderDate:(NSDate*)phd
        forRefreshType:(NSString*)refreshType
           strideStart:(int)stride_start
             strideEnd:(int)stride_end
          onCompletion:(void (^)(RequestResult *))completion;


+(void) smallProfileOfUser:(long)userId
              onCompletion:(void (^)(RequestResult * result)) completion;

+(void) largeProfileOfUser:(long)userId
              onCompletion:(void (^)(RequestResult * result)) completion;

+(void) smallViewOfPost:(long)postId forUserId:(long)userId
           onCompletion:(void (^)(RequestResult * result)) completion;

+(void) largeViewOfPost:(long)postId forUserId:(long)userId
           onCompletion:(void (^)(RequestResult * result)) completion;

@end