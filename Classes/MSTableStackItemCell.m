//
//  MSTableStackItemCell.m
//  Manistone
//
//  Created by Eugenio Depalo on 21/10/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSTableStackItemCell.h"
#import "MSTableStackItem.h"

#import "NSNumber+MSAdditions.h"

@implementation MSTableStackItemCell

static CGFloat kHPadding = 10;
static CGFloat kVPadding = 5;
static CGFloat kTextHeight = 100;
static CGFloat kDetailViewWidth = 105;
static CGFloat kLabelVPadding = 3;
static CGFloat kLabelHeight = 15;

+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)item {
	return kVPadding * 2 + kTextHeight;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)identifier {
	if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier]) {
		_item = nil;
		
		self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		
		self.textLabel.backgroundColor = [UIColor clearColor];
		self.textLabel.font = [UIFont boldSystemFontOfSize:16];
		self.textLabel.textAlignment = UITextAlignmentRight;
		self.textLabel.highlightedTextColor = [UIColor blackColor];
		self.textLabel.numberOfLines = 0;
		
		_stonesCountLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		_stonesCountLabel.font = [UIFont boldSystemFontOfSize:12];
		_stonesCountLabel.backgroundColor = [UIColor clearColor];
		_stonesCountLabel.textAlignment = UITextAlignmentRight;
		
		[self.contentView addSubview:_stonesCountLabel];
		
		_dateLabel = [[TTStyledTextLabel alloc] initWithFrame:CGRectZero];
		_dateLabel.font = TTSTYLEVAR(tableDetailsFont);
		_dateLabel.backgroundColor = [UIColor clearColor];
		
		[self.contentView addSubview:_dateLabel];
		
		_authorLabel = [[TTStyledTextLabel alloc] initWithFrame:CGRectZero];
		_authorLabel.font = TTSTYLEVAR(tableDetailsFont);
		_authorLabel.backgroundColor = [UIColor clearColor];
		
		[self.contentView addSubview:_authorLabel];
		
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
		
		[self.contentView addSubview:_votesView];
		
		_commentsLabel = [[TTStyledTextLabel alloc] initWithFrame:CGRectZero];
		_commentsLabel.font = TTSTYLEVAR(tableDetailsFont);
		_commentsLabel.backgroundColor = [UIColor clearColor];
		
		[self.contentView addSubview:_commentsLabel];
		
		_viewsLabel = [[TTStyledTextLabel alloc] initWithFrame:CGRectZero];
		_viewsLabel.font = TTSTYLEVAR(tableDetailsFont);
		_viewsLabel.backgroundColor = [UIColor clearColor];
		
		[self.contentView addSubview:_viewsLabel];
		[self.contentView bringSubviewToFront:self.textLabel];
	}
	
	return self;
}

- (void)dealloc {
	TT_RELEASE_SAFELY(_stonesCountLabel);
	TT_RELEASE_SAFELY(_dateLabel);
	TT_RELEASE_SAFELY(_votesView);
	TT_RELEASE_SAFELY(_likeLabel);
	TT_RELEASE_SAFELY(_dislikeLabel);
	TT_RELEASE_SAFELY(_authorLabel);
	TT_RELEASE_SAFELY(_commentsLabel);
	TT_RELEASE_SAFELY(_viewsLabel);
	TT_RELEASE_SAFELY(_item);
	
	[super dealloc];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	self.contentView.frame = CGRectMake(kHPadding,
										kVPadding,
										self.contentView.frame.size.width - kHPadding * 2, 
										self.contentView.frame.size.height - kVPadding * 2);
	
	[_stonesCountLabel sizeToFit];
	
	_stonesCountLabel.frame = CGRectMake(kDetailViewWidth + kHPadding,
										 self.contentView.frame.size.height - _stonesCountLabel.height - kVPadding,
										 self.contentView.frame.size.width - kDetailViewWidth - kHPadding,
										 _stonesCountLabel.height);
	
	CGSize size = [self.textLabel.text sizeWithFont:self.textLabel.font
								   constrainedToSize:CGSizeMake(self.contentView.frame.size.width - kDetailViewWidth - kHPadding,
																self.contentView.frame.size.height - _stonesCountLabel.height - kVPadding * 2)];
	
	self.textLabel.frame = CGRectMake(kDetailViewWidth + kHPadding,
									  kVPadding,
									  self.contentView.frame.size.width - kDetailViewWidth - kHPadding,
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
		
		self.textLabel.text = _item.stack.name;
		_stonesCountLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%@ stones", @"Number of stones in stack table cell"), _item.stack.stonesCount];
		_dateLabel.text =[TTStyledText textFromXHTML:[NSString stringWithFormat:@"%@", [_item.stack.createdAt formatRelativeTime]]];
		_authorLabel.text = [TTStyledText textFromXHTML:[NSString stringWithFormat:@"<b>%@ %@</b>", _item.stack.user.name, _item.stack.user.surname]];
		_likeLabel.text = [TTStyledText textFromXHTML:[NSString stringWithFormat:@"<b>%@</b>", [_item.stack.likesCount shortStringValue]]];
		_dislikeLabel.text = [TTStyledText textFromXHTML:[NSString stringWithFormat:@"<b>%@</b>", [_item.stack.dislikesCount shortStringValue]]];
		_commentsLabel.text = [TTStyledText textFromXHTML:[NSString stringWithFormat:NSLocalizedString(@"<b>%@</b> comments", @"Number of comments in stack table cell"), [_item.stack.commentsCount shortStringValue]]];
		_viewsLabel.text = [TTStyledText textFromXHTML:[NSString stringWithFormat:NSLocalizedString(@"<b>%@</b> views", @"Number of views in stack table cell"), [_item.stack.viewsCount shortStringValue]]];
		
    }
}

@end
