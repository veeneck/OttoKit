//
//  Enemy.h
//  OttoKit
//
//  Created by Ryan Campbell on 4/8/14.
//  Copyright (c) 2014 Ryan Campbell. All rights reserved.
//

#import "Character.h"

@interface Enemy : Character {
    
}

- (id)initAtPosition:(CGPoint)position;

@property (nonatomic) NSArray* sharedWalkAnimationFrames;
@property (nonatomic) NSArray* sharedAttackAnimationFrames;

@end
