//
//  Archer.h
//  OttoKit
//
//  Created by Ryan Campbell on 4/4/14.
//  Copyright (c) 2014 Ryan Campbell. All rights reserved.
//

#import "Character.h"

@interface Archer : Character {
    Character* target;
    SKShapeNode* range;
}

- (id)initAtPosition:(CGPoint)position;

@property (nonatomic) NSArray* sharedWalkAnimationFrames;
@property (nonatomic) NSArray* sharedAttackAnimationFrames;

@end
