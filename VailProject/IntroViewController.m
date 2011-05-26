//
//  IntroViewController.m
//  VailProject
//
//  Created by Jeongjin on 5/2/11.
//  Copyright 2011 Stanford. All rights reserved.
//

#import "IntroViewController.h"
#import "TestMethodViewController.h"
#import "InterfaceVariableManager.h"
#import "AdminModeSelectViewController.h"

@implementation IntroViewController

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

- (IBAction)goStudent:(id)sender
{
    [[InterfaceVariableManager sharedManager] setTestMode:REAL_MODE];
    
    TestMethodViewController *nController =[[TestMethodViewController alloc] initWithNibName:@"TestMethodViewController" bundle:nil];
    [self.navigationController pushViewController:nController animated:YES];
    [nController release];
}

- (IBAction)goAdmin:(id)sender
{
    [[InterfaceVariableManager sharedManager] setTestMode:ADMIN_MODE];
    
    AdminModeSelectViewController *nController =[[AdminModeSelectViewController alloc] initWithNibName:@"AdminModeSelectViewController" bundle:nil];
    [self.navigationController pushViewController:nController animated:YES];
    [nController release]; 
}



@end
