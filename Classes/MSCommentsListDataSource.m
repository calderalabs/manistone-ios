//
//  MSCommentsListDataSource.m
//  Manistone
//
//  Created by Eugenio Depalo on 28/10/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSCommentsListDataSource.h"
#import "MSComment.h"
#import "MSSession.h"
#import "MSMemberRequest.h"
#import "MSTableCommentItem.h"
#import "MSTableCommentItemCell.h"

@implementation MSCommentsListDataSource

- (NSString *)titleForEmpty {
	return NSLocalizedString(@"No comments found", @"");
}	

- (void)createModelWithParameters:(NSDictionary *)parameters {
	_searchModel = [[MSSearchModel alloc] initWithResource:[MSComment class] parameters:parameters];
}

- (void)tableViewDidLoadModel:(UITableView*)tableView {	
	NSMutableArray* items = [[NSMutableArray alloc] init];
	
	for(MSComment* comment in _searchModel.results) {
		MSTableCommentItem *item = [MSTableCommentItem itemWithComment:comment];
		
		item.URL = tableView.allowsSelection ? [comment.resource URLValueWithName:@"show"] : nil;
		
		[items addObject:item];
	}
	
	self.items = items;
	TT_RELEASE_SAFELY(items);
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	MSTableCommentItem *item = [self tableView:tableView objectForRowAtIndexPath:indexPath];
	
	if([item isKindOfClass:[MSTableCommentItem class]]) {
		return [item.comment.user.uid isEqualToNumber:[MSSession applicationSession].user.uid];
	}
	
	return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	MSTableCommentItem *item = [self tableView:tableView objectForRowAtIndexPath:indexPath];
	
	if(editingStyle == UITableViewCellEditingStyleDelete) {
		MSMemberRequest *request = [[MSMemberRequest alloc] initWithResource:@"comments"
																	  member:[item.comment.uid description]
																	  action:MSMemberRequestActionDelete
																  parameters:nil
																	delegate:self];
		
		request.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
							indexPath, @"indexPath",
							tableView, @"tableView", nil];
		
		[request send];
		
		TT_RELEASE_SAFELY(request);
		
		[((TTViewController *)[TTNavigator navigator].visibleViewController) startActivity:NSLocalizedString(@"Deleting comment...", @"")];
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
	if ([object isKindOfClass:[MSTableCommentItem class]])
		return [MSTableCommentItemCell class];
	else
		return [super tableView:tableView cellClassForObject:object];
}

@end
