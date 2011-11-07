//
//  MSFavoritesDataSource.m
//  Manistone
//
//  Created by Eugenio Depalo on 04/11/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSFavoritesDataSource.h"
#import "MSFavoritesModel.h"
#import "MSTableCollectionLinkItem.h"
#import "MSTableCollectionLinkItemCell.h"
#import "MSSession.h"

@implementation MSFavoritesDataSource

- (id)initWithUid:(NSUInteger)uid {
	if(self = [self initWithItems:nil]) {
		_uid = uid;
		_favoritesModel = [[MSFavoritesModel alloc] initWithUid:uid];
	}
	
	return self;
}

- (id<TTModel>)model {
	return _favoritesModel;
}

- (void)dealloc {
	TT_RELEASE_SAFELY(_favoritesModel);
	
	[super dealloc];
}

- (void)tableViewDidLoadModel:(UITableView*)tableView {
	self.items = [NSArray arrayWithObjects:
				  [MSTableCollectionLinkItem itemWithText:NSLocalizedString(@"Stones", @"")
												 imageURL:@"stones.png"
													count:_favoritesModel.stonesCount
													  URL:[NSString stringWithFormat:@"tt://stones/%@", [@"Favorite Stones" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
												 userInfo:[NSDictionary dictionaryWithObject:
														   [NSDictionary dictionaryWithObject:[NSNumber numberWithUnsignedInteger:_uid] forKey:@"favorited_by_user_id"]
																					  forKey:@"parameters"]],
				  [MSTableCollectionLinkItem itemWithText:NSLocalizedString(@"Stacks", @"")
												 imageURL:@"stack.png"
													count:_favoritesModel.stacksCount
													  URL:@"tt://stacks"
												 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
														   NSLocalizedString(@"Favorite Stacks", @""), @"title",
														   [NSDictionary dictionaryWithObject:[NSNumber numberWithUnsignedInteger:_uid]
																					   forKey:@"favorited_by_user_id"], @"parameters", nil]],
				  [MSTableCollectionLinkItem itemWithText:NSLocalizedString(@"Authors", @"")
												 imageURL:@"authors.png"
													count:_favoritesModel.authorsCount
													  URL:@"tt://authors"
												 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
														   NSLocalizedString(@"Favorite Authors", @""), @"title",
														   [NSDictionary dictionaryWithObject:[NSNumber numberWithUnsignedInteger:_uid] forKey:@"favorited_by_user_id"], @"parameters",
														   nil]], nil];
}

- (Class)tableView:(UITableView*)tableView cellClassForObject:(id)object {
	if([object isKindOfClass:[MSTableCollectionLinkItem class]])
		return [MSTableCollectionLinkItemCell class];
	
	return [super tableView:tableView cellClassForObject:object];
}

@end
