//
//  RequestResult.h
//  shoutAPP
//
//  Created by Mac on 5/30/15.
//  Copyright (c) 2015 Miguel Garcia Topete. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestResult : NSObject

@property (nonatomic, strong) NSString * msg;
@property (nonatomic, strong) NSDictionary * extra;
@property bool success;

@end
