//
//  MSTableStoneItemCell.m
//  Manistone
//
//  Created by Eugenio Depalo on 11/09/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSTableStoneItemCell.h"
#import "MSTableStoneItem.h"

#import "NSNumber+MSAdditions.h"

static CGFloat kHPadding = 10;
static CGFloat kVPadding = 5;
static CGFloat kTextHeight = 100;
static CGFloat kDetailViewWidth = 105;
static CGFloat kLabelVPadding = 3;
static CGFloat kLabelHeight = 15;

@implementation MSTableStoneItemCell

+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)item {
	return kVPadding * 2 + kTextHeight;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)identifier {
	if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier]) {
		_innerView = [[UIView alloc] initWithFrame:CGRectZero];
		
		self.backgroundView = [[[UIView alloc] initWithFrame:self.frame] autorelease];
		
		self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		
		self.textLabel.font = [UIFont boldSystemFontOfSize:12];
		self.textLabel.numberOfLines = 0;
		self.textLabel.backgroundColor = [UIColor clearColor];
		self.textLabel.highlightedTextColor = [UIColor blackColor];
		self.textLabel.textColor = [UIColor whiteColor];
		
		_engravingView = [[TTView alloc] initWithFrame:CGRectZero];
		_engravingView.backgroundColor = [UIColor clearColor];
		_engravingView.style = [TTShapeStyle styleWithShape:[TTRoundedRectangleShape shapeWithRadius:6] next:
								[TTSolidBorderStyle styleWithColor:RGBCOLOR(200, 200, 200) width:3 next:[TTSolidFillStyle styleWithColor:RGBCOLOR(100, 100, 100) next:
																										 nil	]]];
		
		[_innerView addSubview:_engravingView];
		
		_dateLabel = [[TTStyledTextLabel alloc] initWithFrame:CGRectZero];
		_dateLabel.font = TTSTYLEVAR(tableDetailsFont);
		_dateLabel.backgroundColor = [UIColor clearColor];
		
		[_innerView addSubview:_dateLabel];
		
		_authorLabel = [[TTStyledTextLabel alloc] initWithFrame:CGRectZero];
		_authorLabel.font = TTSTYLEVAR(tableDetailsFont);
		_authorLabel.backgroundColor = [UIColor clearColor];
		
		[_innerView addSubview:_authorLabel];
		
		_votesView = [[TTView alloc] initWithFrame:CGRectZero];
		_votesView.backgroundColor = [UIColor clearColor];
		
		UIImageView *thumbsUpView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"thumbs-up.png"]];
		thumbsUpView.contentMode = UIViewContentModeScaleAspectFit;
		thumbsUpView.frame = CGRectMake(0, 0, 20, 20);
		
		_likeLabel = [[TTStyledTextLabel alloc] initWithFrame:CGRectMake(thumbsUpView.frame.size.width + 4, 3, 30, 30)];
		_likeLabel.font = TTSTYLEVAR(tableDetailsFont);
		_likeLabel.backgroundColor = [UIColor clearColor];
		
		UIImageView *thumbsDownView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"thumbs-down.png"]];
		thumbsDownView.contentMode = UIViewContentModeScaleAspectFit;
		thumbsDownView.frame = CGRectMake(_likeLabel.frame.origin.x + _likeLabel.frame.size.width + 3, 3, 20, 20);
		
		_dislikeLabel = [[TTStyledTextLabel alloc] initWithFrame:CGRectMake(thumbsDownView.frame.origin.x + thumbsDownView.frame.size.width + 4, 3, 30, 30)];
		_dislikeLabel.font = TTSTYLEVAR(tableDetailsFont);
		_dislikeLabel.backgroundColor = [UIColor clearColor];
		
		[_votesView addSubview:thumbsUpView];
		[_votesView addSubview:thumbsDownView];
		
		TT_RELEASE_SAFELY(thumbsUpView);
		TT_RELEASE_SAFELY(thumbsDownView);
		
		[_votesView addSubview:_likeLabel];
		[_votesView addSubview:_dislikeLabel];
		
		[_innerView addSubview:_votesView];
		
		_commentsLabel = [[TTStyledTextLabel alloc] initWithFrame:CGRectZero];
		_commentsLabel.font = TTSTYLEVAR(tableDetailsFont);
		_commentsLabel.backgroundColor = [UIColor clearColor];
		
		[_innerView addSubview:_commentsLabel];
		
		_viewsLabel = [[TTStyledTextLabel alloc] initWithFrame:CGRectZero];
		_viewsLabel.font = TTSTYLEVAR(tableDetailsFont);
		_viewsLabel.backgroundColor = [UIColor clearColor];
		
		[_innerView addSubview:_viewsLabel];
		[_innerView bringSubviewToFront:self.textLabel];
		
		[self.contentView insertSubview:_innerView atIndex:0];
	}
	
	return self;
}

- (void)dealloc {
	TT_RELEASE_SAFELY(_engravingView);
	TT_RELEASE_SAFELY(_dateLabel);
	TT_RELEASE_SAFELY(_votesView);
	TT_RELEASE_SAFELY(_likeLabel);
	TT_RELEASE_SAFELY(_dislikeLabel);
	TT_RELEASE_SAFELY(_authorLabel);
	TT_RELEASE_SAFELY(_commentsLabel);
	TT_RELEASE_SAFELY(_viewsLabel);
	TT_RELEASE_SAFELY(_innerView);
	TT_RELEASE_SAFELY(_item);
	
	[super dealloc];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	CGFloat rightOverflow = ![((UITableView *)[self superview]) isEditing] ? 25 : 0;
	
	_innerView.frame = CGRectMake(kHPadding,
								  kVPadding,
										self.contentView.frame.size.width - kHPadding * 2, 
										self.contentView.frame.size.height - kVPadding * 2);
	
	_engravingView.frame = CGRectMake(kDetailViewWidth + kHPadding,
									  0,
									  _innerView.frame.size.width - kDetailViewWidth - kHPadding + rightOverflow,
									  _innerView.frame.size.height);
	
	CGSize size = [self.textLabel.text sizeWithFont:self.textLabel.font
								  constrainedToSize:CGSizeMake(_engravingView.frame.size.width - rightOverflow - kHPadding,
															   _engravingView.frame.size.height - 10 - kVPadding)];
	
	self.textLabel.frame = CGRectMake(_engravingView.frame.origin.x + 8 + kHPadding,
									  5 + kVPadding,
									  size.width,
									  size.height);
	
	_dateLabel.frame = CGRectMake(0, 3, kDetailViewWidth, kLabelHeight);
	
	_authorLabel.frame = CGRectMake(0,
									_dateLabel.frame.origin.y + _dateLabel.frame.size.height,
									kDetailViewWidth,
									kLabelHeight);
	
	
	_votesView.frame = CGRectMake(0, _authorLabel.frame.origin.y + _authorLabel.frame.size.height + kLabelVPadding,
								  kDetailViewWidth - kHPadding,
								  kLabelHeight);
	
	_commentsLabel.frame = CGRectMake(0,
									  _votesView.frame.origin.y + _votesView.frame.size.height + 15,
									  kDetailViewWidth - kHPadding,
									  kLabelHeight);
	
	_viewsLabel.frame = CGRectMake(0,
								   _commentsLabel.frame.origin.y + _commentsLabel.frame.size.height,
								   kDetailViewWidth - kHPadding,
								   kLabelHeight);
}

- (id)object {
	return _item;
}

- (void)setObject:(id)object {
	if (_item != object) {
		[super setObject:object];
		
		TT_RELEASE_SAFELY(_item);
		_item = [object retain];
		
		self.backgroundView.backgroundColor = _item.markUnread && _item.stone.unread ? RGBCOLOR(255, 239, 215) : [UIColor whiteColor];
		
		self.textLabel.text = _item.stone.engraving;
		_dateLabel.text =[TTStyledText textFromXHTML:[NSString stringWithFormat:@"%@", [_item.stone.createdAt formatRelativeTime]]];
		_authorLabel.text = [TTStyledText textFromXHTML:[NSString stringWithFormat:@"<b>%@ %@</b>", _item.stone.user.name, _item.stone.user.surname]];
		_likeLabel.text = [TTStyledText textFromXHTML:[NSString stringWithFormat:@"<b>%@</b>", [_item.stone.likesCount shortStringValue]]];
		_dislikeLabel.text = [TTStyledText textFromXHTML:[NSString stringWithFormat:@"<b>%@</b>", [_item.stone.dislikesCount shortStringValue]]];
		_commentsLabel.text = [TTStyledText textFromXHTML:[NSString stringWithFormat:NSLocalizedString(@"<b>%@</b> comments", @"Number of comments in stone table cell"), [_item.stone.commentsCount shortStringValue]]];
		_viewsLabel.text = [TTStyledText textFromXHTML:[NSString stringWithFormat:NSLocalizedString(@"<b>%@</b> views", @"Number of views in stone table cell"), [_item.stone.viewsCount shortStringValue]]];
    }
}

@end
