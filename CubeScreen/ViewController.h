//
//  ViewController.h
//  CubeScreen
//
//  Created by kiki kalifa on 9/6/14.
//  Copyright (c) 2014 kiki kalifa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@interface ViewController : UIViewController<UIApplicationDelegate>
@property (nonatomic,strong) AppDelegate *mainDelegate;
@property (strong, nonatomic) IBOutlet UIView *myContainerView;
@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@end
