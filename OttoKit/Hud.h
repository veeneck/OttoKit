//
//  Hud.h
//  OttoKit
//
//  Created by Ryan Campbell on 4/8/14.
//  Copyright (c) 2014 Ryan Campbell. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Hud : SKSpriteNode {
    float gold;
    SKLabelNode *displayGold;
}

- (BOOL) canAfford:(float)cost;
- (void) addGold:(float)payment;
- (void) removeGold:(float)withdrawl;
- (id)initWithSprite:(NSString *)sprite;

@end
