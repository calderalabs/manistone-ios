//
//  MSTableSubItemsCell.m
//  Manistone
//
//  Created by Eugenio Depalo on 10/10/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSTableSubItemsCell.h"
#import "MSTableSubItemsItem.h"

@implementation MSTableSubItemsCell

@synthesize arrowView = _arrowView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)identifier {
	if (self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier]) {
		_item = nil;
		
		_arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.png"]];
		
		[self.contentView addSubview:_arrowView];
	}
	
	return self;
}

- (void)dealloc {
	TT_RELEASE_SAFELY(_arrowView);
	
	[super dealloc];
}

- (void)layoutSubviews {
	[super layoutSubviews];

	_arrowView.frame = CGRectMake(self.contentView.width - _arrowView.width - 10,
								  floor((self.contentView.height - _arrowView.height) / 2),
								  _arrowView.width,
								  _arrowView.height);
	
	self.textLabel.frame = CGRectMake(self.imageView.image ? (self.imageView.right + 10) : self.textLabel.origin.x,
									  self.textLabel.origin.y,
									  self.imageView.image ? self.textLabel.width - (self.imageView.right + 10) : self.textLabel.width,
									  self.textLabel.height);
}

- (void)toggleShown {
	MSTableSubItemsItem *item = (MSTableSubItemsItem *)_item;
	
	item.shown = !item.shown;
	
	[UIView beginAnimations:nil context:_arrowView];
	[UIView setAnimationDuration:0.3];
	
	_arrowView.transform = CGAffineTransformMakeRotation((item.shown ? 0.99999f * M_PI : 0));
	
	[UIView commitAnimations];
}

- (void)setObject:(id)object {
	if (_item != object) {
		[super setObject:object];
		
		self.textLabel.font = TTSTYLEVAR(tableFont);
		self.textLabel.textColor = TTSTYLEVAR(linkTextColor);
		self.selectionStyle = UITableViewCellSelectionStyleBlue;
		
		MSTableSubItemsItem *item = (MSTableSubItemsItem *)_item;
		self.imageView.image = [UIImage imageNamed:item.imageURL];
		
		_arrowView.transform = CGAffineTransformMakeRotation((item.shown ? 0.99999f * M_PI : 0));
	}
}

@end
