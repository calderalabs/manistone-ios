//
//  MSTableMessageItemCell.m
//  Manistone
//
//  Created by Eugenio Depalo on 07/11/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSTableMessageItemCell.h"

@implementation MSTableMessageItemCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)identifier {
	self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
	
	return self;
}

- (void)dealloc {
	TT_RELEASE_SAFELY(_item2);
	
	[super dealloc];
}

- (id)object {
	return _item2;
}

- (void)setObject:(id)object {
	if (_item != object) {
		[super setObject:object];
		
		TT_RELEASE_SAFELY(_item2);
		_item2 = [object retain];
		
		if(_item2.message.unread) {
			self.imageView.image = [UIImage imageNamed:@"unread.png"];
		}
		else {
			self.imageView.image = nil;
		}


    }
}

@end
