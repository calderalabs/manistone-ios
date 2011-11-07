//
//  AreaPickerController.h
//  Manistone
//
//  Created by Eugenio Depalo on 11/10/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "AreaPickerControllerDelegate.h"

@interface AreaPickerController : TTViewController <MKMapViewDelegate, UIActionSheetDelegate> {
	MKCoordinateRegion _area;
	
	id<AreaPickerControllerDelegate> _delegate;
	UIBarButtonItem *_centerUserLocationButton;

	TTSearchDisplayController *_areaPickerSearchController;
	
	MKMapView *_mapView;
}

@property (nonatomic, retain) id<AreaPickerControllerDelegate> delegate;

- (id)initWithArea:(MKCoordinateRegion)area;

@end
