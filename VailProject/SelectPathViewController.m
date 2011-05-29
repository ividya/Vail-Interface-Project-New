//
//  SelectPathViewController.m
//  VailProject
//
//  Created by Jeongjin on 5/3/11.
//  Copyright 2011 Stanford. All rights reserved.
//

#import "SelectPathViewController.h"
#import "InterfaceVariableManager.h"
#import "PathNavigationViewController.h"
#import "InterfaceVariableManager.h"
#import "VailEvent.h"
#import <AVFoundation/AVAudioPlayer.h>


@implementation SelectPathViewController
@synthesize screenDisplayView=_screenDisplayView;
@synthesize screenFeedbackView=_screenFeedbackView;
@synthesize voiceDisplayView=_voiceDisplayView;
@synthesize voiceFeedbackView=_voiceFeedbackView;

@synthesize APathButton=_APathButton;
@synthesize BPathButton=_BPathButton;
@synthesize player=_player;
@synthesize pathPlayer=_pathPlayer;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if([[InterfaceVariableManager sharedManager] displayMode] == VOICE_DISPLAY && [[InterfaceVariableManager sharedManager] feedbackMode] == VOICE_FEEDBACK ){
        self.view.hidden = YES;
    }
    
    // Hide Back
    [self.navigationItem setHidesBackButton:YES animated:YES];
    
    [[InterfaceVariableManager sharedManager] registerController:PATH_SELECTION_ADMIN controller:self];
    
    // Do any additional setup after loading the view from its nib.
    if([[InterfaceVariableManager sharedManager] displayMode] == SCREEN_DISPLAY){
        _screenDisplayView.hidden = NO;
        _voiceDisplayView.hidden = YES;
        [[InterfaceVariableManager sharedManager] saveEvent:NAVIGATION_MODE event:@"PATH_ASK" result:@"SUCCESS" time:[NSDate date]];

    }else{
        _screenDisplayView.hidden = YES;
        _voiceDisplayView.hidden = NO;
        
        NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"pathq" ofType:@"mp3"];
        self.player =[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:soundPath] error:nil];
        [_player release];
        _player.delegate = self;
        [_player play];
        
    }
    
    if([[InterfaceVariableManager sharedManager] feedbackMode] == SCREEN_FEEDBACK){
        _screenFeedbackView.hidden = NO;
        _voiceFeedbackView.hidden = YES;
    }else{
        _screenFeedbackView.hidden = YES;
        _voiceFeedbackView.hidden = NO;
    } 
}

//- (void)receiveVoiceFeedback:(NSNotification*) aNotification
- (void)receiveVoiceFeedback:(id) params
{
    NSString *subtestParam = (NSString*)[params objectForKey:@"subtest"];
    NSString *eventParam = (NSString*)[params objectForKey:@"event"];
    NSString *resultParam = (NSString*)[params objectForKey:@"result"];
    NSString *timeParam = (NSString*)[params objectForKey:@"time"];
    if(timeParam==nil){ 
        timeParam = [NSString stringWithFormat:@"f",[[NSDate date] timeIntervalSince1970]];
    }
    
    [[InterfaceVariableManager sharedManager] saveEvent:[subtestParam integerValue] event:eventParam result:resultParam time:[NSDate dateWithTimeIntervalSince1970:[timeParam doubleValue]]];
        
    nController =[[PathNavigationViewController alloc] initWithNibName:@"PathNavigationViewController" bundle:nil];
    NSString *soundPath = nil;

    if([resultParam isEqualToString:@"A"]){
        nController.pathValue = @"A";
        soundPath = [[NSBundle mainBundle] pathForResource:@"aselected" ofType:@"mp3"];

    }else{
        nController.pathValue = @"B";
        soundPath = [[NSBundle mainBundle] pathForResource:@"bselected" ofType:@"mp3"];

    }
    
    if([[InterfaceVariableManager sharedManager] displayMode] == VOICE_DISPLAY){
        self.pathPlayer =[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:soundPath] error:nil];
        _pathPlayer.delegate = self;
        [_pathPlayer release];
        [_pathPlayer play];
    }else{
        [self.navigationController pushViewController:nController animated:YES];
        [nController release];        
    }
    
}
 
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (IBAction)selectPathButton:(id)sender{
    nController =[[PathNavigationViewController alloc] initWithNibName:@"PathNavigationViewController" bundle:nil];
    NSString *soundPath = nil;
    if([sender isEqual:_APathButton]){
        nController.pathValue = @"A";
        [[InterfaceVariableManager sharedManager] saveEvent:NAVIGATION_MODE event:@"PATH" result:@"A" time:[NSDate date]];
        soundPath = [[NSBundle mainBundle] pathForResource:@"aselected" ofType:@"mp3"];

    }else{
        nController.pathValue = @"B";
        [[InterfaceVariableManager sharedManager] saveEvent:NAVIGATION_MODE event:@"PATH" result:@"B" time:[NSDate date]];
        soundPath = [[NSBundle mainBundle] pathForResource:@"bselected" ofType:@"mp3"];
    }
    
    if([[InterfaceVariableManager sharedManager] displayMode] == VOICE_DISPLAY){
        self.pathPlayer =[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:soundPath] error:nil];
        _pathPlayer.delegate = self;
        [_pathPlayer release];
        [_pathPlayer play];
    }else{
        [self.navigationController pushViewController:nController animated:YES];
        [nController release];
    }
    
    
}
 
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag 
{
    if (player == _pathPlayer){
        [self.navigationController pushViewController:nController animated:YES];
        [nController release];
    }
    
    if(player == _player){
        [[InterfaceVariableManager sharedManager] saveEvent:NAVIGATION_MODE event:@"PATH_ASK" result:@"SUCCESS" time:[NSDate date]];
    }
}


@end
