//
//  ManistoneAppDelegate.m
//  Manistone
//
//  Created by Eugenio Depalo on 03/08/10.
//  Copyright 2010 - Lucido Inc. All rights reserved.
//

#import "ManistoneAppDelegate.h"

#import "HomeController.h"

// List controllers
#import "StacksListController.h"
#import "StonesListController.h"
#import "TagsListController.h"
#import "AuthorsListController.h"
#import "MessageListController.h"
#import "DedicationsController.h"
#import "FollowedController.h"

// Stones controllers
#import "StonesController.h"
#import "StoneEditController.h"
#import "StoneShowController.h"
#import "StonesSearchController.h"
#import "StonesMapController.h"
#import "AddToStackController.h"
#import "LocationPickerController.h"
#import "DedicateController.h"
#import "LocalStonesListController.h"
#import "LocalStoneEditController.h"

// Stacks controllers
#import "StackShowController.h"
#import "StackEditController.h"
#import "StackMapController.h"

// Authors controllers
#import "AuthorShowController.h"

// Profile controllers
#import "ProfileController.h"
#import "ProfileEditController.h"
#import "ProfileEditPrivacySettingsController.h"
#import "ProfileEditInformationsController.h"
#import "ProfileEditBirthdayController.h"
#import "ProfileEditGenderController.h"

// Messages controllers
#import "MessageShowController.h"
#import "MessageController.h"

// Tags controllers
#import "TagShowController.h"

// Others
#import "CommentsController.h"
#import "FavoritesController.h"
#import "AboutController.h"
#import "SessionController.h"
#import "SettingsController.h"
#import "ResendActivationController.h"
#import "ForgotPasswordController.h"

// Models
#import "MSStone.h"
#import "MSStack.h"
#import "MSUser.h"
#import "MSMessage.h"

@implementation ManistoneAppDelegate

#pragma mark -
#pragma mark Application lifecycle

- (void)applicationDidFinishLaunching:(UIApplication*)application {
	[TTStyleSheet setGlobalStyleSheet:[[[MSDefaultStyleSheet alloc] init] autorelease]];
	[[TTURLRequestQueue mainQueue] setMaxContentLength:0];
	
	[[TTURLCache sharedCache] disableDiskCache];
	[[TTURLCache sharedCache] removeAll:YES];
	
	TTNavigator* navigator = [TTNavigator navigator];
	navigator.persistenceMode = TTNavigatorPersistenceModeNone;
	TTURLMap* map = navigator.URLMap;

	[map from:@"*" toViewController:[TTWebController class]];
	[map from:@"tt://login" toModalViewController:[SessionController class] transition:UIModalTransitionStyleFlipHorizontal];
	[map from:@"tt://home" toSharedViewController:[HomeController class]];
	[map from:@"tt://stones" toSharedViewController:[StonesController class]];
	[map from:@"tt://stones/search" toModalViewController:[StonesSearchController class]];
	[map from:@"tt://stones/(initWithTitle:)" toViewController:[StonesListController class]];
	[map from:@"tt://stones/map" toModalViewController:[StonesMapController class]];
	[map from:@"tt://stone/new" toModalViewController:[StoneEditController class]];
	[map from:@"tt://stone/edit" toModalViewController:[StoneEditController class]];
	[map from:@"tt://stone/addToStack/(initWithUid:)" toModalViewController:[AddToStackController class]];
	[map from:@"tt://stone/dedicate/(initWithUid:)" toModalViewController:[DedicateController class]];
	[map from:@"tt://stone/show/(initWithUid:)" toViewController:[StoneShowController class]];
	
	[map from:@"tt://comments" toViewController:[CommentsController class]];
	
	[map from:@"tt://stacks/" toViewController:[StacksListController class]];
	[map from:@"tt://stack/new" toModalViewController:[StackEditController class]];
	[map from:@"tt://stack/edit" toModalViewController:[StackEditController class]];
	[map from:@"tt://stack/show/(initWithUid:)" toViewController:[StackShowController class]];
	[map from:@"tt://stack/map" toModalViewController:[StackMapController class]];
	
	[map from:@"tt://tags" toSharedViewController:[TagsListController class]];
	[map from:@"tt://tag/show/(initWithTagName:)" toViewController:[TagShowController class]];

	[map from:@"tt://authors" toViewController:[AuthorsListController class]];
	[map from:@"tt://author/show/(initWithUid:)" toViewController:[AuthorShowController class]];
	
	[map from:@"tt://profile" toSharedViewController:[ProfileController class]];
	[map from:@"tt://profile/edit" toModalViewController:[ProfileEditController class]];
	[map from:@"tt://profile/edit/gender" toViewController:[ProfileEditGenderController class]];
	[map from:@"tt://profile/edit/birthday" toViewController:[ProfileEditBirthdayController class]];
	[map from:@"tt://profile/edit/informations" toViewController:[ProfileEditInformationsController class]];
	[map from:@"tt://profile/edit/privacy" toViewController:[ProfileEditPrivacySettingsController class]];
	
	[map from:@"tt://favorites/(initWithUid:)" toViewController:[FavoritesController class]];
	
	[map from:@"tt://dedications" toSharedViewController:[DedicationsController class]];
	
	[map from:@"tt://message/new" toModalViewController:[MessageController class]];
	[map from:@"tt://messages" toSharedViewController:[MessageListController class]];
	[map from:@"tt://message/show/(initWithUid:)" toViewController:[MessageShowController class]];

	[map from:@"tt://followed" toSharedViewController:[FollowedController class]];
	
	[map from:@"tt://settings" toSharedViewController:[SettingsController class]];
		
	[map from:@"tt://about" toModalViewController:[AboutController class]];
	
	[map from:@"tt://account/resend_activation" toViewController:[ResendActivationController class]];
	[map from:@"tt://account/forgot_password" toViewController:[ForgotPasswordController class]];
	
	[map from:@"tt://local_stones" toModalViewController:[LocalStonesListController class]];
	[map from:@"tt://local_stone/new" toModalViewController:[LocalStoneEditController class]];
	[map from:@"tt://local_stone/edit" toModalViewController:[LocalStoneEditController class]];
	
	[map from:[MSStone class] name:@"show" toURL:@"tt://stone/show/(uid)"];
	[map from:[MSStone class] name:@"addToStack" toURL:@"tt://stone/addToStack/(uid)"];
	[map from:[MSStone class] name:@"dedicate" toURL:@"tt://stone/dedicate/(uid)"];
	[map from:[MSStack class] name:@"show" toURL:@"tt://stack/show/(uid)"];
	[map from:[MSUser class] name:@"show" toURL:@"tt://author/show/(uid)"];
	[map from:[MSUser class] name:@"favorites" toURL:@"tt://favorites/(uid)"];
	[map from:[MSTag class] name:@"show" toURL:@"tt://tag/show/(name)"];
	[map from:[MSMessage class] name:@"show" toURL:@"tt://message/show/(uid)"];
	
	if (![navigator restoreViewControllers]) {
		[navigator openURLAction:[TTURLAction actionWithURLPath:@"tt://home"]];
	}
	
	[navigator openURLAction:[TTURLAction actionWithURLPath:@"tt://login"]];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}

#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}

@end

