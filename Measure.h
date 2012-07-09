//
//  Measure.h
//  MobileSignal
//
//  Created by Nicolas Seriot on 11/16/10.
//  Copyright 2010 seriot.ch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIApplication+MS.h"

@class CLLocation;

@interface Measure : NSObject {
	NSUInteger networkType;
	NSInteger signalStrength;
	NSString *networkName;
	NSDate *date;
	CLLocation *location;
}

@property NSUInteger networkType;
@property NSInteger signalStrength;
@property (nonatomic, retain) NSString *networkName;
@property (nonatomic, retain) NSDate *date;
@property (nonatomic, retain) CLLocation *location;

+ (Measure *)measureWithStatusBarData:(StatusBarData *)statusBarData location:(CLLocation *)aLocation;
+ (NSString *)stringForNetworkType:(NSUInteger)aNetworkType;

@end
