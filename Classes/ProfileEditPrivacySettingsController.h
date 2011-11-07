//
//  ProfileEditPrivacySettingsController.h
//  Manistone
//
//  Created by Eugenio Depalo on 08/11/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSUser.h"

@interface ProfileEditPrivacySettingsController : TTTableViewController {
	MSUser *_user;
	
	UISwitch *_emailSwitch;
	UISwitch *_birthdaySwitch;
}

@end
