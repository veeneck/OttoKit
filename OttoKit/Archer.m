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
    self.physicsBody.collisionBitMask = 2;
    self.physicsBody.contactTestBitMask = 1;
}

- (void)collidedWith:(SKPhysicsBody *)other {
    [super collidedWith:other];
    [self runAction:[SKAction setTexture:[SKTexture textureWithImageNamed:@"archer_base_right"]]];
}

-(void)attackPoint:(CGPoint)coords {
    target = coords;
    SKAction* fire = [SKAction runBlock:^{
        CGFloat distance  = hypotf(self.position.x - target.x, self.position.y - target.y);
        CGFloat speed = 200;
        SKAction* moveAction = [SKAction moveToX:target.x duration:distance/speed];
        
        SKSpriteNode* arrow = [SKSpriteNode spriteNodeWithImageNamed:@"arrow"];
        arrow.position = CGPointMake(10, 0);
        arrow.zPosition = 1000;
        arrow.physicsBody.dynamic = NO;
        CGSize newSize = CGSizeMake(arrow.size.width, arrow.size.height);
        arrow.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:newSize];
        arrow.physicsBody.categoryBitMask = 4;
        arrow.physicsBody.collisionBitMask = 4;
        arrow.physicsBody.contactTestBitMask = 1;
        
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, 10, 0);
        float distanceToTarget = target.x - self.position.x;
        float offset = distanceToTarget / 3;
        CGPathAddCurveToPoint(path, NULL,
                              offset, arrow.position.y + 40,
                              (offset * 2), arrow.position.y + 60,
                              distanceToTarget, arrow.position.y);
        SKAction *followline = [SKAction followPath:path asOffset:NO orientToPath:YES duration:distanceToTarget/500];
        
        [self addChild:arrow];
        [arrow runAction:followline];
    }];
    
    SKAction *sequence2 = [SKAction sequence:@[[SKAction waitForDuration: 0.7], fire, [SKAction waitForDuration: 0.5]]];
    SKAction *repeat2 = [SKAction repeatActionForever:sequence2];
    [self runAction:repeat2];
    
    animationState = APAAnimationStateAttack;
    [super resolveRequestedAnimation];
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
