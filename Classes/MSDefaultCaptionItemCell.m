//
//  MSDefaultCaptionItemCell.m
//  Manistone
//
//  Created by Eugenio Depalo on 07/11/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSDefaultCaptionItemCell.h"

@implementation MSDefaultCaptionItemCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
	
	return self;
}

+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)object {
	return TT_TOOLBAR_HEIGHT;
}

- (void)setObject:(id)object {
	if (_item != object) {
		[super setObject:object];
		
		TTTableCaptionItem *item = (TTTableCaptionItem *)object;
		
		self.textLabel.text = item.caption;
		self.detailTextLabel.text = item.text;
    }
}

@end
