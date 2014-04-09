//
//  Effects.m
//  OttoKit
//
//  Created by Ryan Campbell on 4/9/14.
//  Copyright (c) 2014 Ryan Campbell. All rights reserved.
//

#import "Effects.h"

@implementation Effects

+ (void)shakeNode:(SKNode*)node {
    CGPoint initialPoint = node.position;
    NSInteger amplitudeX = 4;
    NSInteger amplitudeY = 4;
    NSMutableArray * randomActions = [NSMutableArray array];
    for (int i=0; i<5; i++) {
        NSInteger randX = node.position.x+arc4random() % amplitudeX - amplitudeX/2;
        NSInteger randY = node.position.y+arc4random() % amplitudeY - amplitudeY/2;
        SKAction *action = [SKAction moveTo:CGPointMake(randX, randY) duration:0.01];
        [randomActions addObject:action];
    }
    
    SKAction *rep = [SKAction sequence:randomActions];
    [node runAction:rep completion:^{
        node.position = initialPoint;
    }];
}

@end
