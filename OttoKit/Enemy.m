//
//  Enemy.m
//  OttoKit
//
//  Created by Ryan Campbell on 4/8/14.
//  Copyright (c) 2014 Ryan Campbell. All rights reserved.
//

#import "Enemy.h"
#import "Character.h"

@implementation Enemy

- (id)initAtPosition:(CGPoint)position {
    
    if(self = [super initWithSprite:@"soldier"]) {
        self.position = position;
        self.zPosition = 100;
        self.name = @"enemy";
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
    
    self.physicsBody.dynamic = NO;
    self.physicsBody.allowsRotation = NO;
    
    self.physicsBody.categoryBitMask = APAColliderTypeWall;
    self.physicsBody.collisionBitMask = 0;
    self.physicsBody.contactTestBitMask = APAColliderTypeProjectile | APAColliderTypeHero ;
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