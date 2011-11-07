//
//  MSMessageListDataSource.m
//  Manistone
//
//  Created by Eugenio Depalo on 06/11/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSMessageListDataSource.h"
#import "MSMessage.h"
#import "MSTableMessageItem.h"
#import "MSTableMessageItemCell.h"
#import "MSSession.h"
#import "MSMemberRequest.h"

@implementation MSMessageListDataSource

- (NSString *)titleForEmpty {
	return NSLocalizedString(@"No messages in this folder", @"");
}

- (void)createModelWithParameters:(NSDictionary *)parameters {
	_searchModel = [[MSSearchModel alloc] initWithResource:[MSMessage class] parameters:parameters];
}

- (void)tableViewDidLoadModel:(UITableView*)tableView {	
	NSMutableArray* items = [[NSMutableArray alloc] init];
	
	for(MSMessage* message in _searchModel.results)
		[items addObject:[MSTableMessageItem itemWithMessage:message]];
	
	self.items = items;
	TT_RELEASE_SAFELY(items);
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([[self tableView:tableView objectForRowAtIndexPath:indexPath] isKindOfClass:[MSTableMessageItem class]])
		return YES;
	
	return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	TTTableMessageItem *item = [self tableView:tableView objectForRowAtIndexPath:indexPath];
	
	MSMessage *message = (MSMessage *)item.userInfo;
	
	if(editingStyle == UITableViewCellEditingStyleDelete) {
		MSMemberRequest *request = [[MSMemberRequest alloc] initWithResource:@"messages"
																	  member:[message.uid description]
																	  action:MSMemberRequestActionDelete
																  parameters:nil
																	delegate:self];
		
		request.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
							indexPath, @"indexPath",
							tableView, @"tableView", nil];
		
		[request send];
		
		TT_RELEASE_SAFELY(request);
		
		[((TTViewController *)[TTNavigator navigator].visibleViewController) startActivity:NSLocalizedString(@"Deleting message...", @"")];
	}
}

- (void)requestDidFinishLoad:(TTURLRequest *)request {
	[((TTViewController *)[TTNavigator navigator].visibleViewController) stopActivity];
	
	NSIndexPath *indexPath = [((NSDictionary *)request.userInfo) valueForKey:@"indexPath"];
	UITableView *tableView = [((NSDictionary *)request.userInfo) valueForKey:@"tableView"];
	
	[self.items removeObjectAtIndex:indexPath.row];
	[((MSSearchModel *)self.model).results removeObjectAtIndex:indexPath.row];
	
	[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
	
	TTTableViewDelegate *delegate = (TTTableViewDelegate *)tableView.delegate;
	[[delegate controller] invalidateView];
}

- (void)request:(TTURLRequest *)request didFailLoadWithError:(NSError *)error {
	[((TTViewController *)[TTNavigator navigator].visibleViewController) stopActivity];
}

- (Class)tableView:(UITableView*)tableView cellClassForObject:(id) object { 
	if ([object isKindOfClass:[MSTableMessageItem class]])
		return [MSTableMessageItemCell class];
	else
		return [super tableView:tableView cellClassForObject:object];
}

@end
