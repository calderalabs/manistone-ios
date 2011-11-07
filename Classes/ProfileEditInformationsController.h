//
//  ProfileEditInformationsController.h
//  Manistone
//
//  Created by Eugenio Depalo on 08/11/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSUser.h"

@interface ProfileEditInformationsController : TTTableViewController <UITextViewDelegate> {
	MSUser *_user;
	NSString *_informations;
	UITextView *_informationsView;
}

@end
