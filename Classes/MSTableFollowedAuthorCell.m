//
//  MSTableFollowedAuthorCell.m
//  Manistone
//
//  Created by Eugenio Depalo on 09/11/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSTableFollowedAuthorCell.h"

static CGFloat kMinWidth = 25;

@implementation MSTableFollowedAuthorCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		_item2 = nil;
		
		_unreadBadge = [[TTView alloc] initWithFrame:CGRectZero];
		
		_unreadBadge.style =
			[TTShapeStyle styleWithShape:[TTRoundedRectangleShape shapeWithRadius:TT_ROUNDED] next:
			  [TTSolidFillStyle styleWithColor:TTSTYLEVAR(controlTintColor) next:nil]];
		
		_unreadLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		
		_unreadBadge.backgroundColor = [UIColor clearColor];
		
		_unreadLabel.textColor = [UIColor whiteColor];
		_unreadLabel.backgroundColor = [UIColor clearColor];
		_unreadLabel.font = [UIFont boldSystemFontOfSize:14];
		_unreadLabel.textAlignment = UITextAlignmentCenter;
		
		[self.contentView addSubview:_unreadBadge];
		[self.contentView addSubview:_unreadLabel];
	}
	
	return self;
}

- (void)dealloc {
	TT_RELEASE_SAFELY(_unreadBadge);
	TT_RELEASE_SAFELY(_unreadLabel);
	TT_RELEASE_SAFELY(_item2);
	
	[super dealloc];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	[_unreadLabel sizeToFit];
	
	if(_unreadLabel.width < kMinWidth)
		_unreadLabel.width = kMinWidth;
	
	_unreadBadge.frame = CGRectMake(self.contentView.right - _unreadLabel.width - 30,
									floor((self.contentView.height - (_unreadLabel.height + 5)) / 2),
									_unreadLabel.width + 20,
									_unreadLabel.height + 10);
	
	_unreadLabel.center = _unreadBadge.center;
	
	_unreadLabel.frame = CGRectIntegral(_unreadLabel.frame);
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
		
		_unreadLabel.text = [_item2.author.unreadCount description];
		
		if([_item2.author.unreadCount intValue] == 0) {
			_unreadBadge.hidden = YES;
			_unreadLabel.hidden = YES;
		}
		else {
			_unreadBadge.hidden = NO;
			_unreadLabel.hidden = NO;
		}
    }
}

@end
