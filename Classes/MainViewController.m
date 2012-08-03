//
//  MainViewController.m
//  MobileSignal
//
//  Created by Nicolas Seriot on 11/9/10.
//  Copyright 2010 seriot.ch. All rights reserved.
//

#import "MainViewController.h"
#import "Measure.h"
#import "UIStatusBarServer.h"
#import <MapKit/MapKit.h>
#import "MSPolylineWrapper.h"
#import "UIColor+MS.h"
#import <QuartzCore/QuartzCore.h>

@implementation MainViewController

@synthesize networkNameLabel;
@synthesize signalStrengthLabel;
@synthesize networkTypeLabel;
@synthesize startDateLabel;
@synthesize lastDateLabel;
@synthesize measures;
@synthesize nbMeasuresLabel;
@synthesize startDate;
@synthesize timer;
@synthesize locationManager;
@synthesize chartView;
@synthesize mapView;
@synthesize statusBarServer;

static NSDateFormatter *dateFormatter;

- (NSDateFormatter *)dateFormatter {
    if(dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-dd-MM HH:mm"];
    }
    
    return dateFormatter;
}

- (void)displayMeasure:(Measure *)m {
	networkNameLabel.text = m.networkName;
	signalStrengthLabel.text = [NSString stringWithFormat:@"%d dBm", m.signalStrength];
	networkTypeLabel.text = [Measure stringForNetworkType:m.networkType];
	nbMeasuresLabel.text = [NSString stringWithFormat:@"N=%d", [measures count]];
    
    // TODO: use formatted dates
    NSDateFormatter *dateFormatter = [self dateFormatter];
	startDateLabel.text = [dateFormatter stringFromDate:startDate];
	lastDateLabel.text = [dateFormatter stringFromDate:m.date];
}

- (void)didReceiveMeasure:(Measure *)m {
	
#if TARGET_IPHONE_SIMULATOR
	CLLocationCoordinate2D c = {(float)(rand() % 100),(float)(rand() % 100)};
	m.location = [[[CLLocation alloc] initWithLatitude:c.latitude longitude:c.longitude] autorelease];
#else
	CLLocationCoordinate2D c = m.location.coordinate;
#endif

	NSLog(@"-- new measure with coordinates: %f %f", c.latitude, c.longitude);

	Measure *previousMeasure = [measures lastObject];
	
	[measures addObject:m];
	
	if(previousMeasure) {
		CLLocationCoordinate2D coords[2];
		coords[0] = previousMeasure.location.coordinate;
		coords[1] = c;
		
		MSPolylineWrapper *pw = [MSPolylineWrapper polylineWithCoordinates:coords count:2 networkType:previousMeasure.networkType];
	
		[mapView addOverlay:pw];
	}
	
	[self displayMeasure:m];
	
	[chartView setNeedsDisplay];
}

- (IBAction)addMeasureType1:(id)sender {
	Measure *m = [[[Measure alloc] init] autorelease];
	m.networkName = @"foo";
	m.networkType = 1;
	m.signalStrength = -40 - (rand() % 60);
	m.location = locationManager.location;
	m.date = [NSDate date];
	
	[self didReceiveMeasure:m];
}

- (IBAction)addMeasureType2:(id)sender {
	Measure *m = [[[Measure alloc] init] autorelease];
	m.networkName = @"foo";
	m.networkType = 2;
	m.signalStrength = -50 - (rand() % 50);
	m.location = locationManager.location;
	m.date = [NSDate date];
		
	[self didReceiveMeasure:m];
}

- (void)addMeasure {
	if(locationManager.location == nil) return;
	
	StatusBarData *statusBarData = (StatusBarData *)[UIStatusBarServer getStatusBarData];
	
	Measure *m = [Measure measureWithStatusBarData:(StatusBarData *)statusBarData location:locationManager.location];
	
	[self didReceiveMeasure:m];
}

- (IBAction)clear:(id)sender {
	[measures removeAllObjects];
	
	[mapView removeOverlays:mapView.overlays];
	
	self.startDate = [NSDate date];
	startDateLabel.text = [startDate description];
	lastDateLabel.text = @"";
	
	[self addMeasure];

	[chartView setNeedsDisplay];
}

- (void)addMeasureFromStatusBarServerData:(StatusBarData *)statusBarData {
	Measure *lastMeasure = [measures count] ? [measures objectAtIndex:0] : nil;
	
	Measure *m = [Measure measureWithStatusBarData:statusBarData location:locationManager.location];
	
	if(lastMeasure.signalStrength == m.signalStrength && lastMeasure.networkType == m.networkType) return;
	
	[self didReceiveMeasure:m];
}

- (void)stopListeningToStatusBarServer {
	statusBarServer.statusBar = nil;
	self.statusBarServer = nil;
}

- (void)startListeningToStatusBarServer {
	[self stopListeningToStatusBarServer];
	self.statusBarServer = [[[UIStatusBarServer alloc] initWithStatusBar:self] autorelease];
	
	StatusBarData *statusBarData = (StatusBarData *)[UIStatusBarServer getStatusBarData];
	[self addMeasureFromStatusBarServerData:statusBarData];
}

- (void)loadView {
	[super loadView];
	
	networkNameLabel.text = @"";
	signalStrengthLabel.text = @"";
	networkTypeLabel.text = @"";
	nbMeasuresLabel.text = @"";
	startDateLabel.text = @"";
	lastDateLabel.text = @"";
	
	[self startListeningToStatusBarServer];
	
	self.startDate = [NSDate date];
	self.measures = [NSMutableArray array];
	
	self.locationManager = [[[CLLocationManager alloc] init] autorelease];

	mapView.showsUserLocation = YES;
	
    mapView.layer.borderColor = [UIColor blackColor].CGColor;
    mapView.layer.borderWidth = 1.0f;
    
	chartView.backgroundColor = [UIColor clearColor];
}

- (void)viewDidLoad {
	self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:chartView selector:@selector(setNeedsDisplay) userInfo:nil repeats:YES];

	locationManager.delegate = self;
	[locationManager startMonitoringSignificantLocationChanges];
//	[locationManager startUpdatingLocation];

	[self addMeasure];

	[super viewDidLoad];
}

- (void)viewDidUnload {
	[timer invalidate];
	[timer release];
	
	[self stopListeningToStatusBarServer];
	
	[locationManager stopMonitoringSignificantLocationChanges];
	
	[super viewDidUnload];
}

- (void)dealloc {
	[locationManager release];
	[chartView release];
	[mapView release];
	[statusBarServer release];
	[networkNameLabel release];
	[signalStrengthLabel release];
	[networkTypeLabel release];
	[startDateLabel release];
	[lastDateLabel release];
	[chartView release];
	[measures release];
	[nbMeasuresLabel release];
	[startDate release];
	[timer release];
	[statusBarServer release];
    [super dealloc];
}

- (IBAction)updateDisplay:(id)sender {
	[chartView setNeedsDisplay];
}

#pragma mark -
#pragma mark MSChartViewDataSource

- (NSUInteger)numberOfMeasures {
	return [measures count];
}

- (Measure *)measureAtIndex:(NSUInteger)index {
	if(index >= [measures count]) return nil;
	
	return [measures objectAtIndex:index];
}

- (NSDate *)minDate {
	if([measures count] == 0) return nil;
	
	Measure *m = [measures objectAtIndex:0];
	return m.date;
}

- (NSDate *)maxDate {
	Measure *m = [measures lastObject];
	return m.date;
}

#pragma mark UIStatusBarServerDelegate

- (void)statusBarServer:(id)arg1 didReceiveStatusBarData:(StatusBarData *)statusBarData withActions:(NSInteger)arg3 {
	NSLog(@"-- statusBarServer:didReceiveStatusBarData:withActions:");
//	
//	NSLog(@"-- actions: %d", arg3);
	
	if(locationManager.location == nil) return;
	
	[self addMeasureFromStatusBarServerData:statusBarData];
}

- (void)statusBarServer:(id)arg1 didReceiveStyleOverrides:(NSInteger)arg2 {
	NSLog(@"-- statusBarServer:didReceiveStyleOverrides:");
}

- (void)statusBarServer:(id)arg1 didReceiveGlowAnimationState:(BOOL)arg2 forStyle:(NSInteger)arg3 {
	NSLog(@"-- statusBarServer:didReceiveGlowAnimationState:");
}

- (void)statusBarServer:(id)arg1 didReceiveDoubleHeightStatusString:(id)arg2 forStyle:(NSInteger)arg3 {
	NSLog(@"-- statusBarServer:didReceiveDoubleHeightStatusString:");
}

#pragma mark MKMapViewDelegate

- (MKOverlayView *)mapView:(MKMapView *)aMapView viewForOverlay:(id <MKOverlay>)overlay {
	if ([overlay isKindOfClass:[MSPolylineWrapper class]]) {
		
		MKPolylineView *polylineView = [[MKPolylineView alloc] initWithPolyline:(MKPolyline *)[(MSPolylineWrapper *)overlay polyline]];
		
		UIColor *color = [UIColor colorForNetworkType:[(MSPolylineWrapper *)overlay networkType]];
		
		polylineView.fillColor = [color colorWithAlphaComponent:1.0];
        polylineView.strokeColor = [color colorWithAlphaComponent:1.0];
        polylineView.lineWidth = 6;
		
        return [polylineView autorelease];
    } else {
		NSLog(@"-- unknown overlay: %@", overlay);
	}
 
    return nil;
}

#pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation {
	NSLog(@"-- locationManager:didUpdateToLocation:%@", newLocation);
	
	[mapView setCenterCoordinate:newLocation.coordinate animated:YES];
	
	StatusBarData *statusBarData = (StatusBarData *)[UIStatusBarServer getStatusBarData];
	
	Measure *m = [Measure measureWithStatusBarData:(StatusBarData *)statusBarData location:newLocation];
	
	[self didReceiveMeasure:m];
}

- (void)locationManager:(CLLocationManager *)manager
	   didFailWithError:(NSError *)error {
	NSLog(@"-- locationManager:didFailWithError:%@", error);
}

@end
