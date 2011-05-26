//
//  AlertViewController.h
//  VailProject
//
//  Created by Michael Chun on 5/22/11.
//  Copyright 2011 Stanford. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CustomAlertViewController : UIViewController {
    
    UILabel *alertMessage;
}
@property (nonatomic, retain) IBOutlet UILabel *alertMessage;

- (void) dismissModalViewControllerAnimatedNS:(NSNumber *)animated;
@end
