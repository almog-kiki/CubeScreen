//
//  ViewController.m
//  CubeScreen
//
//  Created by kiki kalifa on 9/6/14.
//  Copyright (c) 2014 kiki kalifa. All rights reserved.
//

#import "ViewController.h"
#import "ContainerViewController.h"
@interface ViewController ()
@end

@implementation ViewController
@synthesize mainDelegate;
@synthesize myContainerView,imgView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // set background color :
    //[self setBackGroundColour:[UIColor brownColor]];
    
    // set image to background by name:
    [self setBackGroundImage:@"manarola.jpg"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    //NSLog(@"%s", __PRETTY_FUNCTION__);
    return YES;
}

-(void)setBackGroundImage:(NSString *)imageName
{
    
    UIImage *img = [UIImage imageNamed:imageName];
    [imgView setImage:img];
    [imgView setFrame:self.view.bounds];
}

-(void)setBackGroundColour:(UIColor *)myColour{
    [self.view setBackgroundColor:myColour];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"embedContainer"]) {
        mainDelegate.containerVCDel = segue.destinationViewController;
    }
}

@end
