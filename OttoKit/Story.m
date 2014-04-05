//
//  Story.m
//  OttoKit
//
//  Created by Ryan Campbell on 4/3/14.
//  Copyright (c) 2014 Ryan Campbell. All rights reserved.
//

#import "Story.h"
#import "Level.h"

@implementation Story

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.808 green:0.808 blue:0.808 alpha:1];
        prose = [SKNode node];
        [self addChild:prose];
        
        SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"DINCond-RegularAlternate"];
        
        myLabel.text = @"it's happening";
        myLabel.fontColor = [SKColor colorWithRed:0.271 green:0.271 blue:0.271 alpha:1]; /*#454545*/
        myLabel.fontSize = 30;
        myLabel.zPosition = 2;
        myLabel.alpha = 0;
        myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                       CGRectGetMidY(self.frame));
        
        [prose addChild:myLabel];
        SKAction *sequence = [SKAction sequence:@[[SKAction fadeInWithDuration: 0.5]]];
        [myLabel runAction: sequence];
        
        NSString *burstPath =
        [[NSBundle mainBundle] pathForResource:@"Snow" ofType:@"sks"];
        
        SKEmitterNode *burstEmitter =
        [NSKeyedUnarchiver unarchiveObjectWithFile:burstPath];
        
        burstEmitter.position = CGPointMake(CGRectGetMidX(self.frame),
                                            CGRectGetMidY(self.frame));

        
        [self addChild:burstEmitter];
        [self performSelector:@selector(switchScene) withObject:nil afterDelay:7];

        
    }
    return self;
}

-(void) switchScene {
    SKTransition *reveal = [SKTransition fadeWithDuration:3];
    
    SKScene *scene = [Level sceneWithSize:self.view.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    [self.view presentScene:scene transition:reveal];
}

@end
