//
//  CalendarViewController.h
//  VailProject
//
//  Created by Michael Chun on 5/18/11.
//  Copyright 2011 Stanford. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CalendarViewController : UITableViewController {
    UITableViewCell *listCell;
}

@property (nonatomic, assign) IBOutlet UITableViewCell *listCell;

@end
