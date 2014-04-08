//
//  Melee.h
//  OttoKit
//
//  Created by Ryan Campbell on 4/8/14.
//  Copyright (c) 2014 Ryan Campbell. All rights reserved.
//

#import "Tower.h"

@interface Melee : Tower {
    
}

- (id)initAtPosition:(CGPoint)position facing:(float)towards;

@property (nonatomic, assign) float direction;

@end
