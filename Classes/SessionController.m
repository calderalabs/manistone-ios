//
//  SessionController.m
//  Manistone
//
//  Created by Eugenio Depalo on 09/09/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "SessionController.h"
#import "MSAPIRequest.h"
#import "SFHFKeychainUtils.h"
#import "MSSession.h"

static NSString *const kManistoneService = @"com.manistone.accounts";

@implementation SessionController

- (id)initWithNavigatorURL:(NSURL *)URL query:(NSDictionary *)query {
	if(self = [self init]) {
		[[NSNotificationCenter defaultCenter] 
		 addObserver:self selector:@selector(userDidLogin:) 
		 name:MSSessionDidLoginNotification
		 object:nil];
		
		[[NSNotificationCenter defaultCenter] 
		 addObserver:self selector:@selector(loginDidTimeout:) 
		 name:MSSessionDidTimeoutNotification
		 object:nil];
		
		[[NSNotificationCenter defaultCenter] 
		 addObserver:self selector:@selector(loginDidFail:) 
		 name:MSSessionLoginDidFailNotification
		 object:nil];
		
		if(![MSSession applicationSession].timedOut) {
			self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"About", @"")
																					  style:UIBarButtonItemStylePlain
																					 target:self
																					 action:@selector(about:)] autorelease];
			
			self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose
																									target:self
																									action:@selector(compose:)] autorelease];
		}
	}
	
	return self;
}

- (void)about:(id)sender {
	[[TTNavigator navigator] openURLAction:[[TTURLAction actionWithURLPath:@"tt://about"] applyAnimated:YES]];
}

- (void)compose:(id)sender {
	[[TTNavigator navigator] openURLAction:[[TTURLAction actionWithURLPath:@"tt://local_stones"] applyAnimated:YES]];
}

- (void)signup:(id)sender {
	[[TTNavigator navigator] openURLAction:[[TTURLAction actionWithURLPath:@"tt://profile/edit"] applyAnimated:YES]];
}

- (void)loadView {
	[super loadView];
	
	self.navigationItem.titleView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]] autorelease];
	
	TTTableView *tableView = [[TTTableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
	tableView.backgroundColor = TTSTYLEVAR(tableGroupedBackgroundColor);
	
	NSMutableArray *items = [[NSMutableArray alloc] init];
	
	_emailField = [[UITextField alloc] init];
	_emailField.placeholder = NSLocalizedString(@"Email", @"");
	_emailField.keyboardType = UIKeyboardTypeEmailAddress;
	_emailField.returnKeyType = UIReturnKeyNext;
	_emailField.autocorrectionType = UITextAutocorrectionTypeNo;
	_emailField.autocapitalizationType = UITextAutocapitalizationTypeNone;
	_emailField.clearButtonMode = UITextFieldViewModeWhileEditing;
	_emailField.clearsOnBeginEditing = NO;
	_emailField.enabled = ([MSSession applicationSession].timedOut == NO);
	_emailField.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"kEmail"];
	_emailField.delegate = self;
	
	[items addObject:_emailField];
	
	_passwordField = [[UITextField alloc] init];
	_passwordField.placeholder = NSLocalizedString(@"Password", @"");
	_passwordField.returnKeyType = UIReturnKeyGo;
	_passwordField.secureTextEntry = YES;
	_passwordField.autocorrectionType = UITextAutocorrectionTypeNo;
	_passwordField.autocapitalizationType = UITextAutocapitalizationTypeNone;
	_passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
	_passwordField.clearsOnBeginEditing = NO;
	_passwordField.text = @"";
	_passwordField.delegate = self;
	[items addObject:_passwordField];
	
	[MSSession applicationSession].timedOut ? [_passwordField becomeFirstResponder] : [_emailField becomeFirstResponder];
	
	tableView.dataSource = [[[TTListDataSource alloc] initWithItems:items] autorelease];
	TT_RELEASE_SAFELY(items);
	
	UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TTNavigationFrame().size.width, 0)];
	
	if(![MSSession applicationSession].timedOut) {
		TTStyledTextLabel *signupLabel = [[[TTStyledTextLabel alloc] initWithFrame:CGRectMake(0, 0, 250, 0)] autorelease];
		TTStyledText *text = [TTStyledText textFromXHTML:@"Do not have an account yet? <a href=\"tt://profile/edit\">Sign up</a>!"];
		text.font = [UIFont systemFontOfSize:11];
		signupLabel.text = text;
		signupLabel.backgroundColor = [UIColor clearColor];
		
		[signupLabel sizeToFit];
		
		signupLabel.frame = CGRectMake(floor((footerView.width - 250) / 2), 10, signupLabel.width, signupLabel.height);
		footerView.height = signupLabel.bottom;
		
		[footerView addSubview:signupLabel];
	}
	
	tableView.contentInset = UIEdgeInsetsMake((TTKeyboardNavigationFrame().size.height - footerView.height -
											   (ttkDefaultRowHeight * 2) -
											   (ttkGroupedTableCellInset * 2)) / 2,
											  0,
											  0,
											  0);
	
	tableView.tableFooterView = footerView;
	TT_RELEASE_SAFELY(footerView);
	
	tableView.scrollEnabled = NO;
	
	[self.view addSubview:tableView];
	TT_RELEASE_SAFELY(tableView);
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:MSSessionDidLoginNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:MSSessionDidTimeoutNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:MSSessionLoginDidFailNotification object:nil];
	
    TT_RELEASE_SAFELY(_emailField);
    TT_RELEASE_SAFELY(_passwordField);
	
    [super dealloc];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
	if(textField == _passwordField)
		_passwordField.text = [SFHFKeychainUtils getPasswordForUsername:_emailField.text
														 andServiceName:kManistoneService
																  error:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.returnKeyType == UIReturnKeyNext) {
        [_passwordField becomeFirstResponder];
    }
    else {
        if(TTIsStringWithAnyText(_emailField.text) && TTIsStringWithAnyText(_passwordField.text)) {
			[[MSSession applicationSession] loginWithEmail:_emailField.text password:_passwordField.text];
			
			[self startActivity:NSLocalizedString(@"Logging in...", @"")];
			
			[textField resignFirstResponder];
		}
    }
	
    return YES;
}

- (void)userDidLogin:(NSNotification *)notification {
	[[NSUserDefaults standardUserDefaults] setValue:_emailField.text forKey:@"kEmail"];
	
	[SFHFKeychainUtils storeUsername:_emailField.text
						 andPassword:_passwordField.text
					  forServiceName:kManistoneService
					  updateExisting:YES
							   error:nil];
	
	[self dismissModalViewControllerAnimated:YES];
}

- (void)loginDidTimeout:(NSNotification *)notification {
	[self stopActivity];
}

- (void)loginDidFail:(NSNotification *)notification {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Could not login", @"")
													message:NSLocalizedString(@"Username and password did not match.", @"")
												   delegate:nil
										  cancelButtonTitle:nil
										  otherButtonTitles:@"OK", nil];
	
	[alert show];
	TT_RELEASE_SAFELY(alert);
	
	[self stopActivity];
}

@end
