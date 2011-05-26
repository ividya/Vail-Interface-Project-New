//
//  ViewEffects.m
//  VailProject
//
//  Created by Michael Chun on 5/20/11.
//  Copyright 2011 Stanford. All rights reserved.
//

#import "ViewEffects.h"


@implementation ViewEffects

static UIView *blinkView = nil;
static UIView *voiceOnlyView = nil;
static CustomAlertViewController *alertVC = nil;  
static NSNumber *yesNumber = nil;

+(void)initialize
{
    if (blinkView == nil)
    {
        blinkView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];    
        [blinkView setBackgroundColor:[UIColor blackColor]];
    }
    
    if (voiceOnlyView == nil)
    {
        // Add Voice only view
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"VoiceOnlyView" owner:self options:nil];
        id obj = [topLevelObjects objectAtIndex:0];
        voiceOnlyView = [obj retain];
    }
    
    if (alertVC == nil)
    {
        alertVC = [[CustomAlertViewController alloc] initWithNibName:@"CustomAlertViewController" bundle:nil];
    }
    
    if (yesNumber == nil)
    {
        yesNumber = [[NSNumber numberWithBool:YES] retain];
    }
}

+(void)blink:(UIView *)targetView
{
    blinkView.alpha = 0;
    [targetView addSubview:blinkView];
    blinkView.hidden = NO;
    
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionRepeat|UIViewAnimationOptionAutoreverse animations:^(void) {
            [UIView setAnimationRepeatCount:3];
            blinkView.alpha = 1;
    } completion:^(BOOL finished) {
        blinkView.alpha = 0;
        blinkView.hidden = YES;
        [blinkView removeFromSuperview];
    }];
    
    [NSThread sleepForTimeInterval:3];
}

+(void)showVoiceView:(UIView *)targetView disableTableView:(UITableView *)tableView;
{
    voiceOnlyView.alpha = 0.0;

    [targetView addSubview:voiceOnlyView];        
    tableView.userInteractionEnabled = NO;
    
    [UIView animateWithDuration:1 animations:^(void) {
        voiceOnlyView.alpha = 1;
    } completion:nil];
}

+(void)hideVoiceView:(NSTimeInterval)delay enableTableView:(UITableView *)tableView;
{
    [UIView animateWithDuration:1 delay:delay options:0 animations:^(void) {
        voiceOnlyView.alpha = 0;
    } completion:^(BOOL finished) {
        [voiceOnlyView removeFromSuperview];
        tableView.userInteractionEnabled = YES;
    }];
}

+(void)showView:(UIView *)myView targetView:(UIView *)targetView
{
    myView.alpha = 0.0;
    
    [targetView addSubview:myView];        
    
    [UIView animateWithDuration:1 animations:^(void) {
        myView.alpha = 1;
    } completion:nil];
}

+(void)hideView:(UIView *)myView delay:(NSTimeInterval)delay
{
    [UIView animateWithDuration:1 delay:delay options:0 animations:^(void) {
        myView.alpha = 0;
    } completion:^(BOOL finished) {
        [myView removeFromSuperview];
    }];
}


+(void)popupAlertViewWithMsg:(NSString *)msg targetViewController:(UIViewController *)targetViewController forDuration:(NSTimeInterval)duration;
{
    alertVC.modalPresentationStyle = UIModalPresentationFormSheet;    
    [targetViewController presentModalViewController:alertVC animated:YES];
    alertVC.alertMessage.text = msg;
    
    [alertVC performSelector:@selector(dismissModalViewControllerAnimatedNS:) withObject:yesNumber afterDelay:duration];    
}
     

@end
