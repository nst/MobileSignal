//
//  MobileSignalAppDelegate.h
//  MobileSignal
//
//  Created by Nicolas Seriot on 11/9/10.
//  Copyright 2010 seriot.ch. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainViewController;

@interface MobileSignalAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    MainViewController *mainViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet MainViewController *mainViewController;

@end

