//
//  InterfaceVariableManager.m
//  VailProject
//
//  Created by Jeongjin on 5/4/11.
//  Copyright 2011 Stanford. All rights reserved.
//

#import "InterfaceVariableManager.h"
#import "VailProjectAppDelegate.h"
#import "VailEvent.h"

@implementation InterfaceVariableManager
@synthesize distance=_distance;
@synthesize speed=_speed;
@synthesize lane=_lane;
@synthesize testId=_testId;
@synthesize testMode=_testMode;
@synthesize displayMode=_displayMode;
@synthesize feedbackMode=_feedbackMode;
@synthesize clientIP=_clientIP;
@synthesize clientPort=_clientPort;
@synthesize controllers=_controllers;


static id sharedManager = nil;

+ (void)initialize {
    if (self == [InterfaceVariableManager class]) {
        sharedManager = [[self alloc] init];
    }
}

+ (id)sharedManager {
    return sharedManager;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.distance = 0.0;
        _controllers = [[NSMutableDictionary alloc]init];
    }
    return self;
}

- (void)registerController:(NSString*) key controller:(id)controller {
    [_controllers setObject:controller forKey:key];
}


- (void)updateInformationWith:(NSString*)uri params:(NSDictionary*)params{
        
    if([uri rangeOfString:@"/admin"].length > 0 )
    {
        NSString *subtestParam = (NSString*)[params objectForKey:@"subtest"];
        NSString *eventParam = (NSString*)[params objectForKey:@"event"];
        if( [subtestParam integerValue] == NAVIGATION_MODE && [eventParam isEqualToString:@"PATH"]){            
            if ([[_controllers objectForKey:PATH_SELECTION_ADMIN] respondsToSelector:@selector(receiveVoiceFeedback:)] )
                 [[_controllers objectForKey:PATH_SELECTION_ADMIN] performSelectorOnMainThread:@selector(receiveVoiceFeedback:) withObject:params waitUntilDone:NO];            
            NSLog(@"post sent\n");
        }else if( [subtestParam integerValue] == NAVIGATION_MODE && [eventParam isEqualToString:@"DESTINATION"]){            
            if ([[_controllers objectForKey:DESTINATION_SELECTION_ADMIN] respondsToSelector:@selector(receiveVoiceFeedback:)] )
                [[_controllers objectForKey:DESTINATION_SELECTION_ADMIN] performSelectorOnMainThread:@selector(receiveVoiceFeedback:) withObject:params waitUntilDone:NO];             
            NSLog(@"post sent\n");
        }
        else if([subtestParam integerValue] == EMAIL_MODE){
            NSString *selectorName = [NSString stringWithFormat:@"%@%@",[params objectForKey:@"result"],@":"];
            
            if ([[_controllers objectForKey:EMAIL_ADMIN] respondsToSelector:NSSelectorFromString(selectorName)])
                [[_controllers objectForKey:EMAIL_ADMIN] performSelectorOnMainThread:NSSelectorFromString(selectorName) withObject:params waitUntilDone:NO];            
        }
        else if([subtestParam integerValue] == CONFIG_MODE){
            NSString *subjectId = [params objectForKey:@"subjectId"];
            NSString *testType = [params objectForKey:@"testType"];
            
            [[_controllers objectForKey:CONFIG_ADMIN] performSelectorOnMainThread:@selector(setSubjectId:) withObject:subjectId waitUntilDone:NO];
            [[_controllers objectForKey:CONFIG_ADMIN] performSelectorOnMainThread:@selector(setTestType:) withObject:testType waitUntilDone:NO];
        }
        else if([subtestParam integerValue] == SCENARIO_MODE){
            NSString *selectorName = [NSString stringWithFormat:@"%@%@",[params objectForKey:@"scenario"],@":"];            
            if ([[_controllers objectForKey:SCENARIO_ADMIN] respondsToSelector:NSSelectorFromString(selectorName)])
                [[_controllers objectForKey:SCENARIO_ADMIN] performSelectorOnMainThread:NSSelectorFromString(selectorName) withObject:params waitUntilDone:NO];            
        }
        
    }else if([uri rangeOfString:@"/simulator"].length > 0 )
    {
        self.distance = [(NSString*)[params objectForKey:@"distance"] doubleValue];
    }
}

- (void)saveEvent:(SubTestMode)subTestMode event:(NSString*)event result:(NSString*) result time:(NSDate*)time{
        
    return;
    NSManagedObjectContext *context = [(id)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    VailEvent *newEvent = [NSEntityDescription insertNewObjectForEntityForName:@"VailEvent" inManagedObjectContext:context];
    
    newEvent.distance = [NSNumber numberWithDouble:self.distance];
    newEvent.testId = self.testId;
    newEvent.displayMode =  [NSString stringWithFormat:@"%d", self.displayMode];
    newEvent.feedbackMode = [NSString stringWithFormat:@"%d", self.feedbackMode]; 
    
    newEvent.subtestMode = [NSString stringWithFormat:@"%d", subTestMode];
    newEvent.eventName = event;
    newEvent.eventResult = result;
    newEvent.time = time;
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    newEvent.timeString = [dateFormatter stringFromDate:time];
    [dateFormatter release];
 
    NSError *error;
    [context save:&error];
    
}

- (VailEvent*)loadEvent:(SubTestMode)subTestMode event:(NSString*)event{
        
    NSManagedObjectContext *context = [(id)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"VailEvent" inManagedObjectContext:context];
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    [request setEntity:entityDescription];
    
    // Set example predicate and sort orderings...
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @" (testId = %@) AND (subtestMode = %@ ) AND (eventName = %@) ",self.testId, [NSString stringWithFormat:@"%d", subTestMode] ,event ];
    [request setPredicate:predicate];
//    
//    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
//                                        initWithKey:@"firstName" ascending:YES];
//    [request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
//    [sortDescriptor release];
    
    NSError *error = nil;
    NSArray *array = [context executeFetchRequest:request error:&error];
    if (array == nil || [array count] == 0)
    {
        return nil;
    }else{
        return [array objectAtIndex:0];
    }
    
}

+ (BOOL) isKeyExist:(NSString *)key{
    NSManagedObjectContext *context = [(id)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"VailEvent" inManagedObjectContext:context];
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    [request setEntity:entityDescription];
    
    // Set example predicate and sort orderings...
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @" (testId = %@ ) ",key ];
    [request setPredicate:predicate];
    //    
    //    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
    //                                        initWithKey:@"firstName" ascending:YES];
    //    [request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    //    [sortDescriptor release];
    
    NSError *error = nil;
    NSArray *array = [context executeFetchRequest:request error:&error];
    if (array == nil || [array count] == 0)
    {
        return NO;
    }else{
        return YES;
    }
}

- (void)dealloc
{
    [super dealloc];
}

@end
