//
//  MSProfileEditDataSource.m
//  Manistone
//
//  Created by Eugenio Depalo on 07/11/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSProfileEditDataSource.h"
#import "MSDefaultCaptionItemCell.h"
#import "MSTablePicturePickerItem.h"
#import "MSTablePicturePickerItemCell.h"
#import "MSSession.h"
#import "TTTableTextItem+MSAdditions.h"

@implementation MSProfileEditDataSource

@synthesize firstResponder = _firstResponder;

- (id)initWithUserObject:(MSUser *)user {
	if(self = [super init]) {
		_user = [user retain];
		
		_fields = [[NSMutableArray alloc] init];
		
		_emailField = [[UITextField alloc] initWithFrame:CGRectZero];
		_emailField.text = _user.email;
		_emailField.keyboardType = UIKeyboardTypeEmailAddress;
		_emailField.returnKeyType = UIReturnKeyNext;
		_emailField.autocorrectionType = UITextAutocorrectionTypeNo;
		_emailField.autocapitalizationType = UITextAutocapitalizationTypeNone;
		[_fields addObject:_emailField];
		
		_passwordField = [[UITextField alloc] initWithFrame:CGRectZero];
		_passwordField.autocorrectionType = UITextAutocorrectionTypeNo;
		_passwordField.autocapitalizationType = UITextAutocapitalizationTypeNone;
		_passwordField.secureTextEntry = YES;
		_passwordField.returnKeyType = UIReturnKeyNext;
		[_fields addObject:_passwordField];
		
		_passwordConfirmationField = [[UITextField alloc] initWithFrame:CGRectZero];
		_passwordConfirmationField.autocorrectionType = UITextAutocorrectionTypeNo;
		_passwordConfirmationField.autocapitalizationType = UITextAutocapitalizationTypeNone;
		_passwordConfirmationField.secureTextEntry = YES;
		_passwordConfirmationField.returnKeyType = UIReturnKeyNext;
		[_fields addObject:_passwordConfirmationField];
		
		_nameField = [[UITextField alloc] initWithFrame:CGRectZero];
		_nameField.text = _user.name;
		_nameField.autocorrectionType = UITextAutocorrectionTypeNo;
		_nameField.returnKeyType = UIReturnKeyNext;
		_nameField.autocapitalizationType = UITextAutocapitalizationTypeWords;
		[_fields addObject:_nameField];
		
		_surnameField = [[UITextField alloc] initWithFrame:CGRectZero];
		_surnameField.text = _user.surname;
		_surnameField.autocorrectionType = UITextAutocorrectionTypeNo;
		_surnameField.autocapitalizationType = UITextAutocapitalizationTypeWords;
		_surnameField.returnKeyType = UIReturnKeyNext;
		[_fields addObject:_surnameField];
		
		_hometownField = [[UITextField alloc] initWithFrame:CGRectZero];
		_hometownField.returnKeyType = UIReturnKeyNext;
		_hometownField.autocorrectionType = UITextAutocorrectionTypeNo;
		_hometownField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
		_hometownField.placeholder = NSLocalizedString(@"Optional", @"");
		_hometownField.text = _user.hometown;
		[_fields addObject:_hometownField];
		
		_currentCityField = [[UITextField alloc] initWithFrame:CGRectZero];
		_currentCityField.returnKeyType = UIReturnKeyNext;
		_currentCityField.autocorrectionType = UITextAutocorrectionTypeNo;
		_currentCityField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
		_currentCityField.placeholder = NSLocalizedString(@"Optional", @"");
		_currentCityField.text = _user.currentCity;
		[_fields addObject:_currentCityField];
		
		_websiteField = [[UITextField alloc] initWithFrame:CGRectZero];
		_websiteField.returnKeyType = UIReturnKeyNext;
		_websiteField.autocorrectionType = UITextAutocorrectionTypeNo;
		_websiteField.autocapitalizationType = UITextAutocapitalizationTypeNone;
		_websiteField.keyboardType = UIKeyboardTypeURL;
		_websiteField.placeholder = NSLocalizedString(@"Optional", @"");
		_websiteField.text = _user.website;
		[_fields addObject:_websiteField];
		
		for(UITextField *field in _fields)
			field.delegate = self;
		
		_photoItem = [[MSTablePicturePickerItem itemWithImageURL:[_user remotePhotoURLWithStyle:@"normal"]
														 caption:@"Photo"
														delegate:self
												shouldShowDelete:_user.hasPhoto] retain];
	}
	
	return self;
}

- (void)dealloc {
	TT_RELEASE_SAFELY(_fields);
	TT_RELEASE_SAFELY(_nameField);
	TT_RELEASE_SAFELY(_surnameField);
	TT_RELEASE_SAFELY(_passwordField);
	TT_RELEASE_SAFELY(_passwordConfirmationField);
	TT_RELEASE_SAFELY(_emailField);
	TT_RELEASE_SAFELY(_hometownField);
	TT_RELEASE_SAFELY(_currentCityField);
	TT_RELEASE_SAFELY(_photoItem);
	TT_RELEASE_SAFELY(_websiteField);
	
	[super dealloc];
}

- (void)tablePicturePickerDidPickImage:(UIImage *)image {
	_user.photo = image;
}

- (void)tablePicturePickerDeleteButtonClicked {
	_user.photo = [[UIImage alloc] init];
	_photoItem.shouldShowDelete = NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.returnKeyType == UIReturnKeyNext) {
		NSUInteger index = [_fields indexOfObject:textField] + 1;
		
		if(index >= _fields.count)
			index = 0;
		
        [(UITextField *)[_fields objectAtIndex:index] becomeFirstResponder];
    }
	
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	if(textField == _nameField)
		_user.name = textField.text;
	else if(textField == _surnameField)
		_user.surname = textField.text;
	else if(textField == _passwordField)
		_user.password = textField.text;
	else if(textField == _passwordConfirmationField)
		_user.passwordConfirmation = textField.text;
	else if(textField == _emailField)
		_user.email = textField.text;
	else if(textField == _hometownField)
		_user.hometown = textField.text;
	else if(textField == _currentCityField)
		_user.currentCity = textField.text;
	else if(textField == _websiteField)
		_user.website = textField.text;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
	_firstResponder = textField;
}

- (void)tableViewDidLoadModel:(UITableView *)tableView {
	TTTableCaptionItem *genderItem = [TTTableCaptionItem itemWithText:[MSUser stringForGender:_user.gender] caption:NSLocalizedString(@"Gender", @"") URL:@"tt://profile/edit/gender"];
	genderItem.userInfo = [NSDictionary dictionaryWithObject:_user forKey:@"user"];
	
	NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
	[formatter setDateFormat:@"yyyy-MM-dd"];
	
	TTTableCaptionItem *birthdayItem = [TTTableCaptionItem itemWithText:[formatter stringFromDate:_user.birthday] caption:NSLocalizedString(@"Birthday", @"") URL:@"tt://profile/edit/birthday"];
	birthdayItem.userInfo = [NSDictionary dictionaryWithObject:_user forKey:@"user"];
	
	TTTableCaptionItem *informationsItem = [TTTableCaptionItem itemWithText:_user.informations caption:NSLocalizedString(@"Informations", @"") URL:@"tt://profile/edit/informations"];
	informationsItem.userInfo = [NSDictionary dictionaryWithObject:_user forKey:@"user"];
	
	self.sections = [NSArray arrayWithObjects:NSLocalizedString(@"Account", @""), NSLocalizedString(@"Personal details", @""), NSLocalizedString(@"Settings", @""), nil];
	
	self.items = [NSArray arrayWithObjects:[NSArray arrayWithObjects:
				  [TTTableControlItem itemWithCaption:NSLocalizedString(@"Email", @"") control:_emailField],
				  [TTTableControlItem itemWithCaption:NSLocalizedString(@"Password", @"") control:_passwordField],
				  [TTTableControlItem itemWithCaption:NSLocalizedString(@"Confirm password", @"") control:_passwordConfirmationField], nil],
				  [NSArray arrayWithObjects:
				   [TTTableControlItem itemWithCaption:NSLocalizedString(@"First name", @"") control:_nameField],
				   [TTTableControlItem itemWithCaption:NSLocalizedString(@"Last name", @"") control:_surnameField],
				   genderItem,
				   birthdayItem,
				   [TTTableControlItem itemWithCaption:NSLocalizedString(@"Hometown", @"") control:_hometownField],
				   [TTTableControlItem itemWithCaption:NSLocalizedString(@"Current city", @"") control:_currentCityField],
				   informationsItem,
				   [TTTableControlItem itemWithCaption:NSLocalizedString(@"Website", @"") control:_websiteField],
				   _photoItem, nil],
				  [NSArray arrayWithObjects:
				  [TTTableLink itemWithText:NSLocalizedString(@"Privacy Settings", @"") URL:@"tt://profile/edit/privacy" userInfo:[NSDictionary dictionaryWithObject:_user forKey:@"user"]],
				  nil], nil];
}

- (Class)tableView:(UITableView*)tableView cellClassForObject:(id) object { 
	if ([object isKindOfClass:[TTTableCaptionItem class]])
		return [MSDefaultCaptionItemCell class];
	else if ([object isKindOfClass:[MSTablePicturePickerItem class]])
		return [MSTablePicturePickerItemCell class];
	else
		return [super tableView:tableView cellClassForObject:object];
}

@end
