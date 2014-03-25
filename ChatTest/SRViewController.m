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

@end

@implementation SRViewController


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ([segue.identifier isEqualToString:@"ContainerViewLoading"])
  {
    TestTableViewController *controller = segue.destinationViewController;
    [controller setup];
  }
}


@end
