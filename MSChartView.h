//
//  LCView.h
//  LightChart
//
//  Created by Nicolas Seriot on 11/19/10.
//  Copyright 2010 seriot.ch. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Measure;

@protocol MSChartViewDataSource
- (NSUInteger)numberOfMeasures;
- (Measure *)measureAtIndex:(NSUInteger)index;
- (NSDate *)minDate;
- (NSDate *)maxDate;
@end

@interface MSChartView : UIView {
	IBOutlet NSObject <MSChartViewDataSource> *dataSource;
}

@property (nonatomic, retain) NSObject <MSChartViewDataSource> *dataSource;

@end
