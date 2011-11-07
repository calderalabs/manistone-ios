//
//  MSMessage.m
//  Manistone
//
//  Created by Eugenio Depalo on 06/11/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSMessage.h"
#import "MSUser.h"

@implementation MSMessage

@synthesize user = _user;
@synthesize recipients = _recipients;
@synthesize text = _text;
@synthesize subject = _subject;

@synthesize unread = _unread;

+ (NSString *)collectionName {
	return @"messages";
}

- (id)init {
	if(self = [super init]) {
		_recipients = [[NSMutableArray alloc] init];
	}
	
	return self;
}

- (id)initWithAttributes:(NSDictionary *)attributes {
	if(self = [super initWithAttributes:attributes]) {
		_user = [[MSUser alloc] initWithAttributes:[attributes valueForKey:@"user"]];
		
		_text = [[attributes valueForKey:@"text"] retain];
		_subject = [[attributes valueForKey:@"subject"] retain];
		
		_unread = [[attributes valueForKey:@"unread"] boolValue];
		
		for(NSDictionary *rawRecipient in [attributes valueForKey:@"recipients"]) {
			MSUser *recipient = [[MSUser alloc] initWithAttributes:rawRecipient];
			[_recipients addObject:recipient];
			TT_RELEASE_SAFELY(recipient);
		}
	}
	
	return self;
}

- (NSDictionary *)attributes {
	NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
	
	[attributes setValue:_text forKey:@"text"];			
	[attributes setValue:_subject forKey:@"subject"];
	
	NSMutableArray *recipientIds = [[NSMutableArray alloc] init];
	
	for(MSUser *recipient in _recipients)
		[recipientIds addObject:recipient.uid];
	
	[attributes setValue:[recipientIds componentsJoinedByString:@","] forKey:@"recipient_ids"];
	
	TT_RELEASE_SAFELY(recipientIds);
	
	[attributes addEntriesFromDictionary:[super attributes]];
	
	return [NSDictionary dictionaryWithDictionary:attributes];
}

- (void)dealloc {
	TT_RELEASE_SAFELY(_user);
	TT_RELEASE_SAFELY(_recipients);
	TT_RELEASE_SAFELY(_text);
	TT_RELEASE_SAFELY(_subject);
	
	[super dealloc];
}

@end
