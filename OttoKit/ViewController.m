//
//  ViewController.m
//  OttoKit
//
//  Created by Ryan Campbell on 4/2/14.
//  Copyright (c) 2014 Ryan Campbell. All rights reserved.
//

#import "ViewController.h"
#import "MainMenu.h"
#import "Level.h"

@implementation ViewController

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];

    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    skView.showsPhysics = NO;
    
    // Create and configure the scene.
    SKScene * scene = [Level sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [skView presentScene:scene];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
