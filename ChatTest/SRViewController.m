//
//  SRViewController.m
//  ChatTest
//
//  Created by Jeremy Stone on 3/20/14.
//  Copyright (c) 2014 SolutionReach. All rights reserved.
//

#import "SRViewController.h"
#import "TestTableViewController.h"


@interface SRViewController ()
@property (weak, nonatomic) IBOutlet PHFComposeBarView *composeBar;

@end

@implementation SRViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
  
//  // this is kind of silly, but PHFComposeBar doesn't load properly from the storyboard, so what is there is basically a placeholder.
//  PHFComposeBarView *composeBar = [[PHFComposeBarView alloc] initWithFrame:self.composeBar.frame];
//  
//  composeBar.maxLinesCount = 5;
//  composeBar.placeholder = @"Message...";
//  composeBar.utilityButtonImage = [UIImage imageNamed:@"attachment"];
//  composeBar.delegate = self;
//  
//  [self.composeBar removeFromSuperview];
//  self.composeBar = composeBar;
//  [self.view addSubview:self.composeBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ([segue.identifier isEqualToString:@"ContainerViewLoading"])
  {
    TestTableViewController* controller = segue.destinationViewController;
    [controller setup];
  }
}


@end
