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
    self.physicsBody.allowsRotation = NO;
    
    self.physicsBody.categoryBitMask = APAColliderTypeHero;
    self.physicsBody.collisionBitMask = 0;
    self.physicsBody.contactTestBitMask = APAColliderTypeEnemy;
}

- (void) loadSharedAssets {
    sharedWalkAnimationFrames = [super loadFramesFromAtlas:@"soldier_walk" baseFileName:@"soldier_" numberOfFrames:8];
    sharedAttackAnimationFrames = [super loadFramesFromAtlas:@"soldier_attack" baseFileName:@"soldier_" numberOfFrames:5];
};

-(void) targetInRange:(SKNode *)enemy {
    self.engaged = YES;
    target = (Character *)enemy;
    [self attackPoint:enemy.position];
}

-(void)attackPoint:(CGPoint)coords {
    SKAction *sequence2 = [SKAction sequence:@[[SKAction waitForDuration: 0.6]]];
    [self runAction:sequence2 completion:^{
        if(!target.dying) {
            [target doDamageWithAmount:20];
            [self attackPoint:target.position];
        }
        else {
            self.engaged = NO;
            target = nil;
            [self runAction:[SKAction setTexture:[SKTexture textureWithImageNamed:@"soldier"]]];
        }
    }];
    
    animationState = APAAnimationStateAttack;
    [super resolveRequestedAnimation];
}

static NSArray *sharedWalkAnimationFrames = nil;
- (NSArray *)walkAnimationFrames {
    return sharedWalkAnimationFrames;
}

static NSArray *sharedAttackAnimationFrames = nil;
- (NSArray *)attackAnimationFrames {
    return sharedAttackAnimationFrames;
}

@end
