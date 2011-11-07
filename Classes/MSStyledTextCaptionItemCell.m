//
//  MSStyledTextCaptionItemCell.m
//  Manistone
//
//  Created by Eugenio Depalo on 10/11/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSStyledTextCaptionItemCell.h"
#import "MSStyledTextCaptionItem.h"
#import <Three20Style/UIFontAdditions.h>
#import <Three20UI/UITableViewAdditions.h>

@implementation MSStyledTextCaptionItemCell

static const CGFloat kKeySpacing = 12;
static const CGFloat kKeyWidth = 75;
static const CGFloat kDisclosureIndicatorWidth = 23;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if(self = [super initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:reuseIdentifier]) {
		self.textLabel.font = TTSTYLEVAR(tableTitleFont);
		self.textLabel.textColor = TTSTYLEVAR(linkTextColor);
		self.textLabel.highlightedTextColor = TTSTYLEVAR(highlightedTextColor);
		self.textLabel.textAlignment = UITextAlignmentRight;
		self.textLabel.lineBreakMode = UILineBreakModeTailTruncation;
		self.textLabel.numberOfLines = 1;
		self.textLabel.adjustsFontSizeToFitWidth = YES;
		
		_label.textColor = TTSTYLEVAR(textColor);
		_label.highlightedTextColor = TTSTYLEVAR(highlightedTextColor);
	}
	
	return self;
}

+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)object {
	TTTableStyledTextItem* item = object;
	
	CGFloat padding = [tableView tableCellMargin]*2 + item.padding.left + item.padding.right;
	if (item.URL) {
		padding += kDisclosureIndicatorWidth;
	}
	
	item.text.width = tableView.width - (padding + kKeyWidth + kKeySpacing);
	
	return item.text.height + item.padding.top + item.padding.bottom + kTableCellVPadding * 2;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	self.textLabel.frame = CGRectMake(kTableCellHPadding, floor((self.contentView.height - self.textLabel.font.ttLineHeight) / 2),
									  kKeyWidth, self.textLabel.font.ttLineHeight);
	
	_label.frame = CGRectMake(kKeyWidth + kKeySpacing + kTableCellHPadding, kTableCellVPadding, self.contentView.width - kKeyWidth - kKeySpacing - kTableCellHPadding, _label.height);
}

- (void)setObject:(id)object {
	if(object != _item) {
		[super setObject:object];
		
		MSStyledTextCaptionItem *item = (MSStyledTextCaptionItem *)_item;
		
		self.textLabel.text = item.caption;
	}
}

@end
