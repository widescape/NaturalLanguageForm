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

// Using AutoLayout constraints to position the friendField
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
  NSString *fullSentence = [@[sentencePart1, friendName, sentencePart2] componentsJoinedByString:@""];
  
  // Get the ranges of the input value and of the last character
  UITextPosition *first = [self.fullTextView positionFromPosition:self.fullTextView.beginningOfDocument offset:sentencePart1.length];
  UITextPosition *last = [self.fullTextView positionFromPosition:first offset:friendField.text.length];
  UITextPosition *secondToLast = [self.fullTextView positionFromPosition:last offset:-1];
  NSInteger startInt = [self.fullTextView offsetFromPosition:self.fullTextView.beginningOfDocument toPosition:first];
  NSInteger endInt = [self.fullTextView offsetFromPosition:first toPosition:last];
  NSRange inputValueRange = NSMakeRange(startInt, endInt);
  UITextRange *lastCharacterRange = [self.fullTextView textRangeFromPosition:secondToLast toPosition:last];
  
  // Make the input value bold
  UIFont *normalFont = [UIFont systemFontOfSize:28];
  UIFont *boldFont = [UIFont boldSystemFontOfSize:28];
  NSMutableAttributedString *attrString = [NSMutableAttributedString.alloc
                                           initWithString:fullSentence
                                           attributes:@{NSForegroundColorAttributeName: UIColor.whiteColor,
                                                        NSFontAttributeName: normalFont}];
  [attrString beginEditing];
  [attrString addAttribute:NSFontAttributeName value:boldFont range:inputValueRange];
  [attrString endEditing];
  
  // Render the fullTextView, so that we can retrieve the friend name's last character position
  self.fullTextView.attributedText = attrString;
  [self.fullTextView setNeedsLayout];
  [self.fullTextView layoutIfNeeded];
  
  // Retrieve the frame of the friend name's last character (in relation to the textView's coordinates)
  CGRect lastCharacterRect = [self.fullTextView firstRectForRange:lastCharacterRange];
  
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
  self.friendFieldLeadingConstraint.constant = - lastCharacterRect.origin.x - lastCharacterRect.size.width;
  self.friendFieldTopConstraint.constant = - lastCharacterRect.origin.y;
  self.friendFieldWidthConstraint.constant = width;
  
  // :-)
}

@end
