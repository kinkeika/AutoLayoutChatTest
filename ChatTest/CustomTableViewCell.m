//
//  CustomTableViewCell.m
//  ChatTest
//
//  Created by Jeremy Stone on 3/20/14.
//  Copyright (c) 2014 SolutionReach. All rights reserved.
//

#import "CustomTableViewCell.h"
#import "UIImage+ImageBubbles.h"
#import "TestTableViewController.h"


extern TestTableViewController* g_testTableController;


#define kMaxBubbleWidth               ([UIScreen mainScreen].applicationFrame.size.width * 0.7)   // 70%
#define kBubbleWidthOffset            ([UIScreen mainScreen].applicationFrame.size.width - kMaxBubbleWidth)
#define kSRLabelMarginForMessageCell  5.0

@interface CustomTableViewCell ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *senderHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timestampHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *readReceiptheightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bubbleViewTrailingSpaceConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bubbleViewLeadingSpaceConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *maskViewLeadingSpaceConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *maskViewTrailingSpaceConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewLeadingSpaceConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewTrailingSpaceConstraint;


@property (assign, nonatomic) CGFloat timestampHeight;
@property (assign, nonatomic) CGFloat senderHeight;
@property (assign, nonatomic) CGFloat readReceiptHeight;
@property (assign, nonatomic) CGFloat textViewLeadingConstant;
@property (assign, nonatomic) CGFloat maskViewLeadingConstant;
@property (assign, nonatomic) CGFloat bubbleViewLeadingConstant;

@end


@implementation CustomTableViewCell


- (void)awakeFromNib
{
  [super awakeFromNib];
  
  // remember base heights
  if (!self.timestampHeight)
    self.timestampHeight = self.timestamp.frame.size.height;
  if (!self.senderHeight)
    self.senderHeight = self.sender.frame.size.height;
  if (!self.readReceiptHeight)
    self.readReceiptHeight = self.readReceipt.frame.size.height;
  
  // remember base left offsets
  
  self.textViewLeadingConstant = self.textViewLeadingSpaceConstraint.constant;
  self.maskViewLeadingConstant = self.maskViewLeadingSpaceConstraint.constant;
  self.bubbleViewLeadingConstant = self.bubbleViewLeadingSpaceConstraint.constant;
}


+ (CGFloat)heightForCellWithData:(NSDictionary *)message nextRowData:(NSDictionary *)nextMessage
{
  CGFloat labelHeight = 21.0;
  CGFloat retVal = 0;
  
  NSString *str = message[@"timestamp"];
  if (str.length)
    retVal += labelHeight;
  
  str = message[@"sender"];
  if (str.length)
    retVal += labelHeight;
  
  // figure out text height
  str = message[@"message"];
  if (str.length)
  {
    CGSize size = [CustomTableViewCell textSizeForMessage:message withFont:[UIFont systemFontOfSize:14]];
    retVal += size.height;
    
    // add the non-stretchable parts of the background bubble here as well.
    retVal += labelHeight;

    // check to see if no read receipt here and a sender or timestamp is on the next row and get rid of the read receipt margin
    if (![message[@"readreceipt"] length] && ([nextMessage[@"sender"] length] || [nextMessage[@"timestamp"] length]))
      retVal -= labelHeight;
  }
  else
  {
    // image height.  Not yet done!
  }
  
  return retVal;
}


+ (CGSize)textSizeForMessage:(NSDictionary *)message withFont:(UIFont *)font
{
  CGFloat maxWidth = kMaxBubbleWidth;
  
  if (!font)
    return CGSizeZero;
  
  NSString* str = message[@"message"];
  
  CGRect stringRect = [str boundingRectWithSize:CGSizeMake(maxWidth, 99999)
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{ NSFontAttributeName : font }
                                        context:nil];
  
  stringRect.size.height += 15;   // for UITextView top and bottom text margins
  
  return CGRectIntegral(stringRect).size;
}


- (void)shiftCell:(BOOL)toRight
{
  if (toRight)
  {
    // adjust bubble view
    if (self.bubbleViewTrailingSpaceConstraint.constant > self.bubbleViewLeadingSpaceConstraint.constant)
    {
      CGFloat tempValue = self.bubbleViewLeadingSpaceConstraint.constant;
      self.bubbleViewLeadingSpaceConstraint.constant = self.bubbleViewTrailingSpaceConstraint.constant;
      self.bubbleViewTrailingSpaceConstraint.constant = tempValue;
    }
    
    // adjust mask view
    if (self.maskViewTrailingSpaceConstraint.constant > self.maskViewLeadingSpaceConstraint.constant)
    {
      CGFloat tempValue = self.maskViewLeadingSpaceConstraint.constant;
      self.maskViewLeadingSpaceConstraint.constant = self.maskViewTrailingSpaceConstraint.constant;
      self.maskViewTrailingSpaceConstraint.constant = tempValue;
    }
    
    // adjust text view
    if (self.textViewTrailingSpaceConstraint.constant > self.textViewLeadingSpaceConstraint.constant)
    {
      CGFloat tempValue = self.textViewLeadingSpaceConstraint.constant;
      self.textViewLeadingSpaceConstraint.constant = self.textViewTrailingSpaceConstraint.constant;
      self.textViewTrailingSpaceConstraint.constant = tempValue;
    }
    
    // adjust the labels
    self.sender.textAlignment = NSTextAlignmentRight;
    self.readReceipt.textAlignment = NSTextAlignmentRight;
  }
  else
  {
    // bubble view
    if (self.bubbleViewTrailingSpaceConstraint.constant < self.bubbleViewLeadingSpaceConstraint.constant)
    {
      CGFloat tempValue = self.bubbleViewLeadingSpaceConstraint.constant;
      self.bubbleViewLeadingSpaceConstraint.constant = self.bubbleViewTrailingSpaceConstraint.constant;
      self.bubbleViewTrailingSpaceConstraint.constant = tempValue;
    }
    
    // mask view
    if (self.maskViewTrailingSpaceConstraint.constant < self.maskViewLeadingSpaceConstraint.constant)
    {
      CGFloat tempValue = self.maskViewLeadingSpaceConstraint.constant;
      self.maskViewLeadingSpaceConstraint.constant = self.maskViewTrailingSpaceConstraint.constant;
      self.maskViewTrailingSpaceConstraint.constant = tempValue;
    }
    
    // adjust text view
    if (self.textViewTrailingSpaceConstraint.constant < self.textViewLeadingSpaceConstraint.constant)
    {
      CGFloat tempValue = self.textViewLeadingSpaceConstraint.constant;
      self.textViewLeadingSpaceConstraint.constant = self.textViewTrailingSpaceConstraint.constant;
      self.textViewTrailingSpaceConstraint.constant = tempValue;
    }
    
    // adjust the labels
    self.sender.textAlignment = NSTextAlignmentLeft;
    self.readReceipt.textAlignment = NSTextAlignmentLeft;
  }
}


- (void)loadWithData:(NSDictionary *)dict
{
  self.textView.text = dict[@"message"];
  self.sender.text = dict[@"sender"];
  self.timestamp.text = dict[@"timestamp"];
  self.readReceipt.text = dict[@"readreceipt"];
  
  BOOL messageFromMe = [dict[@"sender"] isEqualToString:@"me"];
  
  NSString* url = dict[@"url"];
  if (url.length)
  {
    // handle image laoding here
  }
  else
  {
    // handle background bubble
    self.bubbleView.image = [self bubbleImageForColor:[UIColor grayColor] type:!messageFromMe];  // YES is left
  }
  
  // update data-based constraints
  if (!self.sender.text.length)
    self.senderHeightConstraint.constant = 0;
  else
    self.senderHeightConstraint.constant = self.senderHeight;

  if (!self.readReceipt.text.length)
    self.readReceiptheightConstraint.constant = 0;
  else
    self.readReceiptheightConstraint.constant = self.readReceiptHeight;
  
  if (!self.timestamp.text.length)
    self.timestampHeightConstraint.constant = 0;
  else
    self.timestampHeightConstraint.constant = self.timestampHeight;
  
  // update constraints based on left/right
  if (messageFromMe)
    [self shiftCell:YES];
  else
    [self shiftCell:NO];
    
  // until we make changes this is meaningless
  [self setNeedsUpdateConstraints];
  
  self.maskImage.hidden = YES;
}


#pragma mark -


- (UIImage *)imageBackgroundMask
{
  UIImage *image = [UIImage imageNamed:@"ImageBubbleMask"];
  return [image stretchableImageWithLeftCapWidth:image.size.width / 2.0 topCapHeight:image.size.height / 2.0];
}


- (UIImage *)bubbleImageForColor:(UIColor *)color type:(BOOL)left
{
  UIImage *bubble = [UIImage imageNamed:@"ImageBubble"];
  UIImage *normalBubble = [bubble js_imageMaskWithColor:color];
  
  if (left == YES)
    normalBubble = [normalBubble js_imageFlippedHorizontal];
  
  // make image stretchable from center point
  CGPoint center = CGPointMake(bubble.size.width / 2.0f, bubble.size.height / 2.0f);
  UIEdgeInsets capInsets = UIEdgeInsetsMake(center.y, center.x, center.y, center.x);
  
  return [normalBubble resizableImageWithCapInsets:capInsets resizingMode:UIImageResizingModeStretch];
}


@end
