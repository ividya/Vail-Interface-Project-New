//
//  AdminEmailViewController.m
//  VailProject
//
//  Created by Michael Chun on 5/5/11.
//  Copyright 2011 Stanford. All rights reserved.
//

#import "AdminEmailViewController.h"
#import "InterfaceVariableManager.h"
#import "VailUtility.h"

@implementation AdminEmailViewController

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

- (NSString *) urlCommandString:(NSString *)selectorString
{
    NSString *ipaddress = [[InterfaceVariableManager sharedManager] clientIP];
    NSString *port = [[InterfaceVariableManager sharedManager] clientPort];
    NSString *subtest = [NSString stringWithFormat:@"%d",EMAIL_MODE];
    NSString *event = @"email";
    NSString *time = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
    
    NSString *url = [NSString stringWithFormat:@"http://%@:%@/admin?subtest=%@&event=%@&result=%@&time=%@",ipaddress,port,subtest,event,selectorString,time];
    return url;
}

- (IBAction)repeatEmail:(id)sender {    
    [VailUtility sendHTTP:[self urlCommandString:@"repeatAction"]];
}

- (IBAction)firstEmail:(id)sender {    
    [VailUtility sendHTTP:[self urlCommandString:@"firstEmail"]];
}

- (IBAction)secondEmail:(id)sender {
    [VailUtility sendHTTP:[self urlCommandString:@"secondEmail"]];    
}

- (IBAction)closeEmail:(id)sender {
    [VailUtility sendHTTP:[self urlCommandString:@"closeEmail"]];
}

- (IBAction)replyEmail:(id)sender {
    [VailUtility sendHTTP:[self urlCommandString:@"replyEmail"]];
}

- (IBAction)addCalendar:(id)sender {
    [VailUtility sendHTTP:[self urlCommandString:@"addCalendar"]];
}

- (IBAction)deleteEmail:(id)sender {
    [VailUtility sendHTTP:[self urlCommandString:@"deleteEmail"]];
}

- (IBAction)receiveNewEmail:(id)sender {
    [VailUtility sendHTTP:[self urlCommandString:@"addNewEmails"]];
}

- (IBAction)helpMenu:(id)sender
{
    [VailUtility sendHTTP:[self urlCommandString:@"commandList"]];    
}

- (IBAction)yes:(id)sender
{
    [VailUtility sendHTTP:[self urlCommandString:@"yes"]];
}

- (IBAction)no:(id)sender
{
    [VailUtility sendHTTP:[self urlCommandString:@"no"]];   
}

@end
