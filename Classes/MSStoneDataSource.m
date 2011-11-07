//
//  MSStoneDataSource.m
//  Manistone
//
//  Created by Eugenio Depalo on 09/10/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSStoneDataSource.h"
#import "MSStone.h"
#import "MSTableSubItemsItem.h"
#import "MSTag.h"
#import "MSTableViewCell.h"
#import "MSCollectionRequest.h"
#import "MSMemberRequest.h"
#import "MSSession.h"
#import "TTTableTextItem+MSAdditions.h"
#import "MSTableCollectionLinkItem.h"
#import "MSTableCollectionLinkItemCell.h"
#import "MSTableAuthorSmallCell.h"
#import "MSDeleteResourceDelegate.h"
#import "MSStyledTextCaptionItem.h"
#import "MSStyledTextCaptionItemCell.h"

static const CGFloat kFooterWidth = 260;
static const CGFloat kButtonHeight = 50;
static const CGFloat kVPadding = 10;
static const CGFloat kHPadding = 10;

@implementation MSStoneDataSource

@synthesize remoteObjectModel = _remoteObjectModel;

- (id)initWithUid:(NSUInteger)uid {
	if(self = [self init]) {
		_remoteObjectModel = [[MSRemoteObjectModel alloc] initWithResource:[MSStone class] uid:uid];
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

- (BOOL)isLoaded {
	return YES;
}

- (void)tableViewDidLoadModel:(UITableView*)tableView {
	MSStone *stone = (MSStone *)_remoteObjectModel.remoteObject;
	
	NSString *tagList = [MSTag styledTagListWithTags:stone.tags];
	
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
	[likeButton setImage:[UIImage imageNamed:stone.liked ? @"thumbs-up-small-active.png" : @"thumbs-up-small.png"] forState:UIControlStateNormal];
	likeButton.frame = CGRectMake(0, showButton.bottom + kVPadding, 40, 40);
	[likeButton addTarget:self action:@selector(like:) forControlEvents:UIControlEventTouchUpInside];
	[actionsView addSubview:likeButton];
	
	UIButton *dislikeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[dislikeButton setImage:[UIImage imageNamed:stone.disliked ? @"thumbs-down-small-active.png" : @"thumbs-down-small.png"] forState:UIControlStateNormal];
	dislikeButton.frame = CGRectMake(likeButton.right + kHPadding, showButton.bottom + kVPadding, 40, 40);
	[dislikeButton addTarget:self action:@selector(dislike:) forControlEvents:UIControlEventTouchUpInside];
	[actionsView addSubview:dislikeButton];
	
	UIButton *favoriteButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[favoriteButton setTitleColor:TTSTYLEVAR(linkTextColor) forState:UIControlStateNormal];
	[favoriteButton setImage:[UIImage imageNamed:stone.favorited? @"favorite-active.png" : @"favorite.png"] forState:UIControlStateNormal];
	[favoriteButton setTitle:NSLocalizedString(@"Favorite", @"") forState:UIControlStateNormal];
	favoriteButton.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
	favoriteButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
	favoriteButton.frame = CGRectMake(dislikeButton.right + kHPadding,
								  showButton.bottom + kVPadding,
								  kFooterWidth - (dislikeButton.right + kHPadding),
								  40);
	
	[favoriteButton addTarget:self action:@selector(favorite:) forControlEvents:UIControlEventTouchUpInside];
	
	[actionsView addSubview:favoriteButton];
	
	actionsContainerView.frame = CGRectMake(0, 0, tableView.width, favoriteButton.bottom + 20);
	actionsView.frame = CGRectMake(actionsView.origin.x, actionsView.origin.y, actionsView.width, actionsContainerView.height);
	
	NSArray *details = [NSArray arrayWithObjects:
						[MSStyledTextCaptionItem itemWithText:[TTStyledText textFromXHTML:tagList] caption:NSLocalizedString(@"Tags", @"")],
						[TTTableCaptionItem itemWithText:[stone.likesCount description] caption:NSLocalizedString(@"Likes", @"")],
						[TTTableCaptionItem itemWithText:[stone.dislikesCount description] caption:NSLocalizedString(@"Dislikes", @"")],
						[TTTableCaptionItem itemWithText:[stone.viewsCount description] caption:NSLocalizedString(@"Views", @"")],
						nil];
	
	if(_detailsItem == nil) 
		_detailsItem = [[MSTableSubItemsItem itemWithText:NSLocalizedString(@"More details", @"")
											subItems:details imageURL:@"details.png"] retain];
	else
		_detailsItem.subItems = details;
	
	NSMutableArray *items = [NSMutableArray arrayWithObjects:[MSTableCollectionLinkItem itemWithText:NSLocalizedString(@"Comments", @"")
																							imageURL:@"comments.png"
																							   count:[stone.commentsCount unsignedIntegerValue]
																								 URL:@"tt://comments"
																							userInfo:[NSDictionary dictionaryWithObject:[NSDictionary dictionaryWithObjectsAndKeys:stone.uid, @"resource_id", @"stone", @"resource_type", nil] forKey:@"parameters"]],
							 [MSTableCollectionLinkItem itemWithText:NSLocalizedString(@"Stacks", @"")
															imageURL:@"stack.png"
															   count:[stone.stacksCount unsignedIntegerValue]
																 URL:@"tt://stacks"
															userInfo:[NSDictionary dictionaryWithObject:[NSDictionary dictionaryWithObjectsAndKeys:stone.uid, @"stacked_stone_id", nil] forKey:@"parameters"]],
							 _detailsItem,
							 [MSTableAuthorItem itemWithAuthor:stone.user],
							 [TTTableViewItem itemWithCaption:nil view:actionsContainerView], nil];
	
	self.items = items;
	
	TT_RELEASE_SAFELY(actionsView);
	TT_RELEASE_SAFELY(actionsContainerView);
}

- (void)favorite:(id)sender {
	MSStone *stone = (MSStone *)_remoteObjectModel.remoteObject;
	
	MSAPIRequest *request = stone.favorited ? [[MSMemberRequest alloc] initWithResource:@"favorite_stones"
																				 member:[stone.uid description]
																				 action:MSMemberRequestActionDelete
																			 parameters:nil
																			   delegate:_remoteObjectModel] :
	[[MSCollectionRequest alloc] initWithResource:@"favorite_stones"
										   action:MSCollectionRequestActionCreate
									   parameters:[NSDictionary dictionaryWithObjectsAndKeys:
												   [stone.uid description], @"id", nil]
										 delegate:_remoteObjectModel];
	
	[request send];
	
	TT_RELEASE_SAFELY(request);
	
	stone.favorited = !stone.favorited;
	[(TTModel *)self.model didFinishLoad];
}

- (void)like:(id)sender {
	MSStone *stone = (MSStone *)_remoteObjectModel.remoteObject;
	
	MSAPIRequest *request = stone.liked ? [[MSMemberRequest alloc] initWithResource:@"stone_votes"
																			 member:[stone.uid description]
																			 action:MSMemberRequestActionDelete
																		 parameters:nil
																		   delegate:_remoteObjectModel] :
	[[MSCollectionRequest alloc] initWithResource:@"stone_votes"
										   action:MSCollectionRequestActionCreate
									   parameters:[NSDictionary dictionaryWithObject:[NSDictionary dictionaryWithObjectsAndKeys:
																					  [stone.uid description], @"stone_id",
																					  [NSNumber numberWithInt:1], @"rating", nil] forKey:@"vote"]
										 delegate:_remoteObjectModel];
	
	[request send];
	
	TT_RELEASE_SAFELY(request);
	
	stone.liked = !stone.liked;
	stone.disliked = NO;
	[(TTModel *)self.model didFinishLoad];
}

- (void)dislike:(id)sender {
	MSStone *stone = (MSStone *)_remoteObjectModel.remoteObject;
	
	MSAPIRequest *request = stone.disliked ? [[MSMemberRequest alloc] initWithResource:@"stone_votes"
																				member:[stone.uid description]
																				action:MSMemberRequestActionDelete
																			parameters:nil
																			  delegate:_remoteObjectModel] :
	[[MSCollectionRequest alloc] initWithResource:@"stone_votes"
										   action:MSCollectionRequestActionCreate
									   parameters:[NSDictionary dictionaryWithObject:[NSDictionary dictionaryWithObjectsAndKeys:
																					  [stone.uid description], @"stone_id",
																					  [NSNumber numberWithInt:-1], @"rating", nil] forKey:@"vote"]
										 delegate:_remoteObjectModel];
	
	[request send];
	
	TT_RELEASE_SAFELY(request);
	
	stone.disliked = !stone.disliked;
	stone.liked = NO;
	[(TTModel *)self.model didFinishLoad];
}

- (void)showMap:(id)sender {
	MSStone *stone = (MSStone *)_remoteObjectModel.remoteObject;
	
	[[TTNavigator navigator] openURLAction:[[[[TTURLAction actionWithURLPath:@"tt://stones/map"]
											  applyAnimated:YES]
											 applyTransition:UIViewAnimationTransitionFlipFromLeft]
											applyQuery:[NSDictionary dictionaryWithObject:[NSArray arrayWithObject:stone] forKey:@"stones"]]];
}

- (Class)tableView:(UITableView*)tableView cellClassForObject:(id)object {
	if ([object isKindOfClass:[TTTableViewItem class]]) {
		return [MSTableViewCell class];
	}
	else if([object isKindOfClass:[MSTableCollectionLinkItem class]])
		return [MSTableCollectionLinkItemCell class];
	else if([object isKindOfClass:[MSStyledTextCaptionItem class]])
		return [MSStyledTextCaptionItemCell class];
	else if([object isKindOfClass:[MSTableAuthorItem class]])
		return [MSTableAuthorSmallCell class];
	
	return [super tableView:tableView cellClassForObject:object];
}

@end
