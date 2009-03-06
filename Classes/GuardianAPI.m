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


@implementation GuardianAPI
- (NSString *) urlForMethod:(NSString *)methodName withParams:(NSDictionary *)params {
	NSString *url = [NSString stringWithFormat:@"%@/%@?", GUARDIAN_API_PREFIX, methodName];
	url = [url stringByAppendingFormat:@"%@=%@", @"api_key", [GUARDIAN_API_KEY URLEncodedString]];

	for(id key in params) {
		url = [url stringByAppendingFormat:@"&%@=%@", key, [[params objectForKey:key] URLEncodedString]];
	}
	NSLog(@"API call: %@", url);
	return url;
}

- (void) latestContentWithDelegate:(id)successDelegate didSucceedSelector:(SEL)sel {
	[self callMethod:@"search" withParams:[NSDictionary dictionaryWithObject:@"desc" forKey:@"order-by-date"] withDelegate:successDelegate didSucceedSelector:sel];
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
	[self callMethod:@"all-subjects" withParams:[NSDictionary dictionaryWithObject:@"500" forKey:@"count"] withDelegate:successDelegate didSucceedSelector:sel];
}

- (NSDictionary *)parseTagData:(NSData *)data {
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

- (NSArray *)parseSearchData:(NSData *)data {
	NSDateFormatter *sISO8601 = [[NSDateFormatter alloc] init];
	
	sISO8601.timeStyle = NSDateFormatterFullStyle;
	sISO8601.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss";
	NSMutableArray *content = [NSMutableArray array];
	
	NSArray *contentFields = PerformXMLXPathQuery(data, @"/search/results/content");
	
	NSDictionary *info;
	for(info in contentFields) {
		GuardianContent *c = [[[GuardianContent alloc] init] autorelease];
		c.headline = @"Foo!";
		NSDictionary *keyvalue;
		for(keyvalue in [info objectForKey:@"nodeAttributeArray"]) {
			NSString *key = [keyvalue objectForKey:@"attributeName"];
			if([key isEqualToString:@"type"]) {
				c.type = [keyvalue objectForKey:@"nodeContent"];
			}
			if([key isEqualToString:@"web-url"]) {
				c.url = [keyvalue objectForKey:@"nodeContent"];
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
		NSArray *content = [self parseSearchData: data];
		[delegate performSelector:sel withObject:content];
	}
	if([method isEqualToString:@"all-subjects"]) {
		NSDictionary *content = [self parseTagData: data];
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
	if([method isEqualToString:@"all-subjects"]) {
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
