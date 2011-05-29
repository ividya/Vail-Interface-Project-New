//
//  AlertCollisionViewController.m
//  VailProject
//
//  Created by Jeongjin on 5/23/11.
//  Copyright 2011 Stanford. All rights reserved.
//

#import "AlertCollisionViewController.h"
#import "InterfaceVariableManager.h"
#import "PathNavigationViewController.h"


@implementation AlertCollisionViewController
@synthesize rightScreenView = _rightScreenView;
@synthesize leftScreenView = _leftScreenView;
@synthesize voiceView = _voiceView;
@synthesize exitView = _exitView;
@synthesize isRight = _isRight;
@synthesize currentLane = _currentLane;
@synthesize rLabel = _rLabel;
@synthesize lLabel = _lLabel;

#define STAYING_DISTANCE 1000

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
    // Do any additional setup after loading the view from its nib.
    if([[InterfaceVariableManager sharedManager] displayMode] == VOICE_DISPLAY && [[InterfaceVariableManager sharedManager] feedbackMode] == VOICE_FEEDBACK ){
        self.view.hidden = YES;
    }
    
    startDistance = [[InterfaceVariableManager sharedManager] distance];
    
    _exitView.hidden = YES;
    if([[InterfaceVariableManager sharedManager] displayMode] == SCREEN_DISPLAY){
        _voiceView.hidden = YES;
        if(_isRight){
            _rightScreenView.hidden = NO;
            _leftScreenView.hidden = YES;
        }else{
            _rightScreenView.hidden = YES;
            _leftScreenView.hidden = NO;            
        }
        
        [[InterfaceVariableManager sharedManager] saveEvent:NAVIGATION_MODE event: [NSString stringWithFormat:@"COLLISION_ASKED_%f",startDistance] result:@"SUCCESS" time:[NSDate date]];
    }else{
        _voiceView.hidden = NO;
        _rightScreenView.hidden = YES;
        _leftScreenView.hidden = YES;
        NSString *soundPath;
        if(_isRight){
            // play voice alert for right
            soundPath = [[NSBundle mainBundle] pathForResource:@"rcollision" ofType:@"mp3"];
        }else{
            // play voice alert for left
            soundPath = [[NSBundle mainBundle] pathForResource:@"lcollision" ofType:@"mp3"];
        }
        alertPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:soundPath] error:nil];
        alertPlayer.delegate = self;
        [alertPlayer play];

    }
    
    //run timer for exit
    if([[InterfaceVariableManager sharedManager] displayMode] == SCREEN_DISPLAY){

    refreshTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(refreshEvent) userInfo:nil repeats:YES];
        
    }

}

- (void)refreshEvent{
    
    int lane = [[InterfaceVariableManager sharedManager] lane];

    if( (_isRight && lane == 3) || (!_isRight && lane == 1)){
        
        if([[InterfaceVariableManager sharedManager] displayMode] == SCREEN_DISPLAY){

        _rLabel.text = @"Stay in this lane!";
        _lLabel.text = @"Stay in this lane!";
        
        }else{
            if(!isSafe){
                NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"stay" ofType:@"mp3"];
                tempPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:soundPath] error:nil];
                [tempPlayer play];
            }

        }
            
        if(!isRecorded){
            [[InterfaceVariableManager sharedManager] saveEvent:NAVIGATION_MODE event: [NSString stringWithFormat:@"COLLISION_MOVED_%f",startDistance] result:[NSString stringWithFormat:@"%d,%d",_currentLane,lane] time:[NSDate date]];
            isRecorded = YES;
        }
        
        isSafe =YES;
        
    }else{
        
        
        if([[InterfaceVariableManager sharedManager] displayMode] == SCREEN_DISPLAY){

            if(_isRight){
                _rLabel.text = @"Move to the Right-most lane!";
            }else{
                _lLabel.text = @"Move to the Left-most lane!";
            }
        }else{
            
            if(isSafe){
                if(_isRight){
                    NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"mright" ofType:@"mp3"];
                    tempPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:soundPath] error:nil];
                    [tempPlayer play];
                }else{
                    NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"mleft" ofType:@"mp3"];
                    tempPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:soundPath] error:nil];
                    [tempPlayer play];
                }
            }
        }
        
        isSafe =NO;
    }
    
    if( [[InterfaceVariableManager sharedManager] distance] - startDistance >= STAYING_DISTANCE ){
    
        [refreshTimer invalidate];
        
        if([[InterfaceVariableManager sharedManager] displayMode] == SCREEN_DISPLAY){
            _exitView.hidden = NO;
            _rightScreenView.hidden = YES;
            _leftScreenView.hidden = YES;
            [self performSelector:@selector(exitCollisionView) withObject:nil afterDelay:0.5];            
        }else{
            NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"ecollision" ofType:@"mp3"];
            exitPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:soundPath] error:nil];
            exitPlayer.delegate = self;
            [exitPlayer play];
        }
    
    }
    
    
    
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag 
{
    if (player == exitPlayer){
        [self exitCollisionView];
    }
    
    if (player == alertPlayer){
        [[InterfaceVariableManager sharedManager] saveEvent:NAVIGATION_MODE event: [NSString stringWithFormat:@"COLLISION_ASKED_%f",startDistance] result:@"SUCCESS" time:[NSDate date]];
        
         refreshTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(refreshEvent) userInfo:nil repeats:YES];
    }
}

- (void)exitCollisionView{
    PathNavigationViewController *nController =[[PathNavigationViewController alloc] initWithNibName:@"PathNavigationViewController" bundle:nil];
    [self.navigationController pushViewController:nController animated:YES];
    [nController release];
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

@end
