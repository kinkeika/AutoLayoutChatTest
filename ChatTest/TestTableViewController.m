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

extern UIImage* ImageFromCacheWithURL(NSString* url);


@interface TestTableViewController ()
@property (strong, nonatomic) NSArray* dataArray;
@property (strong, nonatomic) NSArray* randomImageURLs;
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
                           @"http://www.colourbox.com/preview/3174257-299019-stylized-tooth-in-circle-isolated-on-white-background-vector-illustration.jpg",
                           @"http://u-wanna-bet.com/wp-content/uploads/2012/12/psychedelic-propeller-iphone-casino-optical-illusion.png",
                           @"http://www.hdwallpapersonly.com/wp-content/uploads/2013/03/Optical-illusions-1.jpg",
                           @"http://inspirationfeed.com/wp-content/uploads/2011/04/optical-illusions-051.jpg",
                           @"http://n7ugc.disney.go.com/item/karalauree97/925_2gs11k6Twm6a000011Y4wOw0-h-8b9862-as/OPTICAL%20ILLUSION!%20Vote%20if%20cool!__600_450_q50.jpg",
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
  NSMutableString *longString = [NSMutableString stringWithString:@"This is a base string"];
  
  for (int x = 0; x < 7; x++)
  {
    [longString appendFormat:@"\rDynamic line %d", x + 1];
    NSMutableDictionary *dict = [@{
                                   @"timestamp": [NSDateFormatter localizedStringFromDate:[NSDate date] dateStyle:NSDateFormatterLongStyle timeStyle:NSDateFormatterMediumStyle],
                                   @"message": [NSString stringWithString:longString],
                                   @"sender": @"me",
                                   @"readreceipt": @"Read",
                                   } mutableCopy];
    
    // every other from a different person.
    if (x % 2 == 0 && dict[@"sender"] != nil)
      dict[@"sender"] = @"you";
    
    if (x % 3 == 0)
    {
      NSString* url = [self.randomImageURLs objectAtIndex:arc4random() % (self.randomImageURLs.count - 1)];
      if (url)
        dict[@"url"] = url;
    }
    
    // only on the last item
    if (x + 1 != 7)
      [dict removeObjectForKey:@"readreceipt"];
    
    [array addObject:dict];
  }
  
  // cache the images up front
  for (NSDictionary *dict in array)
  {
    NSString* url = dict[@"url"];
    if (url.length)
      ImageFromCacheWithURL(url);
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













































