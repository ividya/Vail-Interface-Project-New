//
//  CalendarModel.h
//  VailProject
//
//  Created by Michael Chun on 5/18/11.
//  Copyright 2011 Stanford. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CalendarEventModel : NSObject {
}
@property (nonatomic, retain) NSString *hour;
@property (nonatomic, retain) NSString *min;
@property (nonatomic, retain) NSString *eventTitle;
@property (nonatomic, retain) UITableView *tableView;

@end
