//
//  MyViewController.m
//  PTTextViewCell
//
//  Created by Phillip Harris on 7/15/14.
//  Copyright (c) 2014 Phillip Harris. All rights reserved.
//

#import "MyViewController.h"

#import "PTTextViewCell.h"

@interface MyViewController () <PTTextViewCellDelegate>

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSAttributedString *attributedText;

@end

@implementation MyViewController

//===============================================
#pragma mark -
#pragma mark Initialization
//===============================================

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    
    _text = @"1\n2\n3\n4\n5\n6\n7\n8\n9\n10\n1\n2\n3\n4\n5\n6\n7";
    _attributedText = [[NSAttributedString alloc] initWithString:self.text attributes:@{NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-Bold" size:26.0]}];
}

//===============================================
#pragma mark -
#pragma mark View Methods
//===============================================

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[PTTextViewCell class] forCellReuseIdentifier:PTTextViewCellReuseIdentifier];
    
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    
    UIBarButtonItem *keyboardDismissButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
    self.navigationItem.rightBarButtonItem = keyboardDismissButton;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self registerForKeyboardNotifications];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self unregisterForKeyboardNotifications];
}

- (void)done {
    [self.view endEditing:YES];
}

//===============================================
#pragma mark -
#pragma mark UITableViewDataSource
//===============================================

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PTTextViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PTTextViewCellReuseIdentifier forIndexPath:indexPath];
    
    cell.delegate = self;
    
//    cell.textView.text = self.text;
    
    cell.textView.attributedText = self.attributedText;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    return [PTTextViewCell requiredHeightForString:self.text cellWidth:CGRectGetWidth(tableView.bounds)];
    
    return [PTTextViewCell requiredHeightForAttributedString:self.attributedText cellWidth:CGRectGetWidth(tableView.bounds)];
}

//===============================================
#pragma mark -
#pragma mark PTTextViewCellDelegate
//===============================================

- (void)textViewCellDidChange:(PTTextViewCell *)textViewCell {
    
//    self.text = textViewCell.textView.text;
    
    self.attributedText = textViewCell.textView.attributedText;
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

- (BOOL)textViewCellShouldBeginEditing:(PTTextViewCell *)textViewCell {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    return YES;
}

- (void)textViewCellDidBeginEditing:(PTTextViewCell *)textViewCell {
    
//    [self logTheCaretRect];
    
    [self performSelector:@selector(logTheCaretRect) withObject:nil afterDelay:0.1];
}

//- (BOOL)textViewCellShouldEndEditing:(PTTextViewCell *)textViewCell {
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
//    return YES;
//}

- (void)textViewCellDidEndEditing:(PTTextViewCell *)textViewCell {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)logTheCaretRect {
    
    PTTextViewCell *textViewCell = (PTTextViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
//    UITextRange *selectedTextRange = textViewCell.textView.selectedTextRange;
//    CGRect caretRect = [textViewCell.textView firstRectForRange:selectedTextRange];
//    NSLog(@"%@", NSStringFromCGRect(caretRect));
    
    CGRect otherCaretRect = [textViewCell.textView caretRectForPosition:textViewCell.textView.selectedTextRange.end];
//    NSLog(@"%@", NSStringFromCGRect(otherCaretRect));
    
    otherCaretRect.size.height += roundf(CGRectGetHeight(otherCaretRect) / 2.0);
    
    CGRect rectInTable = [self.tableView convertRect:otherCaretRect fromView:textViewCell.textView];
//    NSLog(@"%@", NSStringFromCGRect(rectInTable));
    
    [self.tableView scrollRectToVisible:rectInTable animated:YES];
}

//===============================================
#pragma mark -
#pragma mark Keyboard Methods
//===============================================

- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)unregisterForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)aNotification {
    
    NSDictionary *info = [aNotification userInfo];
    
    //
    // "UIKeyboardFrameBeginUserInfoKey" - The key for an NSValue object containing a CGRect that identifies the start frame of the keyboard in screen coordinates. These coordinates do not take into account any rotation factors applied to the window’s contents as a result of interface orientation changes. Thus, you may need to convert the rectangle to window coordinates (using the convertRect:fromWindow: method) or to view coordinates (using the convertRect:fromView: method) before using it.
    //
    CGRect kbFrm = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect convertedFrm = [self.view convertRect:kbFrm fromView:nil];
    CGFloat keyboardHeight = CGRectGetHeight(convertedFrm);
    
    double animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:animationDuration delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.tableView.contentInset = UIEdgeInsetsMake(self.tableView.contentInset.top, 0.0, keyboardHeight, 0.0);
        self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(self.tableView.scrollIndicatorInsets.top, 0.0, keyboardHeight, 0.0);
        
    } completion:^(BOOL finished) {
    }];
}

- (void)keyboardWillHide:(NSNotification *)aNotification {
    
    NSDictionary *info = [aNotification userInfo];
    
    double animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:animationDuration delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.tableView.contentInset = UIEdgeInsetsMake(self.tableView.contentInset.top, 0.0, 0.0, 0.0);
        self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(self.tableView.scrollIndicatorInsets.top, 0.0, 0.0, 0.0);
        
    } completion:^(BOOL finished) {
    }];
}

@end
