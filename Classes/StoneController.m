//
//  StoneController.m
//  Manistone
//
//  Created by Eugenio Depalo on 14/09/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "StoneController.h"
#import "MSTagsDataSource.h"
#import "MSDedicationDataSource.h"
#import "MSCollectionRequest.h"
#import "MSLocationPicker.h"
#import "MSTag.h"

@implementation StoneController

- (id)initWithNavigatorURL:(NSURL*)URL query:(NSDictionary*)query {
	if(self = [self init]) {
		MSStone *stone = [query valueForKey:@"stone"];
		
		if(stone)
			_stone = [stone retain];
		else
			_stone = [[MSStone alloc] init];

		self.title = @"Engrave Stone";
		
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
																								target:self
																								action:@selector(save:)] autorelease];
		
		self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
																							   target:self
																							   action:@selector(cancel:)] autorelease];
		
		_fields = [[NSMutableArray alloc] init];
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
	[_textEditor sizeToFit];
	
	NSMutableArray *titles = [[NSMutableArray alloc] init];
	
	_tagsField = [[TTPickerTextField alloc] init];
	_tagsField.dataSource = [[[MSTagsDataSource alloc] init] autorelease];
	_tagsField.delegate = self;
	
	[_tagsField becomeFirstResponder];
	
	[titles addObject:@"Tags"];
	[_fields addObject:_tagsField];
	
	TTPickerTextField *dedicationField = [[TTPickerTextField alloc] init];
	dedicationField.dataSource = [[[MSDedicationDataSource alloc] initWithParameters:nil] autorelease];
	
	dedicationField.delegate = self;
	
	[titles addObject:@"Dedication"];
	[_fields addObject:dedicationField];
	TT_RELEASE_SAFELY(dedicationField);
	
	MSLocationPicker *locationField = [[MSLocationPicker alloc] initWithController:self];
	locationField.delegate = self;
	
	[_fields addObject:locationField];
	TT_RELEASE_SAFELY(locationField);
	
	for(UIView *field in _fields) {
		if([field isKindOfClass:[UITextField class]]) {
			UITextField *textField = (UITextField *)field;
			textField.autocorrectionType = UITextAutocorrectionTypeNo;
			textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
			textField.rightViewMode = UITextFieldViewModeAlways;
			textField.delegate = self;
			
			UILabel *label = [[UILabel alloc] init];
			
			NSString *text = [[NSString alloc] initWithFormat:@"%@:", [titles objectAtIndex:[_fields indexOfObject:textField]]];
			label.text = text;
			TT_RELEASE_SAFELY(text);
			
			label.font = TTSTYLEVAR(messageFont);
			label.textColor = TTSTYLEVAR(messageFieldTextColor);
			[label sizeToFit];
			label.frame = CGRectInset(label.frame, -2, 0);
			textField.leftView = label;
			textField.leftViewMode = UITextFieldViewModeAlways;
			
			TT_RELEASE_SAFELY(label);
		}
		
		[field sizeToFit];
		field.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		
		[_scrollView addSubview:field];
		
		UIView* separator = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 1)];
		separator.backgroundColor = TTSTYLEVAR(messageFieldSeparatorColor);
		separator.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		[_scrollView addSubview:separator];
		
		TT_RELEASE_SAFELY(separator);
	}
	
	TT_RELEASE_SAFELY(titles);
	
	[_scrollView addSubview:_textEditor];
	
	[self layoutViews];
}

- (void)dealloc {
	TT_RELEASE_SAFELY(_stone);
	TT_RELEASE_SAFELY(_scrollView);
	TT_RELEASE_SAFELY(_textEditor);
	TT_RELEASE_SAFELY(_fields);
	TT_RELEASE_SAFELY(_tagsField);
	
	[super dealloc];
}

- (void)cancel:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
}

- (void)save:(id)sender {
	MSCollectionRequest *request = [[[MSCollectionRequest alloc] initWithResource:@"stones"
																		  action:MSCollectionRequestActionCreate
																	  parameters:[NSDictionary dictionaryWithObject:[_stone attributes] forKey:@"stone"]
																		delegate:self] autorelease];
	
	[request send];
}

- (void)requestDidFinishLoad:(TTURLRequest *)request {
	[self dismissModalViewControllerAnimated:YES];
}

- (void)request:(TTURLRequest*)request didFailLoadWithError:(NSError*)error {
	if(error.code == 422) {
		TTURLJSONResponse *response = (TTURLJSONResponse *)request.response;

		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to create stone"
														message:[[response.rootObject valueForKey:@"errors"] componentsJoinedByString:@"\n"]
													   delegate:nil
											  cancelButtonTitle:nil
											  otherButtonTitles:@"OK", nil];
		
		[alert show];
		TT_RELEASE_SAFELY(alert);
	}
}

- (void)pickLocation:(id)sender {
	[[TTNavigator navigator] openURLAction:[[[TTURLAction actionWithURLPath:@"tt://stone/location"]
											 applyAnimated:YES]
											 applyQuery:[NSDictionary dictionaryWithObjectsAndKeys:self, @"delegate", _stone, @"stone", nil]]];
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

- (void)textField:(TTPickerTextField*)textField didAddCellAtIndex:(id)index {
	if(textField == _tagsField) {
		TTTableTextItem *item = [textField.cells lastObject];
		[_stone.tags addObject:item.userInfo];
	}
}

- (void)textField:(TTPickerTextField*)textField didRemoveCellAtIndex:(NSUInteger)index {
	if(textField == _tagsField) {
		[_stone.tags removeLastObject];
	}
}

- (void)locationPicker:(MSLocationPicker *)locationPicker didSelectLocation:(CLLocationCoordinate2D)location {
	_stone.location = location;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	textField.text = nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	NSUInteger fieldIndex = [_fields indexOfObject:textField];
	UIView* nextView = fieldIndex == _fields.count-2
    ? _textEditor
    : [_fields objectAtIndex:fieldIndex+1];
	[nextView becomeFirstResponder];
	return NO;
}

- (void)textFieldDidResize:(TTPickerTextField*)textField {
	[self layoutViews];
}

- (void)textEditorDidChange:(TTTextEditor*)textEditor {
	_stone.engraving = textEditor.text;
}

- (BOOL)textEditor:(TTTextEditor*)textEditor shouldResizeBy:(CGFloat)height {
	_textEditor.frame = TTRectContract(_textEditor.frame, 0, -height);
	[self layoutViews];
	[_textEditor scrollContainerToCursor:_scrollView];
	return NO;
}

@end