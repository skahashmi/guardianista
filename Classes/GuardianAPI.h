//
//  GuardianAPI.h
//  Guardian
//
//  Created by Matt Biddulph on 04/03/2009.
//  Copyright 2009 Hackdiary Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#define GUARDIAN_API_KEY @"5ya7ejbsp8ymbjc6bdymeg8q"
#define GUARDIAN_API_PREFIX @"http://api.guardianapis.com/content"
#define GUARDIAN_OFFLINE_MOCK 1

@interface GuardianAPI : NSObject {
}

- (NSString *) urlForMethod:(NSString *)methodName withParams:(NSDictionary *)params;
- (void) callMethod:(NSString *)method withParams:(NSDictionary *)params withDelegate:(id)successDelegate didSucceedSelector:(SEL)sel;
- (void) latestContentWithDelegate:(id)successDelegate didSucceedSelector:(SEL)sel;
- (void) searchQuery:(NSString *)q withDelegate:(id)successDelegate didSucceedSelector:(SEL)sel;
- (void) searchWithFilter:(NSString *)filter withDelegate:(id)successDelegate didSucceedSelector:(SEL)sel;
- (void) searchQuery:(NSString *)q withFilter:(NSString *)filter withDelegate:(id)successDelegate didSucceedSelector:(SEL)sel;
- (void) allSubjectsWithDelegate: (id)successDelegate didSucceedSelector:(SEL)sel;

@end
