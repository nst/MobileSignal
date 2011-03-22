//
//  MainViewController.h
//  MobileSignal
//
//  Created by Nicolas Seriot on 11/9/10.
//  Copyright 2010 seriot.ch. All rights reserved.
//

#import "FlipsideViewController.h"
#import "MSChartView.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@class UIStatusBarServer;

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate, MSChartViewDataSource, CLLocationManagerDelegate> {	
	IBOutlet UILabel *networkNameLabel;
	IBOutlet UILabel *signalStrengthLabel;
	IBOutlet UILabel *networkTypeLabel;
	IBOutlet UILabel *nbMeasuresLabel;
	IBOutlet UILabel *startDateLabel;
	IBOutlet UILabel *lastDateLabel;

	IBOutlet MKMapView *mapView;
	IBOutlet MSChartView *chartView;

	NSDate *startDate;
	
	UIStatusBarServer *statusBarServer;
	
	NSMutableArray *measures;

	NSTimer *timer;
	
	CLLocationManager *locationManager;
}

@property (nonatomic, retain) UILabel *networkNameLabel;
@property (nonatomic, retain) UILabel *signalStrengthLabel;
@property (nonatomic, retain) UILabel *networkTypeLabel;
@property (nonatomic, retain) UILabel *nbMeasuresLabel;
@property (nonatomic, retain) UILabel *startDateLabel;
@property (nonatomic, retain) UILabel *lastDateLabel;

@property (nonatomic, retain) NSDate *startDate;

@property (nonatomic, retain) NSMutableArray *measures;

@property (nonatomic, retain) NSTimer *timer;

@property (nonatomic, retain) CLLocationManager *locationManager;

@property (nonatomic, retain) MSChartView *chartView;
@property (nonatomic, retain) MKMapView *mapView;

@property (nonatomic, retain) UIStatusBarServer *statusBarServer;

- (IBAction)showInfo:(id)sender;

- (IBAction)addMeasureType1:(id)sender;
- (IBAction)addMeasureType2:(id)sender;
- (IBAction)clear:(id)sender;
- (IBAction)updateDisplay:(id)sender;

- (void)startListeningToStatusBarServer;
- (void)stopListeningToStatusBarServer;

@end
