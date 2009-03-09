//
//  GuardianAPI.m
//  Guardian
//
//  Created by Matt Biddulph on 04/03/2009.
//  Copyright 2009 Hackdiary Ltd. All rights reserved.
//

#import "GuardianContent.h"
#import "GuardianAPI.h"
#import "NSString+URLEncoding.h"
#import "GTMHTTPFetcher.h"
#import "XPathQuery.h"
#import "NSString+SBJSON.h"

@implementation GuardianAPI
- (NSString *) urlForMethod:(NSString *)methodName withParams:(NSDictionary *)params {
	NSString *url = [NSString stringWithFormat:@"%@/%@?", GUARDIAN_API_PREFIX, methodName];
	url = [url stringByAppendingFormat:@"%@=%@", @"api_key", [GUARDIAN_API_KEY URLEncodedString]];
	url = [url stringByAppendingFormat:@"&%@=%@", @"format", @"json"];

	for(id key in params) {
		url = [url stringByAppendingFormat:@"&%@=%@", key, [[params objectForKey:key] URLEncodedString]];
	}
	NSLog(@"API call: %@", url);
	return url;
}

- (void) latestContentWithDelegate:(id)successDelegate didSucceedSelector:(SEL)sel {
	[self callMethod:@"search" withParams:[NSDictionary dictionaryWithObjectsAndKeys:@"desc",@"order-by-date",@"50",@"count",nil] withDelegate:successDelegate didSucceedSelector:sel];
}

- (void) searchWithFilter:(NSString *)filter withDelegate:(id)successDelegate didSucceedSelector:(SEL)sel {
	[self callMethod:@"search" withParams:[NSDictionary dictionaryWithObject:filter forKey:@"filter"] withDelegate:successDelegate didSucceedSelector:sel];
}

- (void) searchQuery:(NSString *)q withDelegate:(id)successDelegate didSucceedSelector:(SEL)sel {
	[self callMethod:@"search" withParams:[NSDictionary dictionaryWithObject:q forKey:@"q"] withDelegate:successDelegate didSucceedSelector:sel];
}

- (void) searchQuery:(NSString *)q withFilter:(NSString *)filter withDelegate:(id)successDelegate didSucceedSelector:(SEL)sel {
}

- (void) allSubjectsWithDelegate: (id)successDelegate didSucceedSelector:(SEL)sel {
	[self callMethod:@"tags" withParams:[NSDictionary dictionaryWithObject:@"100" forKey:@"count"] withDelegate:successDelegate didSucceedSelector:sel];
}

- (NSDictionary *)parseJsonTagData:(NSData *)data {
	NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	NSMutableDictionary *tags = [NSMutableDictionary dictionary];
	for(NSDictionary *info in [[[json JSONValue] objectForKey:@"subjects"] objectForKey:@"tags"]) {
		[tags setObject:[info objectForKey:@"filter"] forKey:[info objectForKey:@"name"]];
	}
	[tags autorelease];
	return tags;
}

- (NSDictionary *)parseXmlTagData:(NSData *)data {
	NSArray *contentFields = PerformXMLXPathQuery(data, @"/tags/tag");
	
	NSMutableDictionary *tags = [NSMutableDictionary dictionary];
	NSString *name = nil;
	NSString *filter = nil;

	for(NSDictionary *tag in contentFields) {
		for(NSDictionary *attr in [tag objectForKey:@"nodeAttributeArray"]) {
			NSString *key = [attr objectForKey:@"attributeName"];
			if([key isEqualToString:@"name"]) {
				name = [attr objectForKey:@"nodeContent"];
			}
			if([key isEqualToString:@"filter"]) {
				filter = [attr objectForKey:@"nodeContent"];
			}
		}
		if(filter != nil && name != nil) {
			[tags setObject:filter forKey:name];
		}
	}
	return tags;
}

- (NSArray *)parseJsonSearchData:(NSData *)data {
	NSDateFormatter *sISO8601 = [[NSDateFormatter alloc] init];
	
	sISO8601.timeStyle = NSDateFormatterFullStyle;
	sISO8601.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss";
	
	NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	NSMutableArray *content = [NSMutableArray array];
	for(NSDictionary *info in [[[json JSONValue] objectForKey:@"search"] objectForKey:@"results"]) {
		GuardianContent *c = [[[GuardianContent alloc] init] autorelease];
		c.headline = [info objectForKey:@"headline"];
		c.type = [info objectForKey:@"type"];
		c.standfirst = [info objectForKey:@"standfirst"];
		c.byline = [info objectForKey:@"byline"];
		c.url = [info objectForKey:@"webUrl"];
		c.publicationDate = [sISO8601 dateFromString: [info objectForKey:@"publicationDate"]];
		c.imageUrl = [info objectForKey:@"trailImage"];
		if([c.type isEqualToString:@"article"]) {
			c.body = [[info objectForKey:@"typeSpecific"] objectForKey:@"body"];
		}
		NSMutableDictionary *tags = [NSMutableDictionary dictionary];
		for(NSDictionary *tag in [info objectForKey:@"tags"]) {
			[tags setObject:[tag objectForKey:@"filter"] forKey:[tag objectForKey:@"name"]];
		}
		c.tags = tags;
		
		NSScanner* scanner = [NSScanner scannerWithString:[info objectForKey:@"id"]];
		NSInteger anInteger;
		if([scanner scanInt:&anInteger] == YES) {
			c.contentId = anInteger;
		}
		
		[c save];
		[content addObject:c];
	}
	[sISO8601 release];
	[json release];
	return content;
}

- (NSArray *)parseXmlSearchData:(NSData *)data {
	NSDateFormatter *sISO8601 = [[NSDateFormatter alloc] init];
	
	sISO8601.timeStyle = NSDateFormatterFullStyle;
	sISO8601.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss";
	NSMutableArray *content = [NSMutableArray array];
	
	NSArray *contentFields = PerformXMLXPathQuery(data, @"/search/results/content");
	
	NSDictionary *info;
	for(info in contentFields) {
		GuardianContent *c = [[[GuardianContent alloc] init] autorelease];
		NSDictionary *keyvalue;
		for(keyvalue in [info objectForKey:@"nodeAttributeArray"]) {
			NSString *key = [keyvalue objectForKey:@"attributeName"];
			if([key isEqualToString:@"type"]) {
				c.type = [keyvalue objectForKey:@"nodeContent"];
			}
			if([key isEqualToString:@"web-url"]) {
				c.url = [keyvalue objectForKey:@"nodeContent"];
			}
			if([key isEqualToString:@"id"]) {
				NSString *cid = [keyvalue objectForKey:@"nodeContent"];
				NSScanner* scanner = [NSScanner scannerWithString:cid];
				NSInteger anInteger;
				
				if([scanner scanInt:&anInteger] == YES) {
					c.contentId = anInteger;
				}
			}			
		}
		for(keyvalue in [info objectForKey:@"nodeChildArray"]) {
			NSString *key = [keyvalue objectForKey:@"nodeName"];
			if([key isEqualToString:@"headline"]) {
				c.headline = [keyvalue objectForKey:@"nodeContent"];
			}
			
			if([key isEqualToString:@"trail-image"]) {
				c.imageUrl = [keyvalue objectForKey:@"nodeContent"];
			}
			if([key isEqualToString:@"byline"]) {
				c.byline = [keyvalue objectForKey:@"nodeContent"];
			}
			if([key isEqualToString:@"standfirst"]) {
				c.standfirst = [keyvalue objectForKey:@"nodeContent"];
			}
			if([key isEqualToString:@"publication-date"]) {
				c.publicationDate = [sISO8601 dateFromString: [keyvalue objectForKey:@"nodeContent"]];
			}
			if([key isEqualToString:@"tagged-with"]) {
				NSArray *taggedWith = [keyvalue objectForKey:@"nodeChildArray"];
				NSMutableDictionary *tags = [NSMutableDictionary dictionary];
				NSDictionary *t;
				for(t in taggedWith) {
					NSDictionary *t2;
					NSString *name=nil;
					NSString *filter=nil;
					
					for(t2 in [t objectForKey:@"nodeAttributeArray"]) {
						
						NSString *key = [t2 objectForKey:@"attributeName"];
						if([key isEqualToString:@"name"]) {
							name = [t2 objectForKey:@"nodeContent"];
						}				
						if([key isEqualToString:@"filter"]) {
							filter = [t2 objectForKey:@"nodeContent"];
						}
					}
					if(filter != nil && name != nil) {
						[tags setObject:filter forKey:name];						
					}
				}
				c.tags = tags;
			}
		}
		[c save];
		[content addObject:c];
	}
	[sISO8601 release];
	return content;
}	

- (void)myFetcher:(GTMHTTPFetcher *)fetcher finishedWithData:(NSData *)data {
	NSString *method = [[fetcher properties] objectForKey:@"method"];
	SEL sel = [[[fetcher properties] objectForKey:@"selector"] pointerValue];
	id delegate = [[fetcher properties] objectForKey:@"delegate"];

	if([method isEqualToString:@"search"]) {
		NSArray *content = [self parseJsonSearchData: data];
		[delegate performSelector:sel withObject:content];
	}
	if([method isEqualToString:@"tags"]) {
		NSDictionary *content = [self parseJsonTagData: data];
		[delegate performSelector:sel withObject:content];
	}
}

- (void)myFetcher:(GTMHTTPFetcher *)fetcher failedWithError:(NSError *)error {
	NSLog(@"ERROR: %@", error);
}

- (void) callMethod:(NSString *)method withParams:(NSDictionary *)params withDelegate:(id)successDelegate didSucceedSelector:(SEL)sel {
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[self urlForMethod:method withParams:params]]];
    GTMHTTPFetcher* myFetcher = [GTMHTTPFetcher httpFetcherWithRequest:request];
	
	NSValue* selector = [NSValue valueWithPointer:sel];
	NSDictionary *properties = [NSDictionary dictionaryWithObjectsAndKeys:successDelegate,@"delegate",selector,@"selector",method,@"method",nil];
	[myFetcher setProperties:properties];
	
#ifdef GUARDIAN_OFFLINE_MOCK
	NSString *filename = nil;
	
	if([method isEqualToString:@"search"]) {
		filename = @"search_order-by-date";
		if([params objectForKey:@"q"]) {
			if([params objectForKey:@"filter"]) {
				filename = @"search-q_twitter_biz-filter-jemima.xml";
			} else {
				filename = @"search-q_dopplr.xml";
			}
		} else {
			if([params objectForKey:@"filter"]) {
				filename = @"search_filter-_global_jemimakiss";
			}
		}
	}
	if([method isEqualToString:@"tags"]) {
		filename = @"all-subjects";
	}
	if(filename) {
		NSString *datapath = [[NSBundle mainBundle] 
							  pathForResource:filename 
							  ofType:@"xml"];
		NSData *data = [NSData dataWithContentsOfFile:datapath];
		[self myFetcher:myFetcher finishedWithData:data];
	} else {
		[self myFetcher:myFetcher failedWithError:[NSError errorWithDomain:@"guardianiata.com" code:1 userInfo:nil]];
	}
#else	
	[myFetcher beginFetchWithDelegate:self
					didFinishSelector:@selector(myFetcher:finishedWithData:)
                      didFailSelector:@selector(myFetcher:failedWithError:)];
#endif
}

@end
