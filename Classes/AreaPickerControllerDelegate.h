//
//  AreaPickerControllerDelegate.h
//  Manistone
//
//  Created by Eugenio Depalo on 22/09/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

@class AreaPickerController;

@protocol AreaPickerControllerDelegate <NSObject>

@optional
- (void)areaPickerController:(AreaPickerController *)controller didSelectArea:(MKCoordinateRegion)area;

@end
