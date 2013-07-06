//
//  erAppDelegate.h
//  er
//
//  Created by 喻静 on 11-6-26.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class erViewController;

@interface erAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet erViewController *viewController;

@end
