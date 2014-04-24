//
//  PTTextViewCell.h
//  PTTextViewCell
//
//  Created by Phillip Harris on 4/24/14.
//  Copyright (c) 2014 Phillip Harris. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PTTextViewCellDelegate;

extern NSString * const PTTextViewCellReuseIdentifier;

@interface PTTextViewCell : UITableViewCell <UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UITextView *textView;

@property (nonatomic, weak) id <PTTextViewCellDelegate> delegate;

+ (CGFloat)requiredHeightForString:(NSString *)text cellWidth:(CGFloat)width;
+ (CGFloat)requiredHeightForAttributedString:(NSAttributedString *)attributedString cellWidth:(CGFloat)width;

@end


@protocol PTTextViewCellDelegate <NSObject>

@optional

- (BOOL)textViewCellShouldBeginEditing:(PTTextViewCell *)textViewCell;
- (BOOL)textViewCellShouldEndEditing:(PTTextViewCell *)textViewCell;
- (void)textViewCellDidBeginEditing:(PTTextViewCell *)textViewCell;
- (void)textViewCellDidEndEditing:(PTTextViewCell *)textViewCell;
- (BOOL)textViewCell:(PTTextViewCell *)textViewCell shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
- (void)textViewCellDidChange:(PTTextViewCell *)textViewCell;
- (void)textViewCellDidChangeSelection:(PTTextViewCell *)textViewCell;
- (BOOL)textViewCell:(PTTextViewCell *)textViewCell shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange;
- (BOOL)textViewCell:(PTTextViewCell *)textViewCell shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange;

@end