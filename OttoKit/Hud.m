//
//  Hud.m
//  OttoKit
//
//  Created by Ryan Campbell on 4/8/14.
//  Copyright (c) 2014 Ryan Campbell. All rights reserved.
//

#import "Hud.h"

@implementation Hud

-(id) initWithSprite:(NSString*)sprite {
    
    if(self = [super initWithImageNamed:sprite]) {
        gold = 100;
        self.position = CGPointMake(CGRectGetMaxX(self.frame) - 50,
                                    CGRectGetMaxY(self.frame));
        self.xScale = 0.5;
        self.yScale = 0.5;
        
        [self createDisplayLabels];
    }
    
    return self;
}

-(void) createDisplayLabels {
    displayGold = [SKLabelNode labelNodeWithFontNamed:@"DINCond-RegularAlternate"];
    
    displayGold.text = [NSString stringWithFormat:@"Gold: %i", (int)gold];
    displayGold.fontColor = [SKColor blackColor];
    displayGold.fontSize = 40;
    displayGold.zPosition = 10000;
    displayGold.alpha = 1;
    displayGold.position = CGPointMake(0,-15);
    
    [self addChild:displayGold];

}

- (BOOL) canAfford:(float)cost {
    if(gold >= cost) {
        return true;
    }
    else {
        return false;
    }
}

- (void) addGold:(float)payment {
    gold += payment;
    displayGold.text = [NSString stringWithFormat:@"Gold: %i", (int)gold];
}

-(void) removeGold:(float)withdrawl {
    gold -= withdrawl;
    displayGold.text = [NSString stringWithFormat:@"Gold: %i", (int)gold];
}

@end
