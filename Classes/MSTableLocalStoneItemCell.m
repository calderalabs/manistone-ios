//
//  MSTableLocalStoneItemCell.m
//  Manistone
//
//  Created by Eugenio Depalo on 12/01/11.
//  Copyright 2011 Lucido Inc. All rights reserved.
//

#import "MSTableLocalStoneItemCell.h"

@implementation MSTableLocalStoneItemCell

static CGFloat kHPadding = 10;
static CGFloat kVPadding = 5;

+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)item {
	MSTableLocalStoneItem *stoneItem = (MSTableLocalStoneItem *)item;
	
	return kVPadding * 2 + [stoneItem.stone.engraving sizeWithFont:[UIFont boldSystemFontOfSize:12]
												 constrainedToSize:CGSizeMake(tableView.width, CGFLOAT_MAX)].height + 50;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)identifier {
	if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier]) {
		self.textLabel.font = [UIFont boldSystemFontOfSize:12];
		self.textLabel.numberOfLines = 0;
		self.textLabel.backgroundColor = [UIColor clearColor];
		self.textLabel.highlightedTextColor = [UIColor blackColor];
		self.textLabel.textColor = [UIColor whiteColor];
		
		_engravingView = [[TTView alloc] initWithFrame:CGRectZero];
		_engravingView.backgroundColor = [UIColor clearColor];
		_engravingView.style = 		[TTShapeStyle styleWithShape:[TTRoundedRectangleShape shapeWithRadius:5] next:
									 [TTSolidBorderStyle styleWithColor:[UIColor clearColor] width:8 next:
									  [TTSolidFillStyle styleWithColor:RGBCOLOR(100, 100, 100) next:
									   nil]]];
		
		_dateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		_dateLabel.font = TTSTYLEVAR(tableDetailsFont);
		_dateLabel.textColor = [UIColor whiteColor];
		_dateLabel.backgroundColor = [UIColor clearColor];
		
		self.backgroundView = _engravingView;
		[self.contentView addSubview:_dateLabel];
	}
	
	return self;
}

- (void)dealloc {
	TT_RELEASE_SAFELY(_engravingView);
	TT_RELEASE_SAFELY(_dateLabel);
	TT_RELEASE_SAFELY(_item);
	
	[super dealloc];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	_engravingView.frame = self.contentView.frame;
	
	[_dateLabel sizeToFit];
	
	CGSize size = [self.textLabel.text sizeWithFont:self.textLabel.font
								  constrainedToSize:CGSizeMake(_engravingView.frame.size.width - (_engravingView.frame.origin.x + 5 + kHPadding) - kHPadding - 5,
															   _engravingView.frame.size.height - (8 + kVPadding) - _dateLabel.height - 25)];
	
	self.textLabel.frame = CGRectMake(_engravingView.frame.origin.x + 6 + kHPadding,
									  8 + kVPadding,
									  size.width,
									  size.height);
	
	_dateLabel.frame = CGRectMake(_engravingView.width - _dateLabel.width - 8 - kHPadding,
								  _engravingView.height - _dateLabel.height - 15 - kVPadding,
								  _dateLabel.width,
								  _dateLabel.height);
}

- (id)object {
	return _item;
}

- (void)setObject:(id)object {
	if (_item != object) {
		[super setObject:object];
		
		TT_RELEASE_SAFELY(_item);
		_item = [object retain];

		self.textLabel.text = _item.stone.engraving;
		_dateLabel.text = [_item.stone.createdAt formatRelativeTime];
    }
}

@end
