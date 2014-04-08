//
//  Tower.h
//  OttoKit
//
//  Created by Ryan Campbell on 4/8/14.
//  Copyright (c) 2014 Ryan Campbell. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Tower : SKSpriteNode {

}

- (id)initWithSprite:(NSString *)sprite;
- (void)addSoldier:(SKNode*)layer;

@property (nonatomic, getter=getCost) float cost;

@end
