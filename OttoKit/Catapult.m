//
//  Catapult.m
//  OttoKit
//
//  Created by Ryan Campbell on 4/9/14.
//  Copyright (c) 2014 Ryan Campbell. All rights reserved.
//

#import "Catapult.h"
#import "Character.h"

@implementation Catapult

- (id)initAtPosition:(CGPoint)position {
    
    NSString* asset = @"catapult_base";
    
    if(self = [super initWithSprite:asset]) {
        self.position = position;
        self.zPosition = 110;
        self.name = @"Catapult";
        self.cost = 100;
        self.xScale = 0.75;
        self.yScale = 0.75;
        sharedProjectile = [SKTexture textureWithImageNamed:@"boulder"];
        [self loadSharedAssets];
        [self configureRange];
    }
    
    return self;
}

- (void) configureRange {
    range = [[SKShapeNode alloc] init];
    
    range.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:400 center:CGPointMake(700, -400)];
    range.physicsBody.dynamic = YES;
    range.physicsBody.restitution = 0;
    range.physicsBody.allowsRotation = NO;
    
    range.physicsBody.categoryBitMask = 0;
    range.physicsBody.collisionBitMask = 0;
    range.physicsBody.contactTestBitMask = ColliderTypeEnemy;
    range.name = @"range_catapult";
    
    
    [self addChild:range];
}

-(void) targetInRange:(SKNode *)enemy {
    target = (Character *)enemy;
    [self attackPoint:enemy.position];
}

-(BOOL) targetOutOfRange {
    CGPoint startPos;
    startPos.x = self.position.x + 700;
    startPos.y = self.position.y - 400;
    CGFloat distance  = hypotf(startPos.x - target.position.x, startPos.y - target.position.y);
    if(distance > 200) {
        return true;
    }
    return false;
}

-(void)attackPoint:(CGPoint)coords {
    [range removeFromParent];
    SKAction* fire = [self shootArrow:coords];
    SKAction *sequence2 = [SKAction sequence:@[
                                               [SKAction waitForDuration: 0.3],
                                               fire,
                                               [SKAction playSoundFileNamed:@"catapult2.wav" waitForCompletion:NO],
                                               [SKAction waitForDuration: 4]]];
    [self runAction:sequence2 completion:^{
        if(!target.dying && ![self targetOutOfRange]) {
            [self attackPoint:target.position];
        }
        else {
            [self addChild:range];
            target = nil;
        }
    }];
    
    animationState = AnimationStateAttack;
    [super resolveRequestedAnimation];
}

-(SKAction *)shootArrow:(CGPoint) coords {
    float speedOffset = 50;
    SKAction* fire = [SKAction runBlock:^{
        
        SKSpriteNode* arrow = [SKSpriteNode spriteNodeWithTexture:sharedProjectile];
        arrow.xScale = 0.75;
        arrow.yScale = 0.75;
        arrow.position = CGPointMake(10, 35);
        arrow.zPosition = 1000;
        arrow.userData = [NSMutableDictionary
                          dictionaryWithDictionary:@{
                                                     @"damage" : [NSNumber numberWithFloat:20]
                                                     }];
        
        // Set up arrow physics
        CGSize newSize = CGSizeMake(sharedProjectile.size.width, sharedProjectile.size.height);
        arrow.physicsBody.dynamic = NO;
        arrow.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:newSize];
        arrow.physicsBody.categoryBitMask = ColliderTypeProjectile;
        arrow.physicsBody.collisionBitMask = 0;
        arrow.physicsBody.contactTestBitMask = 0;
        
        // move point to where rock launches from
        CGPoint launchPoint;
        launchPoint.x = self.position.x + 10;
        launchPoint.y = self.position.y + 35;
        
        // Determine how far away target is, and how to get there
        float distanceX = (arrow.position.x - coords.x - speedOffset)*-1;
        float offsetX = distanceX / 3;
        
        float distanceY = (launchPoint.y - coords.y)*-1;
        float offsetY = distanceY / 3;
        
        float duration = distanceX / 400;
        if(duration <= 0) {
            duration = duration * -1;
        }
        
        if(distanceY / 400 > duration) {
            duration = distanceY / 400;
        }
        
        // Make a path
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, launchPoint.x, launchPoint.y);
        CGPathAddCurveToPoint(path, NULL,
                              launchPoint.x + offsetX, launchPoint.y + offsetY + 200,
                              launchPoint.x + (offsetX * 2), launchPoint.y + (offsetY * 2) + 100,
                              coords.x - speedOffset, coords.y);
        
        
        // Add to scene and run action
        SKAction *followline = [SKAction followPath:path asOffset:NO orientToPath:YES duration:duration];
        [[self scene] addChild:arrow];
        [arrow runAction:[SKAction sequence:@[followline]] completion:^{
            [self createSplashDamage:coords];
            [arrow removeFromParent];
        }];
    }];
    
    return fire;
}

-(void)createSplashDamage:(CGPoint)coords {
    /*SKShapeNode* splash = [[SKShapeNode alloc] init];
    
    splash.position = coords;
    splash.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:100 center:CGPointMake(0, 0)];
    splash.physicsBody.dynamic = YES;
    splash.physicsBody.restitution = 0;
    splash.physicsBody.allowsRotation = NO;
    
    splash.physicsBody.categoryBitMask = 0;
    splash.physicsBody.collisionBitMask = 0;
    splash.physicsBody.contactTestBitMask = ColliderTypeEnemy;
    splash.name = @"range_catapult_splash";*/
    //[[self scene] addChild:splash];
    [Effects shakeNode:world];
    [self runAction:[SKAction playSoundFileNamed:@"impact.wav" waitForCompletion:NO]];
  
}

- (void) loadSharedAssets {
    sharedAttackAnimationFrames = [super loadFramesFromAtlas:@"catapult_fire" baseFileName:@"catapult_" numberOfFrames:6];
    
};

-(void)setWorldLayer:(SKNode*)worldlayer {
    world = worldlayer;
}

static SKTexture *sharedProjectile = nil;
- (SKTexture *)sharedProjectile {
    return sharedProjectile;
}

static NSArray *sharedAttackAnimationFrames = nil;
- (NSArray *)attackAnimationFrames {
    return sharedAttackAnimationFrames;
}

@end
