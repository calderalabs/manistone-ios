//
//  MSTablePicturePickerItemCell.h
//  Manistone
//
//  Created by Eugenio Depalo on 07/11/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSTablePicturePickerItem.h"
#import "MSTablePicturePickerDelegate.h"

@interface MSTablePicturePickerItemCell : TTTableViewCell <UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>  {
	MSTablePicturePickerItem *_item;

	UIImageView *_localImageView;
	TTImageView *_imageView2;
}

@end
