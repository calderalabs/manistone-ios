//
//  MSTablePicturePickerItem.m
//  Manistone
//
//  Created by Eugenio Depalo on 07/11/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSTablePicturePickerItem.h"

@implementation MSTablePicturePickerItem

@synthesize imageURL = _imageURL;
@synthesize pictureDelegate = _pictureDelegate;
@synthesize shouldShowDelete = _shouldShowDelete;

+ (id)itemWithImageURL:(NSString *)imageURL
			   caption:(NSString *)caption
			  delegate:(id<MSTablePicturePickerDelegate>)delegate
	  shouldShowDelete:(BOOL)shouldShowDelete {
	MSTablePicturePickerItem *item = [[[self alloc] init] autorelease];
	item.text = caption;
	item.imageURL = imageURL;
	item.pictureDelegate = delegate;
	item.shouldShowDelete = shouldShowDelete;
	
	return item;
}

- (void)dealloc {
	TT_RELEASE_SAFELY(_imageURL);
	TT_RELEASE_SAFELY(_pictureDelegate);
	
	[super dealloc];
}

@end
