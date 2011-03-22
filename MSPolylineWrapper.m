//
//  MeasurePolyLine.m
//  MobileSignal
//
//  Created by Nicolas Seriot on 12/5/10.
//  Copyright 2010 seriot.ch. All rights reserved.
//

#import "MSPolyLineWrapper.h"


@implementation MSPolylineWrapper

@synthesize networkType;
@synthesize polyline;

+ (MSPolylineWrapper *)polylineWithCoordinates:(CLLocationCoordinate2D *)coords count:(NSUInteger)count networkType:(NSUInteger)aNetworkType {
	MSPolylineWrapper *pw = [[MSPolylineWrapper alloc] init];
	
	pw.polyline = [MKPolyline polylineWithCoordinates:coords count:count];
	pw.networkType = aNetworkType;

	return [pw autorelease];
}

- (void)dealloc {
	[polyline release];
	[super dealloc];
}

#pragma mark MKOverlay

- (MKMapRect)boundingMapRect {
	return polyline.boundingMapRect;
}

- (CLLocationCoordinate2D) coordinate {
	return polyline.coordinate;
}

- (BOOL)intersectsMapRect:(MKMapRect)mapRect {
	return [polyline intersectsMapRect:mapRect];
}

@end
