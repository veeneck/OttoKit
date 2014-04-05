//
//  Character.h
//  OttoKit
//
//  Created by Ryan Campbell on 4/4/14.
//  Copyright (c) 2014 Ryan Campbell. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

/* The different animation states of an animated character. */
typedef enum : uint8_t {
    APAAnimationStateIdle = 0,
    APAAnimationStateWalk,
    APAAnimationStateAttack,
    APAAnimationStateGetHit,
    APAAnimationStateDeath,
    kAnimationStateCount
} APAAnimationState;

@interface Character : SKSpriteNode {
    APAAnimationState animationState;
}

- (id)initWithSprite:(NSString *)sprite;
- (NSArray*)loadFramesFromAtlas:(NSString *)atlasName baseFileName:(NSString*)baseFileName numberOfFrames:(int)numberOfFrames;
- (void)resolveRequestedAnimation;
- (void)movetoPoint:(CGPoint)coords;
- (void)attackPoint:(CGPoint)coords;
- (void)configurePhysicsBody;
- (void)collidedWith:(SKPhysicsBody *)other;

@property (nonatomic) APAAnimationState requestedAnimation;
@property (nonatomic, assign) float currentHealth;
@property (nonatomic, assign) float maxHealth;

/* Assets - should be overridden for animated characters. */
- (NSArray *)walkAnimationFrames;
- (NSArray *)attackAnimationFrames;

@end

