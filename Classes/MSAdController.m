//
//  MSAdController.m
//  Manistone
//
//  Created by Eugenio Depalo on 29/11/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#ifdef LITE_VERSION

#import "MSAdController.h"
#import "MSSession.h"
#import "MSUser.h"

@implementation MSAdController

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
	
	newFrame.origin.x = (self.view.bounds.size.width - adSize.width)/2; // center
	
	newFrame.size.height = adSize.height;
	newFrame.size.width = adSize.width;
	
	_adView.frame = newFrame;
	
	if(_adView.hidden) {
		for(UIView *subview in self.view.subviews) {
			if(subview != _adView && subview != _pagingToolbar)
				subview.top += _adView.height;
		}
		
		self.tableView.height -= _adView.height;
		_adView.hidden = NO;

	}
	
	[UIView commitAnimations];
}

- (void)loadView {
	[super loadView];
	
	_adView = [[AdWhirlView requestAdWhirlViewWithDelegate:self] retain];
	_adView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
	_adView.hidden = YES;
	
	[self.view addSubview:_adView];
}

- (void)dealloc {
	TT_RELEASE_SAFELY(_adView);
	
	[super dealloc];
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

@end

#endif