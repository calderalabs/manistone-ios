//
//  StackEditController.h
//  Manistone
//
//  Created by Eugenio Depalo on 23/10/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSStack.h"

@interface StackEditController : TTTableViewController {
	BOOL _isNewStack;
	MSStack *_stack;
	
	UITextField *_nameField;
	
	id<TTURLRequestDelegate> _delegate;
}

@end
