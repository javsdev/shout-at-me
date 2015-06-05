//
//  GeoShoutApi.m
//  shoutAPP
//
//  Created by MAC01 on 5/28/15.
//  Copyright (c) 2015 Miguel Garcia Topete. All rights reserved.
//

#import "GeoShoutApi.h"
#import "AFNetworkReachabilityManager.h"
#import "AFNetworking.h"
#import "Utils.h"

#import <AWSS3/AWSS3.h>

static const NSString * saBucket = @"sa-content-main";
static const NSString * mediaPath = @"media/";
static const NSString * displayPicPath = @"pf/";

static AFHTTPRequestOperationManager *manager = nil;

@implementation GeoShoutApi

static NSString *const URL_API = @"http://larutavcc.com/shoutapp/";
static NSString *const BaseLocation = @"https://s3.amazonaws.com/sa-content-main/";
static NSString *const USER_LOCATION_INFO = @"https://maps.googleapis.com/maps/api/geocode/json?key=AIzaSyAxCoFOymmCjnG1QcEpNMdhCVg2TaKb-jw";


+(void)makeApiRequestWithParameters:(NSDictionary *)parameters
                         withScript:(NSString*)script
                       onCompletion:(void (^)(RequestResult * result))completion {
    NSString * currentURL = [NSString stringWithFormat:@"%@%@", URL_API, script];
    
    if (!manager){
        manager = [AFHTTPRequestOperationManager manager];
        [manager setCompletionQueue:PROCESSING_DISPATCH];
    }
    
    [manager GET:currentURL
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             RequestResult * requestRes = [RequestResult new];
             
             [requestRes setValuesForKeysWithDictionary:responseObject];
             
             if (completion){
                 completion(requestRes);
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             if (error.code == 1009)
                 NSLog(@"Error: %@", @"The Internet connection appears to be offline.");
             else
                 NSLog(@"Error: %@", error);
    }];
}

@end

@implementation Users

/****
 
 Users SubAPI
 
 */

+(void)loginWithUserId:(NSString*) user
           credentials:(Credentials *)credentials
          onCompletion:(void (^)(RequestResult * result)) completion {
    NSMutableDictionary * params = [NSMutableDictionary new];
    [params setObject:@"login" forKey:@"act"];
    [params setObject:user forKey:@"pr"];
    [params setObject:[NSNumber numberWithInt:credentials.cred_type] forKey:@"ct"];
    
    // default credential type uses user name and passwords (profilename is the user name)
    [params setObject:credentials.cred_pass forKey:@"cp"];
    if (credentials.cred_type>1){
        // other credential types use both credential user and credential password
        [params setObject:credentials.cred_user forKey:@"cu"];
    }
    
    [GeoShoutApi makeApiRequestWithParameters:params withScript:@"usr.php" onCompletion:completion];
}

+(void)getProfileWithUserId:(long)userId
                onCompletion:(void (^)(RequestResult * result)) completion{
    NSMutableDictionary * params = [NSMutableDictionary new];
    [params setObject:@"info" forKey:@"act"];
    [params setObject:[NSString stringWithFormat:@"%li", userId] forKey:@"usr"];
    
    [GeoShoutApi makeApiRequestWithParameters:params withScript:@"usr.php" onCompletion:completion];
}

+(void)updateUserWithProfile:(Profile *)profile
                 withUserId:(long)userId
                onCompletion:(void (^)(RequestResult * result)) completion{
    NSString *dobStr = [Utils getFormattedStringWithDate:profile.DOB withFormat:@"yyyy-MM-dd 00:00:00"];
    
    NSMutableDictionary * params = [NSMutableDictionary new];
    
    [params setObject:@"edit" forKey:@"act"];
    [params setObject:profile.profileName forKey:@"pf"];
    [params setObject:profile.displayName forKey:@"dn"];
    [params setObject:profile.displayStatus forKey:@"ds"];
    [params setObject:dobStr forKey:@"dob"];
    [params setObject:[NSString stringWithFormat:@"%li", userId] forKey:@"usr"];
    
    [GeoShoutApi makeApiRequestWithParameters:params withScript:@"usr.php" onCompletion:completion];
}

+(void)createUserWithProfile:(Profile *)profile
                 credentials:(Credentials *)credentials
                onCompletion:(void (^)(RequestResult * result)) completion{
    NSString *credTypeStr = [NSString stringWithFormat:@"%i", credentials.cred_type];
    NSString *dobStr = [Utils getFormattedStringWithDate:profile.DOB withFormat:@"yyyy-MM-dd 00:00:00"];
    
    NSMutableDictionary * params = [NSMutableDictionary new];
    
    [params setObject:@"new" forKey:@"act"];
    [params setObject:profile.profileName forKey:@"pn"];
    [params setObject:profile.displayName forKey:@"dn"];
    [params setObject:profile.displayStatus forKey:@"ds"];
    [params setObject:dobStr forKey:@"dob"];
    [params setObject:credTypeStr forKey:@"ct"];
    
    // default credential type uses user name and passwords (profilename is the user name)
    [params setObject:credentials.cred_pass forKey:@"cp"];
    if (credentials.cred_type>1){
        // other credential types use both credential user and credential password
        [params setObject:credentials.cred_user forKey:@"cu"];
    }
    
    [GeoShoutApi makeApiRequestWithParameters:params withScript:@"usr.php" onCompletion:completion];
}

+(void)deactiveUser:(long)userId
       onCompletion:(void (^)(RequestResult * result)) completion{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:@"deact" forKey:@"act"];
    [params setObject:[NSString stringWithFormat:@"%li", userId] forKey:@"usr"];
    
    [GeoShoutApi makeApiRequestWithParameters:params withScript:@"usr.php" onCompletion:completion];
}

+(void)reactiveUser:(long)userId
       onCompletion:(void (^)(RequestResult * result)) completion{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:@"react" forKey:@"act"];
    [params setObject:[NSString stringWithFormat:@"%li", userId] forKey:@"usr"];
    
    [GeoShoutApi makeApiRequestWithParameters:params withScript:@"usr.php" onCompletion:completion];
}

+(void)logoutUserId:(long)userId onCompletion:(void (^)(RequestResult *))completion{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:@"logout" forKey:@"act"];
    [params setObject:[NSString stringWithFormat:@"%li", userId] forKey:@"usr"];
    
    [GeoShoutApi makeApiRequestWithParameters:params withScript:@"usr.php" onCompletion:completion];
}

+(void)addCredential:(Credentials *)credentials toUserId:(long)userId onCompletion:(void (^)(RequestResult *))completion{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:@"add_cred" forKey:@"act"];
    [params setObject:[NSString stringWithFormat:@"%li", userId] forKey:@"pn"];
    
    // default credential type uses user name and passwords (profilename is the user name)
    [params setObject:credentials.cred_pass forKey:@"cp"];
    if (credentials.cred_type>1){
        // other credential types use both credential user and credential password
        [params setObject:credentials.cred_user forKey:@"cu"];
    }
    
    [GeoShoutApi makeApiRequestWithParameters:params withScript:@"usr.php" onCompletion:completion];
}


+(void) getUserRegionWithName:(int)filter
                       forLat:(double)lat
                       forLng:(double)lng
                 onCompletion:(void(^)(Region * region))completion{
    
    if (!manager){
        manager = [AFHTTPRequestOperationManager manager];
        [manager setCompletionQueue:PROCESSING_DISPATCH];
    }
    
    [Posts locInfo:lat withLat:lng onCompletion:^(RequestResult *result) {
        if(result.success ) {
            NSString* strAddress = @"";
            __block int currentFilter = filter;
            
            if (filter == 7 && [[result.extra objectForKey:@"state"] isEqualToString:@"Hawaii"]) {
                currentFilter = 6;
            }
            switch (currentFilter){
                case 4: strAddress = [NSString stringWithFormat:@"%@ %@", strAddress, [result.extra objectForKey:@"region"]];
                case 5: strAddress = [NSString stringWithFormat:@"%@ %@", strAddress,  [result.extra objectForKey:@"city"]];
                case 6: strAddress = [NSString stringWithFormat:@"%@ %@", strAddress,  [result.extra objectForKey:@"state"]];
                case 7: strAddress = [NSString stringWithFormat:@"%@ %@", strAddress,  [result.extra objectForKey:@"country"]];
            }
            
            __block RequestResult * lastResult = result;
            
            NSDictionary * params = @{@"address" : strAddress};
            
            //NSString *currentURL = [NSString stringWithFormat:@"%@%@",USER_LOCATION_INFO,strAddress];
            [manager GET:USER_LOCATION_INFO
              parameters:params
                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                     Region *reg = [Region new];
                     
                     if (currentFilter == 7 && [[lastResult.extra objectForKey:@"country"] isEqualToString:@"United States"]){
                         reg.startLat = 44.78078;
                         reg.startLng = -66.133751;
                         reg.endLat = 32.290522;
                         reg.endLng = -125.779257;
                         
                     }
                     else{
                         NSMutableDictionary *dictInfo = [NSMutableDictionary new];
                         dictInfo = (NSMutableDictionary*)responseObject;
                         if ([[dictInfo objectForKey:@"status"] isEqualToString:@"OK"] ) {
                             
                             NSDictionary *dictGeometry =[[[[dictInfo objectForKey:@"results"] objectAtIndex:0] objectForKey:@"geometry"] objectForKey:@"bounds"];
                             
                             reg.startLat = [[[dictGeometry objectForKey:@"northeast"] objectForKey:@"lat"] floatValue];
                             reg.startLng = [[[dictGeometry objectForKey:@"northeast"] objectForKey:@"lng"] floatValue];
                             reg.endLat = [[[dictGeometry objectForKey:@"southwest"] objectForKey:@"lat"] floatValue];
                             reg.endLng = [[[dictGeometry objectForKey:@"southwest"] objectForKey:@"lng"] floatValue];
                         }
                         else
                         {
                             dispatch_async(dispatch_get_main_queue(), ^{
                                                
                                 
                                 UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error"
                                                                            message:@"We Need User Location"
                                                                           delegate:self
                                                                  cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                                 [alert show];
                             });
                         }
                     }
                     
                     if (completion){
                         completion(reg);
                     }
                 }
                 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                     if (error.code == 1009)
                         NSLog(@"Error: %@", @"The Internet connection appears to be offline.");
                     else
                         NSLog(@"Error: %@", error);
                 }];
        }
        else {
            NSLog(@"%@", result.msg);
        }
    }];
}



@end

/***********************************
 
 Subsriptions SubAPI
 
 */

@implementation Subscriptions

+(void) subscribeToUser:(long)userId toOwner:(long)ownerId onCompletion:(void (^)(RequestResult *))completion{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:@"pair" forKey:@"act"];
    [params setObject:[NSString stringWithFormat:@"%li", userId] forKey:@"usr"];
    [params setObject:[NSString stringWithFormat:@"%li", ownerId] forKey:@"to"];
    
    [GeoShoutApi makeApiRequestWithParameters:params withScript:@"subs.php" onCompletion:completion];
}

+(void) unsubscribeToUser:(long)userId fromOwner:(long)ownerId onCompletion:(void (^)(RequestResult *))completion{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:@"unpair" forKey:@"act"];
    [params setObject:[NSString stringWithFormat:@"%li", userId] forKey:@"usr"];
    [params setObject:[NSString stringWithFormat:@"%li", ownerId] forKey:@"to"];
    
    [GeoShoutApi makeApiRequestWithParameters:params withScript:@"subs.php" onCompletion:completion];
}

@end

/***********************************
 
 Posting SubAPI
 
 */

@implementation Posts

+(void)postMedia:(NSData*)content
         forUser:(long)userId
             lat:(double)lat
             lng:(double)lng
 withContentType:(int)content_type
contentTypeString:(NSString*)typeString
      contentExt:(NSString*)ext
    onCompletion:(void (^)(RequestResult *))completion {
    
    // TODO: Maybe use more random temp file
    NSString *tmpPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"shout.tmp"];
    [content writeToFile: tmpPath atomically:true];
    
    tmpPath = [NSString stringWithFormat:@"file://%@", tmpPath];
    
    NSURL * tmpURL = [NSURL URLWithString:tmpPath];
    
    AWSS3TransferManager *transferManager = [AWSS3TransferManager defaultS3TransferManager];
    
    NSString *fileKey = [NSString stringWithFormat:@"%d_%d", (arc4random()%1000000000) + 1000000000,
                         (arc4random()%1000000000) + 1000000000] ;
    
    AWSS3TransferManagerUploadRequest *mediaUploadRequest = [AWSS3TransferManagerUploadRequest new];
    mediaUploadRequest.bucket = [NSString stringWithFormat:@"%@", saBucket];
    mediaUploadRequest.key = [NSString stringWithFormat:@"%@%@.%@", mediaPath, fileKey,ext];
    mediaUploadRequest.body = tmpURL;
    mediaUploadRequest.contentType = typeString;
    
    NSString * remoteLoc = [BaseLocation stringByAppendingString:mediaUploadRequest.key];

    [[transferManager upload:mediaUploadRequest] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id(BFTask *task) {
        [[NSFileManager defaultManager] removeItemAtURL:tmpURL error:nil];
        
        if (task.error) {
            if ([task.error.domain isEqualToString:AWSS3TransferManagerErrorDomain]) {
                switch (task.error.code) {
                    case AWSS3TransferManagerErrorCancelled:
                    case AWSS3TransferManagerErrorPaused:
                        break;
                        
                    default:
                        NSLog(@"Error: %@", task.error);
                        break;
                }
            } else {
                // Unknown error.
                NSLog(@"Error: %@", task.error);
            }
        }
        
        if (task.result) {
            [[NSFileManager defaultManager] removeItemAtURL:tmpURL error:nil];
            
            NSMutableDictionary *params = [NSMutableDictionary new];
            [params setObject:@"media" forKey:@"act"];
            [params setObject:[NSNumber numberWithInt:content_type] forKey:@"type"];
            [params setObject:[NSString stringWithFormat:@"%li", userId] forKey:@"usr"];
            [params setObject:[NSString stringWithFormat:@"%f", lat] forKey:@"lat"];
            [params setObject:[NSString stringWithFormat:@"%f", lng] forKey:@"long"];
            [params setObject: remoteLoc forKey:@"src"];
            
            [GeoShoutApi makeApiRequestWithParameters:params withScript:@"posts.php" onCompletion:completion];
        }
        return nil;
    }];
}


+(void)postMedia:(NSData*)content
         forUser:(long)userId
 withContentType:(int)content_type
contentTypeString:(NSString*)typeString
      contentExt:(NSString*)ext
    onCompletion:(void (^)(RequestResult *))completion {
    
    NSString *tmpPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"pf.tmp"];
    [content writeToFile: tmpPath atomically:true];
    
    tmpPath = [NSString stringWithFormat:@"file://%@", tmpPath];
    
    NSURL * tmpURL = [NSURL URLWithString:tmpPath];
    
    AWSS3TransferManager *transferManager = [AWSS3TransferManager defaultS3TransferManager];
    
    NSString *fileKey = [NSString stringWithFormat:@"%d_%d", (arc4random()%1000000000) + 1000000000,
                         (arc4random()%1000000000) + 1000000000] ;
    
    AWSS3TransferManagerUploadRequest *mediaUploadRequest = [AWSS3TransferManagerUploadRequest new];
    mediaUploadRequest.bucket = [NSString stringWithFormat:@"%@", saBucket];
    mediaUploadRequest.key = [NSString stringWithFormat:@"%@%@.%@", displayPicPath, fileKey,ext];
    mediaUploadRequest.body = tmpURL;
    mediaUploadRequest.contentType = typeString;
    
    NSString * remoteLoc = [BaseLocation stringByAppendingString:mediaUploadRequest.key];
    
    [[transferManager upload:mediaUploadRequest] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id(BFTask *task) {
        [[NSFileManager defaultManager] removeItemAtURL:tmpURL error:nil];
        
        if (task.error) {
            if ([task.error.domain isEqualToString:AWSS3TransferManagerErrorDomain]) {
                switch (task.error.code) {
                    case AWSS3TransferManagerErrorCancelled:
                    case AWSS3TransferManagerErrorPaused:
                        break;
                        
                    default:
                        NSLog(@"Error: %@", task.error);
                        break;
                }
            } else {
                // Unknown error.
                NSLog(@"Error: %@", task.error);
            }
        }
        
        if (task.result) {
            [[NSFileManager defaultManager] removeItemAtURL:tmpURL error:nil];
            
            NSMutableDictionary *params = [NSMutableDictionary new];
            [params setObject:@"img" forKey:@"act"];
            [params setObject:[NSString stringWithFormat:@"%li", userId] forKey:@"usr"];
            [params setObject: remoteLoc forKey:@"src"];
            
            [GeoShoutApi makeApiRequestWithParameters:params withScript:@"usr.php" onCompletion:completion];
        }
        return nil;
    }];
}

+(void) postText:(NSString*)post
         forUser:(long)usr
   withLattitude:(double)lat
   withLongitude:(double)lng
    onCompletion:(void (^)(RequestResult * result)) completion {
    NSDictionary * params = @{
                              @"act":@"text",
                              @"usr":[NSNumber numberWithLong:usr],
                              @"lat":[NSNumber numberWithDouble:lat],
                              @"long":[NSNumber numberWithDouble:lng],
                              @"txt":post
                              };
    [GeoShoutApi makeApiRequestWithParameters:params withScript:@"posts.php" onCompletion:completion];
}

+(void)postUrlContent:(NSObject *)content forUser:(long)userId lat:(double)lat lng:(double)lng onCompletion:(void (^)(RequestResult *))completion{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:@"pu" forKey:@"act"];
    [params setObject:[NSString stringWithFormat:@"%li", userId] forKey:@"usr"];
    [params setObject:[NSString stringWithFormat:@"%f", lat] forKey:@"lat"];
    [params setObject:[NSString stringWithFormat:@"%f", lng] forKey:@"lng"];
    
    [GeoShoutApi makeApiRequestWithParameters:params withScript:@"posts.php" onCompletion:completion];
}

+(void)likeTogglePost:(long)postId
              forUser:(long)userId
                  lat:(double)lat
                  lng:(double)lng
         onCompletion:(void (^)(RequestResult *))completion{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:@"togg" forKey:@"act"];
    [params setObject:@1 forKey:@"type"];
    [params setObject:[NSString stringWithFormat:@"%li", postId] forKey:@"id"];
    [params setObject:[NSString stringWithFormat:@"%li", userId] forKey:@"usr"];
    
    if (lat!=0 && lng != 0) {
        [params setObject:[NSNumber numberWithDouble:lat] forKey:@"lat"];
        [params setObject:[NSNumber numberWithDouble:lng] forKey:@"lng"];
    }
    
    [GeoShoutApi makeApiRequestWithParameters:params withScript:@"posts.php" onCompletion:completion];
}

+(void)favoriteTogglePost:(long)postId
                  forUser:(long)userId
                      lat:(double)lat
                      lng:(double)lng
             onCompletion:(void (^)(RequestResult *))completion{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:@"togg" forKey:@"act"];
    [params setObject:@3 forKey:@"type"];
    [params setObject:[NSString stringWithFormat:@"%li", postId] forKey:@"id"];
    [params setObject:[NSString stringWithFormat:@"%li", userId] forKey:@"usr"];
    
    if (lat!=0 && lng != 0) {
        [params setObject:[NSNumber numberWithDouble:lat] forKey:@"lat"];
        [params setObject:[NSNumber numberWithDouble:lng] forKey:@"lng"];
    }
    
    [GeoShoutApi makeApiRequestWithParameters:params withScript:@"posts.php" onCompletion:completion];
}

+(void)dislikeTogglePost:(long)postId
                 forUser:(long)userId
                     lat:(double)lat
                     lng:(double)lng
            onCompletion:(void (^)(RequestResult *))completion{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:@"togg" forKey:@"act"];
    [params setObject:@2 forKey:@"type"];
    [params setObject:[NSString stringWithFormat:@"%li", postId] forKey:@"id"];
    [params setObject:[NSString stringWithFormat:@"%li", userId] forKey:@"usr"];
    
    if (lat!=0 && lng != 0) {
        [params setObject:[NSNumber numberWithDouble:lat] forKey:@"lat"];
        [params setObject:[NSNumber numberWithDouble:lng] forKey:@"lng"];
    }
    
    [GeoShoutApi makeApiRequestWithParameters:params withScript:@"posts.php" onCompletion:completion];
}







+(void) locInfo:(double)lat
        withLat:(double)lng
   onCompletion:(void (^)(RequestResult *))completion{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:@"loc" forKey:@"act"];
    [params setObject:[NSString stringWithFormat:@"%f", lat] forKey:@"lat"];
    [params setObject:[NSString stringWithFormat:@"%f", lng] forKey:@"long"];
    
    [GeoShoutApi makeApiRequestWithParameters:params withScript:@"posts.php" onCompletion:completion];
}






@end

/***********************************
 
 View Content SubAPI
 
 */

@implementation Contents

+(void) contentForUser:(long)userId
               withLat:(double)lat
               withLng:(double)lng
               inRange:(NSString*)range
           sortingType:(NSString*)sorting
    forPlaceHolderDate:(NSDate*)phd
        forRefreshType:(NSString*)refreshType
           strideStart:(int)stride_start
             strideEnd:(int)stride_end
          onCompletion:(void (^)(RequestResult *))completion {
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:@"posts" forKey:@"act"];
    if (userId != 0) [params setObject:[NSNumber numberWithLong:userId] forKey:@"usr"];
    
    if (lat!=0 && lng != 0) {
        [params setObject:[NSNumber numberWithDouble:lat] forKey:@"lat"];
        [params setObject:[NSNumber numberWithDouble:lng] forKey:@"lng"];
    }
    
    if (range) [params setObject:range forKey:@"rng"];
    if (sorting) [params setObject:sorting forKey:@"meth"];
    
    if (refreshType) [params setObject:refreshType forKey:@"qm"];
    if (phd) [params setObject:phd forKey:@"phd"];
    
    if (stride_start != 0 && stride_end != 0){
        [params setObject:[NSNumber numberWithInt:stride_start] forKey:@"stri_s"];
        [params setObject:[NSNumber numberWithInt:stride_end] forKey:@"stri_e"];
    }
    
    [GeoShoutApi makeApiRequestWithParameters:params withScript:@"views.php" onCompletion:completion];
}

+(void)smallProfileOfUser:(long)userId onCompletion:(void (^)(RequestResult *))completion {
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:@"sp" forKey:@"act"];
    [params setObject:[NSString stringWithFormat:@"%li", userId] forKey:@"usr"];
    
    [GeoShoutApi makeApiRequestWithParameters:params withScript:@"views.php" onCompletion:completion];
}

+(void)largeProfileOfUser:(long)userId onCompletion:(void (^)(RequestResult *))completion {
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:@"lp" forKey:@"act"];
    [params setObject:[NSString stringWithFormat:@"%li", userId] forKey:@"usr"];
    
    [GeoShoutApi makeApiRequestWithParameters:params withScript:@"views.php" onCompletion:completion];
}

+(void)smallViewOfPost:(long)postId forUserId:(long)userId onCompletion:(void (^)(RequestResult *))completion {
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:@"post" forKey:@"act"];
    [params setObject:@"sml" forKey:@"typ"];
    [params setObject:[NSString stringWithFormat:@"%li", postId] forKey:@"id"];
    [params setObject:[NSString stringWithFormat:@"%li", userId] forKey:@"usr"];
    
    [GeoShoutApi makeApiRequestWithParameters:params withScript:@"views.php" onCompletion:completion];
}

+(void)largeViewOfPost:(long)postId forUserId:(long)userId onCompletion:(void (^)(RequestResult *))completion {
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:@"post" forKey:@"act"];
    [params setObject:@"lg" forKey:@"typ"];
    [params setObject:[NSString stringWithFormat:@"%li", postId] forKey:@"id"];
    [params setObject:[NSString stringWithFormat:@"%li", userId] forKey:@"usr"];
    
    [GeoShoutApi makeApiRequestWithParameters:params withScript:@"views.php" onCompletion:completion];
}

@end