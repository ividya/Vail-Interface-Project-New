//
//  ViewEffects.h
//  VailProject
//
//  Created by Michael Chun on 5/20/11.
//  Copyright 2011 Stanford. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomAlertViewController.h"

@interface ViewEffects : NSObject {
    
}
+(void)initialize;

+(void)blink:(UIView *)targetView;
+(void)showVoiceView:(UIView *)targetView disableTableView:(UITableView *)tableView;
+(void)hideVoiceView:(NSTimeInterval)delay enableTableView:(UITableView *)tableView;
+(void)showView:(UIView *)targetView targetView:(UIView *)targetView;
+(void)hideView:(UIView *)myView delay:(NSTimeInterval)delay;
+(void)popupAlertViewWithMsg:(NSString *)msg targetViewController:(UIViewController *)targetViewController forDuration:(NSTimeInterval)duration;
@end