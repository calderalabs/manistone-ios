//
//  HomeController.m
//  Manistone
//
//  Created by Eugenio Depalo on 06/09/10.
//  Copyright 2010 - Lucido Inc. All rights reserved.
//

#import "HomeController.h"
#import "MSSession.h"
#import "MSAPIRequest.h"
#import "MSLocalStonesManager.h"

#ifdef LITE_VERSION
#import "MSUser.h"
#endif 

@implementation HomeController

#ifdef LITE_VERSION

- (NSString *)adWhirlApplicationKey {
	return @"YOUR_ADWHIRL_APPLICATION_KEY";
}

- (UIViewController *)viewControllerForPresentingModalView {
	return [TTNavigator navigator].visibleViewController.navigationController;
}

- (void)adWhirlDidReceiveAd:(AdWhirlView *)adWhirlView {
	[UIView beginAnimations:@"AdResize" context:nil];
	[UIView setAnimationDuration:0.7];
	CGSize adSize = [_adView actualAdSize];
	CGRect newFrame = _adView.frame;
	
	newFrame.size.height = adSize.height;
	newFrame.size.width = adSize.width;
	
	newFrame.origin.x = (self.view.bounds.size.width - adSize.width)/2; // center
	newFrame.origin.y = (self.view.bounds.size.height - adSize.height);
	
	_adView.frame = newFrame;
	
	_launcherView.height = self.view.height - adSize.height;
	[_launcherView endEditing];
	
	[UIView commitAnimations];
}

- (NSDate *)dateOfBirth {
	return [MSSession applicationSession].user.birthday;
}

- (NSString *)gender {
	switch ([MSSession applicationSession].user.gender) {
		case MSUserGenderMale:
			return @"m";
			break;
		case MSUserGenderFemale:
			return @"f";
			break;
		default:
			return nil;
			break;
	}
}

#endif

- (void)refreshUnreadCounts:(NSTimer *)timer {
	MSAPIRequest *request = [[MSAPIRequest alloc] initWithController:@"users"
															  action:@"unread_counts"
															  method:@"GET"
														  parameters:nil
															delegate:self];
	
	[request send];
	
	TT_RELEASE_SAFELY(request);
}

- (void)requestDidFinishLoad:(TTURLRequest*)request {
	TTURLJSONResponse* response = request.response;
	NSDictionary* result = response.rootObject;
	
	_dedicationsItem.badgeNumber = [[result valueForKey:@"dedications_count"] unsignedIntegerValue];
	_inboxItem.badgeNumber = [[result valueForKey:@"inbox_count"] unsignedIntegerValue];
	_subscriptionsItem.badgeNumber = [[result valueForKey:@"subscriptions_count"] unsignedIntegerValue];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	[self refreshUnreadCounts:nil];
	
	_unreadTimer = [[NSTimer scheduledTimerWithTimeInterval:10.0
													 target:self
												   selector:@selector(refreshUnreadCounts:)
												   userInfo:nil
													repeats:YES] retain];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	
	[_unreadTimer invalidate];
	TT_RELEASE_SAFELY(_unreadTimer);
}

- (id)initWithNavigatorURL:(NSURL *)URL query:(NSDictionary *)query {
	if(self = [self init]) {
		[[NSNotificationCenter defaultCenter] 
		 addObserver:self selector:@selector(userDidLogout:) 
		 name:MSSessionDidLogoutNotification
		 object:nil];
		
		[[NSNotificationCenter defaultCenter] 
		 addObserver:self selector:@selector(loginDidTimeout:) 
		 name:MSSessionDidTimeoutNotification
		 object:nil];
	}
	
	return self;
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:MSSessionDidLogoutNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:MSSessionDidTimeoutNotification object:nil];
	
	TT_RELEASE_SAFELY(_launcherView);
	TT_RELEASE_SAFELY(_logoutButton);
	TT_RELEASE_SAFELY(_engraveButton);
	TT_RELEASE_SAFELY(_subscriptionsItem);
	TT_RELEASE_SAFELY(_dedicationsItem);
	TT_RELEASE_SAFELY(_inboxItem);
	TT_RELEASE_SAFELY(_unreadTimer);
	
#ifdef LITE_VERSION
	TT_RELEASE_SAFELY(_adView);
#endif
	
	[super dealloc];
}

- (void)loadView {
	[super loadView];
	
	_logoutButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Logout", @"")
													 style:UIBarButtonItemStyleBordered
													target:self
													action:@selector(logout:)];
	_engraveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose
																   target:self
																   action:@selector(engrave:)];
	
	self.navigationItem.leftBarButtonItem = _logoutButton;
	self.navigationItem.rightBarButtonItem = _engraveButton;
	
	self.navigationItem.titleView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]] autorelease];
	
	_launcherView = [[TTLauncherView alloc] initWithFrame:self.view.bounds];
	self.view.backgroundColor = TTSTYLEVAR(tableGroupedBackgroundColor);
	_launcherView.delegate = self;
	_launcherView.columnCount = 3;
	
	_dedicationsItem = [[MSLauncherItem alloc] initWithTitle:NSLocalizedString(@"Dedications", @"")
													   image:@"bundle://dedicationsLauncher.png"
														 URL:@"tt://dedications" canDelete:NO];
	_subscriptionsItem = [[MSLauncherItem alloc] initWithTitle:NSLocalizedString(@"Followed", @"")
														 image:@"bundle://followedLauncher.png"
														   URL:@"tt://followed" canDelete:NO];
	
	_inboxItem = [[MSLauncherItem alloc] initWithTitle:NSLocalizedString(@"Messages", @"")
												 image:@"bundle://messagesLauncher.png"
												   URL:@"tt://messages" canDelete:NO];
	
	MSLauncherItem *stacksItem = [[[MSLauncherItem alloc] initWithTitle:NSLocalizedString(@"Stacks", @"")
																  image:@"bundle://stacksLauncher.png"
																	URL:@"tt://stacks" canDelete:NO] autorelease];
	
	stacksItem.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
						   [NSNumber numberWithBool:YES], @"showSort",
						   [NSNumber numberWithBool:YES], @"showSearch", nil];
	
	MSLauncherItem *authorsItem = [[[MSLauncherItem alloc] initWithTitle:NSLocalizedString(@"Authors", @"")
																   image:@"bundle://authorsLauncher.png"
																	 URL:@"tt://authors" canDelete:NO] autorelease];
	
	authorsItem.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
							[NSNumber numberWithBool:YES], @"showSort",
							[NSNumber numberWithBool:YES], @"showSearch", nil];
	
	_launcherView.pages = [NSArray arrayWithObjects:
						   [NSArray arrayWithObjects:
							[[[MSLauncherItem alloc] initWithTitle:NSLocalizedString(@"Stones", @"")
															 image:@"bundle://stonesLauncher.png"
															   URL:@"tt://stones" canDelete:NO] autorelease],
							[[[MSLauncherItem alloc] initWithTitle:NSLocalizedString(@"Tags", @"")
															 image:@"bundle://tagsLauncher.png"
															   URL:@"tt://tags" canDelete:NO] autorelease],
							authorsItem,
							stacksItem,
							_inboxItem,
							[[[MSLauncherItem alloc] initWithTitle:NSLocalizedString(@"Profile", @"")
															 image:@"bundle://profileLauncher.png"
															   URL:@"tt://profile" canDelete:NO] autorelease],
							_dedicationsItem,
							_subscriptionsItem,
							[[[MSLauncherItem alloc] initWithTitle:NSLocalizedString(@"Settings", @"")
															 image:@"bundle://settingsLauncher.png"
															   URL:@"tt://settings" canDelete:NO] autorelease],
							nil],
						   nil
						   ];
	
	[self.view addSubview:_launcherView];
	
#ifdef LITE_VERSION
	_adView = [[AdWhirlView requestAdWhirlViewWithDelegate:self] retain];
	_adView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
	_adView.origin = CGPointMake(0, self.view.bottom);
	[self.view addSubview:_adView];
#endif
}

- (void)logout:(id)sender {
	UIActionSheet *logoutSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Are you sure you want to logout?", @"")
															 delegate:self
													cancelButtonTitle:NSLocalizedString(@"Cancel", @"")
											   destructiveButtonTitle:NSLocalizedString(@"Logout", @"")
													otherButtonTitles:nil];
	
	[logoutSheet showFromBarButtonItem:sender animated:YES];
	
	TT_RELEASE_SAFELY(logoutSheet);
}

- (void)engrave:(id)sender {
	if([MSLocalStonesManager defaultManager].stones.count > 0) {
		UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Select a source of writing", @"")
																 delegate:self
														cancelButtonTitle:NSLocalizedString(@"Cancel", @"")
												   destructiveButtonTitle:nil
														otherButtonTitles:NSLocalizedString(@"Pick from bag", @""), NSLocalizedString(@"Create from scratch", @""), nil];
		
		[actionSheet showFromBarButtonItem:sender animated:YES];
		
		actionSheet.tag = 1;
		
		TT_RELEASE_SAFELY(actionSheet);
	}
	else
		[[TTNavigator navigator] openURLAction:[[TTURLAction actionWithURLPath:@"tt://stone/new"] applyAnimated:YES]];
}

- (void)launcherView:(TTLauncherView*)launcher didSelectItem:(MSLauncherItem*)item {
	[[TTNavigator navigator] openURLAction:[[[TTURLAction actionWithURLPath:item.URL] applyAnimated:YES] applyQuery:item.userInfo]];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if(actionSheet.tag == 1) {
		if(buttonIndex == actionSheet.firstOtherButtonIndex)
			[[TTNavigator navigator] openURLAction:[[[TTURLAction actionWithURLPath:@"tt://local_stones"] applyAnimated:YES]
													applyQuery:
													[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES]
																				forKey:@"picker"]]];
		else if(buttonIndex == actionSheet.firstOtherButtonIndex + 1)
			[[TTNavigator navigator] openURLAction:[[TTURLAction actionWithURLPath:@"tt://stone/new"] applyAnimated:YES]];
	}
	else {
		if(buttonIndex == 0) {
			[self startActivity:@"Logging out..."];
			
			[[MSSession applicationSession] logout];
		}
	}
}

- (void)userDidLogout:(NSNotification *)notification {
	[[TTNavigator navigator] openURLAction:[[TTURLAction actionWithURLPath:@"tt://login"] applyAnimated:YES]];
	
	_dedicationsItem.badgeNumber = 0;
	_inboxItem.badgeNumber = 0;
	_subscriptionsItem.badgeNumber = 0;
	
	[self stopActivity];
}

- (void)loginDidTimeout:(NSNotification *)notification {
	[self stopActivity];
}

- (void)launcherViewDidBeginEditing:(TTLauncherView*)launcher {
	[self.navigationItem setLeftBarButtonItem:nil animated:YES];
	
	[self.navigationItem setRightBarButtonItem:[[[UIBarButtonItem alloc]
												 initWithBarButtonSystemItem:UIBarButtonSystemItemDone
												 target:_launcherView action:@selector(endEditing)] autorelease] animated:YES];
}

- (void)launcherViewDidEndEditing:(TTLauncherView*)launcher {
	[self.navigationItem setRightBarButtonItem:_engraveButton animated:YES];
	[self.navigationItem setLeftBarButtonItem:_logoutButton animated:YES];
}

@end
