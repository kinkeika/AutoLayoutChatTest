//
//  CustomTableViewCell.h
//  ChatTest
//
//  Created by Jeremy Stone on 3/20/14.
//  Copyright (c) 2014 SolutionReach. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CustomTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *timestamp;
@property (weak, nonatomic) IBOutlet UILabel *sender;
@property (weak, nonatomic) IBOutlet UIImageView *bubbleView;
@property (weak, nonatomic) IBOutlet UIImageView *urlImageView;
@property (weak, nonatomic) IBOutlet UIImageView *maskImage;
@property (weak, nonatomic) IBOutlet UILabel *readReceipt;
@property (weak, nonatomic) IBOutlet UITextView *textView;

+ (CGSize)textSizeForMessage:(NSDictionary *)message withFont:(UIFont *)font;
- (void)loadWithData:(NSDictionary *)message nextMessageData:(NSDictionary *)nextMessage;
+ (CGFloat)heightForCellWithData:(NSDictionary *)message nextRowData:(NSDictionary *)nextMessage;

@end
