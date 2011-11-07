//
//  SessionController.h
//  Manistone
//
//  Created by Eugenio Depalo on 09/09/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

@interface SessionController : TTViewController <UITextFieldDelegate, TTURLRequestDelegate> {
	UITextField *_emailField;
	UITextField *_passwordField;
}

@end
