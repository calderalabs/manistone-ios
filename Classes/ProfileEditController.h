//
//  ProfileEditController.h
//  Manistone
//
//  Created by Eugenio Depalo on 07/11/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSUser.h"

@interface ProfileEditController : TTTableViewController <UIAlertViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, TTURLRequestDelegate> {
	MSUser *_user;
	
	id<TTURLRequestDelegate> _delegate;
}

@end
