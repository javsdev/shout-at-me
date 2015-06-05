//
//  Profile.h
//  shoutAPP
//
//  Created by MAC01 on 5/30/15.
//  Copyright (c) 2015 Miguel Garcia Topete. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Profile : NSObject

@property long profileId;
@property long postCount;
@property (nonatomic, strong) NSString * profileName;
@property (nonatomic, strong) NSString * displayName;
@property (nonatomic, strong) NSString * displayStatus;
@property (nonatomic, strong) NSDate * DOB;
@property (nonatomic, strong) NSString * displayImage;

@end
