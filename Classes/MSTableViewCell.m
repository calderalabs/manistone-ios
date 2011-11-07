//
//  MSTableViewCell.m
//  Manistone
//
//  Created by Eugenio Depalo on 11/10/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSTableViewCell.h"

@implementation MSTableViewCell

@synthesize item = _item;
@synthesize view = _view;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)identifier {
	if (self = [super initWithStyle:style reuseIdentifier:identifier]) {
		self.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	
	return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
	TT_RELEASE_SAFELY(_item);
	TT_RELEASE_SAFELY(_view);
	
	[super dealloc];
}


+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)object {
	TTTableViewItem *item = (TTTableViewItem *)object;
	
	return item.view.height;
}

- (id)object {
	return _item ? _item : (id)_view;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setObject:(id)object {
	if (object != _view && object != _item) {
		[_view removeFromSuperview];
		TT_RELEASE_SAFELY(_view);
		TT_RELEASE_SAFELY(_item);
		
		if ([object isKindOfClass:[UIView class]]) {
			_view = [object retain];
		} else if ([object isKindOfClass:[TTTableViewItem class]]) {
			_item = [object retain];
			_view = [_item.view retain];
		}
		
		[self.contentView addSubview:_view];
	}
}

@end
