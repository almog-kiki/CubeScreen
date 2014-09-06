//
//  ContainerViewController.h
//  CubeScreen
//
//  Created by kiki kalifa on 9/6/14.
//  Copyright (c) 2014 kiki kalifa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@class AppDelegate;
@interface ContainerViewController : UIViewController<UIApplicationDelegate>
@property (nonatomic, strong) AppDelegate *mainDelegate;
@end
