//
//  UIColor+MS.m
//  MobileSignal
//
//  Created by Nicolas Seriot on 12/5/10.
//  Copyright 2010 seriot.ch. All rights reserved.
//

#import "UIColor+MS.h"


@implementation UIColor (MS)

+ (UIColor *)colorForNetworkType:(NSUInteger)aNetworkType {
	if(aNetworkType == 0) {
		return [UIColor purpleColor];
	} else if (aNetworkType == 1) {
		return [UIColor blueColor];	
	} else if (aNetworkType == 2) {
		return [UIColor redColor];
	} else if (aNetworkType == 3) {
		return [UIColor grayColor];	
	}

	return nil;
}

@end
