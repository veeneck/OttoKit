//
//  Level.h
//  OttoKit
//
//  Created by Ryan Campbell on 4/3/14.
//  Copyright (c) 2014 Ryan Campbell. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
@import AVFoundation;


@interface Level : SKScene <SKPhysicsContactDelegate> {
    
    SKNode* world;
    AVAudioPlayer* backgroundMusicPlayer;

    
}

@end
