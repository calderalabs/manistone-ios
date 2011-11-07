//
//  HomeController.h
//  Manistone
//
//  Created by Eugenio Depalo on 06/09/10.
//  Copyright 2010 - Lucido Inc. All rights reserved.
//

#ifdef LITE_VERSION
#import "AdWhirlDelegateProtocol.h"
#import "AdWhirlView.h"
#endif

#import "MSLauncherItem.h"

@interface HomeController : TTViewController <TTLauncherViewDelegate, UIActionSheetDelegate, TTURLRequestDelegate
#ifdef LITE_VERSION
, AdWhirlDelegate
#endif
> {
	TTLauncherView *_launcherView;
	UIBarButtonItem *_logoutButton;
	UIBarButtonItem *_engraveButton;
	
	MSLauncherItem *_dedicationsItem;
	MSLauncherItem *_inboxItem;
	MSLauncherItem *_subscriptionsItem;

	NSTimer *_unreadTimer;
	
	#ifdef LITE_VERSION
	AdWhirlView *_adView;
	#endif
}

@end
