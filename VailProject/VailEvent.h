//
//  VailEvent.h
//  VailProject
//
//  Created by Michael Chun on 5/26/11.
//  Copyright (c) 2011 Stanford. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface VailEvent : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * testId;
@property (nonatomic, retain) NSString * feedbackMode;
@property (nonatomic, retain) NSDate * time;
@property (nonatomic, retain) NSNumber * distance;
@property (nonatomic, retain) NSString * subtestMode;
@property (nonatomic, retain) NSString * eventName;
@property (nonatomic, retain) NSString * eventResult;
@property (nonatomic, retain) NSString * displayMode;
@property (nonatomic, retain) NSString * timeString;

@end
