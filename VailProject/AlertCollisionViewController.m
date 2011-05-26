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

#define STAYING_DISTANCE 500

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
        [alertPlayer play];

    }
    
    //run timer for exit
    refreshTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(refreshEvent) userInfo:nil repeats:YES];

}

- (void)refreshEvent{
    
    int lane = [[InterfaceVariableManager sharedManager] lane];

    if( (_isRight && lane == 3) || (!_isRight && lane == 1)){
        _rLabel.text = @"Stay in this lane!";
        _lLabel.text = @"Stay in this lane!";
    }else{
        if(_isRight){
            _rLabel.text = @"Move to the Right-most lane and stay there!";
        }else{
            _lLabel.text = @"Move to the Left-most lane and stay there!";
        }
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
