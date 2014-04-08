//
//  Level.m
//  OttoKit
//
//  Created by Ryan Campbell on 4/3/14.
//  Copyright (c) 2014 Ryan Campbell. All rights reserved.
//

#import "Level.h"
#import "Enemy.h"
#import "Archer.h"
#import "Ranged.h"
#import "Melee.h"
#import "Hud.h"

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
        
        HUD = [[Hud alloc ]initWithSprite:@"labelBox"];
        [world addChild:HUD];
        
        //Load config settings and world data
        NSDictionary* levelDict = [self loadCurrentLevel];
        paths = [self loadPathData:levelDict];
        currentWave = 0;
        waves = [self loadWaveData:levelDict];
        
        [self createTowerPoints:CGPointMake(500, 500) facing:1];
        [self createTowerPoints:CGPointMake(400, 400) facing:2];
        
        [self createSoldierPoints:CGPointMake(200, 500) facing:1];
        
        [self runWaves];
        
    }
    return self;
}

/* --- HANDLE WAVES --- */

-(void) runWaves {
    NSDictionary* wave = [NSDictionary dictionaryWithDictionary:[waves objectAtIndex:currentWave]];
    int waitTime = [[wave objectForKey:@"WaitTime"]intValue];
    [self performSelector:@selector(spawnCreeps:) withObject:wave afterDelay:waitTime];
}

-(void) spawnCreeps:(NSDictionary*)wave {
    //NSString* enemyType = [wave objectForKey:@"Enemy"];
    int spawnCount = [[wave objectForKey:@"Amount"]intValue];
    int distance = [[wave objectForKey:@"Distance"]intValue];
    
    for(int i = 0; i < spawnCount; i++) {
        CGPoint coords;
        if (i % 2) {
            coords = CGPointMake(1000+((i-1)*distance), 550);
        }
        else {
            coords = CGPointMake(1000+(i*distance), 500);
        }
        Enemy* character = [[Enemy alloc] initAtPosition:coords];
        if (i % 2) {
            character.walkingOffset = 30;
        }
        else {
            
        }
        
        [world addChild:character];
        [character moveAlongPaths:paths];
    }
    
    currentWave = currentWave + 1;
    if(currentWave < [waves count]) {
        [self runWaves];
    }
}

/* --- CREATE SPAWN POINTS ---  */

-(void) createTowerPoints:(CGPoint)coords facing:(int)direction {
    Ranged* tower = [[Ranged alloc] initAtPosition:coords facing:direction];
    [world addChild:tower];
}

-(void) createSoldierPoints:(CGPoint)coords facing:(int)direction {
    Melee* tower = [[Melee alloc] initAtPosition:coords facing:direction];
    [world addChild:tower];
}

-(void) addTower:(SKNode*)territory {
    Tower *tower;
    if([territory.name isEqualToString:@"Ranged"]) {
        tower = (Ranged*) territory;
    }
    else {
        tower = (Melee*) territory;
    }
    if([HUD canAfford:tower.cost]) {
        [tower addSoldier:world];
        [HUD removeGold:tower.cost];
    }
}

/* --- PHYSICS ---  */

/* Physics and collision detection */
-(void) didBeginContact:(SKPhysicsContact *)contact {
        
    // Either bodyA or bodyB in the collision could be a character.
    SKNode *node = contact.bodyA.node;
    if([node.name isEqualToString:@"range"]) {
        [(Character *)node.parent targetInRange:contact.bodyB.node];
    }
    
    if ([node isKindOfClass:[Character class]]) {
        [(Character *)node collidedWith:contact.bodyB];
        if([(Character *)node isDying]) {
            [HUD addGold:25];
        }
    }
    
    // Check bodyB too.
    node = contact.bodyB.node;
    
    if([node.name isEqualToString:@"range"]) {
        [(Character *)node.parent targetInRange:contact.bodyA.node];
    }
    
    if ([node isKindOfClass:[Character class]]) {
        [(Character *)node collidedWith:contact.bodyA];
        if([(Character *)node isDying]) {
            [HUD addGold:25];
        }
    }
    
}

/* --- PLAYER INPUT ---  */

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    //if fire button touched, bring the rain
    if ([node.name isEqualToString:@"Ranged"] || [node.name isEqualToString:@"Melee"]) {
        [self addTower:node];
    }
}

/* --- LOAD INITIAL DATA ---  */

/* Read in Levels.plist and get the current level */
-(NSDictionary*)loadCurrentLevel {
    NSString* path = [[ NSBundle mainBundle] bundlePath];
    NSString* finalPath = [ path stringByAppendingPathComponent:@"Levels.plist"];
    NSDictionary *plistData = [NSDictionary dictionaryWithContentsOfFile:finalPath];
    
    NSMutableArray* levelArray = [NSMutableArray arrayWithArray:[plistData objectForKey:@"Levels"]];
    NSDictionary* levelDict = [NSDictionary dictionaryWithDictionary:[levelArray objectAtIndex:0]];
    return levelDict;
}

/* Get the paths from the current level */
-(NSMutableArray*) loadPathData:(NSDictionary*)levelDict {
    NSMutableArray *allPaths = [levelDict objectForKey:@"Paths"];
    return [allPaths objectAtIndex:0];
}

/* Get the waves from the current level */
-(NSMutableArray*) loadWaveData:(NSDictionary*)levelDict {
    NSMutableArray *wavesData = [levelDict objectForKey:@"Waves"];
    return wavesData;
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