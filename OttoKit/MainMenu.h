//
//  MainMenu.h
//  OttoKit
//
//  Created by Ryan Campbell on 4/2/14.
//  Copyright (c) 2014 Ryan Campbell. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
@import AVFoundation;

@interface MainMenu : SKScene {
    
    SKNode* menu;
    AVAudioPlayer* backgroundMusicPlayer;
    SKVideoNode *introVideo;
    
}

@end
