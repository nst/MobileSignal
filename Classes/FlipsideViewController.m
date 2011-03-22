//
//  FlipsideViewController.m
//  MobileSignal
//
//  Created by Nicolas Seriot on 11/9/10.
//  Copyright 2010 seriot.ch. All rights reserved.
//

#import "FlipsideViewController.h"


@implementation FlipsideViewController

@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor viewFlipsideBackgroundColor];      
}


- (IBAction)done:(id)sender {
	[self.delegate flipsideViewControllerDidFinish:self];	
}

- (void)dealloc {
    [super dealloc];
}


@end
