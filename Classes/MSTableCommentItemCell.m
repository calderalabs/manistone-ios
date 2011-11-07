//
//  MSTableCommentItemCell.m
//  Manistone
//
//  Created by Eugenio Depalo on 13/01/11.
//  Copyright 2011 Lucido Inc. All rights reserved.
//

#import "MSTableCommentItemCell.h"

@implementation MSTableCommentItemCell

static CGFloat kHPadding = 10;
static CGFloat kVPadding = 5;

+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)item {
	MSTableCommentItem *commentItem = (MSTableCommentItem *)item;
	
	return kVPadding * 2 +
	[commentItem.text sizeWithFont:[UIFont systemFontOfSize:13]
												 constrainedToSize:CGSizeMake(tableView.width - kHPadding * 2, CGFLOAT_MAX)].height +
	[@"X" sizeWithFont:[UIFont boldSystemFontOfSize:12]].height + kVPadding * 3;
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
	}
	
	return self;
}

- (void)dealloc {
	TT_RELEASE_SAFELY(_timestampLabel);
	TT_RELEASE_SAFELY(_authorLabel);
	TT_RELEASE_SAFELY(_item2);
	
	[super dealloc];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	[_timestampLabel sizeToFit];

	CGSize size = [self.textLabel.text sizeWithFont:self.textLabel.font
								  constrainedToSize:CGSizeMake(self.contentView.width - kHPadding * 2,
															   self.contentView.height - kVPadding * 2 - _timestampLabel.height - kVPadding)];
	
	self.textLabel.frame = CGRectMake(kHPadding,
									  kVPadding,
									  size.width,
									  size.height);
	
	_timestampLabel.frame = CGRectMake(self.contentView.width - _timestampLabel.width - kHPadding,
									   self.contentView.height - _timestampLabel.height - kVPadding * 2,
									   _timestampLabel.width,
									   _timestampLabel.height);
	
	_authorLabel.frame = CGRectMake(kHPadding,
									   self.contentView.height - _timestampLabel.height - kVPadding * 2,
									   self.contentView.width - _timestampLabel.width - kHPadding * 2,
									   _timestampLabel.height);
}

- (id)object {
	return _item2;
}

- (void)setObject:(id)object {
	if (_item2 != object) {
		[super setObject:object];
		
		self.textLabel.font = [UIFont systemFontOfSize:13];
		self.textLabel.numberOfLines = 0;
		self.textLabel.backgroundColor = [UIColor clearColor];
		
		TT_RELEASE_SAFELY(_item2);
		_item2 = [object retain];
		
		self.textLabel.text = _item2.text;
		_timestampLabel.text = [_item2.comment.createdAt formatRelativeTime];
		_authorLabel.text = [TTStyledText textFromXHTML:[NSString stringWithFormat:@"<a href=\"%@\">%@</a>",
														 [_item2.comment.user URLValueWithName:@"show"],
														 _item2.comment.user.fullName]];
    }
}

@end
