//
//  StoneShowController.m
//  Manistone
//
//  Created by Eugenio Depalo on 08/10/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSStoneDataSource.h"
#import "StoneShowController.h"
#import "MSStone.h"
#import "MSTableViewSubItemsDelegate.h"
#import "MSSession.h"
#import "StoneEditController.h"
#import "MSMemberRequest.h"
#import "MSDeleteResourceDelegate.h"
#import "SHK.h"

enum {
	kShareAction = 0,
	kDedicateAction,
	kAddToStackAction,
};

#ifndef LITE_VERSION
static const NSString *kGoogleTranslateAPIKey = @"YOUR_GOOGLE_TRANSLATE_API_KEY";
#endif

@interface StoneShowController (Private)

- (void)resizeViews;

@end

@implementation StoneShowController

@synthesize engraving;

- (void)replaceItemAtIndex:(NSUInteger)index withItem:(TTTableItem *)item {
	MSStoneDataSource *dataSource = (MSStoneDataSource *)self.dataSource;
	
	[dataSource.items replaceObjectAtIndex:0 withObject:item];
	dataSource.items = dataSource.items;
	
	[self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)createModel {
	self.dataSource = [[[MSStoneDataSource alloc] initWithUid:_uid] autorelease];
}

- (void)edit:(id)sender {
	MSStoneDataSource *dataSource = (MSStoneDataSource *)self.dataSource;
	
	[[TTNavigator navigator] openURLAction:[[[TTURLAction actionWithURLPath:@"tt://stone/edit"]
											 applyAnimated:YES]
											applyQuery:[NSDictionary dictionaryWithObjectsAndKeys:_stone, @"stone",
														dataSource.remoteObjectModel, @"delegate",
														nil]]];
}

- (void)setEngraving:(NSString *)text {
	_engravingLabel.text = text;
	[self resizeViews];
}

- (id<UITableViewDelegate>)createDelegate {
	return [[[MSTableViewSubItemsDelegate alloc] initWithController:self] autorelease];
}

- (id)initWithUid:(NSUInteger)uid {
	if(self = [self init]) {
		_uid = uid;
		
		self.title = NSLocalizedString(@"Stone Details", @"");
		
		_engravingLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, 0, 0)];
		_engravingLabel.backgroundColor = [UIColor clearColor];
		_engravingLabel.font = [UIFont boldSystemFontOfSize:15];
		_engravingLabel.textColor = [UIColor whiteColor];
		_engravingLabel.numberOfLines = 0;
		
		_engravingView = [[TTView alloc] initWithFrame:CGRectMake(0, 0, TTApplicationFrame().size.width, 0)];
		_engravingView.backgroundColor = RGBCOLOR(200, 200, 200);
		_engravingView.style = 
		[TTShapeStyle styleWithShape:[TTRoundedRectangleShape shapeWithRadius:5] next:
		 [TTSolidBorderStyle styleWithColor:[UIColor clearColor] width:8 next:
		  [TTSolidFillStyle styleWithColor:RGBCOLOR(100, 100, 100) next:
		   nil]]];
		[_engravingView addSubview:_engravingLabel];
		
		_dateLabel = [[UILabel alloc] init];
		_dateLabel.backgroundColor = [UIColor clearColor];
		_dateLabel.font = [UIFont systemFontOfSize:13];
		_dateLabel.textColor = [UIColor whiteColor];
		
		[_engravingView addSubview:_dateLabel];
		
		self.tableView.tableHeaderView = _engravingView;
		
		self.tableView.tableFooterView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
		
		_actionsToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,
																	  TTNavigationFrame().size.height - TT_TOOLBAR_HEIGHT,
																	  TTNavigationFrame().size.width,
																	  TT_TOOLBAR_HEIGHT)];
		
		_actionsToolbar.items = [NSArray arrayWithObjects:
								 [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease],
								 [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(showActions:)] autorelease],
								 [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease],
								 nil];
		
		_actionsToolbar.tintColor = TTSTYLEVAR(toolbarTintColor);
		_actionsToolbar.hidden = YES;
		
		[self.view addSubview:_actionsToolbar];
	}
	
	return self;
}

- (void)didLoadModel:(BOOL)firstTime {
	[super didLoadModel:firstTime];
	
	MSStoneDataSource *dataSource = (MSStoneDataSource *)self.dataSource;
	
	TT_RELEASE_SAFELY(_stone);
	_stone = [(MSStone *)dataSource.remoteObjectModel.remoteObject retain];
	
	_dateLabel.text = [NSString stringWithFormat:@"%@", [_stone.createdAt formatRelativeTime]];
	[_dateLabel sizeToFit];
	
	self.engraving = _stone.engraving;
	
	if([_stone.user.uid isEqualToNumber:[MSSession applicationSession].user.uid]) {
		if(!self.navigationItem.rightBarButtonItem)
			[self.navigationItem setRightBarButtonItem:[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
																									  target:self
																									  action:@selector(edit:)] autorelease] animated:YES];
	}
	else
		[self.navigationItem setRightBarButtonItem:nil animated:YES];
	
	if(_actionsToolbar.hidden == YES) {
		_actionsToolbar.hidden = NO;
		self.tableView.height -= _actionsToolbar.height;
	}
	
#ifndef LITE_VERSION
	TT_RELEASE_SAFELY(_translateItem);
	
	_translateItem = [[TTTableButton itemWithText:[NSString stringWithFormat:@"Translate in %@", [[NSLocale currentLocale] displayNameForKey:NSLocaleLanguageCode value:[[NSLocale currentLocale] localeIdentifier]]]] retain];
	_translateItem.delegate = self;
	_translateItem.selector = @selector(translate:);
	
	[dataSource.items insertObject:_translateItem atIndex:0];
	dataSource.items = dataSource.items;
	
	TT_RELEASE_SAFELY(_translatedText);
	TT_RELEASE_SAFELY(_revertButton);
#endif
}

- (void)resizeViews {
	CGSize size = [_engravingLabel.text sizeWithFont:_engravingLabel.font
								   constrainedToSize:CGSizeMake(_engravingView.width - 40,
																INT_MAX)];
	
	_engravingLabel.frame = CGRectMake(_engravingLabel.origin.x, _engravingLabel.origin.y, size.width, size.height);
	
	CGFloat engravingHeight = _engravingLabel.height + 60;
	
	if(engravingHeight < 150)
		engravingHeight = 150;
	
	_engravingView.frame = CGRectMake(_engravingView.origin.x,
									  _engravingView.origin.y,
									  _engravingView.width,
									  engravingHeight);
	
	_dateLabel.frame = CGRectMake(_engravingView.right - _dateLabel.width - _engravingLabel.origin.x,
								  _engravingView.bottom - _dateLabel.height - _engravingLabel.origin.y - 3,
								  _dateLabel.width,
								  _dateLabel.height);
	
	self.tableView.tableHeaderView = _engravingView;
}

#ifndef LITE_VERSION
- (void)translate:(id)sender {
	if(_translatedText) {
		self.engraving = _translatedText;
		[self replaceItemAtIndex:0 withItem:_revertButton];
	}
	else {
		[self replaceItemAtIndex:0 withItem:[TTTableActivityItem itemWithText:NSLocalizedString(@"Translating...", @"")]];
		
		TTURLRequest *request = [TTURLRequest requestWithURL:[NSString stringWithFormat:@"https://www.googleapis.com/language/translate/v2?key=%@&format=text&q=%@&target=%@",
															  kGoogleTranslateAPIKey,
															  [_stone.engraving stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
															  [[NSLocale preferredLanguages] objectAtIndex:0]]
													delegate:self];
		
		request.response = [[[TTURLJSONResponse alloc] init] autorelease];
		
		[request send];
	}
}

- (void)requestDidFinishLoad:(TTURLRequest *)request {
	TTURLJSONResponse *response = (TTURLJSONResponse *)request.response;
	
	NSDictionary *translatedDictionary = [[[response.rootObject valueForKey:@"data"] valueForKey:@"translations"] objectAtIndex:0];
	_translatedText = [[translatedDictionary valueForKey:@"translatedText"] retain];
	self.engraving = _translatedText;
	
	NSString *languageString = [[NSLocale currentLocale] displayNameForKey:NSLocaleLanguageCode value:[translatedDictionary valueForKey:@"detectedSourceLanguage"]];
	
	_revertButton = [[TTTableButton itemWithText:[NSString stringWithFormat:@"Revert to %@", languageString]] retain];
	_revertButton.delegate = self;
	_revertButton.selector = @selector(revert:);
	
	[self replaceItemAtIndex:0 withItem:_revertButton];
}

- (void)revert:(id)sender {
	self.engraving = _stone.engraving;
	
	[self replaceItemAtIndex:0 withItem:_translateItem];
}

- (void)request:(TTURLRequest *)request didFailLoadWithError:(NSError *)error {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error translating stone", @"")
													message:NSLocalizedString(@"The text for this stone could not be translated.", @"")
												   delegate:nil
										  cancelButtonTitle:@"OK"
										  otherButtonTitles:nil];
	
	[alert show];
	
	TT_RELEASE_SAFELY(alert);
	
	[self replaceItemAtIndex:0 withItem:_translateItem];
}
#endif

- (void)delete {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Confirmation", @"")
													message:NSLocalizedString(@"Are you sure you want to delete this stone?", @"")
												   delegate:self
										  cancelButtonTitle:NSLocalizedString(@"Cancel", @"")
										  otherButtonTitles:@"OK", nil];
	
	alert.delegate = self;
	
	[alert show];
	
	TT_RELEASE_SAFELY(alert);
}

- (void)share {
	SHKItem *item = [SHKItem URL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.manistone.net/stone.php?id=%@", _stone.uid]] title:nil];
	
	SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];
	
	[actionSheet showInView:[TTNavigator navigator].visibleViewController.view];
}

- (void)addToStack {
	[[TTNavigator navigator] openURLAction:[[TTURLAction actionWithURLPath:[_stone URLValueWithName:@"addToStack"]] applyAnimated:YES]];
}

- (void)dedicate {
	[[TTNavigator navigator] openURLAction:[[TTURLAction actionWithURLPath:[_stone URLValueWithName:@"dedicate"]] applyAnimated:YES]];
}

- (void)showActions:(id)sender {
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"More actions", @"")
															 delegate:self
													cancelButtonTitle:NSLocalizedString(@"Cancel", @"")
											   destructiveButtonTitle:[[MSSession applicationSession].user.uid isEqualToNumber:_stone.user.uid] ? NSLocalizedString(@"Delete", @"") : nil
													otherButtonTitles:NSLocalizedString(@"Share", @""), NSLocalizedString(@"Dedicate", @""), NSLocalizedString(@"Add to Stack", @""),nil];
	
	[actionSheet showFromToolbar:_actionsToolbar];
	
	TT_RELEASE_SAFELY(actionSheet);
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if(buttonIndex == actionSheet.destructiveButtonIndex) {
		[self delete];
	}
	else if(buttonIndex == actionSheet.firstOtherButtonIndex + kAddToStackAction) {
		[self addToStack];
	}
	else if(buttonIndex == actionSheet.firstOtherButtonIndex + kShareAction) {
		[self share];
	}
	else if(buttonIndex == actionSheet.firstOtherButtonIndex + kDedicateAction) {
		[self dedicate];
	}
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if(buttonIndex == alertView.firstOtherButtonIndex) {
		MSMemberRequest	*request = [[MSMemberRequest alloc] initWithResource:@"stones"
																	  member:[_stone.uid description]
																	  action:MSMemberRequestActionDelete
																  parameters:nil
																	delegate:[[[MSDeleteResourceDelegate alloc] initWithController:self
																															  text:NSLocalizedString(@"Deleting stone...", @"")] autorelease]];
		
		[request send];
		
		TT_RELEASE_SAFELY(request);
	}
}

- (void)dealloc {
	TT_RELEASE_SAFELY(_stone);
	TT_RELEASE_SAFELY(_engravingLabel);
	TT_RELEASE_SAFELY(_engravingView);
	TT_RELEASE_SAFELY(_dateLabel);
	TT_RELEASE_SAFELY(_actionsToolbar);
	
#ifndef LITE_VERSION
	TT_RELEASE_SAFELY(_translateItem);
	TT_RELEASE_SAFELY(_translatedText);
	TT_RELEASE_SAFELY(_revertButton);
#endif
	
	[super dealloc];
}

@end
