//
//  MSTableAuthorItemCell.m
//  Manistone
//
//  Created by Eugenio Depalo on 31/10/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSTableAuthorItemCell.h"

#import "NSNumber+MSAdditions.h"

static CGFloat kHPadding = 10;
static CGFloat kVPadding = 5;
static CGFloat kLabelHeight = 18;

@implementation MSTableAuthorItemCell

+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)item {
	return kVPadding * 2 + 90;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		
		_stonesLabel = [[TTStyledTextLabel alloc] initWithFrame:CGRectZero];
		_stonesLabel.backgroundColor = [UIColor clearColor];
		
		[self.contentView addSubview:_stonesLabel];
		
		_followersLabel = [[TTStyledTextLabel alloc] initWithFrame:CGRectZero];
		_followersLabel.backgroundColor = [UIColor clearColor];
		
		[self.contentView addSubview:_followersLabel];
		
		_locationLabel = [[TTStyledTextLabel alloc] initWithFrame:CGRectZero];
		_locationLabel.backgroundColor = [UIColor clearColor];
		
		[self.contentView addSubview:_locationLabel];
		
		self.textLabel.font = [UIFont boldSystemFontOfSize:12];
		self.textLabel.highlightedTextColor = [UIColor blackColor];
	}
	
	return self;
}

- (void)dealloc {
	TT_RELEASE_SAFELY(_stonesLabel);
	TT_RELEASE_SAFELY(_followersLabel);
	TT_RELEASE_SAFELY(_locationLabel);
	TT_RELEASE_SAFELY(_item2);
	
	[super dealloc];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	self.contentView.frame = CGRectMake(kHPadding,
										kVPadding,
										self.contentView.frame.size.width - kHPadding * 2, 
										self.contentView.frame.size.height - kVPadding * 2);
	
	CGFloat detailsX = _imageView2.width + kVPadding + 15;
	CGFloat detailsWidth = self.contentView.width - detailsX;
	
	[self.textLabel sizeToFit];
	
	self.textLabel.frame = CGRectMake(detailsX,
									  3,
									  self.textLabel.width,
									  self.textLabel.height);
	
	_stonesLabel.frame = CGRectMake(detailsX, self.textLabel.bottom + kVPadding, detailsWidth, kLabelHeight);
	
	_followersLabel.frame = CGRectMake(detailsX,
									_stonesLabel.frame.origin.y + _stonesLabel.frame.size.height,
									detailsWidth,
									kLabelHeight);
	
	_locationLabel.frame = CGRectMake(detailsX,
									   _followersLabel.frame.origin.y + _followersLabel.frame.size.height,
									   detailsWidth,
									   kLabelHeight);
}

- (id)object {
	return _item2;
}

- (void)setObject:(id)object {
	if (_item2 != object) {
		[super setObject:object];
		
		TT_RELEASE_SAFELY(_item2);
		_item2 = [object retain];
		
		self.textLabel.text = _item2.author.fullName;
		_stonesLabel.text = [TTStyledText textFromXHTML:[NSString stringWithFormat:NSLocalizedString(@"<b>%@</b> stones", @"Number of stones in author table cell"), _item2.author.stonesCount]];
		_followersLabel.text = [TTStyledText textFromXHTML:[NSString stringWithFormat:NSLocalizedString(@"<b>%@</b> followers", @"Number of followers in author table cell"), _item2.author.followersCount]];
		
		_locationLabel.text = [TTStyledText textFromXHTML:[NSString stringWithFormat:NSLocalizedString(@"<b>Hometown:</b> %@", @""), _item2.author.hometown]];
		
		if(TTIsStringWithAnyText(_item2.author.hometown))
			_locationLabel.hidden = NO;
		else
			_locationLabel.hidden = YES;
    }
}


@end
