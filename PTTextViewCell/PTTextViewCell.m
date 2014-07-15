//
//  PTTextViewCell.m
//  PTTextViewCell
//
//  Created by Phillip Harris on 4/24/14.
//  Copyright (c) 2014 Phillip Harris. All rights reserved.
//

#import "PTTextViewCell.h"

NSString * const PTTextViewCellReuseIdentifier = @"PTTextViewCellReuseIdentifier";

@implementation PTTextViewCell

//===============================================
#pragma mark -
#pragma mark Initialization
//===============================================

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _textView = [[UITextView alloc] initWithFrame:self.contentView.bounds];
        _textView.delegate = self;
        
        [[self class] formatTextView:_textView];
        
        _textView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_textView];
        
        NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_textView);
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_textView]|" options:0 metrics:0 views:viewsDictionary]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_textView]|" options:0 metrics:0 views:viewsDictionary]];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [[self class] formatTextView:self.textView];
}

//===============================================
#pragma mark -
#pragma mark Cell Formatting
//===============================================

+ (UIFont *)desiredFont {
    return [UIFont systemFontOfSize:17.0];
}

+ (UIEdgeInsets)desiredTextMargins {
    CGFloat margin = 24.0;
    return UIEdgeInsetsMake(margin, margin, margin, margin);
}

+ (void)formatTextView:(UITextView *)textView {
    
    UIEdgeInsets textMargins = [self desiredTextMargins];
    
    textView.scrollEnabled = NO;
    textView.textContainerInset = UIEdgeInsetsMake(textMargins.top, textMargins.left - textView.textContainer.lineFragmentPadding, textMargins.bottom, textMargins.right - textView.textContainer.lineFragmentPadding);
    textView.font = [self desiredFont];
    
    textView.autocorrectionType = UITextAutocorrectionTypeNo;
    textView.autocapitalizationType = UITextAutocapitalizationTypeNone;
}

//===============================================
#pragma mark -
#pragma mark Calculate Cell Height
//===============================================

+ (CGFloat)requiredHeightForString:(NSString *)string cellWidth:(CGFloat)width {
    
    NSDictionary *attributes = @{NSFontAttributeName: [self desiredFont]};
    
    UIEdgeInsets textMargins = [self desiredTextMargins];
    
    CGRect boundingRect = [string boundingRectWithSize:CGSizeMake(width - textMargins.left - textMargins.right, FLT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:attributes context:nil];
    
    CGFloat textHeight = CGRectGetHeight(boundingRect) + 5.0;
    
    CGFloat requiredHeight = ceilf(textHeight) + textMargins.top + textMargins.bottom;
    
    if ([string hasSuffix:@"\n"]) {
        
        requiredHeight += [[self desiredFont] lineHeight];
    }
    
    return requiredHeight;
}

+ (CGFloat)requiredHeightForAttributedString:(NSAttributedString *)attributedString cellWidth:(CGFloat)width {
    
    UIEdgeInsets textMargins = [self desiredTextMargins];
    
    CGRect boundingRect = [attributedString boundingRectWithSize:CGSizeMake(width - textMargins.left - textMargins.right, FLT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) context:nil];
    
    CGFloat textHeight = CGRectGetHeight(boundingRect) + 5.0;
    
    CGFloat requiredHeight = ceilf(textHeight) + textMargins.top + textMargins.bottom;
    
    if ([[attributedString string] hasSuffix:@"\n"]) {
        
        UIFont *font = [attributedString attribute:NSFontAttributeName atIndex:0 effectiveRange:NULL];
        if (font) {
            requiredHeight += [font lineHeight];
        }
    }
    
    return requiredHeight;
}
/*
+ (CGFloat)textViewSizeThatFitsHeightForAttributedString:(NSAttributedString *)attributedString cellWidth:(CGFloat)width {
    
    [[self sharedTextView] setAttributedText:attributedString];
    CGSize size = [[self sharedTextView] sizeThatFits:CGSizeMake(width, FLT_MAX)];
    NSLog(@"%@", NSStringFromCGSize(size));
    return size.height + 5.0;
}

+ (UITextView *)sharedTextView {
    
    static dispatch_once_t pred;
    static UITextView *shared = nil;
    
    dispatch_once(&pred, ^{
        
        shared = [[UITextView alloc] init];
        
        [self formatTextView:shared];
    });
    return shared;
}
*/
//===============================================
#pragma mark -
#pragma mark UITextViewDelegate
//===============================================

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    
    if ([self.delegate respondsToSelector:@selector(textViewCellShouldBeginEditing:)]) {
        return [self.delegate textViewCellShouldBeginEditing:self];
    }
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    
    if ([self.delegate respondsToSelector:@selector(textViewCellShouldEndEditing:)]) {
        return [self.delegate textViewCellShouldEndEditing:self];
    }
    return YES;
}
- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    if ([self.delegate respondsToSelector:@selector(textViewCellDidBeginEditing:)]) {
        [self.delegate textViewCellDidBeginEditing:self];
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView {
    
    if ([self.delegate respondsToSelector:@selector(textViewCellDidEndEditing:)]) {
        [self.delegate textViewCellDidEndEditing:self];
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([self.delegate respondsToSelector:@selector(textViewCell:shouldChangeTextInRange:replacementText:)]) {
        return [self.delegate textViewCell:self shouldChangeTextInRange:range replacementText:text];
    }
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView {
    
    if ([self.delegate respondsToSelector:@selector(textViewCellDidChange:)]) {
        [self.delegate textViewCellDidChange:self];
    }
}
- (void)textViewDidChangeSelection:(UITextView *)textView {
    
    if ([self.delegate respondsToSelector:@selector(textViewCellDidChangeSelection:)]) {
        [self.delegate textViewCellDidChangeSelection:self];
    }
}
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    
    if ([self.delegate respondsToSelector:@selector(textViewCell:shouldInteractWithURL:inRange:)]) {
        return [self.delegate textViewCell:self shouldInteractWithURL:URL inRange:characterRange];
    }
    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange {
    
    if ([self.delegate respondsToSelector:@selector(textViewCell:shouldInteractWithTextAttachment:inRange:)]) {
        return [self.delegate textViewCell:self shouldInteractWithTextAttachment:textAttachment inRange:characterRange];
    }
    return YES;
}

@end
