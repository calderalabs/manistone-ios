//
//  StoneController.m
//  Manistone
//
//  Created by Eugenio Depalo on 14/09/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "StoneEditController.h"
#import "MSTagsDataSource.h"
#import "MSCollectionRequest.h"
#import "MSMemberRequest.h"
#import "MSLocationPicker.h"
#import "MSTag.h"
#import "MSLocalStonesManager.h"

#import <AudioToolbox/AudioToolbox.h>

@implementation StoneEditController

- (id)init {
	if(self = [super init]) {
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

- (id)initWithNavigatorURL:(NSURL *)URL query:(NSDictionary *)query {
	if(self = [self init]) {
		_done = NO;
		
		if([query valueForKey:@"stone"]) {
			_stone = [[query valueForKey:@"stone"] copy];
			_originalStone = [[query valueForKey:@"stone"] retain];
			_isNewStone = NO;
		}
		else {
			_stone = [[MSStone alloc] init];
			_isNewStone = YES;
		}
		
		self.title = !_stone.uid ? NSLocalizedString(@"Engrave Stone", @"") : NSLocalizedString(@"Edit Stone", @"");
		
		_delegate = [[query valueForKey:@"delegate"] retain];
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
	
	NSMutableArray *titles = [[NSMutableArray alloc] init];
	
	_tagsField = [[TTPickerTextField alloc] init];
	_tagsField.dataSource = [[[MSTagsDataSource alloc] init] autorelease];
	
	for(MSTag *tag in _stone.tags) {
		TTTableTextItem *item = [TTTableTextItem itemWithText:tag.name];
		item.userInfo = tag;
		
		[_tagsField addCellWithObject:item];
	}
	
	_tagsField.delegate = self;
	
	[_fields removeAllObjects];
	
	[titles addObject:NSLocalizedString(@"Tags", @"")];
	[_fields addObject:_tagsField];
	
	MSLocationPicker *locationField = [[MSLocationPicker alloc] initWithParentController:self startWithUserLocation:_isNewStone];
	
	if(!_isNewStone)
		locationField.location = _stone.location;
	
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
	
	[_tagsField becomeFirstResponder];
}

- (void)dealloc {
	TT_RELEASE_SAFELY(_originalStone);
	TT_RELEASE_SAFELY(_stone);
	TT_RELEASE_SAFELY(_scrollView);
	TT_RELEASE_SAFELY(_textEditor);
	TT_RELEASE_SAFELY(_fields);
	TT_RELEASE_SAFELY(_tagsField);
	TT_RELEASE_SAFELY(_delegate);
	
	[super dealloc];
}

- (void)viewDidDisappear:(BOOL)animated {
	if (_isNewStone && _done) {
		[[TTNavigator navigator] openURLAction:[[TTURLAction actionWithURLPath:[_stone URLValueWithName:@"show"]] applyAnimated:YES]];
	}
}

- (void)cancel:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
}

- (void)save:(id)sender {
	for(UIView *field in _fields)
		[field resignFirstResponder];
	
	[_textEditor resignFirstResponder];
	
	MSAPIRequest *request;
	
	if(_stone.uid)
		request = [[[MSMemberRequest alloc] initWithResource:@"stones"
													  member:[_stone.uid description]
													  action:MSMemberRequestActionUpdate
												  parameters:[NSDictionary dictionaryWithObject:[_stone attributes] forKey:@"stone"]
													delegate:_delegate] autorelease];
	else
		request = [[[MSCollectionRequest alloc] initWithResource:@"stones"
														  action:MSCollectionRequestActionCreate
													  parameters:[NSDictionary dictionaryWithObject:[_stone attributes] forKey:@"stone"]
														delegate:_delegate] autorelease];
	
	[request.delegates addObject:self];
	
	[request send];
	
	[self startActivity:_stone.uid ? NSLocalizedString(@"Updating stone...", @"") : NSLocalizedString(@"Creating stone...", @"")];
}

- (void)requestDidFinishLoad:(TTURLRequest *)request {
	NSString *path = [NSString stringWithFormat:@"%@%@",
					  [[NSBundle mainBundle] resourcePath],
					  @"/chisel.wav"];
	
	SystemSoundID soundID;
	
	NSURL *filePath = [NSURL fileURLWithPath:path isDirectory:NO];
	
	AudioServicesCreateSystemSoundID((CFURLRef)filePath, &soundID);
	AudioServicesPlaySystemSound(soundID);
	
	[[MSLocalStonesManager defaultManager].stones removeObjectIdenticalTo:_originalStone];
	
	_done = YES;
	[self dismissModalViewControllerAnimated:YES];
	
	TTURLJSONResponse *response = (TTURLJSONResponse *)request.response;
	
	_stone = [[MSStone alloc] initWithAttributes:response.rootObject];
	
	[self stopActivity];
}

- (void)request:(TTURLRequest*)request didFailLoadWithError:(NSError*)error {
	if(error.code == 422) {
		TTURLJSONResponse *response = (TTURLJSONResponse *)request.response;
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Unable to create stone", @"")
														message:[[response.rootObject valueForKey:@"errors"] componentsJoinedByString:@"\n"]
													   delegate:nil
											  cancelButtonTitle:nil
											  otherButtonTitles:@"OK", nil];
		
		[alert show];
		TT_RELEASE_SAFELY(alert);
	}
	
	[self stopActivity];
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

- (void)textField:(TTPickerTextField*)textField didAddCellAtIndex:(NSInteger)index {
	TTTableTextItem *item = [textField.cells objectAtIndex:index];
	
	[_stone.tags insertObject:item.userInfo atIndex:index];
}

- (void)textField:(TTPickerTextField*)textField didRemoveCellAtIndex:(NSInteger)index {
	[_stone.tags removeObjectAtIndex:index];
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