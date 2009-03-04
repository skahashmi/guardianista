//
//  GuardianAppDelegate.h
//  Guardian
//
//  Created by Matt Biddulph on 04/03/2009.
//  Copyright Hackdiary Ltd 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GuardianAPI.h"

@interface GuardianAppDelegate : NSObject <UIApplicationDelegate> {
	GuardianAPI *guardian;
    UIWindow *window;
    UINavigationController *navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end

