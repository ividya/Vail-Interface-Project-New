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


#define MIN_INDICATING_DISTANCE_TURN 250
#define MIN_INDICATING_DISTANCE_STRAIGHT 500


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
    }else{
        _pathLabel.text = @"";
    }
    
    if([_pathValue isEqualToString:@"A"]){
        [prospectedEvent setObject:@"S" forKey:[NSNumber numberWithDouble:0]];
        [prospectedEvent setObject:@"R" forKey:[NSNumber numberWithDouble:1000]];
        [prospectedEvent setObject:@"S" forKey:[NSNumber numberWithDouble:1485]];
        [prospectedEvent setObject:@"L" forKey:[NSNumber numberWithDouble:2000]];
        [prospectedEvent setObject:@"S" forKey:[NSNumber numberWithDouble:2735]];
        [prospectedEvent setObject:@"R" forKey:[NSNumber numberWithDouble:3500]];        
        [prospectedEvent setObject:@"S" forKey:[NSNumber numberWithDouble:4485]];
        [prospectedEvent setObject:@"I" forKey:[NSNumber numberWithDouble:6500]];
        [prospectedEvent setObject:@"S" forKey:[NSNumber numberWithDouble:7000]];
        [prospectedEvent setObject:@"R" forKey:[NSNumber numberWithDouble:8750]];        
        [prospectedEvent setObject:@"S" forKey:[NSNumber numberWithDouble:9750]];
        [prospectedEvent setObject:@"L" forKey:[NSNumber numberWithDouble:11750]];        
        [prospectedEvent setObject:@"S" forKey:[NSNumber numberWithDouble:12735]];
        [prospectedEvent setObject:@"L" forKey:[NSNumber numberWithDouble:13335]];        
        [prospectedEvent setObject:@"S" forKey:[NSNumber numberWithDouble:14335]];
        [prospectedEvent setObject:@"R" forKey:[NSNumber numberWithDouble:16750]];        
        [prospectedEvent setObject:@"S" forKey:[NSNumber numberWithDouble:17750]];
        [prospectedEvent setObject:@"R" forKey:[NSNumber numberWithDouble:19750]];        
        [prospectedEvent setObject:@"S" forKey:[NSNumber numberWithDouble:20750]];
        [prospectedEvent setObject:@"L" forKey:[NSNumber numberWithDouble:21750]];
        [prospectedEvent setObject:@"E" forKey:[NSNumber numberWithDouble:22700]];
    }else{
        [prospectedEvent setObject:@"S" forKey:[NSNumber numberWithDouble:0]];
        [prospectedEvent setObject:@"R" forKey:[NSNumber numberWithDouble:1000]];
        [prospectedEvent setObject:@"S" forKey:[NSNumber numberWithDouble:1485]];
        [prospectedEvent setObject:@"L" forKey:[NSNumber numberWithDouble:2000]];
        [prospectedEvent setObject:@"S" forKey:[NSNumber numberWithDouble:2735]];
        [prospectedEvent setObject:@"R" forKey:[NSNumber numberWithDouble:3500]];        
        [prospectedEvent setObject:@"S" forKey:[NSNumber numberWithDouble:4485]];
        [prospectedEvent setObject:@"I" forKey:[NSNumber numberWithDouble:6500]];
        [prospectedEvent setObject:@"S" forKey:[NSNumber numberWithDouble:7000]];
        [prospectedEvent setObject:@"R" forKey:[NSNumber numberWithDouble:8750]];        
        [prospectedEvent setObject:@"S" forKey:[NSNumber numberWithDouble:9750]];
        [prospectedEvent setObject:@"L" forKey:[NSNumber numberWithDouble:11750]];        
        [prospectedEvent setObject:@"S" forKey:[NSNumber numberWithDouble:12735]];
        [prospectedEvent setObject:@"L" forKey:[NSNumber numberWithDouble:13335]];        
        [prospectedEvent setObject:@"S" forKey:[NSNumber numberWithDouble:14335]];
        [prospectedEvent setObject:@"R" forKey:[NSNumber numberWithDouble:16750]];        
        [prospectedEvent setObject:@"S" forKey:[NSNumber numberWithDouble:17750]];
        [prospectedEvent setObject:@"R" forKey:[NSNumber numberWithDouble:19750]];        
        [prospectedEvent setObject:@"S" forKey:[NSNumber numberWithDouble:20750]];
        [prospectedEvent setObject:@"L" forKey:[NSNumber numberWithDouble:21750]];
        [prospectedEvent setObject:@"E" forKey:[NSNumber numberWithDouble:22700]];

    }
    
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
        //[refreshTimer release];
        SelectPathViewController *nController =[[SelectPathViewController alloc] initWithNibName:@"SelectPathViewController" bundle:nil];
        [self.navigationController pushViewController:nController animated:YES];
        [nController release];
    }else if([lastEvent isEqualToString:@"E"]){
        [_refreshTimer invalidate];
        [self quitNavigation];
    }else if(lastEvent == nil){
        
        if([lastIndicatedDirection isEqualToString:@"S"] || [lastIndicatedDirection isEqualToString:@"I"]){
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
