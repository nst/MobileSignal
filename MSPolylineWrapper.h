//
//  MeasurePolyLine.h
//  MobileSignal
//
//  Created by Nicolas Seriot on 12/5/10.
//  Copyright 2010 seriot.ch. All rights reserved.
//

#import <MapKit/MapKit.h>


@interface MSPolylineWrapper : MKPolyline <MKOverlay> {
	MKPolyline *polyline;
	NSUInteger networkType;
}

@property NSUInteger networkType;
@property (nonatomic, retain) MKPolyline *polyline;

+ (MSPolylineWrapper *)polylineWithCoordinates:(CLLocationCoordinate2D *)coords count:(NSUInteger)count networkType:(NSUInteger)aNetworkType;

@end
