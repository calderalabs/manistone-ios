//
//  MSTablePicturePickerItem.h
//  Manistone
//
//  Created by Eugenio Depalo on 07/11/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSTablePicturePickerDelegate.h"

@interface MSTablePicturePickerItem : TTTableButton {
	NSString *_imageURL;
	id<MSTablePicturePickerDelegate> _pictureDelegate;
	
	BOOL _shouldShowDelete;
}

+ (id)itemWithImageURL:(NSString *)imageURL
			   caption:(NSString *)caption
			  delegate:(id<MSTablePicturePickerDelegate>)delegate
	  shouldShowDelete:(BOOL)shouldShowDelete;

@property (nonatomic, retain) NSString *imageURL;
@property (nonatomic, retain) id<MSTablePicturePickerDelegate> pictureDelegate;
@property (nonatomic, assign) BOOL shouldShowDelete;

@end
