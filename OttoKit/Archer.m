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
    
    self.physicsBody.dynamic = YES;
    self.physicsBody.restitution = 0;
    self.physicsBody.allowsRotation = YES;
    
    self.physicsBody.categoryBitMask = 2;
    self.physicsBody.collisionBitMask = 1;
    self.physicsBody.contactTestBitMask = 1;
}

- (void) configureRange {
    range = [[SKShapeNode alloc] init];
    CGMutablePathRef circlePath = CGPathCreateMutable();
    CGPathAddArc(circlePath, NULL, 0, 0, 400, 0, M_PI*2, NO);
    range.position = CGPointMake( 0, 0);
    range.lineWidth = 1;
    range.strokeColor = [SKColor greenColor];
    
    range.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:400 center:CGPointMake(0, 0)];
    range.physicsBody.dynamic = NO;
    range.physicsBody.restitution = 0;
    range.physicsBody.allowsRotation = NO;
    
    range.physicsBody.categoryBitMask = 8;
    range.physicsBody.collisionBitMask = 36;
    range.physicsBody.contactTestBitMask = 1;
    range.name = @"range";

    range.path = circlePath;
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
    SKAction *sequence2 = [SKAction sequence:@[[SKAction waitForDuration: 0.7], fire, [SKAction waitForDuration: 0.8]]];
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
        
        // Create an arrow sprite
        SKSpriteNode* arrow = [SKSpriteNode spriteNodeWithImageNamed:@"arrow"];
        arrow.position = CGPointMake(10, 0);
        arrow.zPosition = 1000;
        arrow.userData = [NSMutableDictionary
                          dictionaryWithDictionary:@{
                                                     @"damage" : [NSNumber numberWithFloat:20]
                                                    }];
        
        // Set up arrow physics
        CGSize newSize = CGSizeMake(arrow.size.width, arrow.size.height);
        arrow.physicsBody.dynamic = NO;
        arrow.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:newSize];
        arrow.physicsBody.categoryBitMask = 4;
        arrow.physicsBody.collisionBitMask = 1;
        arrow.physicsBody.contactTestBitMask = 1;
        
        // Determine how far away target is, and how to get there
        float distanceX = (self.position.x - coords.x - speedOffset)*-1;
        float offsetX = distanceX / 3;
        
        float distanceY = (self.position.y - coords.y)*-1;
        float offsetY = distanceY / 3;
        
        float duration = distanceX / 500;
        if(duration <= 0) {
            duration = duration * -1;
            self.xScale = -1;
        }
        else {
            self.xScale = 1;
        }
        
        // Make a path
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, self.position.x, self.position.y);
        CGPathAddCurveToPoint(path, NULL,
                              self.position.x + offsetX, self.position.y + offsetY,
                              self.position.x + (offsetX * 2), self.position.y + (offsetY * 2),
                              coords.x - speedOffset, coords.y);
        
        // Add to scene and run action
        SKAction *followline = [SKAction followPath:path asOffset:NO orientToPath:YES duration:duration];
        [[self scene] addChild:arrow];
        [arrow runAction:followline];
    }];
    
    return fire;
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
