//
//  Melee.m
//  OttoKit
//
//  Created by Ryan Campbell on 4/8/14.
//  Copyright (c) 2014 Ryan Campbell. All rights reserved.
//

#import "Melee.h"
#import "Squire.h"

@implementation Melee

- (id)initAtPosition:(CGPoint)position facing:(float)towards {
    
    NSString* asset = @"melee_tower_front";
    if(towards == 2) {
        asset = @"melee_tower_front";
    }
    
    if(self = [super initWithSprite:asset]) {
        self.position = position;
        self.zPosition = 110;
        self.name = @"Melee";
        self.direction = towards;
        self.cost = 100;
    }
    
    return self;
}

-(void)addSoldier:(SKNode*) layer {
    CGPoint offsetPos;
    if(self.direction == 1) {
        offsetPos.x = self.position.x + 75;
        offsetPos.y = self.position.y - 75;
    }
    if(self.direction == 2) {
        offsetPos.x = self.position.x + 70;
        offsetPos.y = self.position.y - 15;
    }
    Squire* character = [[Squire alloc] initAtPosition:offsetPos];
    character.zPosition = 100;
    character.xScale = -0.5;
    character.physicsBody = character.physicsBody;
    [layer addChild:character];
}

@end
