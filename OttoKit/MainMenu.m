//
//  MainMenu.m
//  OttoKit
//
//  Created by Ryan Campbell on 4/2/14.
//  Copyright (c) 2014 Ryan Campbell. All rights reserved.
//

#import "MainMenu.h"
#import "Story.h"

@implementation MainMenu

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        menu = [SKNode node];
        [self addChild:menu];

        [self loadSound];
        [self loadVideo];
        [self performSelector:@selector(loadBackground) withObject:nil afterDelay:4];
        [self performSelector:@selector(loadLogo) withObject:nil afterDelay:5];
        [self performSelector:@selector(loadText) withObject:nil afterDelay:5];
    
    }
    return self;
}

/* --- VIDEO ---  */

- (void) loadVideo {
    introVideo = [SKVideoNode videoNodeWithVideoFileNamed:@"gameandcode_mockup_forryan.mov"];
    introVideo.position = CGPointMake(CGRectGetMidX(self.frame),
                                  CGRectGetMidY(self.frame));
    [self addChild: introVideo];
    [introVideo play];
    [self performSelector:@selector(destroyVideo) withObject:nil afterDelay:4];
}

-(void) destroyVideo {
    [introVideo removeFromParent];
}

/* --- SOUND ---  */

-(void) loadSound {
    NSError *error;
    NSURL * backgroundMusicURL = [[NSBundle mainBundle] URLForResource:@"otto_basetrack" withExtension:@"mp3"];
    backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:&error];
    backgroundMusicPlayer.numberOfLoops = -1;
    backgroundMusicPlayer.volume = 0;
    [backgroundMusicPlayer prepareToPlay];
    [backgroundMusicPlayer play];
    [self doVolumeFade];
}

-(void)doVolumeFade
{
    if (backgroundMusicPlayer.volume < 1) {
        backgroundMusicPlayer.volume = backgroundMusicPlayer.volume + 0.1;
        [self performSelector:@selector(doVolumeFade) withObject:nil afterDelay:0.5];
    }
}

/* --- ASSETS ---  */

-(void) loadBackground {
    SKSpriteNode* bg = [SKSpriteNode spriteNodeWithImageNamed:@"otto_interface_bg"];
    bg.position = CGPointMake(CGRectGetMidX(self.frame),
                              CGRectGetMidY(self.frame));
    bg.zPosition = 1;
    bg.alpha = 0;
    [menu addChild:bg];
    SKAction *sequence = [SKAction sequence:@[[SKAction fadeInWithDuration: 0.5]]];
    [bg runAction: sequence];
}

-(void) loadLogo {
    SKSpriteNode* logo = [SKSpriteNode spriteNodeWithImageNamed:@"otto_logo"];
    logo.position = CGPointMake(CGRectGetMidX(self.frame) - 100,
                              CGRectGetMidY(self.frame) + 50);
    logo.zPosition = 2;
    logo.alpha = 0;
    [menu addChild:logo];
    SKAction *sequence = [SKAction sequence:@[[SKAction fadeInWithDuration: 0.5]]];
    [logo runAction: sequence];
}

/* --- TEXT ---  */

-(void) loadText {
    SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"DINCond-RegularAlternate"];
    SKLabelNode *myLabelA = [SKLabelNode labelNodeWithFontNamed:@"DINCond-RegularAlternate"];
    SKLabelNode *myLabelB = [SKLabelNode labelNodeWithFontNamed:@"DINCond-RegularAlternate"];
    
    myLabel.text = @"play";
    myLabel.fontColor = [SKColor colorWithRed:0.271 green:0.271 blue:0.271 alpha:1]; /*#454545*/
    myLabel.fontSize = 30;
    myLabel.zPosition = 2;
    myLabel.name = @"playBtn";
    myLabel.alpha = 0;
    myLabel.position = CGPointMake(500, 430);
    
    [menu addChild:myLabel];
    [self performSelector:@selector(doImageFade:) withObject:myLabel afterDelay:0.5];
    
    myLabelA.text = @"options";
    myLabelA.fontColor = [SKColor colorWithRed:0.271 green:0.271 blue:0.271 alpha:1]; /*#454545*/
    myLabelA.fontSize = 30;
    myLabelA.zPosition = 2;
    myLabelA.alpha = 0;
    myLabelA.position = CGPointMake(514, 390);
    
    [menu addChild:myLabelA];
    [self performSelector:@selector(doImageFade:) withObject:myLabelA afterDelay:1];
    
    myLabelB.text = @"quit";
    myLabelB.fontColor = [SKColor colorWithRed:0.271 green:0.271 blue:0.271 alpha:1]; /*#454545*/
    myLabelB.fontSize = 30;
    myLabelB.zPosition = 2;
    myLabelB.alpha = 0;
    myLabelB.position = CGPointMake(499, 350);
    
    [menu addChild:myLabelB];
    [self performSelector:@selector(doImageFade:) withObject:myLabelB afterDelay:1.5];
}

-(void) doImageFade:(SKNode*) img {
    SKAction *sequence = [SKAction sequence:@[[SKAction fadeInWithDuration: 0.5]]];
    [img runAction: sequence];
}

-(void) switchScene {
    SKTransition *reveal = [SKTransition fadeWithDuration:3];
    
    SKScene *scene = [Story sceneWithSize:self.view.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    [self.view presentScene:scene transition:reveal];
}

/* --- SYSTEM CALLS ---  */

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    //if fire button touched, bring the rain
    if ([node.name isEqualToString:@"playBtn"]) {
        [backgroundMusicPlayer pause];
        [self runAction:[SKAction playSoundFileNamed:@"Otto_interface_snd_03.mp3" waitForCompletion:NO]];
        [node runAction:[SKAction fadeOutWithDuration: 0.3]];
        [node runAction:[SKAction moveToX:400 duration:0.3]];
        [self performSelector:@selector(switchScene) withObject:nil afterDelay:0.3];
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
