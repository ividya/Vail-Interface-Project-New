//
//  AdminNavigationViewController.m
//  VailProject
//
//  Created by Jeongjin on 5/4/11.
//  Copyright 2011 Stanford. All rights reserved.
//

#import "AdminNavigationViewController.h"
#import "VailUtility.h"
#import "InterfaceVariableManager.h"

@implementation AdminNavigationViewController

@synthesize currentLabel = _currentLabel;
@synthesize weightField = _weightField;

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

- (IBAction)selectAPath{
    
    NSString *ipaddress = [[InterfaceVariableManager sharedManager] clientIP];
    NSString *port = [[InterfaceVariableManager sharedManager] clientPort];
    NSString *subtest = [NSString stringWithFormat:@"%d",NAVIGATION_MODE];
    NSString *event = @"PATH";
    NSString *result = @"A";
    NSString *time = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
    
    NSString *url = [NSString stringWithFormat:@"http://%@:%@/admin?subtest=%@&event=%@&result=%@&time=%@",ipaddress,port,subtest,event,result,time];
    
    if(![VailUtility sendHTTP:url]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                        message:@"Command Failed"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:nil]; 
        [alert show];
        [alert release];
    }
    
}

- (IBAction)selectBPath{
    NSString *ipaddress = [[InterfaceVariableManager sharedManager] clientIP];
    NSString *port = [[InterfaceVariableManager sharedManager] clientPort];
    NSString *subtest = [NSString stringWithFormat:@"%d",NAVIGATION_MODE];
    NSString *event = @"PATH";
    NSString *result = @"B";
    NSString *time = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
    
    NSString *url = [NSString stringWithFormat:@"http://%@:%@/admin?subtest=%@&event=%@&result=%@&time=%@",ipaddress,port,subtest,event,result,time];
    if(![VailUtility sendHTTP:url]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                        message:@"Command Failed"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:nil]; 
        [alert show];
        [alert release];
    }
}

- (IBAction)selectCafePath{
    NSString *ipaddress = [[InterfaceVariableManager sharedManager] clientIP];
    NSString *port = [[InterfaceVariableManager sharedManager] clientPort];
    NSString *subtest = [NSString stringWithFormat:@"%d",NAVIGATION_MODE];
    NSString *event = @"DESTINATION";
    NSString *result = @"CAFE";
    NSString *time = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
    
    NSString *url = [NSString stringWithFormat:@"http://%@:%@/admin?subtest=%@&event=%@&result=%@&time=%@",ipaddress,port,subtest,event,result,time];
    if(![VailUtility sendHTTP:url]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                        message:@"Command Failed"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:nil]; 
        [alert show];
        [alert release]; 
    }
}

- (IBAction)selectCampusPath{
    NSString *ipaddress = [[InterfaceVariableManager sharedManager] clientIP];
    NSString *port = [[InterfaceVariableManager sharedManager] clientPort];
    NSString *subtest = [NSString stringWithFormat:@"%d",NAVIGATION_MODE];
    NSString *event = @"DESTINATION";
    NSString *result = @"CAMPUS";
    NSString *time = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
    
    NSString *url = [NSString stringWithFormat:@"http://%@:%@/admin?subtest=%@&event=%@&result=%@&time=%@",ipaddress,port,subtest,event,result,time];
    if(![VailUtility sendHTTP:url]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                        message:@"Command Failed"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:nil]; 
        [alert show];
        [alert release];
    }
}

- (IBAction)increaseDistance{
    NSString *ipaddress = [[InterfaceVariableManager sharedManager] clientIP];
    NSString *port = [[InterfaceVariableManager sharedManager] clientPort];
    
    NSString *increment = _weightField.text;
    NSString *current = _currentLabel.text;
    
    NSString *newcurrent = [NSString stringWithFormat:@"%d",([current intValue] + [increment intValue])];
    
    NSString *url = [NSString stringWithFormat:@"http://%@:%@/simulator?distance=%@",ipaddress,port,newcurrent];
    if(![VailUtility sendHTTP:url]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                        message:@"Command Failed"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:nil]; 
        [alert show];
        [alert release];
    }else{
        
        _currentLabel.text = newcurrent;
    }
    
}

@end
