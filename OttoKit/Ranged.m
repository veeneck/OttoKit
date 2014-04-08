//
//  Ranged.m
//  OttoKit
//
//  Created by Ryan Campbell on 4/8/14.
//  Copyright (c) 2014 Ryan Campbell. All rights reserved.
//

#import "Ranged.h"
#import "Archer.h"

@implementation Ranged

- (id)initAtPosition:(CGPoint)position facing:(float)towards {
    
    NSString* asset = @"archer_tower_front";
    if(towards == 2) {
        asset = @"archer_tower_rear";
    }
    
    if(self = [super initWithSprite:asset]) {
        self.position = position;
        self.zPosition = 110;
        self.name = @"Ranged";
        self.direction = towards;
        self.cost = 100;
    }
    
    return self;
}

-(void)addSoldier:(SKNode*) layer {
    CGPoint offsetPos;
    if(self.direction == 1) {
        offsetPos.x = self.position.x - 80;
        offsetPos.y = self.position.y - 15;
    }
    if(self.direction == 2) {
        offsetPos.x = self.position.x + 70;
        offsetPos.y = self.position.y - 50;
    }
    Archer* character = [[Archer alloc] initAtPosition:offsetPos];
    character.zPosition = 100;
    [layer addChild:character];
}

@end
