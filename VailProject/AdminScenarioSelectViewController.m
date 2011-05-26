//
//  AdminScenarioSelectViewController.m
//  VailProject
//
//  Created by Michael Chun on 5/23/11.
//  Copyright 2011 Stanford. All rights reserved.
//

#import "AdminScenarioSelectViewController.h"
#import "InterfaceVariableManager.h"
#import "VailUtility.h"
#import "AdminNavigationViewController.h"
#import "AdminEmailViewController.h"

@implementation AdminScenarioSelectViewController

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

- (NSString *) urlCommandScenario:(NSString *)scenario
{
    NSString *ipaddress = [[InterfaceVariableManager sharedManager] clientIP];
    NSString *port = [[InterfaceVariableManager sharedManager] clientPort];
    NSString *subtest = [NSString stringWithFormat:@"%d",SCENARIO_MODE];;
    
    NSString *url = [NSString stringWithFormat:@"http://%@:%@/admin?subtest=%@&scenario=%@",ipaddress,port,subtest,scenario];
    return url;
}


- (IBAction)tutorialAction:(id)sender {
    [VailUtility sendHTTP:[self urlCommandScenario:@"tutorialButtonPushed"]];
    
    
    AdminEmailViewController *adminEmailVC = [[AdminEmailViewController alloc] initWithNibName:@"AdminEmailViewController" bundle:nil];
    [self.navigationController pushViewController:adminEmailVC animated:YES];
    [adminEmailVC release];


}

- (IBAction)emailAction:(id)sender {
    [VailUtility sendHTTP:[self urlCommandScenario:@"emailButtonPushed"]];
    
    
    AdminEmailViewController *adminEmailVC = [[AdminEmailViewController alloc] initWithNibName:@"AdminEmailViewController" bundle:nil];
    [self.navigationController pushViewController:adminEmailVC animated:YES];
    [adminEmailVC release];


}

- (IBAction)navigationAction:(id)sender {
    [VailUtility sendHTTP:[self urlCommandScenario:@"goNavigation"]];
    
    AdminNavigationViewController *nController =[[AdminNavigationViewController alloc] initWithNibName:@"AdminNavigationViewController" bundle:nil]; 
    [self.navigationController pushViewController:nController animated:YES];
    [nController release]; 
    
}

@end
