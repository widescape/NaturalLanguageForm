//
//  ViewController.m
//  NaturalLanguageForm
//
//  Created by Robert Wünsch on 21.11.14.
//  Copyright (c) 2014 widescape. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic) IBOutlet UITextView *fullTextView;

@property (strong, nonatomic) IBOutlet UITextField *friendField;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *friendFieldLeadingConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *friendFieldTopConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *friendFieldWidthConstraint;

@property (assign, nonatomic) CGFloat initialFriendFieldWidth;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  // Store the intrinsic size of the friendField displaying the placeholder
  // (there's probably a better way to this than storing the value on view load)
  self.initialFriendFieldWidth = self.friendField.intrinsicContentSize.width;
}

- (IBAction)friendFieldEditingChanged:(UITextField *)friendField {
  
  // Insert the friend name into the sentence
  NSString *sentencePart1 = @"I'm paying ";
  NSString *sentencePart2 = @" $ amount\nfor description";
  NSString *friendName = friendField.text;
  if (friendField.text.length == 0) {
    friendName = @"\n";
    sentencePart2 = @"$ amount\nfor description";
  }
  self.fullTextView.text = [@[sentencePart1, friendName, sentencePart2] componentsJoinedByString:@""];
  
  // Render the fullTextView, so that we can retrieve the last friend name's last character position
  [self.fullTextView setNeedsLayout];
  [self.fullTextView layoutIfNeeded];
  
  // Retrieve the frame of the last character (in relation to the textView's coordinates)
  UITextPosition *last = [self.fullTextView positionFromPosition:self.fullTextView.beginningOfDocument offset:sentencePart1.length + friendField.text.length];
  UITextPosition *secondToLast = [self.fullTextView positionFromPosition:last offset:-1];
  UITextRange *range = [self.fullTextView textRangeFromPosition:secondToLast toPosition:last];
  CGRect rangeRect = [self.fullTextView firstRectForRange:range];
  
  // Here comes the trick:
  // The friendField's width will be reduced to the width of the caret and
  // placed at the last character's position within the fullTextView.
  
  // Retrieve the caret width
  CGFloat width = [self.friendField caretRectForPosition:nil].size.width;
  // If no text is entered, unfold friendField to reveal the placeholder
  if (friendField.text.length == 0) {
    width = self.initialFriendFieldWidth;
  }
  
  // Using AutoLayout constraints (see Main.storyboard)
  self.friendFieldLeadingConstraint.constant = - rangeRect.origin.x - rangeRect.size.width;
  self.friendFieldTopConstraint.constant = - rangeRect.origin.y;
  self.friendFieldWidthConstraint.constant = width;
  
  // :-)
}

@end
