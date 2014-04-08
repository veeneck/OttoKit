//
//  Tower.m
//  OttoKit
//
//  Created by Ryan Campbell on 4/8/14.
//  Copyright (c) 2014 Ryan Campbell. All rights reserved.
//

#import "Tower.h"

@implementation Tower 
    
-(id) initWithSprite:(NSString*)sprite {
    
    if(self = [super initWithImageNamed:sprite]) {

    }
    
    return self;
}

-(void)addSoldier {
    //overridden
}

@end
