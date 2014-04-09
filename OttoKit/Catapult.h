//
//  Catapult.h
//  OttoKit
//
//  Created by Ryan Campbell on 4/9/14.
//  Copyright (c) 2014 Ryan Campbell. All rights reserved.
//

#import "Tower.h"
#import "Effects.h"

@interface Catapult : Tower {
    SKShapeNode* range;
}

- (id)initAtPosition:(CGPoint)position;
-(void)setWorldLayer:(SKNode*)worldlayer;

@property (nonatomic) SKTexture* sharedProjectile;

@end
