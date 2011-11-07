//
//  MSMessageDataSource.m
//  Manistone
//
//  Created by Eugenio Depalo on 06/11/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSMessageDataSource.h"
#import "MSMessage.h"
#import "MSUser.h"

@implementation MSMessageDataSource

@synthesize remoteObjectModel = _remoteObjectModel;

- (id)initWithUid:(NSUInteger)uid {
	if(self = [self init]) {
		_remoteObjectModel = [[MSRemoteObjectModel alloc] initWithResource:[MSMessage class] uid:uid];
	}
	
	return self;
}

- (void)dealloc {
	TT_RELEASE_SAFELY(_remoteObjectModel);
	
	[super dealloc];
}

- (id<TTModel>)model {
	return _remoteObjectModel;
}

- (UIImage*)imageForEmpty
{
	return [UIImage imageNamed:@"Three20.bundle/images/empty.png"];
}

- (UIImage*)imageForError:(NSError*)error
{
    return [UIImage imageNamed:@"Three20.bundle/images/error.png"];
}

- (void)tableViewDidLoadModel:(UITableView*)tableView {
	MSMessage *message = (MSMessage *)_remoteObjectModel.remoteObject;
	
	NSMutableArray *fullNames = [[NSMutableArray alloc] init];
	
	for(MSUser *recipient in message.recipients)
		[fullNames addObject:recipient.fullName];
	
	self.items = [NSArray arrayWithObjects:[TTTableCaptionItem itemWithText:message.subject caption:NSLocalizedString(@"Subject", @"")],
				  [TTTableCaptionItem itemWithText:message.user.fullName caption:NSLocalizedString(@"From", @"")],
				  [TTTableCaptionItem itemWithText:[fullNames componentsJoinedByString:@", "] caption:NSLocalizedString(@"To", @"")],
				  nil];
	
	TT_RELEASE_SAFELY(fullNames);
	
	UIView *footerView = [[UIView alloc] initWithFrame:CGRectZero];
	UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	textLabel.numberOfLines = 0;
	textLabel.text = message.text;
	
	CGSize size = [textLabel.text sizeWithFont:textLabel.font constrainedToSize:CGSizeMake(TTApplicationFrame().size.width - 20, CGFLOAT_MAX)];
	
	textLabel.frame = CGRectMake(10, 10, size.width, size.height);
	footerView.frame = CGRectMake(0, 0, TTApplicationFrame().size.width, size.height + 20);
	
	[footerView addSubview:textLabel];
	
	TT_RELEASE_SAFELY(textLabel);
	
	tableView.tableFooterView = footerView;
	
	TT_RELEASE_SAFELY(footerView);
}	

@end
