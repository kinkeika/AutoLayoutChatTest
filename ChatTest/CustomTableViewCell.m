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
#import "UIView+AutoLayout.h"


extern TestTableViewController* g_testTableController;


#define kMaxBubbleWidth               ([UIScreen mainScreen].applicationFrame.size.width * 0.7)   // 70%
#define kBubbleWidthOffset            ([UIScreen mainScreen].applicationFrame.size.width - kMaxBubbleWidth)
#define kSRLabelMarginForMessageCell  5.0

@interface CustomTableViewCell ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *senderHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timestampHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *readReceiptheightConstraint;

@property (assign, nonatomic) BOOL constraintsLoaded;
@property (assign, nonatomic) CGFloat timestampHeight;
@property (assign, nonatomic) CGFloat senderHeight;
@property (assign, nonatomic) CGFloat readReceiptHeight;

@end


@implementation CustomTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}


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

  self.constraintsLoaded = YES;
}


- (void)updateConstraints
{
  [super updateConstraints];

  return;
  
  if (!self.constraintsLoaded)
  {
    [self autoRemoveConstraintsAffectingViewAndSubviews];
    
    CGFloat marginOffset = 10.0;
    
    // timestamp is always first, up top
    [self.timestamp autoRemoveConstraintsAffectingViewAndSubviews];
    [self.timestamp autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self];
    [self.timestamp autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self];
    [self.timestamp autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self];
    [self.timestamp autoSetDimension:ALDimensionHeight toSize:self.timestampHeight];
    
    // sender, pin to timestamp and edges.
    [self.sender autoRemoveConstraintsAffectingViewAndSubviews];
    [self.sender autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.timestamp withOffset:kSRLabelMarginForMessageCell];
    [self.sender autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self withOffset:marginOffset];
    [self.sender autoSetDimension:ALDimensionHeight toSize:self.senderHeight];
    [self.sender autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self withOffset:kBubbleWidthOffset];
    
    // bubbleView, pin to sender, left/right and the bottom to the top of the read receipt edge.
    [self.bubbleView autoRemoveConstraintsAffectingViewAndSubviews];
    [self.bubbleView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.sender];
    [self.bubbleView autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:marginOffset];
    [self.bubbleView autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kBubbleWidthOffset];
    [self.bubbleView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.readReceipt withOffset:kSRLabelMarginForMessageCell];
    
    // mask image (same as bubble view
      // later
    
    // textView
    [self.textView autoRemoveConstraintsAffectingViewAndSubviews];
    [self.textView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.sender];
    [self.textView autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:marginOffset];
    [self.textView autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kBubbleWidthOffset];
    [self.textView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.readReceipt withOffset:kSRLabelMarginForMessageCell];
    
    // read receipt
    [self.readReceipt autoRemoveConstraintsAffectingViewAndSubviews];
    [self.readReceipt autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.bubbleView];
    [self.readReceipt autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:marginOffset];
    [self.readReceipt autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kBubbleWidthOffset];
    [self.readReceipt autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kSRLabelMarginForMessageCell];
    [self.readReceipt autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self withOffset:kSRLabelMarginForMessageCell];
    
    self.constraintsLoaded = YES;
  }
}


+ (CGFloat)heightForCellWithData:(NSDictionary *)message
{
  CGFloat retVal = 0;

  retVal += 4 * kSRLabelMarginForMessageCell;   // this should be shorter
  
  NSString *str = message[@"timestamp"];
  if (str.length)
    retVal += 21;//cell.timestamp.frame.size.height;
  else
    retVal -= kSRLabelMarginForMessageCell;
  
  str = message[@"sender"];
  if (str.length)
    retVal += 21;//cell.sender.frame.size.height;
  else
    retVal -= kSRLabelMarginForMessageCell;
  
  // figure out text height
  str = message[@"message"];
  if (str.length)
  {
    CGSize size = [CustomTableViewCell textSizeForMessage:message withFont:[UIFont systemFontOfSize:14]];
    retVal += size.height;
    
    // add the non-stretchable parts of the background bubble here as well.
    retVal += 12;
  }
  else
  {
    // image height.  Not yet done!
    retVal -= kSRLabelMarginForMessageCell;
  }
  
  str = message[@"readreceipt"];
  if (str.length)
    retVal += 21;//cell.readReceipt.frame.size.height;
  else
    retVal -= kSRLabelMarginForMessageCell;
  
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


- (void)loadWithData:(NSDictionary *)dict
{
  // make sure all of our constraints are set up properly before we do this the first time.
  if (!self.constraintsLoaded)
    [self updateConstraints];
  
  self.textView.text = dict[@"message"];
  self.sender.text = dict[@"sender"];
  self.timestamp.text = dict[@"timestamp"];
  self.readReceipt.text = dict[@"readreceipt"];
  
  NSString* url = dict[@"url"];
  if (url.length)
  {
    // handle image laoding here
  }
  else
  {
    // handle background bubble
    self.bubbleView.image = [self bubbleImageForColor:[UIColor grayColor] type:YES];  // YES is left
  }
  
  // update constraints
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
