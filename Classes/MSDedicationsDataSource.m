//
//  MSDedicationsDataSource.m
//  Manistone
//
//  Created by Eugenio Depalo on 05/11/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSDedicationsDataSource.h"
#import "MSDedication.h"
#import "MSTableDedicationItem.h"
#import "MSTableDedicationItemCell.h"
#import "MSMemberRequest.h"

@implementation MSDedicationsDataSource

- (void)createModelWithParameters:(NSDictionary *)parameters {
	_searchModel = [[MSSearchModel alloc] initWithResource:[MSDedication class] parameters:nil];
}

- (void)tableViewDidLoadModel:(UITableView*)tableView {	
	NSMutableArray* items = [[NSMutableArray alloc] init];
	
	for(MSDedication *dedication in _searchModel.results) {
		MSTableDedicationItem *item = [MSTableDedicationItem itemWithDedication:dedication];

		[items addObject:item];
	}
	
	self.items = items;
	TT_RELEASE_SAFELY(items);
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	MSTableDedicationItem *item = [self tableView:tableView objectForRowAtIndexPath:indexPath];
	
	if([item isKindOfClass:[MSTableDedicationItem class]])
		return YES;
	
	return NO;
}

- (NSString *)titleForEmpty {
	return NSLocalizedString(@"You have no dedications", @"");
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	MSTableDedicationItem *item = [self tableView:tableView objectForRowAtIndexPath:indexPath];
	
	if(editingStyle == UITableViewCellEditingStyleDelete) {
		MSMemberRequest *request = [[MSMemberRequest alloc] initWithResource:@"dedications"
																	  member:[item.dedication.uid description]
																	  action:MSMemberRequestActionDelete
																  parameters:nil
																	delegate:self];
		
		request.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
							indexPath, @"indexPath",
							tableView, @"tableView", nil];
		
		[request send];
		
		TT_RELEASE_SAFELY(request);
		
		[((TTViewController *)[TTNavigator navigator].visibleViewController) startActivity:NSLocalizedString(@"Deleting dedication...", @"")];
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

- (Class)tableView:(UITableView*)tableView cellClassForObject:(id)object {
	if([object isKindOfClass:[MSTableDedicationItem class]])
		return [MSTableDedicationItemCell class];
	
	return [super tableView:tableView cellClassForObject:object];
}

@end
