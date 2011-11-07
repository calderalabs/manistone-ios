//
//  LocationPickerController.m
//  Manistone
//
//  Created by Eugenio Depalo on 21/09/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "LocationPickerController.h"

#import "MSGeocoderDataSource.h"
#import "MSGeocoderResult.h"

@implementation LocationPickerController

@synthesize delegate = _delegate;

- (id)initWithLocation:(CLLocationCoordinate2D)location {
	if(self = [self init]) {
		_annotation = [[MSLocationAnnotation alloc] init];
		_annotation.coordinate = location;
	}
	
	return self;
}

- (void)dealloc {
	TT_RELEASE_SAFELY(_delegate);
	TT_RELEASE_SAFELY(_mapView);
	TT_RELEASE_SAFELY(_annotation);
	TT_RELEASE_SAFELY(_centerUserLocationButton);
	TT_RELEASE_SAFELY(_pickButton);
	TT_RELEASE_SAFELY(_changeMapTypeButton);
	TT_RELEASE_SAFELY(_locationPickerSearchController);
					  
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

- (void)loadView {
	[super loadView];
	
	self.title = NSLocalizedString(@"Select a location", @"");
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
																							target:self
																							action:@selector(done:)] autorelease];
	
	self.navigationController.toolbar.tintColor = TTSTYLEVAR(toolbarTintColor);
	
	_centerUserLocationButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"location.png"]
																			   style:UIBarButtonItemStyleBordered
																			  target:self 
																			  action:@selector(centerUserLocation:)];
	
	_centerUserLocationButton.width = 35;
	
	_centerUserLocationButton.enabled = NO;
	
	_pickButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Pick center location", @"")
																	style:UIBarButtonItemStyleBordered
																   target:self 
																   action:@selector(pick:)];
	
	_pickButton.width = 220;
	
	_changeMapTypeButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"map.png"]
																	style:UIBarButtonItemStyleBordered
																   target:self 
													 action:@selector(changeMapType:)];
	
	_changeMapTypeButton.width = 35;
	
	self.toolbarItems = [NSArray arrayWithObjects:_centerUserLocationButton,
						 _pickButton,
						 _changeMapTypeButton,
						 nil];
	
	UISearchBar *searchBar = [[UISearchBar alloc] init];
	searchBar.tintColor = TTSTYLEVAR(controlTintColor);
	[searchBar sizeToFit];
	
	_locationPickerSearchController = [[TTSearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
	TTTableViewController *searchResultsViewController = [[TTTableViewController alloc] init];
	
	MSGeocoderDataSource *dataSource = [[MSGeocoderDataSource alloc] initWithQueryString:nil];
	dataSource.delegate = self;
	searchResultsViewController.dataSource = dataSource;
	TT_RELEASE_SAFELY(dataSource);
	
	_locationPickerSearchController.searchResultsViewController = searchResultsViewController;
	TT_RELEASE_SAFELY(searchResultsViewController);
	
	CGRect mapFrame = TTToolbarNavigationFrame();
	_mapView = [[MKMapView alloc] initWithFrame:CGRectMake(mapFrame.origin.x, searchBar.height, mapFrame.size.width, mapFrame.size.height - searchBar.height)];
	_mapView.delegate = self;
	_mapView.region = MKCoordinateRegionMake(_annotation.coordinate, MKCoordinateSpanMake(0.005, 0.005));
	_mapView.showsUserLocation = YES;
	
	[_mapView addAnnotation:_annotation];

	[self.view addSubview:_mapView];
	[self.view addSubview:searchBar];
	
	TT_RELEASE_SAFELY(searchBar);
	
	UIImageView *ghostAnnotation = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"stone.png"]];
	
	ghostAnnotation.frame = CGRectMake(floor(_mapView.width / 2 - ghostAnnotation.width / 4),
									   floor(_mapView.height / 2) + ghostAnnotation.height / 4,
									   ghostAnnotation.width,
									   ghostAnnotation.height);
	
	ghostAnnotation.alpha = 0.5;

	[self.view addSubview:ghostAnnotation];
	TT_RELEASE_SAFELY(ghostAnnotation);
}

- (void)didSelectResult:(id)sender {
	TTTableButton *item = (TTTableButton *)sender;
	MSGeocoderResult *result = (MSGeocoderResult *)item.userInfo;
	
	[_locationPickerSearchController setActive:NO animated:YES];
	
	CLLocationCoordinate2D northEast = result.northEast;
	CLLocationCoordinate2D southWest = result.southWest;
	
	MKCoordinateRegion region;
	CLLocationCoordinate2D _center;
	
	_center.latitude = (northEast.latitude + southWest.latitude) / 2;
	_center.longitude = (northEast.longitude + southWest.longitude) / 2;
	
	region.span = MKCoordinateSpanMake((northEast.latitude - southWest.latitude),
									   (northEast.longitude - southWest.longitude));
	region.center = _center;
	
	[_mapView setRegion:[_mapView regionThatFits:region]];
}

- (void)centerUserLocation:(id)sender {
	[_mapView setCenterCoordinate:_mapView.userLocation.coordinate animated:YES];
}

- (void)changeMapType:(id)sender {
	UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Select your preferred map type", @"")
													   delegate:self
											  cancelButtonTitle:NSLocalizedString(@"Cancel", @"")
										 destructiveButtonTitle:nil
											  otherButtonTitles:NSLocalizedString(@"Standard", @"Standard map type"),
							NSLocalizedString(@"Hybrid", @"Hybrid map type"),
							NSLocalizedString(@"Satellite", @"Satellite map type"), nil];
	
	[sheet showFromBarButtonItem:sender animated:YES];
	
	TT_RELEASE_SAFELY(sheet);
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	switch (buttonIndex) {
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

- (void)pick:(id)sender {
	_annotation.coordinate = _mapView.centerCoordinate;
}

- (void)done:(id)sender {
	[_delegate locationPickerController:self didSelectLocation:_annotation.coordinate];
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
	_centerUserLocationButton.enabled = YES;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
	if(annotation == mapView.userLocation)
		return nil;
	
	MKPinAnnotationView *view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
	view.draggable = YES;
	
	return [view autorelease];
}

@end
