//
//  PathNavigationViewController.m
//  VailProject
//
//  Created by Jeongjin on 5/3/11.
//  Copyright 2011 Stanford. All rights reserved.
//

#import "PathNavigationViewController.h"
#import "InterfaceVariableManager.h"
#import "SelectPathViewController.h"
#import <AVFoundation/AVAudioPlayer.h>
#import "AlertCollisionViewController.h"
#import "DestinationSuggestionViewController.h"

#define MIN_INDICATING_DISTANCE_TURN 250
#define MIN_INDICATING_DISTANCE_STRAIGHT 1000

@implementation PathNavigationViewController
@synthesize micView=_micView;
@synthesize rightView=_rightView;
@synthesize leftView=_leftView;
@synthesize straightView=_straightView;
@synthesize player=_player;
@synthesize pathValue=_pathValue; 
@synthesize distanceLabel=_distanceLabel;
@synthesize pathLabel=_pathLabel;
@synthesize refreshTimer=_refreshTimer;
@synthesize directionLabel=_directionLabel;

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
    [_player release]; 
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
    
    // Hide Back
    [self.navigationItem setHidesBackButton:YES animated:YES];
    // Do any additional setup after loading the view from its nib.    

    prospectedEvent = [[NSMutableDictionary alloc] initWithCapacity:100];    
    
    if([[InterfaceVariableManager sharedManager] displayMode] == SCREEN_DISPLAY && [_pathValue isEqualToString:@"A"]){
        _pathLabel.text = @"PATH A Selected";
    }else if([[InterfaceVariableManager sharedManager] displayMode] == SCREEN_DISPLAY && [_pathValue isEqualToString:@"B"]){
        _pathLabel.text = @"PATH B Selected";
    }else if([[InterfaceVariableManager sharedManager] displayMode] == SCREEN_DISPLAY && [_pathValue isEqualToString:@"CAMPUS"]){
        _pathLabel.text = @"PATH to Campus";
    }else if([[InterfaceVariableManager sharedManager] displayMode] == SCREEN_DISPLAY && [_pathValue isEqualToString:@"CAFE"]){
        _pathLabel.text = @"PATH to Brunch Cafe";
    }else{
        _pathLabel.text = @"";
    }
    
        [prospectedEvent setObject:@"S" forKey:[NSNumber numberWithDouble:0]];
    
    if([[InterfaceVariableManager sharedManager] displayMode] == SCREEN_DISPLAY){
        [prospectedEvent setObject:@"D" forKey:[NSNumber numberWithDouble:500]];
    }else{
        [prospectedEvent setObject:@"D" forKey:[NSNumber numberWithDouble:200]];
    }
    
        [prospectedEvent setObject:@"S" forKey:[NSNumber numberWithDouble:1000]];
        [prospectedEvent setObject:@"L" forKey:[NSNumber numberWithDouble:2300]];
        [prospectedEvent setObject:@"S" forKey:[NSNumber numberWithDouble:3500]];
        [prospectedEvent setObject:@"R" forKey:[NSNumber numberWithDouble:4100]];
        [prospectedEvent setObject:@"S" forKey:[NSNumber numberWithDouble:5300]];
        [prospectedEvent setObject:@"CR" forKey:[NSNumber numberWithDouble:6000]];
        [prospectedEvent setObject:@"S" forKey:[NSNumber numberWithDouble:7000]];
        [prospectedEvent setObject:@"CL" forKey:[NSNumber numberWithDouble:8200]];
        [prospectedEvent setObject:@"S" forKey:[NSNumber numberWithDouble:9000]];
        [prospectedEvent setObject:@"L" forKey:[NSNumber numberWithDouble:9500]];
        [prospectedEvent setObject:@"S" forKey:[NSNumber numberWithDouble:10500]];
    if([[InterfaceVariableManager sharedManager] displayMode] == SCREEN_DISPLAY){
        [prospectedEvent setObject:@"I" forKey:[NSNumber numberWithDouble:11300]];
    }else{
        [prospectedEvent setObject:@"I" forKey:[NSNumber numberWithDouble:11000]];
    }
        [prospectedEvent setObject:@"S" forKey:[NSNumber numberWithDouble:11500]];
        [prospectedEvent setObject:@"CR" forKey:[NSNumber numberWithDouble:12300]];
        [prospectedEvent setObject:@"S" forKey:[NSNumber numberWithDouble:13300]];
        [prospectedEvent setObject:@"R" forKey:[NSNumber numberWithDouble:13800]];
        [prospectedEvent setObject:@"S" forKey:[NSNumber numberWithDouble:14500]];
        [prospectedEvent setObject:@"CL" forKey:[NSNumber numberWithDouble:15200]];
        [prospectedEvent setObject:@"S" forKey:[NSNumber numberWithDouble:16200]];
        [prospectedEvent setObject:@"CR" forKey:[NSNumber numberWithDouble:17200]];
        [prospectedEvent setObject:@"S" forKey:[NSNumber numberWithDouble:18000]];
        [prospectedEvent setObject:@"E" forKey:[NSNumber numberWithDouble:18400]];

      
    
    double currentDistance = [[InterfaceVariableManager sharedManager] distance];
    NSArray *keys = [[[prospectedEvent keyEnumerator] allObjects] sortedArrayUsingSelector:@selector(compare:)];
    for(NSNumber *eKey in keys){         
        double eventPoint = [eKey doubleValue];
        if(eventPoint < currentDistance){
            [prospectedEvent removeObjectForKey:eKey];
        }else{ 
            break;
        }
    }
    
    [self indicateStraight];
    lastIndicatedDistance = currentDistance;

    
    self.refreshTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(refreshEvent) userInfo:nil repeats:YES];

}

- (void)refreshEvent{
    
    NSString *lastEvent = nil; 
    double currentDistance = [[InterfaceVariableManager sharedManager] distance];
    _distanceLabel.text = [NSString stringWithFormat:@"%f", currentDistance];
    
    NSArray *keys = [[[prospectedEvent keyEnumerator] allObjects] sortedArrayUsingSelector:@selector(compare:)];
    //NSArray *reversedKeys = [[keys reverseObjectEnumerator] allObjects];

    for(NSNumber *eKey in keys){         
        double eventPoint = [eKey doubleValue];
        if(eventPoint < currentDistance){
            lastEvent = [prospectedEvent objectForKey:eKey];   
            [prospectedEvent removeObjectForKey:eKey];
        }else{
            break;
        }
    }
    
    if([lastEvent isEqualToString:@"R"]){
        [self indicateRight];
        lastIndicatedDistance = currentDistance;
        lastIndicatedDirection = @"R";

    }else if([lastEvent isEqualToString:@"L"]){
        [self indicateLeft];
        lastIndicatedDistance = currentDistance;
        lastIndicatedDirection = @"L";

    }else if([lastEvent isEqualToString:@"S"]){
        [self indicateStraight];
        lastIndicatedDistance = currentDistance;
        lastIndicatedDirection = @"S";

    }else if([lastEvent isEqualToString:@"I"]){
        [_refreshTimer invalidate];
        lastIndicatedDirection = @"I";
        //[refreshTimer release];
        SelectPathViewController *nController =[[SelectPathViewController alloc] initWithNibName:@"SelectPathViewController" bundle:nil];
        [self.navigationController pushViewController:nController animated:YES];
        [nController release];
        
    }else if([lastEvent isEqualToString:@"D"]){
        [_refreshTimer invalidate];
        lastIndicatedDirection = @"D";
        //[refreshTimer release];
        DestinationSuggestionViewController *nController =[[DestinationSuggestionViewController alloc] initWithNibName:@"DestinationSuggestionViewController" bundle:nil];
        [self.navigationController pushViewController:nController animated:YES];
        [nController release];
        
    }else if([lastEvent isEqualToString:@"CR"]){
        [_refreshTimer invalidate];
        lastIndicatedDirection = @"CR";

        //[refreshTimer release];
        AlertCollisionViewController *nController =[[AlertCollisionViewController alloc] initWithNibName:@"AlertCollisionViewController" bundle:nil];
        nController.isRight = YES;
        nController.currentLane = [[InterfaceVariableManager sharedManager] lane];
        [self.navigationController pushViewController:nController animated:YES];
        [nController release];
    }else if([lastEvent isEqualToString:@"CL"]){
        [_refreshTimer invalidate];
        lastIndicatedDirection = @"CL";
        //[refreshTimer release];
        AlertCollisionViewController *nController =[[AlertCollisionViewController alloc] initWithNibName:@"AlertCollisionViewController" bundle:nil];
        nController.isRight = NO;
        nController.currentLane = [[InterfaceVariableManager sharedManager] lane];
        [self.navigationController pushViewController:nController animated:YES];
        [nController release];
    }else if([lastEvent isEqualToString:@"E"]){
        [_refreshTimer invalidate];
        [self quitNavigation];
    }else if(lastEvent == nil){
        
        if([lastIndicatedDirection isEqualToString:@"S"] || [lastIndicatedDirection isEqualToString:@"I"] || [lastIndicatedDirection isEqualToString:@"CR"] || [lastIndicatedDirection isEqualToString:@"CL"] || [lastIndicatedDirection isEqualToString:@"D"]){
            if( currentDistance - lastIndicatedDistance > MIN_INDICATING_DISTANCE_STRAIGHT ){
                lastIndicatedDistance = currentDistance;
                [self indicateStraight]; 
            }
        }else{
            if( currentDistance - lastIndicatedDistance > MIN_INDICATING_DISTANCE_TURN ){
                lastIndicatedDistance = currentDistance;
                if([lastIndicatedDirection isEqualToString:@"R"]){
                    [self indicateRight];
                }else if([lastIndicatedDirection isEqualToString:@"L"]){
                    [self indicateLeft];
                }
            }
        }
        

    }
}

- (void)quitNavigation{
    [self.navigationController popToRootViewControllerAnimated:YES];
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

- (void)indicateStraight{

    if([[InterfaceVariableManager sharedManager] displayMode] == SCREEN_DISPLAY){
        _straightView.hidden = NO;
        _leftView.hidden = YES;
        _rightView.hidden = YES;
        _micView.hidden = YES;
        _directionLabel.text = @"Go Straight!";
    }else{
        _straightView.hidden = YES;
        _leftView.hidden = YES;
        _rightView.hidden = YES;
        _micView.hidden = NO;
        
        NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"gostraight" ofType:@"mp3"];
        self.player =[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:soundPath] error:nil];
        [_player release];
        [_player play];
    }
}

- (void)indicateRight{
    
    if([[InterfaceVariableManager sharedManager] displayMode] == SCREEN_DISPLAY){
        _straightView.hidden = YES;
        _leftView.hidden = YES;
        _rightView.hidden = NO;
        _micView.hidden = YES;
        _directionLabel.text = @"Turn Right at the next intersection";
    }else{
        _straightView.hidden = YES;
        _leftView.hidden = YES;
        _rightView.hidden = YES;
        _micView.hidden = NO;
        
        NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"turnright" ofType:@"mp3"];
        self.player =[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:soundPath] error:nil];
        [_player release];
        [_player play];
    }    
}

- (void)indicateLeft{
    if([[InterfaceVariableManager sharedManager] displayMode] == SCREEN_DISPLAY){
        _straightView.hidden = YES;
        _leftView.hidden = NO;
        _rightView.hidden = YES;
        _micView.hidden = YES;
        _directionLabel.text = @"Turn Left at the next intersection";
    }else{
        _straightView.hidden = YES;
        _leftView.hidden = YES;
        _rightView.hidden = YES;
        _micView.hidden = NO;
        
        NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"turnleft" ofType:@"mp3"];
        self.player =[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:soundPath] error:nil];
        [_player release];
        [_player play];
    }    
}


@end
