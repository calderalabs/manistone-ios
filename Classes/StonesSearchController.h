//
//  StonesSearchController.h
//  Manistone
//
//  Created by Eugenio Depalo on 11/10/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "AreaPickerControllerDelegate.h"

@interface StonesSearchController : TTTableViewController <UITextFieldDelegate, AreaPickerControllerDelegate> {
	MKCoordinateRegion _area;
	MKMapView *_mapView;
	UITextField *_searchField;
	UISegmentedControl *_sortControl;
	UISegmentedControl *_scopeControl;
}

@end
