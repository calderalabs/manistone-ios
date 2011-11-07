//
//  MSLocationPicker.h
//  Manistone
//
//  Created by Eugenio Depalo on 02/10/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "LocationPickerControllerDelegate.h"
#import "MSLocationPickerDelegate.h"

@interface MSLocationPicker : UIView <CLLocationManagerDelegate, LocationPickerControllerDelegate, MKReverseGeocoderDelegate> {
	id<MSLocationPickerDelegate> _delegate;
	
	TTActivityLabel *_locationActivity;
	CLLocationManager *_locationManager;
	UILabel *_titleLabel;
	UILabel *_locationLabel;
	UIButton *_pickButton;
	TTViewController *_controller;
	CLLocationCoordinate2D _location;
}

@property (nonatomic, assign) CLLocationCoordinate2D location;
@property (nonatomic, assign) id<MSLocationPickerDelegate> delegate;
@property (nonatomic, assign) BOOL showsPicker;

- (id)initWithParentController:(TTViewController *)controller startWithUserLocation:(BOOL)locate;

@end
