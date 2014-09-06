//
//  AppDelegate.h
//  CubeScreen
//
//  I used with "EmbeddedSwapping" project by Michael Luton on 11/13/12.
//  Copyright (c) 2012 Sandmoose Software. All rights reserved.

//  Created by kiki kalifa on 9/6/14.
//  Copyright (c) 2014 kiki kalifa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FirstViewController.h"
#import "SecondViewController.h"
#import "ContainerViewController.h"
@class ContainerViewController;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) IBOutlet UIView *myContainerViewDel;

@property (strong,nonatomic) ContainerViewController *containerVCDel;

@end
