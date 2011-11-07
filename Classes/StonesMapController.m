//
//  StonesMapController.m
//  Manistone
//
//  Created by Eugenio Depalo on 13/10/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "StonesMapController.h"
#import "MSStone.h"

#import "MKMapView+MSAdditions.h"

@implementation StonesMapController

- (id)initWithNavigatorURL:(NSURL *)URL query:(NSDictionary *)query {
	if(self = [self init]) {
		_stones = [[self createStonesWithQuery:query] retain];

		self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", @"")
																				  style:UIBarButtonItemStylePlain
																				 target:self
																				 action:@selector(showList:)] autorelease];
		
		self.title = NSLocalizedString(@"Stones Map", @"");
	}
	
	return self;
}

- (void)dealloc {
	TT_RELEASE_SAFELY(_stones);
	TT_RELEASE_SAFELY(_mapView);
	
	[super dealloc];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.navigationController setToolbarHidden:NO animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[self.navigationController setToolbarHidden:YES animated:animated];
}

- (NSArray *)createStonesWithQuery:(NSDictionary *)query {
	return [query valueForKey:@"stones"];
}

- (void)loadView {
	[super loadView];
	
	UISegmentedControl *mapTypeControl = [[[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:
																					 NSLocalizedString(@"Standard", @"Standard map type"),
																					 NSLocalizedString(@"Hybrid", @"Hybrid map type"),
																					 NSLocalizedString(@"Satellite", @"Satellite map type"), nil]] autorelease];
	
	[mapTypeControl addTarget:self action:@selector(mapTypeChanged:) forControlEvents:UIControlEventValueChanged];
	
	mapTypeControl.segmentedControlStyle = UISegmentedControlStyleBar;
	mapTypeControl.tintColor = TTSTYLEVAR(controlTintColor);
	
	UIBarButtonItem *mapBarButton = [[[UIBarButtonItem alloc] initWithCustomView:mapTypeControl] autorelease];
	mapBarButton.width = 308;
	
	self.toolbarItems = [NSArray arrayWithObjects:
						 mapBarButton,
						 nil];
	
	self.navigationController.toolbar.tintColor = TTSTYLEVAR(toolbarTintColor);
	
	mapTypeControl.selectedSegmentIndex = 0;
	
	_mapView = [[MKMapView alloc] initWithFrame:TTNavigationFrame()];
	_mapView.delegate = self;
	[_mapView addAnnotations:_stones];
	
	[_mapView fitAnnotationsAnimated:NO];
	
	[self.view addSubview:_mapView];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
	MKAnnotationView *annotationView = nil;
	
	if([annotation isKindOfClass:[MSStone class]]) {
		annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"StoneAnnotation"];
		
		if(!annotationView) {
			annotationView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"StoneAnnotation"] autorelease];
			annotationView.canShowCallout = YES;
			annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
		}
		else
			annotationView.annotation = annotation;
	}
	
	return annotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
	MSStone *stone = (MSStone *)view.annotation;
	
	[[TTNavigator navigator] openURLAction:[[TTURLAction actionWithURLPath:[stone URLValueWithName:@"show"]] applyAnimated:YES]];
}

- (void)mapTypeChanged:(id)sender {
	UISegmentedControl *control = (UISegmentedControl *)sender;
	
	switch (control.selectedSegmentIndex) {
		case 0:
			_mapView.mapType = MKMapTypeStandard;
			break;
		case 1:
			_mapView.mapType = MKMapTypeHybrid;
			break;
		case 2:
			_mapView.mapType = MKMapTypeSatellite;
			break;
	}
}

- (void)showList:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
}

@end
