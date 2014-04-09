//
//  Archer.m
//  OttoKit
//
//  Created by Ryan Campbell on 4/4/14.
//  Copyright (c) 2014 Ryan Campbell. All rights reserved.
//

#import "Archer.h"

@implementation Archer

- (id)initAtPosition:(CGPoint)position {
    
    if(self = [super initWithSprite:@"archer_base_right"]) {
        self.position = position;
        self.zPosition = 100;
        self.name = @"archer";
        [self configurePhysicsBody];
        [self configureRange];
        [self loadSharedAssets];
    }
    
    return self;
}

- (void)configurePhysicsBody {
    CGSize newSize = CGSizeMake(self.size.width, self.size.height);
    self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:newSize.width/2];
    
    self.physicsBody.dynamic = NO;
    self.physicsBody.restitution = 0;
    self.physicsBody.allowsRotation = YES;
    
    self.physicsBody.categoryBitMask = APAColliderTypeHero;
    self.physicsBody.collisionBitMask = 0;
    self.physicsBody.contactTestBitMask = APAColliderTypeEnemy;
}

- (void) configureRange {
    range = [[SKShapeNode alloc] init];
    
    range.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:400 center:CGPointMake(0, 0)];
    range.physicsBody.dynamic = YES;
    range.physicsBody.restitution = 0;
    range.physicsBody.allowsRotation = NO;
    
    range.physicsBody.categoryBitMask = 0;
    range.physicsBody.collisionBitMask = 0;
    range.physicsBody.contactTestBitMask = APAColliderTypeEnemy;
    range.name = @"range";


    [self addChild:range];
}

- (void)collidedWith:(SKPhysicsBody *)other {
    [super collidedWith:other];
    [self runAction:[SKAction setTexture:[SKTexture textureWithImageNamed:@"archer_base_right"]]];
}

-(void) targetInRange:(SKNode *)enemy {
    target = (Character *)enemy;
    [self attackPoint:enemy.position];
}

-(void)attackPoint:(CGPoint)coords {
    [range removeFromParent];
    SKAction* fire = [self shootArrow:coords];
    SKAction *sequence2 = [SKAction sequence:@[
                                               [SKAction waitForDuration: 0.7],
                                               fire,
                                               [SKAction playSoundFileNamed:@"arrow.wav" waitForCompletion:NO],
                                               [SKAction waitForDuration: 0.8]]];
    [self runAction:sequence2 completion:^{
        if(!target.dying) {
            [self attackPoint:target.position];
        }
        else {
            [self addChild:range];
            target = nil;
        }
    }];
    
    animationState = APAAnimationStateAttack;
    [super resolveRequestedAnimation];
}

-(SKAction *)shootArrow:(CGPoint) coords {
    float speedOffset = 50;
    SKAction* fire = [SKAction runBlock:^{
        
        SKSpriteNode* arrow = [SKSpriteNode spriteNodeWithTexture:sharedProjectile];
        arrow.xScale = 0.5;
        arrow.yScale = 0.5;
        arrow.position = CGPointMake(10, 0);
        arrow.zPosition = 1000;
        arrow.userData = [NSMutableDictionary
                                     dictionaryWithDictionary:@{
                                                                @"damage" : [NSNumber numberWithFloat:50]
                                                                }];
        
        // Set up arrow physics
        CGSize newSize = CGSizeMake(sharedProjectile.size.width, sharedProjectile.size.height);
        arrow.physicsBody.dynamic = NO;
        arrow.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:newSize];
        arrow.physicsBody.categoryBitMask = APAColliderTypeProjectile;
        arrow.physicsBody.collisionBitMask = 0;
        arrow.physicsBody.contactTestBitMask = 0;
        
        // Determine how far away target is, and how to get there
        float distanceX = (self.position.x - coords.x - speedOffset)*-1;
        //float offsetX = distanceX / 3;
        
        //float distanceY = (self.position.y - coords.y)*-1;
        //float offsetY = distanceY / 3;
        
        float duration = distanceX / 500;
        if(duration <= 0) {
            duration = duration * -1;
            if(self.xScale != -0.5) {
                self.xScale = -0.5;
            }
        }
        else {
            if(self.xScale != 0.5) {
                self.xScale = 0.5;
            }
        }
        
        // Make a path
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, self.position.x, self.position.y);
        /*CGPathAddCurveToPoint(path, NULL,
                              self.position.x + offsetX, self.position.y + offsetY,
                              self.position.x + (offsetX * 2), self.position.y + (offsetY * 2),
                              coords.x - speedOffset, coords.y);*/
        
        CGPathAddLineToPoint(path, NULL, coords.x-speedOffset, coords.y);
        
        // Add to scene and run action
        SKAction *followline = [SKAction followPath:path asOffset:NO orientToPath:YES duration:duration];
        [[self scene] addChild:arrow];
        [arrow runAction:[SKAction sequence:@[followline,[SKAction runBlock:^{
            [arrow removeFromParent];
        }]]]];
    }];
    
    return fire;
}

- (void) loadSharedAssets {
    sharedWalkAnimationFrames = [super loadFramesFromAtlas:@"soldier_walk" baseFileName:@"soldier_" numberOfFrames:8];
    sharedAttackAnimationFrames = [super loadFramesFromAtlas:@"archer_shoot" baseFileName:@"shoot_" numberOfFrames:12];
    sharedProjectile = [SKTexture textureWithImageNamed:@"arrow"];
};

static NSArray *sharedWalkAnimationFrames = nil;
- (NSArray *)walkAnimationFrames {
    return sharedWalkAnimationFrames;
}

static NSArray *sharedAttackAnimationFrames = nil;
- (NSArray *)attackAnimationFrames {
    return sharedAttackAnimationFrames;
}

static SKTexture *sharedProjectile = nil;
- (SKTexture *)sharedProjectile {
    return sharedProjectile;
}

@end
