//
//  LocalStoneEditController.m
//  Manistone
//
//  Created by Eugenio Depalo on 11/01/11.
//  Copyright 2011 Lucido Inc. All rights reserved.
//

#import "LocalStoneEditController.h"
#import "MSLocationPicker.h"
#import "MSStone.h"
#import "MSLocalStonesManager.h"

@implementation LocalStoneEditController

- (id)init {
	if(self = [super init]) {
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
																								target:self
																								action:@selector(save:)] autorelease];
		
		self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
																							   target:self
																							   action:@selector(cancel:)] autorelease];
	}
	
	return self;
}

- (id)initWithNavigatorURL:(NSURL *)URL query:(NSDictionary *)query {
	if(self = [self init]) {
		if([query valueForKey:@"stone"]) {
			_stone = [[query valueForKey:@"stone"] copy];
			_originalStone = [[query valueForKey:@"stone"] retain];
			_isNewStone = NO;
		}
		else {
			_stone = [[MSStone alloc] init];
			_stone.createdAt = [NSDate date];
			_isNewStone = YES;
			self.navigationItem.rightBarButtonItem.enabled = NO;
		}
		
		self.title = _isNewStone ? NSLocalizedString(@"New Stone", @"") : NSLocalizedString(@"Edit Stone", @"");
	}
	
	return self;
}

- (void)loadView {
	[super loadView];
	
	self.view.backgroundColor = TTSTYLEVAR(backgroundColor);
	
	_scrollView = [[[UIScrollView class] alloc] initWithFrame:TTKeyboardNavigationFrame()];
	_scrollView.backgroundColor = TTSTYLEVAR(backgroundColor);
	_scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
	_scrollView.canCancelContentTouches = NO;
	_scrollView.showsVerticalScrollIndicator = NO;
	_scrollView.showsHorizontalScrollIndicator = NO;
	[self.view addSubview:_scrollView];
	
	_textEditor = [[TTTextEditor alloc] initWithFrame:CGRectMake(0, 0, _scrollView.width, 0)];
	_textEditor.backgroundColor = TTSTYLEVAR(backgroundColor);
	_textEditor.font = TTSTYLEVAR(messageFont);
	_textEditor.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	_textEditor.delegate = self;
	_textEditor.autoresizesToText = YES;
	_textEditor.showsExtraLine = YES;
	_textEditor.minNumberOfLines = 6;
	_textEditor.text = _stone.engraving;
	
	[_textEditor sizeToFit];
	
	MSLocationPicker *locationField = [[MSLocationPicker alloc] initWithParentController:self startWithUserLocation:_isNewStone];
	
	locationField.showsPicker = NO;
	
	if(!_isNewStone)
		locationField.location = _stone.location;
	
	locationField.delegate = self;
	
		[locationField sizeToFit];
		locationField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		
		[_scrollView addSubview:locationField];
		
	TT_RELEASE_SAFELY(locationField);
	
		UIView* separator = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 1)];
		separator.backgroundColor = TTSTYLEVAR(messageFieldSeparatorColor);
		separator.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		[_scrollView addSubview:separator];
		
		TT_RELEASE_SAFELY(separator);
	
	[_scrollView addSubview:_textEditor];
	
	[self layoutViews];

}

- (void)dealloc {
	TT_RELEASE_SAFELY(_stone);
	TT_RELEASE_SAFELY(_originalStone);
	TT_RELEASE_SAFELY(_scrollView);
	TT_RELEASE_SAFELY(_textEditor);
	
	[super dealloc];
}

- (void)cancel:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
}

- (void)save:(id)sender {
	[_textEditor resignFirstResponder];
	
	if(_isNewStone)
		[[MSLocalStonesManager defaultManager].stones addObject:_stone];
	else {
		_originalStone.engraving = _stone.engraving;
		_originalStone.location = _stone.location;
	}
	
	[[MSLocalStonesManager defaultManager] save];
	
	[self dismissModalViewControllerAnimated:YES];
}

- (void)layoutViews {
	CGFloat y = 0;
	
	for (UIView *view in _scrollView.subviews) {
		view.frame = CGRectMake(0, y, self.view.width, view.height);
		y += view.height;
	}
	
	_scrollView.contentSize = CGSizeMake(_scrollView.width, y);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return TTIsSupportedOrientation(interfaceOrientation);
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	[super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
	_scrollView.height = self.view.height - TTKeyboardHeight();
	[self layoutViews];
}

- (void)locationPicker:(MSLocationPicker *)locationPicker didSelectLocation:(CLLocationCoordinate2D)location {
	_stone.location = location;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	return NO;
}

- (void)textEditorDidChange:(TTTextEditor*)textEditor {
	_stone.engraving = textEditor.text;
	
	self.navigationItem.rightBarButtonItem.enabled = TTIsStringWithAnyText(textEditor.text);
}

- (BOOL)textEditor:(TTTextEditor*)textEditor shouldResizeBy:(CGFloat)height {
	_textEditor.frame = TTRectContract(_textEditor.frame, 0, -height);
	[self layoutViews];
	[_textEditor scrollContainerToCursor:_scrollView];
	return NO;
}

@end
