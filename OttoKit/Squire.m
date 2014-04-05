//
//  Squire.m
//  OttoKit
//
//  Created by Ryan Campbell on 4/4/14.
//  Copyright (c) 2014 Ryan Campbell. All rights reserved.
//

#import "Squire.h"
#import "Character.h"

@implementation Squire

- (id)initAtPosition:(CGPoint)position {
    
    if(self = [super initWithSprite:@"soldier"]) {
        self.position = position;
        self.zPosition = 100;
        self.name = @"squire";
        [self configurePhysicsBody];
        [self loadSharedAssets];
    }
    
    return self;
}

- (void)collidedWith:(SKPhysicsBody *)other {
    [super collidedWith:other];
    [self runAction:[SKAction setTexture:[SKTexture textureWithImageNamed:@"soldier"]]];
}

- (void)configurePhysicsBody {
    CGSize newSize = CGSizeMake(self.size.width, self.size.height);
    self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:newSize.width/2];
    
    self.physicsBody.dynamic = YES;
    self.physicsBody.restitution = 0;
    self.physicsBody.allowsRotation = YES;
    
    self.physicsBody.categoryBitMask = 1;
    self.physicsBody.collisionBitMask = 1;
    self.physicsBody.contactTestBitMask = 4 | 2;
}

- (void) loadSharedAssets {
    sharedWalkAnimationFrames = [super loadFramesFromAtlas:@"soldier_walk" baseFileName:@"soldier_" numberOfFrames:8];
    sharedAttackAnimationFrames = [super loadFramesFromAtlas:@"archer_shoot" baseFileName:@"shoot_" numberOfFrames:12];

};

static NSArray *sharedWalkAnimationFrames = nil;
- (NSArray *)walkAnimationFrames {
    return sharedWalkAnimationFrames;
}

static NSArray *sharedAttackAnimationFrames = nil;
- (NSArray *)attackAnimationFrames {
    return sharedAttackAnimationFrames;
}

@end
