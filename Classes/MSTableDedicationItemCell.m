//
//  MSTableDedicationItemCell.m
//  Manistone
//
//  Created by Eugenio Depalo on 15/01/11.
//  Copyright 2011 Lucido Inc. All rights reserved.
//

#import "MSTableDedicationItemCell.h"

@implementation MSTableDedicationItemCell

static CGFloat kHPadding = 10;
static CGFloat kVPadding = 5;

+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)item {
	return 120;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)identifier {
	if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier]) {
		_timestampLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		_timestampLabel.font = [UIFont boldSystemFontOfSize:12];
		_timestampLabel.backgroundColor = [UIColor clearColor];
		
		_authorLabel = [[TTStyledTextLabel alloc] initWithFrame:CGRectZero];
		_authorLabel.font = [UIFont boldSystemFontOfSize:12];
		_authorLabel.textColor = [UIColor blackColor];
		_authorLabel.backgroundColor = [UIColor clearColor];
		
		[self.contentView addSubview:_timestampLabel];
		[self.contentView addSubview:_authorLabel];
		
		_engravingView = [[TTView alloc] initWithFrame:CGRectZero];
		_engravingView.backgroundColor = [UIColor clearColor];
		_engravingView.style = [TTShapeStyle styleWithShape:[TTRoundedRectangleShape shapeWithRadius:6] next:
								[TTSolidBorderStyle styleWithColor:[UIColor clearColor] width:8 next:[TTSolidFillStyle styleWithColor:RGBCOLOR(100, 100, 100) next:
																										 nil	]]];
		
		[self.contentView insertSubview:_engravingView atIndex:0];
		
		self.backgroundView = [[[UIView alloc] initWithFrame:self.frame] autorelease];
	}
	
	return self;
}

- (void)dealloc {
	TT_RELEASE_SAFELY(_timestampLabel);
	TT_RELEASE_SAFELY(_authorLabel);
	TT_RELEASE_SAFELY(_item2);
	TT_RELEASE_SAFELY(_engravingView);
	
	[super dealloc];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	[_timestampLabel sizeToFit];
	
	_engravingView.frame = CGRectMake(0, 0, self.contentView.width, 90);
	
	_authorLabel.width = [_item2.dedication.user.fullName sizeWithFont:_authorLabel.font].width;
	[_authorLabel sizeToFit];
	
	CGSize size = [self.textLabel.text sizeWithFont:self.textLabel.font
								  constrainedToSize:CGSizeMake(self.contentView.width - kHPadding * 2 - 10,
															   90 - kVPadding * 2 - 10)];
	
	self.textLabel.frame = CGRectMake(kHPadding + 8,
									  kVPadding + 8,
									  size.width,
									  size.height);
	
	_timestampLabel.frame = CGRectMake(self.contentView.width - _timestampLabel.width - kHPadding,
									   self.contentView.height - _timestampLabel.height - kVPadding - 6,
									   _timestampLabel.width,
									   _timestampLabel.height);
	
	_authorLabel.frame = CGRectMake(kHPadding,
									self.contentView.height - _authorLabel.height - kVPadding - 6,
									_authorLabel.width,
									_authorLabel.height);
}

- (id)object {
	return _item2;
}

- (void)setObject:(id)object {
	if (_item2 != object) {
		[super setObject:object];
		
		self.textLabel.font = [UIFont boldSystemFontOfSize:12];
		self.textLabel.numberOfLines = 0;
		self.textLabel.backgroundColor = [UIColor clearColor];
		self.textLabel.highlightedTextColor = [UIColor blackColor];
		self.textLabel.textColor = [UIColor whiteColor];
		
		self.accessoryType = UITableViewCellAccessoryNone;
		
		TT_RELEASE_SAFELY(_item2);
		_item2 = [object retain];
		
		self.textLabel.text = _item2.text;
		_timestampLabel.text = [_item2.dedication.createdAt formatRelativeTime];
		_authorLabel.text = [TTStyledText textFromXHTML:[NSString stringWithFormat:@"<a href=\"%@\">%@</a>",
														 [_item2.dedication.user URLValueWithName:@"show"],
														 _item2.dedication.user.fullName]];
		_authorLabel.text.font = _authorLabel.font;
		
		self.backgroundView.backgroundColor = _item2.dedication.unread ? RGBCOLOR(255, 239, 215) : [UIColor whiteColor];
    }
}

@end
