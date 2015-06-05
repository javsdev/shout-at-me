//
//  ShoutAnnotation.m
//  shoutAPP
//
//  Created by Miguel Garcia Topete on 5/31/15.
//  Copyright (c) 2015 Miguel Garcia Topete. All rights reserved.
//

#import "ShoutAnnotation.h"

@implementation ShoutAnnotation

- (id) initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier])
    {
            self.backgroundColor = [UIColor clearColor];

    }
    return self;
}

@end
