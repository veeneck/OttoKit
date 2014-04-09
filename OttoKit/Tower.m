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

- (void)resolveRequestedAnimation {
    // Determine the animation we want to play.
    NSString *animationKey = nil;
    NSArray *animationFrames = nil;
    
    switch (animationState) {
            
        default:
            
        case AnimationStateAttack:
            animationKey = @"anim_attack";
            animationFrames = [self attackAnimationFrames];
            break;
            
    }
    
    if (animationKey) {
        [self fireAnimationForStateOnce:animationState usingTextures:animationFrames withKey:animationKey];
    }
    
    self.requestedAnimation = AnimationStateWalk;
}

- (void)fireAnimationForState:(AnimationState)animationState usingTextures:(NSArray *)frames withKey:(NSString *)key {
    SKAction *sequence = [SKAction sequence:@[[SKAction animateWithTextures:frames timePerFrame:0.1]]];
    SKAction *repeat = [SKAction repeatActionForever:sequence];
    [self runAction:repeat];
}

- (void)fireAnimationForStateOnce:(AnimationState)animationState usingTextures:(NSArray *)frames withKey:(NSString *)key {
    SKAction *sequence = [SKAction sequence:@[
                                              [SKAction animateWithTextures:frames timePerFrame:0.05],
                                              [SKAction setTexture:[SKTexture textureWithImageNamed:@"catapult_base"]]]];
    [self runAction:sequence];
}

- (NSArray*)loadFramesFromAtlas:(NSString *)atlasName baseFileName:(NSString*)baseFileName numberOfFrames:(int)numberOfFrames {
    NSMutableArray *frames = [NSMutableArray arrayWithCapacity:numberOfFrames];
    
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:atlasName];
    for (int i = 0; i < numberOfFrames; i++) {
        NSString *fileName = [NSString stringWithFormat:@"%@%d.png", baseFileName, i];
        SKTexture *texture = [atlas textureNamed:fileName];
        [frames addObject:texture];
    }
    
    return frames;
}


-(void)addSoldier:(SKNode*)layer {
    //overridden
}

-(void)targetInRange:(SKNode*)enemy {
    // Overridden
}

-(void)attackPoint:(CGPoint)coords {
    // Overridden
}

- (NSArray *)attackAnimationFrames {
    return nil;
}

@end
