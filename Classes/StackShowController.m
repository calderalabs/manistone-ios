//
//  StackShowController.m
//  Manistone
//
//  Created by Eugenio Depalo on 26/10/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "StackShowController.h"
#import "MSStackDataSource.h"
#import "MSStackDelegate.h"
#import "MSSession.h"
#import "MSMemberRequest.h"
#import "MSDeleteResourceDelegate.h"

#import "StackEditController.h"

@implementation StackShowController

- (void)createModel {
	self.dataSource = [[[MSStackDataSource alloc] initWithUid:_uid] autorelease];
}

- (void)updateHeaderView {
	CGSize size = [_nameLabel.text sizeWithFont:_nameLabel.font constrainedToSize:CGSizeMake(self.tableView.tableHeaderView.width - 20, CGFLOAT_MAX)];
	
	_nameLabel.frame = CGRectMake(floor((self.tableView.tableHeaderView.width - size.width) / 2),
								  10,
								  size.width,
								  size.height);

	_tipLabel.top = _tipView.top = _nameLabel.bottom + 10;
	
	self.tableView.tableHeaderView.height = self.editing ? _tipView.bottom + 10 : _nameLabel.bottom + 10;
	self.tableView.tableHeaderView = self.tableView.tableHeaderView;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
	[super setEditing:editing animated:animated];
	
	static const CGFloat displacement = 20;
	
	if(editing) {
		_tipView.top += displacement;
		_tipLabel.top += displacement;
	}
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.3];
	
	if(editing) {
		_tipView.top -= displacement;
		_tipLabel.top -= displacement;
	}
	
	[self updateHeaderView];
	
	_tipView.alpha = editing ? 0.5 : 0;
	_tipLabel.alpha = editing ? 1.0 : 0;
	
	[UIView commitAnimations];
}

- (void)didLoadModel:(BOOL)firstTime {
	[super didLoadModel:firstTime];
	
	MSStackDataSource *dataSource = (MSStackDataSource *)self.dataSource;
	
	TT_RELEASE_SAFELY(_stack);
	_stack = [(MSStack *)dataSource.remoteObjectModel.remoteObject retain];
	
	_nameLabel.text = _stack.name;

	[self updateHeaderView];
	
	if([_stack.user.uid isEqualToNumber:[MSSession applicationSession].user.uid]) {
		if(!self.navigationItem.rightBarButtonItem)
			self.navigationItem.rightBarButtonItem = [self editButtonItem];
		
		if(_actionsToolbar.hidden == YES) {
			_actionsToolbar.hidden = NO;
			self.tableView.height -= _actionsToolbar.height;
		}
	}
	else
		[self.navigationItem setRightBarButtonItem:nil animated:YES];
}

- (void)edit:(id)sender {
	if(self.editing) {
		MSStackDataSource *dataSource = (MSStackDataSource *)self.dataSource;
		
		[[TTNavigator navigator] openURLAction:[[[TTURLAction actionWithURLPath:@"tt://stack/edit"]
												 applyAnimated:YES]
												applyQuery:[NSDictionary dictionaryWithObjectsAndKeys:_stack, @"stack",
															dataSource.remoteObjectModel, @"delegate",
															nil]]];
	}
}

- (id<UITableViewDelegate>)createDelegate {
	return [[[MSStackDelegate alloc] initWithController:self] autorelease];
}

- (id)initWithUid:(NSUInteger)uid {
	if(self = [self init]) {
		_uid = uid;
		
		self.title = NSLocalizedString(@"Stack Details", @"");
		
		_nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
		_nameLabel.backgroundColor = [UIColor clearColor];
		_nameLabel.font = [UIFont boldSystemFontOfSize:18];
		_nameLabel.textColor = [UIColor whiteColor];
		_nameLabel.numberOfLines = 0;
		_nameLabel.textAlignment = UITextAlignmentCenter;
		
		UIButton *headerView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, TTApplicationFrame().size.width, 0)];
		[headerView addTarget:self action:@selector(edit:) forControlEvents:UIControlEventTouchUpInside];
		headerView.backgroundColor = TTSTYLEVAR(controlTintColor);
		[headerView addSubview:_nameLabel];
		
		_tipLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		_tipLabel.text = NSLocalizedString(@"Tap title to edit", @"");
		_tipLabel.backgroundColor = [UIColor clearColor];
		_tipLabel.textColor = [UIColor whiteColor];
		_tipLabel.font = [UIFont systemFontOfSize:14.0];
		
		[_tipLabel sizeToFit];
		_tipLabel.textAlignment = UITextAlignmentCenter;
		
		_tipView = [[TTView alloc] initWithFrame:CGRectMake(floor((headerView.width - _tipLabel.width - 20) / 2),
																   0, _tipLabel.width + 20, _tipLabel.height + 20)];
		_tipView.backgroundColor = [UIColor clearColor];
		_tipView.style = [TTShapeStyle styleWithShape:[TTSpeechBubbleShape shapeWithRadius:6 pointLocation:90
																				pointAngle:0.
																				 pointSize:CGSizeMake(20,10)] next:
						  [TTSolidFillStyle styleWithColor:[UIColor blackColor] next:
						   [TTSolidBorderStyle styleWithColor:[UIColor whiteColor] width:2 next:nil]]];
		_tipView.alpha = 0;
		_tipLabel.alpha = 0;
		
		_tipLabel.frame = _tipView.frame;
		_tipLabel.height += 10;
		
		[headerView addSubview:_tipView];
		[headerView addSubview:_tipLabel];

		self.tableView.tableHeaderView = headerView;
		
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

- (void)dealloc {
	TT_RELEASE_SAFELY(_stack);
	TT_RELEASE_SAFELY(_tipLabel);
	TT_RELEASE_SAFELY(_tipView);
	TT_RELEASE_SAFELY(_actionsToolbar);
	
	[super dealloc];
}

- (void)showActions:(id)sender {
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"More actions", @"")
															 delegate:self
													cancelButtonTitle:NSLocalizedString(@"Cancel", @"")
											   destructiveButtonTitle:NSLocalizedString(@"Delete", @"")
													otherButtonTitles:nil];
	
	[actionSheet showFromToolbar:_actionsToolbar];
	
	TT_RELEASE_SAFELY(actionSheet);
}

- (void)delete {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Confirmation", @"")
													message:NSLocalizedString(@"Are you sure you want to delete this stack?", @"")
												   delegate:self
										  cancelButtonTitle:NSLocalizedString(@"Cancel", @"")
										  otherButtonTitles:@"OK", nil];
	
	alert.delegate = self;
	
	[alert show];
	
	TT_RELEASE_SAFELY(alert);
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if(buttonIndex == actionSheet.destructiveButtonIndex)
		[self delete];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if(buttonIndex == alertView.firstOtherButtonIndex) {
		MSMemberRequest	*request = [[MSMemberRequest alloc] initWithResource:@"stacks"
																	  member:[_stack.uid description]
																	  action:MSMemberRequestActionDelete
																  parameters:nil
																	delegate:[[[MSDeleteResourceDelegate alloc] initWithController:self
																															  text:NSLocalizedString(@"Deleting stack...", @"")] autorelease]];
		
		[request send];
		
		TT_RELEASE_SAFELY(request);
	}
}

@end