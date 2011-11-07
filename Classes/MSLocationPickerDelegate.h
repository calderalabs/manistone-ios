//
//  MSLocationPickerDelegate.h
//  Manistone
//
//  Created by Eugenio Depalo on 05/10/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

@class MSLocationPicker;

@protocol MSLocationPickerDelegate <NSObject>

@optional
- (void)locationPicker:(MSLocationPicker *)locationPicker didSelectLocation:(CLLocationCoordinate2D)location;

@end
