//
//  MSStackDataSource.m
//  Manistone
//
//  Created by Eugenio Depalo on 26/10/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSStackDataSource.h"
#import "MSStack.h"
#import "MSTag.h"
#import "MSTableViewCell.h"
#import "MSCollectionRequest.h"
#import "MSMemberRequest.h"
#import "MSSession.h"
#import "MSTableSubItemsItem.h"
#import "MSTableStoneItem.h"
#import "MSTableStoneItemCell.h"
#import "TTTableTextItem+MSAdditions.h"
#import "MSTableCollectionLinkItem.h"
#import "MSTableCollectionLinkItemCell.h"
#import "MSDeleteResourceDelegate.h"
#import "MSTableAuthorItem.h"
#import "MSTableAuthorSmallCell.h"

static const CGFloat kFooterWidth = 260;
static const CGFloat kButtonHeight = 50;
static const CGFloat kVPadding = 10;
static const CGFloat kHPadding = 10;

@implementation MSStackDataSource

@synthesize remoteObjectModel = _remoteObjectModel;

- (id)initWithUid:(NSUInteger)uid {
	if(self = [self init]) {
		_remoteObjectModel = [[MSRemoteObjectModel alloc] initWithResource:[MSStack class] uid:uid];
	}
	
	return self;
}

- (void)dealloc {
	TT_RELEASE_SAFELY(_remoteObjectModel);
	TT_RELEASE_SAFELY(_detailsItem);
	
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
	MSStack *stack = (MSStack *)_remoteObjectModel.remoteObject;
	
	UIView *actionsContainerView = [[UIView alloc] initWithFrame:CGRectZero];
	UIView *actionsView = [[UIView alloc] initWithFrame:CGRectMake(floor((tableView.width - kFooterWidth) / 2), 0, kFooterWidth, 0)];
	
	[actionsContainerView addSubview:actionsView];
	
	UIButton *showButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[showButton setTitle:@"Show in map" forState:UIControlStateNormal];
	[showButton setImage:[UIImage imageNamed:@"map.png"] forState:UIControlStateNormal];
	[showButton setTitleColor:TTSTYLEVAR(linkTextColor) forState:UIControlStateNormal];
	showButton.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
	showButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
	[showButton addTarget:self action:@selector(showMap:) forControlEvents:UIControlEventTouchUpInside];
	
	showButton.frame = CGRectMake(0, 20, kFooterWidth, 40);
	
	[actionsView addSubview:showButton];
	
	UIButton *likeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[likeButton setImage:[UIImage imageNamed:stack.liked ? @"thumbs-up-small-active.png" : @"thumbs-up-small.png"] forState:UIControlStateNormal];
	likeButton.frame = CGRectMake(0, showButton.bottom + kVPadding, 40, 40);
	[likeButton addTarget:self action:@selector(like:) forControlEvents:UIControlEventTouchUpInside];
	[actionsView addSubview:likeButton];
	
	UIButton *dislikeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[dislikeButton setImage:[UIImage imageNamed:stack.disliked ? @"thumbs-down-small-active.png" : @"thumbs-down-small.png"] forState:UIControlStateNormal];
	dislikeButton.frame = CGRectMake(likeButton.right + kHPadding, showButton.bottom + kVPadding, 40, 40);
	[dislikeButton addTarget:self action:@selector(dislike:) forControlEvents:UIControlEventTouchUpInside];
	[actionsView addSubview:dislikeButton];
	
	UIButton *favoriteButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[favoriteButton setTitleColor:TTSTYLEVAR(linkTextColor) forState:UIControlStateNormal];
	[favoriteButton setImage:[UIImage imageNamed:stack.favorited? @"favorite-active.png" : @"favorite.png"] forState:UIControlStateNormal];
	favoriteButton.frame = CGRectMake(dislikeButton.right + kHPadding, showButton.bottom + kVPadding, kFooterWidth - (dislikeButton.right + kHPadding), 40);
	[favoriteButton setTitle:NSLocalizedString(@"Favorite", @"") forState:UIControlStateNormal];
	[favoriteButton setTitleColor:TTSTYLEVAR(linkTextColor) forState:UIControlStateNormal];
	favoriteButton.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
	favoriteButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
	[favoriteButton addTarget:self action:@selector(favorite:) forControlEvents:UIControlEventTouchUpInside];
	
	[actionsView addSubview:favoriteButton];
	
	actionsContainerView.frame = CGRectMake(0, 0, tableView.width, favoriteButton.bottom + 20);
	actionsView.frame = CGRectMake(actionsView.origin.x, actionsView.origin.y, actionsView.width, actionsContainerView.height);
	
	NSMutableArray *items = [[NSMutableArray alloc] init];
	
	for(MSStone *stone in stack.stones)
		[items addObject:[MSTableStoneItem itemWithStone:stone]];
	
	NSArray *details = [NSArray arrayWithObjects:
						[TTTableCaptionItem itemWithText:[stack.likesCount description] caption:@"Likes"],
						[TTTableCaptionItem itemWithText:[stack.dislikesCount description] caption:@"Dislikes"],
						[TTTableCaptionItem itemWithText:[stack.viewsCount description] caption:@"Views"],
						nil];
	
	if(_detailsItem == nil)
		_detailsItem = [[MSTableSubItemsItem itemWithText:NSLocalizedString(@"More details", @"")
												 subItems:details imageURL:@"details.png"] retain];
	else
		_detailsItem.subItems = details;
	
	[items addObjectsFromArray:[NSArray arrayWithObjects:[MSTableCollectionLinkItem itemWithText:NSLocalizedString(@"Comments", @"")
																						imageURL:@"comments.png"
																						   count:[stack.commentsCount unsignedIntegerValue]
																							 URL:@"tt://comments"
																						userInfo:[NSDictionary dictionaryWithObject:[NSDictionary dictionaryWithObjectsAndKeys:stack.uid, @"resource_id", @"stack", @"resource_type", nil] forKey:@"parameters"]],
								_detailsItem,
								[MSTableAuthorItem itemWithAuthor:stack.user],
								[TTTableViewItem itemWithCaption:nil view:actionsContainerView], nil]];
	
	self.items = items;
	
	TT_RELEASE_SAFELY(items);
	TT_RELEASE_SAFELY(actionsView);
	TT_RELEASE_SAFELY(actionsContainerView);
}

- (void)delete:(id)sender {
	UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Are you sure you want to delete this stack?", @"")
													   delegate:self
											  cancelButtonTitle:NSLocalizedString(@"Cancel", @"")
										 destructiveButtonTitle:NSLocalizedString(@"Delete stack", @"")
											  otherButtonTitles:nil];
	
	[sheet showInView:sender];
	
	TT_RELEASE_SAFELY(sheet);
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if(buttonIndex == 0) {
		MSStack *stack = (MSStack *)_remoteObjectModel.remoteObject;
		
		MSMemberRequest	*request = [[MSMemberRequest alloc] initWithResource:@"stacks"
																	  member:[stack.uid description]
																	  action:MSMemberRequestActionDelete
																  parameters:nil
																	delegate:[[[MSDeleteResourceDelegate alloc] initWithController:(TTViewController *)[TTNavigator navigator].visibleViewController
																															  text:NSLocalizedString(@"Deleting stack...", @"")] autorelease]];
		
		[request send];
		
		TT_RELEASE_SAFELY(request);
	}
}

- (void)favorite:(id)sender {
	MSStack *stack = (MSStack *)_remoteObjectModel.remoteObject;
	
	MSAPIRequest *request = stack.favorited ? [[MSMemberRequest alloc] initWithResource:@"favorite_stacks"
																				 member:[stack.uid description]
																				 action:MSMemberRequestActionDelete
																			 parameters:nil
																			   delegate:_remoteObjectModel] :
	[[MSCollectionRequest alloc] initWithResource:@"favorite_stacks"
										   action:MSCollectionRequestActionCreate
									   parameters:[NSDictionary dictionaryWithObjectsAndKeys:
												   [stack.uid description], @"id", nil]
										 delegate:_remoteObjectModel];
	
	[request send];
	
	TT_RELEASE_SAFELY(request);
	
	stack.favorited = !stack.favorited;
	[(TTModel *)self.model didFinishLoad];
}

- (void)like:(id)sender {
	MSStack *stack = (MSStack *)_remoteObjectModel.remoteObject;
	
	MSAPIRequest *request = stack.liked ? [[MSMemberRequest alloc] initWithResource:@"stack_votes"
																			 member:[stack.uid description]
																			 action:MSMemberRequestActionDelete
																		 parameters:nil
																		   delegate:_remoteObjectModel] :
	[[MSCollectionRequest alloc] initWithResource:@"stack_votes"
										   action:MSCollectionRequestActionCreate
									   parameters:[NSDictionary dictionaryWithObject:[NSDictionary dictionaryWithObjectsAndKeys:
																					  [stack.uid description], @"stack_id",
																					  [NSNumber numberWithInt:1], @"rating", nil] forKey:@"vote"]
										 delegate:_remoteObjectModel];
	
	[request send];
	
	TT_RELEASE_SAFELY(request);
	
	stack.liked = !stack.liked;
	stack.disliked = NO;
	[(TTModel *)self.model didFinishLoad];
}

- (void)dislike:(id)sender {
	MSStack *stack = (MSStack *)_remoteObjectModel.remoteObject;
	
	MSAPIRequest *request = stack.disliked ? [[MSMemberRequest alloc] initWithResource:@"stack_votes"
																				member:[stack.uid description]
																				action:MSMemberRequestActionDelete
																			parameters:nil
																			  delegate:_remoteObjectModel] :
	[[MSCollectionRequest alloc] initWithResource:@"stack_votes"
										   action:MSCollectionRequestActionCreate
									   parameters:[NSDictionary dictionaryWithObject:[NSDictionary dictionaryWithObjectsAndKeys:
																					  [stack.uid description], @"stack_id",
																					  [NSNumber numberWithInt:-1], @"rating", nil] forKey:@"vote"]
										 delegate:_remoteObjectModel];
	
	[request send];
	
	TT_RELEASE_SAFELY(request);
	
	stack.disliked = !stack.disliked;
	stack.liked = NO;
	[(TTModel *)self.model didFinishLoad];
}

- (void)showMap:(id)sender {
	MSStack *stack = (MSStack *)_remoteObjectModel.remoteObject;
	
	[[TTNavigator navigator] openURLAction:[[[[TTURLAction actionWithURLPath:@"tt://stack/map"]
											  applyAnimated:YES]
											 applyTransition:UIViewAnimationTransitionFlipFromLeft]
											applyQuery:[NSDictionary dictionaryWithObject:stack forKey:@"stack"]]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
	
	cell.editingAccessoryType = cell.accessoryType;
	
	return cell;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
	MSStack *stack = (MSStack *)_remoteObjectModel.remoteObject;
	
	return indexPath.row < stack.stones.count;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		MSStack *stack = (MSStack *)_remoteObjectModel.remoteObject;
		
		MSMemberRequest *request = [[MSMemberRequest alloc] initWithResource:@"stacked_stones"
																	  member:nil
																	  action:MSMemberRequestActionDelete
																  parameters:[NSDictionary dictionaryWithObjectsAndKeys:
																			  [[stack.stones objectAtIndex:indexPath.row] uid], @"stone_id",
																			  stack.uid, @"stack_id", nil] delegate:_remoteObjectModel];
		
		[request send];
		
		TT_RELEASE_SAFELY(request);
	}
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
	if(fromIndexPath.row != toIndexPath.row) {
		MSStack *stack = (MSStack *)_remoteObjectModel.remoteObject;
		
		MSMemberRequest *request = [[MSMemberRequest alloc] initWithResource:@"stacked_stones"
																	  member:nil
																	  action:MSMemberRequestActionUpdate
																  parameters:[NSDictionary dictionaryWithObjectsAndKeys:
																			  [[stack.stones objectAtIndex:fromIndexPath.row] uid], @"stone_id",
																			  stack.uid, @"stack_id",
																			  [NSDictionary dictionaryWithObjectsAndKeys:
																			   [NSNumber numberWithUnsignedInteger:toIndexPath.row], @"position", nil],
																			  @"stacked_stone", nil] delegate:_remoteObjectModel];
		
		[request send];
		
		TT_RELEASE_SAFELY(request);
	}
}

- (Class)tableView:(UITableView*)tableView cellClassForObject:(id)object {
	if ([object isKindOfClass:[TTTableViewItem class]]) {
		return [MSTableViewCell class];
	} else if ([object isKindOfClass:[MSTableStoneItem class]]) {
		return [MSTableStoneItemCell class];
	}
	else if([object isKindOfClass:[MSTableCollectionLinkItem class]])
		return [MSTableCollectionLinkItemCell class];
	else if([object isKindOfClass:[MSTableAuthorItem class]])
		return [MSTableAuthorSmallCell class];
	
	return [super tableView:tableView cellClassForObject:object];
}


@end
