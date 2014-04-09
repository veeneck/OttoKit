//
//  Tower.h
//  OttoKit
//
//  Created by Ryan Campbell on 4/8/14.
//  Copyright (c) 2014 Ryan Campbell. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Character.h"

/* The different animation states of an animated character. */
typedef enum : uint8_t {
    AnimationStateIdle = 0,
    AnimationStateWalk,
    AnimationStateAttack,
    AnimationStateGetHit,
    AnimationStateDeath,
    AnimationStateCount
} AnimationState;

/* Bitmask for the different entities with physics bodies. */
typedef enum : uint8_t {
    ColliderTypeHero             = 1,
    ColliderTypeGoblinOrBoss     = 2,
    ColliderTypeProjectile       = 4,
    ColliderTypeEnemy            = 8,
    ColliderTypeCave             = 16
} ColliderType;

@interface Tower : SKSpriteNode {
    AnimationState animationState;
    Character* target;
    SKNode* world;
}

- (NSArray*)loadFramesFromAtlas:(NSString *)atlasName baseFileName:(NSString*)baseFileName numberOfFrames:(int)numberOfFrames;
- (id)initWithSprite:(NSString *)sprite;
- (void)resolveRequestedAnimation;
- (void)addSoldier:(SKNode*)layer;
- (void)attackPoint:(CGPoint)coords;
- (void)targetInRange:(SKNode *)enemy;

@property (nonatomic, getter=getCost) float cost;
@property (nonatomic) AnimationState requestedAnimation;

- (NSArray *)attackAnimationFrames;

@end
