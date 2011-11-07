//
//  SettingsController.m
//  Manistone
//
//  Created by Eugenio Depalo on 09/11/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "SettingsController.h"

@implementation SettingsController

- (id)initWithNavigatorURL:(NSURL *)URL query:(NSDictionary *)query {
	if(self = [self initWithNibName:@"IASKAppSettingsView" bundle:nil]) {
		self.showDoneButton = NO;
		self.showCreditsFooter = NO;
	}
	
	return self;
}

@end
