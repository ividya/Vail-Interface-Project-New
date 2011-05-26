//
//  AdminModeSelectViewController.m
//  VailProject
//
//  Created by Jeongjin on 5/4/11.
//  Copyright 2011 Stanford. All rights reserved.
//

#import "AdminModeSelectViewController.h"
#import "InterfaceVariableManager.h"
#import "AdminNavigationViewController.h"
#import "AdminEmailViewController.h"
#import "VailUtility.h"
#import "ViewEffects.h"
#import "AdminScenarioSelectViewController.h"

@interface AdminModeSelectViewController ()
-(BOOL)checkSubjectId;
@end

@implementation AdminModeSelectViewController
@synthesize ipTextField=_ipTextField;
@synthesize portTextField=_portTextField;
@synthesize subjectIdField = _subjectIdField;

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
    [_voicescreenAction release];
    [_subjectIdField release];
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
    [self setSubjectIdField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (NSString *) urlCommandSubjectID:(NSString *)partId testType:(NSString *)testType
{
    NSString *ipaddress = [[InterfaceVariableManager sharedManager] clientIP];
    NSString *port = [[InterfaceVariableManager sharedManager] clientPort];
    NSString *subtest = [NSString stringWithFormat:@"%d",CONFIG_MODE];;
    
    NSString *url = [NSString stringWithFormat:@"http://%@:%@/admin?subtest=%@&subjectId=%@&testType=%@",ipaddress,port,subtest,partId,testType];
    return url;
}

- (IBAction)screenscreenAction:(id)sender {
    if ([self saveIP] == YES && [self checkSubjectId])
    {
        [VailUtility sendHTTP:[self urlCommandSubjectID:self.subjectIdField.text testType:@"1"]];
        
        AdminScenarioSelectViewController *adminVC = [[[AdminScenarioSelectViewController alloc] initWithNibName:@"AdminScenarioSelectViewController" bundle:nil] autorelease];
        
        [self.navigationController pushViewController:adminVC animated:YES];
    }    
}

- (IBAction)voicescreenAction:(id)sender {
    if ([self saveIP] == YES && [self checkSubjectId])
    {
        [VailUtility sendHTTP:[self urlCommandSubjectID:self.subjectIdField.text testType:@"2"]];
        
        AdminScenarioSelectViewController *adminVC = [[[AdminScenarioSelectViewController alloc] initWithNibName:@"AdminScenarioSelectViewController" bundle:nil] autorelease];
        
        [self.navigationController pushViewController:adminVC animated:YES];
    }    
}

- (IBAction)screenvoiceAction:(id)sender {
    if ([self saveIP] == YES && [self checkSubjectId])
    {
        [VailUtility sendHTTP:[self urlCommandSubjectID:self.subjectIdField.text testType:@"3"]];
        
        AdminScenarioSelectViewController *adminVC = [[[AdminScenarioSelectViewController alloc] initWithNibName:@"AdminScenarioSelectViewController" bundle:nil] autorelease];
        
        [self.navigationController pushViewController:adminVC animated:YES];
    }    

}

- (IBAction)voicevoiceAction:(id)sender {
    if ([self saveIP] == YES && [self checkSubjectId])
    {
        [VailUtility sendHTTP:[self urlCommandSubjectID:self.subjectIdField.text testType:@"4"]];
        
        AdminScenarioSelectViewController *adminVC = [[[AdminScenarioSelectViewController alloc] initWithNibName:@"AdminScenarioSelectViewController" bundle:nil] autorelease];
        
        [self.navigationController pushViewController:adminVC animated:YES];
    }    
}

- (BOOL)saveIP{
    
    if([_ipTextField.text isEqualToString:@""]){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                        message:@"Please insert ip/port address!"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:nil]; 
        [alert show];
        [alert release];
        return FALSE;
    }
    NSString *clientIP = _ipTextField.text;
    NSString *clientPort = _portTextField.text;
    
    [[InterfaceVariableManager sharedManager] setClientIP:clientIP];
    [[InterfaceVariableManager sharedManager] setClientPort:clientPort];

    return TRUE;
    
}

- (BOOL)checkSubjectId
{
    if (self.subjectIdField.text == nil || [@"" isEqualToString:self.subjectIdField.text])
    {
        [ViewEffects popupAlertViewWithMsg:@"Please enter subject id." targetViewController:self forDuration:2];
        return false;
    }
    
    return true;
}


@end