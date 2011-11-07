//
//  MSTablePicturePickerDelegate.h
//  Manistone
//
//  Created by Eugenio Depalo on 07/11/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

@protocol MSTablePicturePickerDelegate <NSObject>

- (void)tablePicturePickerDidPickImage:(UIImage *)image;
- (void)tablePicturePickerDeleteButtonClicked;

@end
