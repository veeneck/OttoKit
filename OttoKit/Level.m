//
//  Level.m
//  OttoKit
//
//  Created by Ryan Campbell on 4/3/14.
//  Copyright (c) 2014 Ryan Campbell. All rights reserved.
//

#import "Level.h"
#import "Squire.h"
#import "Archer.h"

@implementation Level

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        [self loadSound];
        self.backgroundColor = [SKColor colorWithRed:0.616 green:0.714 blue:0.549 alpha:1]; /*#9db68c*/
        world = [SKNode node];
        [self addChild:world];
        
        self.physicsWorld.contactDelegate = self;
        self.physicsWorld.gravity = CGVectorMake(0.0, 0.0);

        
        Squire* character = [[Squire alloc] initAtPosition:CGPointMake(700, 400)];
        [world addChild:character];
        //[character movetoPoint:CGPointMake(0, 300)];
        
        Squire* character2 = [[Squire alloc] initAtPosition:CGPointMake(700, 500)];
        [world addChild:character2];
        //[character2 movetoPoint:CGPointMake(0, 500)];
        
        Archer* character3 = [[Archer alloc] initAtPosition:CGPointMake(200, 500)];
        [world addChild:character3];
        [character3 attackPoint:CGPointMake(700, 500)];
        
        
        /*CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, 800, 400);
        CGPathAddLineToPoint(path, NULL, 600, 400);
        SKAction *followline = [SKAction followPath:path asOffset:NO orientToPath:NO duration:3.0];*/
        
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, 700, 400);
        CGPathAddCurveToPoint(path, NULL, 500, 500, 400, 600, 200, 400);
        //CGPathAddLineToPoint(path, NULL, 200, 400);
        SKAction *followline = [SKAction followPath:path asOffset:NO orientToPath:NO duration:3.0];
        
        /*CGMutablePathRef path2 = CGPathCreateMutable();
        CGPathMoveToPoint(path2, NULL, 600, 400);
        CGPathAddLineToPoint(path2, NULL, 400, 600);
        SKAction *followline2 = [SKAction followPath:path2 asOffset:NO orientToPath:NO duration:3.5];
        
        CGMutablePathRef path3 = CGPathCreateMutable();
        CGPathMoveToPoint(path3, NULL, 400, 600);
        CGPathAddLineToPoint(path3, NULL, 0, 800);
        SKAction *followline3 = [SKAction followPath:path3 asOffset:NO orientToPath:NO duration:5.0];*/
        
        [character runAction:[SKAction sequence:@[followline]]];
    
    }
    return self;
}

-(void) didBeginContact:(SKPhysicsContact *)contact {
    
    // Either bodyA or bodyB in the collision could be a character.
    SKNode *node = contact.bodyA.node;
    if ([node isKindOfClass:[Character class]]) {
        [(Character *)node collidedWith:contact.bodyB];
    }

    // Check bodyB too.
    node = contact.bodyB.node;
    if ([node isKindOfClass:[Character class]]) {
        [(Character *)node collidedWith:contact.bodyA];
    }

    // Handle collisions with projectiles.
    if (contact.bodyA.categoryBitMask & 2 || contact.bodyB.categoryBitMask & 2) {
        /*SKNode *projectile = (contact.bodyA.categoryBitMask & 2) ? contact.bodyA.node : contact.bodyB.node;
        
        [projectile runAction:[SKAction removeFromParent]];
        
        // Build up a "one shot" particle to indicate where the projectile hit.
        SKEmitterNode *emitter = [[self sharedProjectileSparkEmitter] copy];
        [self addNode:emitter atWorldLayer:APAWorldLayerAboveCharacter];
        emitter.position = projectile.position;
        APARunOneShotEmitter(emitter, 0.15f);*/
    }
    
}

/* --- SOUND ---  */

-(void) loadSound {
    NSError *error;
    NSURL * backgroundMusicURL = [[NSBundle mainBundle] URLForResource:@"horde" withExtension:@"mp3"];
    backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:&error];
    backgroundMusicPlayer.numberOfLoops = -1;
    backgroundMusicPlayer.volume = 1;
    [backgroundMusicPlayer prepareToPlay];
    [backgroundMusicPlayer play];
}

@end