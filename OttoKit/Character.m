//
//  Character.m
//  OttoKit
//
//  Created by Ryan Campbell on 4/4/14.
//  Copyright (c) 2014 Ryan Campbell. All rights reserved.
//

#import "Character.h"

@implementation Character
    
-(id) initWithSprite:(NSString*)sprite {
    
    if(self = [super initWithImageNamed:sprite]) {
        [self setUpHealthMeter];
        self.xScale = 0.5;
        self.yScale = 0.5;
        self.dying = NO;
        self.walkingOffset = 0;
    }
    
    return self;
}

- (void)configurePhysicsBody {
    
}

-(void) setUpHealthMeter {
    
    _maxHealth = 100;
    _currentHealth = _maxHealth;
    
    SKSpriteNode* healthBar = [SKSpriteNode spriteNodeWithImageNamed:@"healthbar"];
    healthBar.zPosition = 200;
    healthBar.position = CGPointMake(0, (self.frame.size.height / 2)  );
    healthBar.alpha = 0;
    [self addChild:healthBar];
    
    SKSpriteNode* green = [SKSpriteNode spriteNodeWithImageNamed:@"green"];
    green.zPosition = 201;
    green.position = CGPointMake( - (green.frame.size.width / 2), (self.frame.size.height / 2)  );
    green.anchorPoint = CGPointMake(0.0, 0.5);
    green.name = @"green";
    green.alpha = 0;
    [self addChild:green];
}

-(void) doDamageWithAmount:(float)amount {
    
    _currentHealth = _currentHealth - amount;
    SKNode* damageBar = [self childNodeWithName:@"green"];
    damageBar.xScale = _currentHealth / _maxHealth;
    [self doImageFade:damageBar];
    
    
    // just to prevent the green health bar from being inverted.
    if (_currentHealth <= 0) {
        self.dying = YES;
        _currentHealth = 0;
        [self childNodeWithName:@"green"].xScale = _currentHealth / _maxHealth;
        [self removeFromParent];
    }
    
}

-(void) doImageFade:(SKNode*) img {
    SKAction *sequence = [SKAction sequence:@[[SKAction fadeInWithDuration: 0.5]]];
    [img runAction: sequence];
}

- (void)collidedWith:(SKPhysicsBody *)other {
    if(other.categoryBitMask == 0) {
        
    }
    else if(other.categoryBitMask != APAColliderTypeProjectile) {
        [self removeAllActions];
    }
    else {
        float damage = [[other.node.userData objectForKey:@"damage"]floatValue];
        [self doDamageWithAmount:damage];
        [self addEmitter];
        [other.node runAction:[SKAction removeFromParent]];
    }
}

-(void) addEmitter {
    
    NSString *burstPath =
    [[NSBundle mainBundle] pathForResource:@"arrow_spark" ofType:@"sks"];
    
    SKEmitterNode *burstEmitter =
    [NSKeyedUnarchiver unarchiveObjectWithFile:burstPath];
    
    burstEmitter.zPosition = 10000;
    burstEmitter.name = @"particles";
    
    [self addChild:burstEmitter];
    [self performSelector:@selector(removeEmitter) withObject:nil afterDelay: 2];
    
}

-(void) removeEmitter {
    SKNode* particles = [self childNodeWithName:@"particles"];
    [particles removeFromParent];
}

- (void)resolveRequestedAnimation {
    // Determine the animation we want to play.
    NSString *animationKey = nil;
    NSArray *animationFrames = nil;
    
    switch (animationState) {
            
        default:
            
        case APAAnimationStateWalk:
            animationKey = @"anim_walk";
            animationFrames = [self walkAnimationFrames];
            break;
            
        case APAAnimationStateAttack:
            animationKey = @"anim_attack";
            animationFrames = [self attackAnimationFrames];
            break;
        
    }
    
    if (animationKey) {
        if([animationKey isEqualToString:@"anim_walk"]) {
            [self fireAnimationForState:animationState usingTextures:animationFrames withKey:animationKey];
        }
        else {
            [self fireAnimationForStateOnce:animationState usingTextures:animationFrames withKey:animationKey];
        }
    }
    
    self.requestedAnimation = APAAnimationStateWalk;
}

- (void)fireAnimationForState:(APAAnimationState)animationState usingTextures:(NSArray *)frames withKey:(NSString *)key {
    SKAction *sequence = [SKAction sequence:@[[SKAction animateWithTextures:frames timePerFrame:0.1]]];
    SKAction *repeat = [SKAction repeatActionForever:sequence];
    [self runAction:repeat];
}

- (void)fireAnimationForStateOnce:(APAAnimationState)animationState usingTextures:(NSArray *)frames withKey:(NSString *)key {
    SKAction *sequence = [SKAction sequence:@[[SKAction animateWithTextures:frames timePerFrame:0.1]]];
    [self runAction:sequence];
}

-(void)movetoPoint:(CGPoint)coords {
    CGFloat distance  = hypotf(self.position.x - coords.x, self.position.y - coords.y);
    CGFloat speed = 200;
    SKAction* moveAction = [SKAction moveToX:coords.x duration:distance/speed];
    [self runAction:moveAction];
    animationState = APAAnimationStateWalk;
    [self resolveRequestedAnimation];
}

- (void)moveAlongPaths:(NSMutableArray*)paths {
    NSDictionary* pathDict;
    NSMutableArray* actions = [[NSMutableArray alloc] initWithCapacity:([paths count] - 1)];
    
    float startingX = self.position.x;
    float startingY = self.position.y;
    
    for(int i = 0; i < [paths count]; i++) {
        
        // Get the {x, y} dict from the array at position i
        pathDict = [NSDictionary dictionaryWithDictionary:[paths objectAtIndex:i]];
        
        // Create a path to follow
        CGMutablePathRef pathing = CGPathCreateMutable();
        CGPathMoveToPoint(pathing, NULL, startingX, startingY + self.walkingOffset);
        CGPathAddLineToPoint(pathing, NULL, [[pathDict objectForKey:@"x"]floatValue], [[pathDict objectForKey:@"y"]floatValue] + self.walkingOffset);
        
        // Calculate time by speed/distance
        CGFloat distance  = hypotf(startingX - [[pathDict objectForKey:@"x"]floatValue], startingY - [[pathDict objectForKey:@"y"]floatValue]);
        CGFloat speed = 30;
        
        // Add the action
        SKAction* move = [SKAction followPath:pathing asOffset:NO orientToPath:NO duration:distance/speed];
        [actions addObject:move];
        
        // Update starting point for next action
        startingX = [[pathDict objectForKey:@"x"]floatValue];
        startingY = [[pathDict objectForKey:@"y"]floatValue];
    }
    
    [self runAction:[SKAction sequence:actions]];
    animationState = APAAnimationStateWalk;
    [self resolveRequestedAnimation];

}

-(void)targetInRange:(SKNode*)enemy {
    // Overridden
}


-(void)attackPoint:(CGPoint)coords {
    // Overridden
}

-(void)makeEnemy {
    
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

- (NSArray *)walkAnimationFrames {
    return nil;
}

- (NSArray *)attackAnimationFrames {
    return nil;
}


@end
