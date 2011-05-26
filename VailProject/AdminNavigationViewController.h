//
//  AdminNavigationViewController.h
//  VailProject
//
//  Created by Jeongjin on 5/4/11.
//  Copyright 2011 Stanford. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AdminNavigationViewController : UIViewController {
    
}

@property (nonatomic, retain) IBOutlet UITextField *weightField;
@property (nonatomic, retain) IBOutlet UILabel *currentLabel;


- (IBAction)selectAPath;
- (IBAction)selectBPath;
- (IBAction)selectCafePath;
- (IBAction)selectCampusPath;
- (IBAction)increaseDistance;



@end
