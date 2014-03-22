//
//  TestTableViewController.m
//  ChatTest
//
//  Created by Jeremy Stone on 3/20/14.
//  Copyright (c) 2014 SolutionReach. All rights reserved.
//

#import "TestTableViewController.h"
#import "CustomTableViewCell.h"


TestTableViewController* g_testTableController = nil;


@interface TestTableViewController ()
@property (strong, nonatomic) NSArray* dataArray;
@end

@implementation TestTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
  self = [super initWithStyle:style];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  g_testTableController = self;
}


- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


#pragma mark -


- (void)setup
{
  self.dataArray = [self dataForDataArray];
  [self.tableView reloadData];
}


#pragma mark - Table view data source


- (NSArray*)dataForDataArray
{
  NSMutableArray *array = [NSMutableArray array];
  
  // LOAD DATA
  NSMutableString *longString = [NSMutableString stringWithString:@"This is a base string"];
  
  for (int x = 0; x < 10; x++)
  {
    [longString appendFormat:@"\rExtra (line %d)", x + 2];
    NSDictionary *dict = @{
//                           @"timestamp": [NSDateFormatter localizedStringFromDate:[NSDate date] dateStyle:NSDateFormatterLongStyle timeStyle:NSDateFormatterMediumStyle],
                           @"message": [NSString stringWithString:longString],
                           @"sender": @"me",
//                           @"readreceipt": @"Read"
//                           @"url": @"http://www.greatpetnet.com/wp-content/uploads/2008/07/MadCat.jpg"
                           };
    [array addObject:dict];
  }
  
  return array;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  // Return the number of rows in the section.
  return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  CustomTableViewCell *cell = (CustomTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"superCoolCell" forIndexPath:indexPath];
  
  // Configure the cell...
  [cell loadWithData:[self.dataArray objectAtIndex:indexPath.row]];
  
  return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return [CustomTableViewCell heightForCellWithData:[self.dataArray objectAtIndex:indexPath.row]];
}


@end













































