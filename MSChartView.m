//
//  LCView.m
//  LightChart
//
//  Created by Nicolas Seriot on 11/19/10.
//  Copyright 2010 seriot.ch. All rights reserved.
//

#import "MSChartView.h"
#import "Measure.h"
#import <CoreLocation/CoreLocation.h>
#import "UIColor+MS.h"

#define MAX_DB 120.0

@implementation MSChartView

@synthesize dataSource;

- (CGPoint)pointForMeasure:(Measure *)m {
	CGFloat height = [self bounds].size.height;
	CGFloat width = [self bounds].size.width;
	
	NSDate *minDate = [dataSource minDate];
	NSDate *maxDate = [NSDate date];

	double percent = 0.0;
	
	if(minDate != maxDate) { // juste another way to say "if i > 0"
		NSTimeInterval minDateTimeInterval = [minDate timeIntervalSinceReferenceDate];
		NSTimeInterval maxDateTimeInterval = [maxDate timeIntervalSinceReferenceDate];
		
		NSTimeInterval range = maxDateTimeInterval - minDateTimeInterval;
		
		percent = ([m.date timeIntervalSinceReferenceDate] - minDateTimeInterval) / range;		
	}
	
	double x = width * percent;
	double y = (abs(m.signalStrength) / MAX_DB) * height;
	CGPoint p = CGPointMake(x, y);
	
	return p;
}

- (void)fillAndStrikePath:(UIBezierPath *)path networkType:(NSUInteger)aNetworkType {
	UIColor *stokeColor = [UIColor blackColor];
	UIColor *fillColor = [UIColor colorForNetworkType:aNetworkType];

	[stokeColor setStroke];
	[fillColor setFill];
	
	[path fill];
	[path stroke];
}

- (void)drawRect:(CGRect)rect {

	if([dataSource numberOfMeasures] == 0) return;

	UIBezierPath *path = nil;
	
	// first point
	
	Measure *m = [dataSource measureAtIndex:0];
	Measure *previousMeasure = nil;
	
	CGPoint p0 = [self pointForMeasure:m];
	CGPoint openingPoint = p0;
	
	[path moveToPoint:p0];
		
	CGPoint p = CGPointZero;
	CGPoint previousPoint = CGPointZero;
	
	for(NSUInteger i = 0; i < [dataSource numberOfMeasures]; i++) {		
		
		if (i > 0) previousMeasure = m;
		m = [dataSource measureAtIndex:i];
		
		if (i > 0) previousPoint = p;
		p = [self pointForMeasure:m];
		
		BOOL hasSameNetwork = m.networkType == previousMeasure.networkType;
		BOOL isLastPoint = i == [dataSource numberOfMeasures] - 1;
		
		if(i == 0) {
			// open path
			path = [UIBezierPath bezierPath];
			[path moveToPoint:p];
			openingPoint = p;
		}
		
		if (hasSameNetwork) {
			// just add line
			[path addLineToPoint:CGPointMake(p.x, previousPoint.y)];
			[path addLineToPoint:CGPointMake(p.x, p.y)];
		} else {
			// close previous, open new one
			if(i > 0) {
				[path addLineToPoint:CGPointMake(p.x, previousPoint.y)];
			}
			[path addLineToPoint:CGPointMake(p.x, self.bounds.size.height)];
			[path addLineToPoint:CGPointMake(openingPoint.x, self.bounds.size.height)];
			[path addLineToPoint:openingPoint];

			[self fillAndStrikePath:path networkType:previousMeasure.networkType];
			
			path = [UIBezierPath bezierPath];
			[path moveToPoint:p];
			openingPoint = p;
		}
		
		if (isLastPoint) {
			// add a temporary "guessed" measure for current date
			Measure *tmpMeasure = [[[Measure alloc] init] autorelease];
			tmpMeasure.networkType = m.networkType;
			tmpMeasure.signalStrength = m.signalStrength;
			tmpMeasure.location = m.location;
			tmpMeasure.date = [NSDate date];
			CGPoint tmpPoint = [self pointForMeasure:tmpMeasure];
			
			// close
			[path addLineToPoint:CGPointMake(tmpPoint.x, p.y)];
			[path addLineToPoint:CGPointMake(tmpPoint.x, self.bounds.size.height)];
			[path addLineToPoint:CGPointMake(openingPoint.x, self.bounds.size.height)];
			[path addLineToPoint:openingPoint];

			[self fillAndStrikePath:path networkType:m.networkType];
		}
		
	}
}

- (void)dealloc {
	[dataSource release];
    [super dealloc];
}

@end
