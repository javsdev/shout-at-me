//
//  Credentials.h
//  shoutAPP
//
//  Created by Mac on 5/30/15.
//  Copyright (c) 2015 Miguel Garcia Topete. All rights reserved.
//

#import <Foundation/Foundation.h>

//const int kCredentialUserNamePassword = 1;

@interface Credentials : NSObject

@property (nonatomic, strong) NSString * cred_user;
@property (nonatomic, strong) NSString * cred_pass;
@property int cred_type;

@end
