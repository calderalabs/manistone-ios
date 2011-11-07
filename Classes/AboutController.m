//
//  AboutController.m
//  Manistone
//
//  Created by Eugenio Depalo on 15/11/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "AboutController.h"

@implementation AboutController

- (id)initWithNavigatorURL:(NSURL *)URL query:(NSDictionary *)query {
	if(self = [self init]) {
		self.title = NSLocalizedString(@"About", @"");
		
		self.tableViewStyle = UITableViewStyleGrouped;
		self.variableHeightRows = YES;
	}
	
	return self;
}

- (void)loadView {
	[super loadView];
	
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Close", @"")
																			  style:UIBarButtonItemStylePlain
																					target:self
																					action:@selector(cancel:)] autorelease];
	
	UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TTApplicationFrame().size.width, 100)];
	UIImageView *logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AboutIcon.png"]];
	
	logoView.frame = CGRectMake(floor((headerView.width - logoView.width) / 2),
								floor((headerView.height - logoView.height) / 2),
								logoView.width,
								logoView.height);
	
	[headerView addSubview:logoView];
	
	TT_RELEASE_SAFELY(logoView);
	
	self.tableView.tableHeaderView = headerView;
	
	TT_RELEASE_SAFELY(headerView);
}

- (void)cancel:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
}

- (void)createModel {
	self.dataSource = [TTSectionedDataSource dataSourceWithObjects:[NSString stringWithFormat:NSLocalizedString(@"Manistone %@ (Build %@)", @""),
																	[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"],
																	[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]],
					   [TTTableTextItem itemWithText:NSLocalizedString(@"Engrave your thoughts.", @"")],
					   @"Policies",
					   [TTTableTextItem itemWithText:NSLocalizedString(@"Terms of Service", @"") URL:@"http://www.manistone.net/tos.php?format=iphone"],
					   [TTTableTextItem itemWithText:NSLocalizedString(@"Privacy Policy", @"") URL:@"http://www.manistone.net/privacy.php?format=iphone"],
					   @"Help",
					   [TTTableTextItem itemWithText:NSLocalizedString(@"Resend activation", @"") URL:@"tt://account/resend_activation"],
					   [TTTableTextItem itemWithText:NSLocalizedString(@"Forgot your password", @"") URL:@"tt://account/forgot_password"],
					   nil];
}

@end
