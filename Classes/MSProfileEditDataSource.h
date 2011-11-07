//
//  MSProfileEditDataSource.h
//  Manistone
//
//  Created by Eugenio Depalo on 07/11/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSUser.h"
#import "MSTablePicturePickerDelegate.h"
#import "MSTablePicturePickerItem.h"

@interface MSProfileEditDataSource : TTSectionedDataSource <MSTablePicturePickerDelegate, UITextFieldDelegate> {
	MSUser *_user;
	
	UITextField *_nameField;
	UITextField *_surnameField;
	UITextField *_hometownField;
	UITextField *_passwordField;
	UITextField *_passwordConfirmationField;
	UITextField *_currentCityField;
	UITextField *_emailField;
	UITextField *_websiteField;
	
	UIView *_firstResponder;
	
	MSTablePicturePickerItem *_photoItem;
	
	NSMutableArray *_fields;
}

@property (nonatomic, readonly) UIView *firstResponder;

- (id)initWithUserObject:(MSUser *)user;

@end
