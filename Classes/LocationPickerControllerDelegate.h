//
//  LocationPickerControllerDelegate.h
//  Manistone
//
//  Created by Eugenio Depalo on 22/09/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

@class LocationPickerController;

@protocol LocationPickerControllerDelegate <NSObject>

@optional
- (void)locationPickerController:(LocationPickerController *)controller didSelectLocation:(CLLocationCoordinate2D)location;

@end
