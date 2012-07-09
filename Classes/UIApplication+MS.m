//
//  UIApplication+MS.m
//  MobileSignal
//
//  Created by Nicolas Seriot on 7/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIApplication+MS.h"

@class UIStatusBarForegroundView;
@class UIStatusBarDataNetworkItemView;

@implementation UIApplication (MS)

+ (NSNumber *)dataNetworkTypeFromStatusBar {
    
    UIApplication *app = [UIApplication sharedApplication];
    
    UIStatusBar *statusBar = [app valueForKey:@"statusBar"];
    
    UIStatusBarForegroundView *foregroundView = [statusBar valueForKey:@"foregroundView"];
    
    NSArray *subviews = [foregroundView subviews];
    
    UIStatusBarDataNetworkItemView *dataNetworkItemView = nil;
    
    for (id subview in subviews) {
        if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
            dataNetworkItemView = subview;
            break;
        }
    }
    
    return [dataNetworkItemView valueForKey:@"dataNetworkType"];
}

@end
