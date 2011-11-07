//
//  LocationPickerController.h
//  Manistone
//
//  Created by Eugenio Depalo on 21/09/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "LocationPickerControllerDelegate.h"
#import "MSLocationAnnotation.h"

@interface LocationPickerController : TTViewController <MKMapViewDelegate, UIActionSheetDelegate> {
	id<LocationPickerControllerDelegate> _delegate;
	UIBarButtonItem *_centerUserLocationButton;
	UIBarButtonItem *_pickButton;
	UIBarButtonItem *_changeMapTypeButton;

	TTSearchDisplayController *_locationPickerSearchController;
	
	MSLocationAnnotation *_annotation;
	
	MKMapView *_mapView;
}

@property (nonatomic, retain) id<LocationPickerControllerDelegate> delegate;

- (id)initWithLocation:(CLLocationCoordinate2D)location;

@end
