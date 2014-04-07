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
        
        NSMutableArray* paths = [self loadPathData];
        
        for(int i = 0; i < 200; i++) {
            Squire* character = [[Squire alloc] initAtPosition:CGPointMake(1000+(i*100), 500)];
            [world addChild:character];
            [character moveAlongPaths:paths];
        }
        
        for(int i = 0; i < 200; i++) {
            Squire* character = [[Squire alloc] initAtPosition:CGPointMake(1000+(i*100), 200)];
            [world addChild:character];
            [character movetoPoint:CGPointMake(0, 200)];
        }
        
        for(int i = 0; i < 200; i++) {
            Squire* character = [[Squire alloc] initAtPosition:CGPointMake(1000+(i*100), 100)];
            [world addChild:character];
            [character movetoPoint:CGPointMake(0, 100)];
        }
        
        for(int i = 0; i < 15; i++) {
            Archer* character = [[Archer alloc] initAtPosition:CGPointMake(100 + (i*16), 100 + (i*32))];
            [world addChild:character];
        }
        
        for(int i = 0; i < 15; i++) {
            Archer* character = [[Archer alloc] initAtPosition:CGPointMake(150 + (i*16), 100 + (i*32))];
            [world addChild:character];
        }
        
        for(int i = 0; i < 15; i++) {
            Archer* character = [[Archer alloc] initAtPosition:CGPointMake(200 + (i*16), 100 + (i*32))];
            [world addChild:character];
        }
        
        
    }
    return self;
}

-(NSMutableArray*) loadPathData {
    NSString* path = [[ NSBundle mainBundle] bundlePath];
    NSString* finalPath = [ path stringByAppendingPathComponent:@"Levels.plist"];
    NSDictionary *plistData = [NSDictionary dictionaryWithContentsOfFile:finalPath];
    
    NSMutableArray* levelArray = [NSMutableArray arrayWithArray:[plistData objectForKey:@"Levels"]];
    NSDictionary* levelDict = [NSDictionary dictionaryWithDictionary:[levelArray objectAtIndex:0]];
    
    NSMutableArray *allPaths = [levelDict objectForKey:@"Paths"];
    
    return [allPaths objectAtIndex:0];
}

-(void) didBeginContact:(SKPhysicsContact *)contact {
    
    // Either bodyA or bodyB in the collision could be a character.
    SKNode *node = contact.bodyA.node;
    if([node.name isEqualToString:@"range"]) {
        [(Character *)node.parent targetInRange:contact.bodyB.node];
    }
    
    if ([node isKindOfClass:[Character class]]) {
        [(Character *)node collidedWith:contact.bodyB];
    }

    // Check bodyB too.
    node = contact.bodyB.node;
    
    if([node.name isEqualToString:@"range"]) {
        [(Character *)node.parent targetInRange:contact.bodyA.node];
    }
    
    if ([node isKindOfClass:[Character class]]) {
        [(Character *)node collidedWith:contact.bodyA];
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