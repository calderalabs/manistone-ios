//
//  MSAuthorDataSource.m
//  Manistone
//
//  Created by Eugenio Depalo on 01/11/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSAuthorDataSource.h"
#import "MSUser.h"
#import "MSTableViewCell.h"
#import "TTTableTextItem+MSAdditions.h"
#import "MSTableCollectionLinkItem.h"
#import "MSTableCollectionLinkItemCell.h"
#import "MSAPIRequest.h"
#import "MSMemberRequest.h"
#import "MSCollectionRequest.h"
#import "MSSession.h"
#import "MSTableSubItemsItem.h"

@implementation MSAuthorDataSource

@synthesize remoteObjectModel = _remoteObjectModel;

static const CGFloat kFooterWidth = 260;
static const CGFloat kButtonHeight = 50;
static const CGFloat kVPadding = 10;
static const CGFloat kHPadding = 10;

- (id)initWithUid:(NSUInteger)uid parameters:(NSDictionary *)parameters {
	if(self = [self init]) {
		_remoteObjectModel = [[MSRemoteObjectModel alloc] initWithResource:[MSUser class] uid:uid parameters:parameters];
	}
	
	return self;
}

- (id)initWithUid:(NSUInteger)uid {
	self = [self initWithUid:uid parameters:nil];
	
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

- (void)tableViewDidLoadModel:(UITableView*)tableView {
	MSUser *user = (MSUser *)_remoteObjectModel.remoteObject;
	
	UIView *actionsContainerView = [[UIView alloc] initWithFrame:CGRectZero];
	UIView *actionsView = [[UIView alloc] initWithFrame:CGRectMake(floor((tableView.width - kFooterWidth) / 2), 0, kFooterWidth, 0)];
	
	[actionsContainerView addSubview:actionsView];
	
	if(![user.uid isEqualToNumber:[MSSession applicationSession].user.uid]) {
		UIButton *favoriteButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[favoriteButton setImage:[UIImage imageNamed:user.favorited? @"favorite-active.png" : @"favorite.png"] forState:UIControlStateNormal];
		favoriteButton.frame = CGRectMake(0, 20, 40, 40);
		
		[favoriteButton addTarget:self action:@selector(favorite:) forControlEvents:UIControlEventTouchUpInside];
		
		[actionsView addSubview:favoriteButton];
		
		UIButton *messageButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[messageButton setImage:[UIImage imageNamed:@"inbox.png"] forState:UIControlStateNormal];
		messageButton.frame = CGRectMake(favoriteButton.right + kHPadding, favoriteButton.top, 40, 40);
		
		[messageButton addTarget:self action:@selector(mail:) forControlEvents:UIControlEventTouchUpInside];
		
		[actionsView addSubview:messageButton];
		
		UIButton *blockButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[blockButton setImage:[UIImage imageNamed:user.blocked? @"block-active.png" : @"block.png"] forState:UIControlStateNormal];
		blockButton.frame = CGRectMake(messageButton.right + kHPadding, 20, actionsView.width - messageButton.right - kHPadding, 40);
		[blockButton setTitle:NSLocalizedString(@"Block", @"") forState:UIControlStateNormal];
		[blockButton setTitleColor:TTSTYLEVAR(linkTextColor) forState:UIControlStateNormal];
		
		blockButton.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
		blockButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
		
		[blockButton addTarget:self action:@selector(block:) forControlEvents:UIControlEventTouchUpInside];
		
		[actionsView addSubview:blockButton];
		
		UIButton *followButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[followButton setImage:[UIImage imageNamed:user.followed? @"follow-active.png" : @"follow.png"] forState:UIControlStateNormal];
		followButton.frame = CGRectMake(0, blockButton.bottom + kVPadding, actionsView.width, 40);
		[followButton setTitle:NSLocalizedString(@"Follow", @"") forState:UIControlStateNormal];
		[followButton setTitleColor:TTSTYLEVAR(linkTextColor) forState:UIControlStateNormal];
		
		followButton.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
		followButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
		
		[followButton addTarget:self action:@selector(follow:) forControlEvents:UIControlEventTouchUpInside];
		
		[actionsView addSubview:followButton];
		
		actionsContainerView.frame = CGRectMake(0, 0, tableView.width, followButton.bottom + 20);
		actionsView.frame = CGRectMake(actionsView.origin.x, actionsView.origin.y, actionsView.width, actionsContainerView.height);
	}
	
	NSMutableArray *detailItems = [NSMutableArray array];
	
	NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
	[formatter setDateStyle:NSDateFormatterLongStyle];
	
	if(TTIsStringWithAnyText(user.informations))
		[detailItems addObject:[TTTableLongTextItem itemWithText:user.informations]];
	
	if(user.birthday) {
		[detailItems addObject:[TTTableCaptionItem itemWithText:[formatter stringFromDate:user.birthday] caption:NSLocalizedString(@"Birthday", @"")]];
	}
	
	if(TTIsStringWithAnyText(user.currentCity)) {
		[detailItems addObject:[TTTableCaptionItem itemWithText:user.currentCity caption:NSLocalizedString(@"Current city", @"")]];
	}
	
	if(user.gender != MSUserGenderUnspecified)
		[detailItems addObject:[TTTableCaptionItem itemWithText:[MSUser stringForGender:user.gender] caption:NSLocalizedString(@"Gender", @"")]];
	
	if(TTIsStringWithAnyText(user.email)) {
		[detailItems addObject:[TTTableCaptionItem itemWithText:user.email caption:NSLocalizedString(@"Email", @"")]];
	}
	
	if(TTIsStringWithAnyText(user.website)) {
		[detailItems addObject:[TTTableCaptionItem itemWithText:user.website caption:NSLocalizedString(@"Website", @"") URL:user.website]];
	}
	
	NSArray *details = detailItems.count > 0 ? detailItems : [NSArray arrayWithObject:[TTTableTextItem itemWithText:NSLocalizedString(@"No details are available", @"")]];
	
	if(_detailsItem == nil)
		_detailsItem = [[MSTableSubItemsItem itemWithText:NSLocalizedString(@"More informations", @"")
								 subItems:details
								 imageURL:@"informations.png"] retain];
	else
		_detailsItem.subItems = details;
	
	NSMutableArray *items = [[NSMutableArray alloc] initWithObjects:
							 _detailsItem,
							 [MSTableCollectionLinkItem itemWithText:NSLocalizedString(@"Stones", @"")
															imageURL:@"stones.png"
															   count:[user.stonesCount unsignedIntegerValue]
																 URL:[NSString stringWithFormat:@"tt://stones/%@", NSLocalizedString(@"Stones", @"")]
															userInfo:[NSDictionary dictionaryWithObject:[NSDictionary dictionaryWithObject:user.uid forKey:@"user_id"]
																								 forKey:@"parameters"]],
							 [MSTableCollectionLinkItem itemWithText:NSLocalizedString(@"Followers", @"")
															imageURL:@"follow.png"
															   count:[user.followersCount unsignedIntegerValue]
																 URL:@"tt://authors"
															userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
																	  [NSDictionary dictionaryWithObject:user.uid forKey:@"followed_id"],
																	  @"parameters",
																	  NSLocalizedString(@"Followers", @""), NSLocalizedString(@"title", @""), nil]],
							 [MSTableCollectionLinkItem itemWithText:NSLocalizedString(@"Stacks", @"")
															imageURL:@"stack.png"
															   count:[user.stacksCount unsignedIntegerValue]
																 URL:@"tt://stacks"
															userInfo:[NSDictionary dictionaryWithObject:[NSDictionary dictionaryWithObject:user.uid forKey:@"user_id"]
																								 forKey:@"parameters"]],
							 [MSTableCollectionLinkItem itemWithText:NSLocalizedString(@"Comments", @"")
															imageURL:@"comments.png"
															   count:[user.commentsCount unsignedIntegerValue]
																 URL:@"tt://comments"
															userInfo:[NSDictionary dictionaryWithObject:[NSDictionary dictionaryWithObject:user.uid forKey:@"user_id"]
																								 forKey:@"parameters"]],
							 [MSTableCollectionLinkItem itemWithText:NSLocalizedString(@"Favorites", @"")
															imageURL:@"favorite.png"
															   count:[user.favoritesCount unsignedIntegerValue]
																 URL:[user URLValueWithName:@"favorites"]
															userInfo:nil], nil];
	
	if(![user.uid isEqualToNumber:[MSSession applicationSession].user.uid])
		[items addObject:[TTTableViewItem itemWithCaption:nil view:actionsContainerView]];
	
	self.items = items;
	
	TT_RELEASE_SAFELY(items);
	TT_RELEASE_SAFELY(actionsView);
	TT_RELEASE_SAFELY(actionsContainerView);
}

- (void)favorite:(id)sender {
	MSUser *user = (MSUser *)_remoteObjectModel.remoteObject;
	
	MSAPIRequest *request = user.favorited ? [[MSMemberRequest alloc] initWithResource:@"favorite_users"
																				member:[user.uid description]
																				action:MSMemberRequestActionDelete
																			parameters:nil
																			  delegate:_remoteObjectModel] :
	[[MSCollectionRequest alloc] initWithResource:@"favorite_users"
										   action:MSCollectionRequestActionCreate
									   parameters:[NSDictionary dictionaryWithObjectsAndKeys:
												   [user.uid description], @"id", nil]
										 delegate:_remoteObjectModel];
	
	[request send];
	
	TT_RELEASE_SAFELY(request);
	
	user.favorited = !user.favorited;
	[(TTModel *)self.model didFinishLoad];
}

- (void)follow:(id)sender {
	MSUser *user = (MSUser *)_remoteObjectModel.remoteObject;
	
	MSAPIRequest *request = user.followed ? [[MSMemberRequest alloc] initWithResource:@"followed_users"
																			   member:[user.uid description]
																			   action:MSMemberRequestActionDelete
																		   parameters:nil
																			 delegate:_remoteObjectModel] :
	[[MSCollectionRequest alloc] initWithResource:@"followed_users"
										   action:MSCollectionRequestActionCreate
									   parameters:[NSDictionary dictionaryWithObjectsAndKeys:
												   [user.uid description], @"id", nil]
										 delegate:_remoteObjectModel];
	
	[request send];
	
	TT_RELEASE_SAFELY(request);
	
	user.followed = !user.followed;
	[(TTModel *)self.model didFinishLoad];
}

- (void)block:(id)sender {
	MSUser *user = (MSUser *)_remoteObjectModel.remoteObject;
	
	if(user.blocked)
		[self alertView:nil clickedButtonAtIndex:1];
	else {
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Confirmation", @"")
															message:NSLocalizedString(@"Are you sure you want to block this author? By blocking an author, you won't be able to receive messages and dedications from him.", @"")
														   delegate:self
												  cancelButtonTitle:NSLocalizedString(@"Cancel", @"")
												  otherButtonTitles:@"OK", nil];
		
		[alertView show];
		
		TT_RELEASE_SAFELY(alertView);
	}
}

- (void)mail:(id)sender {
	[[TTNavigator navigator] openURLAction:[[[TTURLAction actionWithURLPath:@"tt://message/new"] applyAnimated:YES] 
											applyQuery:[NSDictionary dictionaryWithObject:[NSArray arrayWithObject:_remoteObjectModel.remoteObject] forKey:@"recipients"]]];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if(buttonIndex == 1) {
		MSUser *user = (MSUser *)_remoteObjectModel.remoteObject;
		
		MSAPIRequest *request = user.blocked ?  [[MSMemberRequest alloc] initWithResource:@"blocked_users"
																				   member:[user.uid description]
																				   action:MSMemberRequestActionDelete
																			   parameters:nil
																				 delegate:_remoteObjectModel] :
		[[MSCollectionRequest alloc] initWithResource:@"blocked_users"
											   action:MSCollectionRequestActionCreate
										   parameters:[NSDictionary dictionaryWithObjectsAndKeys:
													   [user.uid description], @"id", nil]
											 delegate:_remoteObjectModel];
		
		[request send];
		
		TT_RELEASE_SAFELY(request);
		
		user.blocked = !user.blocked;
		[(TTModel *)self.model didFinishLoad];
	}
}

- (Class)tableView:(UITableView*)tableView cellClassForObject:(id)object {
	if ([object isKindOfClass:[TTTableViewItem class]])
		return [MSTableViewCell class];
	else if([object isKindOfClass:[MSTableCollectionLinkItem class]])
		return [MSTableCollectionLinkItemCell class];
	
	return [super tableView:tableView cellClassForObject:object];
}

@end
