//
//  StoneEditController.h
//  Manistone
//
//  Created by Eugenio Depalo on 14/09/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSStone.h"
#import "MSLocationPickerDelegate.h"

@interface StoneEditController : TTViewController <UITextFieldDelegate, TTTextEditorDelegate, TTURLRequestDelegate, MSLocationPickerDelegate> {
	BOOL _isNewStone;
	BOOL _done;

	MSStone *_stone;
	MSStone *_originalStone;
	UIScrollView *_scrollView;
	TTTextEditor *_textEditor;
	TTPickerTextField *_tagsField;
	NSMutableArray *_fields;
	
	id<TTURLRequestDelegate> _delegate;
}

- (void)layoutViews;

@end
