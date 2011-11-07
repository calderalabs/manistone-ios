//
//  LocalStoneEditController.h
//  Manistone
//
//  Created by Eugenio Depalo on 11/01/11.
//  Copyright 2011 Lucido Inc. All rights reserved.
//

#import "MSStone.h"
#import "MSLocationPickerDelegate.h"

@interface LocalStoneEditController : TTViewController <TTTextEditorDelegate, MSLocationPickerDelegate> {
	MSStone *_stone;
	MSStone *_originalStone;
	UIScrollView *_scrollView;
	TTTextEditor *_textEditor;
	BOOL _isNewStone;
}

- (void)layoutViews;

@end
