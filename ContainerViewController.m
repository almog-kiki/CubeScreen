//
//  ContainerViewController.m
//  EmbeddedSwapping
//
//  Created by Michael Luton on 11/13/12.
//  Copyright (c) 2012 Sandmoose Software. All rights reserved.
//  Heavily inspired by http://orderoo.wordpress.com/2012/02/23/container-view-controllers-in-the-storyboard/
//
//  ContainerViewController.m
//  CubeScreen
//
//  Created by kiki kalifa on 9/6/14.
//  Copyright (c) 2014 kiki kalifa. All rights reserved.
//
#import <objc/runtime.h>

#import "ContainerViewController.h"
#import "MainViewController.h"
#import "FirstViewController.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"

#define SegueIdentifierMain @"embedMain"
#define SegueIdentifierFirst @"embedFirst"
#define SegueIdentifierSecond @"embedSecond"
#define SegueIdentifierThird @"embedThird"

typedef enum SwipeType : NSUInteger {
    kUp,
    kRight,
    kLeft,
    kButtom
} SwipeType;

@interface ContainerViewController ()
{
    NSInteger rotateDirection;
}
@property (strong, nonatomic) NSString *currentSegueIdentifier;
@property (strong, nonatomic) FirstViewController *firstViewController;
@property (strong,nonatomic) MainViewController *mainViewController;
@property (strong, nonatomic) SecondViewController *secondViewController;
@property(strong, nonatomic) ThirdViewController *thirdViewController;
@property (assign, nonatomic) BOOL transitionInProgress;
@end

@implementation ContainerViewController
@synthesize mainDelegate;

- (void)setBGColor:(UIColor *)color forAllSubviewsOf:(UIView *)view
{
    /*NSArray *arr = [[NSArray alloc] initWithObjects:
     [UIColor redColor], nil];
     */
    int i=1;
    [view setBackgroundColor:color];
    for (UIView *sub in view.subviews)
    {
        i++;
        [self setBGColor:color forAllSubviewsOf:sub];
    }
    NSLog(@" i: %d", i);
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    rotateDirection = -1;//Initialization
    
    UISwipeGestureRecognizer * swiperight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(SwapRight:)];
    swiperight.direction=UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swiperight];
    
    UISwipeGestureRecognizer * swipeleft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(SwapLeft:)];
    swipeleft.direction=UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeleft];
    
    UISwipeGestureRecognizer *swipeUp =[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(SwapUp:)];
    swipeUp.direction= UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:swipeUp];
    
    UISwipeGestureRecognizer *swipDown =[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(SwapDown:)];
    swipDown.direction= UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipDown];
    
    // load the main view :
    self.transitionInProgress = NO;
    self.currentSegueIdentifier = SegueIdentifierMain;
    [self performSegueWithIdentifier:self.currentSegueIdentifier sender:nil];
    
}
- (IBAction)SwapRight:(id)sender {
    [self swapViewControllers:1];
}
- (IBAction)SwapLeft:(id)sender {
    [self swapViewControllers:2];
}
-(IBAction)SwapUp:(id)sender{
    [self swapViewControllers:3];
}
-(IBAction)SwapDown:(id)sender{
    [self swapViewControllers:0];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // NSLog(@"prepareForSegue");
    // NSLog(@"%s", __PRETTY_FUNCTION__);
    // Instead of creating new VCs on each seque we want to hang on to existing
    // instances if we have it. Remove the second condition of the following
    // two if statements to get new VC instances instead.
    
    if(rotateDirection ==-2)
    {
        // managing the swipes at views that can't swipe to R/L/U/D
        return;
    }
    if ([segue.identifier isEqualToString:SegueIdentifierMain]) {
        self.mainViewController = segue.destinationViewController;
    }
    if ([segue.identifier isEqualToString:SegueIdentifierFirst]) {
        self.firstViewController = segue.destinationViewController;
    }
    if ([segue.identifier isEqualToString:SegueIdentifierSecond]) {
        self.secondViewController = segue.destinationViewController;
    }
    if([segue.identifier isEqualToString:SegueIdentifierThird]){
        self.thirdViewController = segue.destinationViewController;
    }
    
    // If we're going to the first view controller.
    if ([segue.identifier isEqualToString:SegueIdentifierMain]) {
        // If this is not the first time we're loading this.
        if (self.childViewControllers.count > 0) {
            [self swapFromViewController:[self.childViewControllers objectAtIndex:0] toViewController:self.mainViewController];
        }
        else {
            // If this is the very first time we're loading this we need to do
            // an initial load and not a swap.
            [self addChildViewController:segue.destinationViewController];
            UIView* destView = ((UIViewController *)segue.destinationViewController).view;
            destView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            destView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            [self.view addSubview:destView];
            [segue.destinationViewController didMoveToParentViewController:self];
            
        }
    }
    //change to other views!
    else if ([segue.identifier isEqualToString:SegueIdentifierFirst]) {
        [self swapFromViewController:[self.childViewControllers objectAtIndex:0] toViewController:self.firstViewController];
    }
    else if ([segue.identifier isEqualToString:SegueIdentifierSecond]){
        [self swapFromViewController:[self.childViewControllers objectAtIndex:0] toViewController:self.secondViewController];
    }
    else if([segue.identifier isEqualToString:SegueIdentifierThird]){
        [self swapFromViewController:[self.childViewControllers objectAtIndex:0] toViewController:self.thirdViewController];
    }
}


- (UIView*) makeBackgroundWithColor:(UIColor*)color {
    UIView* background = [[UIView alloc] initWithFrame:self.view.frame];
    [background setBackgroundColor:color];
    return background;
}
-(CATransition *)RotateAnumation:(int)type subType:(int)sType{
    
    CATransition *transition = [CATransition animation];
    transition.delegate = self;
    transition.duration = 0.8;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    NSString *types[4] = {@"cube", @"rippleEffect", @"cube", @"alignedCube"};
    // ####    0  #####       ####     1   #####    ####     2  #####       ####     3  #####
    //swapFromUP   ---------  swapFrom Left --------swapFrom Right ------- swapFrom Down
    NSString *subtypes[5] = {kCATransitionFromBottom, kCATransitionFromRight, kCATransitionFromLeft,kCATransitionFromTop,kCATransitionFromBottom};
    transition.type = types[type];
    transition.subtype = subtypes[sType];
    /*
     UIView *darkenBackground = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
     [darkenBackground setBackgroundColor:[UIColor blackColor]];
     [darkenBackground setAlpha:0.5];
     [self.view addSubview:darkenBackground];*/
    /*  UIColor *uicolor = [UIColor greenColor];
     CGColorRef color = [uicolor CGColor];
     self.view.layer.backgroundColor= color;
     self.view.backgroundColor = [UIColor blackColor];
     */
    [self.view.layer addAnimation:transition forKey:nil];
    [[[self view] layer] addAnimation: transition forKey: nil];
    
    return transition;
}

- (void)swapFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController
{
    //NSLog(@"swapFromViewController");
    toViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [fromViewController willMoveToParentViewController:nil];
    [self addChildViewController:toViewController];
    // rotateDirection is the which side the screen will be rotate according to the SWIPE
    //NSLog(@"rotateDirction: %d", rotateDirection);
    CATransition *transition = [self RotateAnumation:0 subType:(int)rotateDirection];

    [self transitionFromViewController:fromViewController
                      toViewController:toViewController
                              duration:0.3
                               options:nil
                            animations:^{
                                /*  UIColor *uicolor = [UIColor greenColor];
                                 CGColorRef color = [uicolor CGColor];
                                 self.view.layer.backgroundColor= color;
                                 self.view.backgroundColor = [UIColor blackColor];
                                 */

                                [UIView setAnimationTransition:transition forView:toViewController.view cache:NO];
                                //[UIView  setAnimationTransition:transition forView:toViewController.view cache:NO];
                                
                            }
                            completion:^(BOOL finished) {
                                
                                [fromViewController removeFromParentViewController];
                                [toViewController didMoveToParentViewController:self];
                            }];
}
-(void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
    // [objc_getAssociatedObject(self, backgroundKey) removeFromSuperview];
    self.transitionInProgress = NO;
}

- (void)swapViewControllers:(int)vcIndex
{
    /*
     *  vcIndex:
     *  0 = Down ->swipe up
     *  1 = RIGHT
     *  2 = LEFT
     *  3 = UP
     *
     */
    
    if (self.transitionInProgress && rotateDirection != -2)
    {
        NSLog(@"transitionInProgress");
        return;
    }
    self.transitionInProgress = YES;
    // vcIndex is the swipe Gesture direction
    switch (vcIndex)
    {
        case 1:
            NSLog(@"SWIPE RIGHT");
            rotateDirection = kLeft;
           // NSLog(@" rotateDirection: %ld", (long)rotateDirection);
            
            if(!self.firstViewController && ([self.currentSegueIdentifier isEqualToString:SegueIdentifierMain]))
            {
                //NSLog(@" fVC is NULL!! ");
                self.currentSegueIdentifier = SegueIdentifierFirst;
            }
            else if (!self.secondViewController && ([self.currentSegueIdentifier isEqualToString:SegueIdentifierFirst]))
            {
                //NSLog(@" secVC is NULL!! ");
                self.currentSegueIdentifier = SegueIdentifierSecond;
            }
            else if ( ([self.currentSegueIdentifier isEqualToString:SegueIdentifierMain]) && self.firstViewController )
            {
                NSLog(@"main->first");
                self.currentSegueIdentifier = SegueIdentifierFirst;
                [self swapFromViewController:self.mainViewController toViewController:self.firstViewController];
                return;
            }
            else if( ([self.currentSegueIdentifier isEqualToString:SegueIdentifierFirst]) && self.secondViewController)
            {
                NSLog(@"first->second");
                self.currentSegueIdentifier = SegueIdentifierSecond;
                [self swapFromViewController:self.firstViewController toViewController:self.secondViewController];
                return;
            }
            else if( ([self.currentSegueIdentifier isEqualToString:SegueIdentifierSecond]) && self.mainViewController)
            {
                NSLog(@"second->main");
                self.currentSegueIdentifier = SegueIdentifierMain;
                [self swapFromViewController:self.secondViewController toViewController:self.mainViewController];
                return;
            }
            else if ([self.currentSegueIdentifier isEqualToString:SegueIdentifierThird] ){
                NSLog(@"Can't swipe Left/Right");
                rotateDirection = -2;
                //return;
            }
            break;
        case 2:
            NSLog(@"SWIPE LEFT");
            rotateDirection = kRight;
            if(!self.secondViewController && ([self.currentSegueIdentifier isEqualToString:SegueIdentifierMain]))
            {
                NSLog(@"SVC is NULL!!");
                self.currentSegueIdentifier = SegueIdentifierSecond;
            }
            else if (!self.firstViewController && ([self.currentSegueIdentifier isEqualToString:SegueIdentifierSecond]))
            {
                NSLog(@"FVC is NULL!!");
                self.currentSegueIdentifier = SegueIdentifierFirst;
            }
            else if ( ([self.currentSegueIdentifier isEqualToString:SegueIdentifierMain]) &&  self.secondViewController)
            {
                NSLog(@"main->second");
                self.currentSegueIdentifier = SegueIdentifierSecond;
                [self swapFromViewController:self.mainViewController toViewController:self.secondViewController];
                return;
            }
            else if ( ([self.currentSegueIdentifier isEqualToString:SegueIdentifierSecond]) && self.firstViewController){
                NSLog(@"second->first");
                self.currentSegueIdentifier = SegueIdentifierFirst;
                [self swapFromViewController:self.secondViewController toViewController:self.firstViewController];
                return;
                
            }
            else if (([self.currentSegueIdentifier isEqualToString:SegueIdentifierFirst]) && self.mainViewController){
                NSLog(@"first->main");
                self.currentSegueIdentifier = SegueIdentifierMain;
                [self swapFromViewController:self.firstViewController toViewController:self.mainViewController];
                return;
            }
            else if ([self.currentSegueIdentifier isEqualToString:SegueIdentifierThird]){
                NSLog(@"Can't swipe Left/Right");
                rotateDirection = -2;
                //return;
            }
            break;
        case 3:
            NSLog(@"SWIPE UP");
            rotateDirection = kButtom;
            if ([self.currentSegueIdentifier isEqualToString:SegueIdentifierFirst] ||
                [self.currentSegueIdentifier isEqualToString:SegueIdentifierSecond])
            {
                NSLog(@"Can't swipe UP");
                rotateDirection = -2;
            }
            else if (!self.thirdViewController) {
                self.currentSegueIdentifier = SegueIdentifierThird;
            }
            else if ([self.currentSegueIdentifier isEqualToString:SegueIdentifierMain] && self.thirdViewController)
            {
                NSLog(@"main->third");
                self.currentSegueIdentifier = SegueIdentifierThird;
                [self swapFromViewController:self.mainViewController toViewController:self.thirdViewController];
                return;
            }
            else if ([self.currentSegueIdentifier isEqualToString:SegueIdentifierThird] && self.mainViewController){
                NSLog(@"third->main");
                self.currentSegueIdentifier = SegueIdentifierMain;
                [self swapFromViewController:self.thirdViewController toViewController:self.mainViewController];
                return;
            }
            else if ([self.currentSegueIdentifier isEqualToString:SegueIdentifierFirst] ||
                     [self.currentSegueIdentifier isEqualToString:SegueIdentifierSecond])
            {
                NSLog(@"Can't swipe UP");
                rotateDirection = -2;
            }
            break;
        case 0:
            NSLog(@"SWIPE DOWN");
            rotateDirection = kUp;
            if ([self.currentSegueIdentifier isEqualToString:SegueIdentifierFirst] ||
                [self.currentSegueIdentifier isEqualToString:SegueIdentifierSecond])
            {
                NSLog(@"Can't swipe down");
                rotateDirection = -2;
            }
            else if (!self.thirdViewController) {
                self.currentSegueIdentifier = SegueIdentifierThird;
            }
            else if([self.currentSegueIdentifier isEqualToString:SegueIdentifierThird] && self.mainViewController)
            {
                NSLog(@"third->main");
                self.currentSegueIdentifier = SegueIdentifierMain ;
                [self swapFromViewController:self.thirdViewController toViewController:self.mainViewController];
                return;
            }
            else if ( ([self.currentSegueIdentifier isEqualToString:SegueIdentifierMain]) && self.thirdViewController)
            {
                NSLog(@"main->third");
                self.currentSegueIdentifier = SegueIdentifierThird;
                [self swapFromViewController:self.mainViewController toViewController:self.thirdViewController];
                return;
                
            }
            else if ([self.currentSegueIdentifier isEqualToString:SegueIdentifierFirst] ||
                     [self.currentSegueIdentifier isEqualToString:SegueIdentifierSecond])
            {
                NSLog(@"Can't swipe down");
                rotateDirection = -2;
            }
            break;
        default:
            break;
    }
    [self performSegueWithIdentifier:self.currentSegueIdentifier sender:nil];
  
}



@end
