//
//  VailProjectAppDelegate.h
//  VailProject
//
//  Created by Michael Chun on 4/30/11.
//  Copyright 2011 Stanford. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VailProjectViewController;
@class HTTPServer;

@interface VailProjectAppDelegate : NSObject <UIApplicationDelegate> {
	HTTPServer *httpServer;
    UINavigationController *navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
