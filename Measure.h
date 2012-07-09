//
//  Measure.h
//  MobileSignal
//
//  Created by Nicolas Seriot on 11/16/10.
//  Copyright 2010 seriot.ch. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct { // UIStatusBarServerThread
	BOOL itemIsEnabled[23];
	BOOL timeString[64];
	int gsmSignalStrengthRaw;
	int gsmSignalStrengthBars;
	BOOL serviceString[100];
	BOOL serviceCrossfadeString[100];
	BOOL serviceImages[3][100];
	BOOL operatorDirectory[1024];
	unsigned int serviceContentType;
	int wifiSignalStrengthRaw;
	int wifiSignalStrengthBars;
	unsigned int dataNetworkType;
	int batteryCapacity;
	unsigned int batteryState;
	BOOL notChargingString[150];
	int bluetoothBatteryCapacity;
	int thermalColor;
	unsigned int thermalSunlightMode : 1;
	unsigned int slowActivity : 1;
	unsigned int syncActivity : 1;
	BOOL activityDisplayId[256];
	unsigned int bluetoothConnected : 1;
	unsigned int displayRawGSMSignal : 1;
	unsigned int displayRawWifiSignal : 1;
	unsigned int locationIconType : 1;
} StatusBarData;

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
