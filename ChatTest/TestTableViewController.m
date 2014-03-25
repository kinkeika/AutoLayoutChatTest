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
@property (strong, nonatomic) NSArray *dataArray;
@property (strong, nonatomic) NSArray *randomImageURLs;
@end

@implementation TestTableViewController


- (void)viewDidLoad
{
  [super viewDidLoad];
  
  g_testTableController = self;
}


#pragma mark -


- (void)setup
{
  self.randomImageURLs = @[
                           @"http://www.theprintblog.com/wp-content/uploads/2013/03/green.jpg",
                           @"http://www.dickson-constant.com/medias/images/catalogue/api/5029-paris-red-680.jpg",
                           @"http://fc01.deviantart.net/fs30/f/2008/166/7/d/Apple_on_the_red_carpet_by_shamrock593.jpg",
                           @"http://upload.wikimedia.org/wikipedia/commons/e/e5/Solid_blue.png",
                           ];
  
  self.dataArray = [self dataForDataArray];
  self.imageCache = [NSMutableDictionary dictionary];
  
  [self.tableView reloadData];
}


#pragma mark - Table view data source


- (NSArray*)dataForDataArray
{
  NSMutableArray *array = [NSMutableArray array];
  
  // LOAD DATA
  NSMutableString *longString = [NSMutableString stringWithString:@"A base line string"];
  NSMutableString *dynString = [NSMutableString stringWithString:@"A base string"];
  
  NSInteger numDataPayloads = 21;
  
  for (int x = 0; x < numDataPayloads; x++)
  {
    // returns vs longer lines
    NSString* lineString = longString;
    if (x % 2 == 0)
      lineString = dynString;
    
    [dynString appendFormat:@" dynamic text %d", x + 1];
    [longString appendFormat:@"\r --dynamic line %d--", x + 1];

    NSMutableDictionary *dict = [@{
                                   @"timestamp": [NSDateFormatter localizedStringFromDate:[NSDate date] dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterShortStyle],
                                   @"message": [NSString stringWithString:lineString],
                                   @"sender": @"me",
                                   @"readreceipt": @"Message Delivered",
                                   } mutableCopy];
    
    // make every third message from a different person.
    if ((x + 2) % 3 == 0 && dict[@"sender"] != nil)
      dict[@"sender"] = @"you";
    
    // make every third message an image.
    if (x % 3 == 0)
    {
      NSString *url = [self.randomImageURLs objectAtIndex:arc4random() % (self.randomImageURLs.count - 1)];
      if (url)
        dict[@"url"] = url;
    }

    // every third message show a timestamp
    if ((x + 1) % 3 != 0)
      [dict removeObjectForKey:@"timestamp"];
    
    // only on the last item do we want to see a read receipt
    if (x + 1 != numDataPayloads)
      [dict removeObjectForKey:@"readreceipt"];
    
    [array addObject:dict];
  }
  
  // cache the images up front
  for (NSDictionary *dict in array)
  {
    NSString *url = dict[@"url"];
    if (url.length)
      [CustomTableViewCell imageFromCacheWithURL:url];
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
  
  NSDictionary *nextMessage = nil;
  
  if (indexPath.row + 1 < self.dataArray.count)
    nextMessage = [self.dataArray objectAtIndex:indexPath.row + 1];
  
  // Configure the cell...
  [cell loadWithData:[self.dataArray objectAtIndex:indexPath.row] nextMessageData:nextMessage];
  
  return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  CGFloat numRows = [self tableView:tableView numberOfRowsInSection:indexPath.section];
  
  NSDictionary *nextData = nil;
  if (numRows > indexPath.row + 1)
    nextData = [self.dataArray objectAtIndex:indexPath.row + 1];

  return [CustomTableViewCell heightForCellWithData:[self.dataArray objectAtIndex:indexPath.row] nextRowData:nextData];
}


@end













































