//
//  InterfaceController.h
//  shoutAPP WatchKit Extension
//
//  Created by Miguel Garcia Topete on 6/5/15.
//  Copyright (c) 2015 Miguel Garcia Topete. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>

@interface MapInterfaceController : WKInterfaceController
@property (strong, nonatomic) IBOutlet WKInterfaceMap *myMap;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *myLabel;

@end
