//
//  MyTableViewController.m
//  PTTextViewCell
//
//  Created by Phillip Harris on 4/24/14.
//  Copyright (c) 2014 Phillip Harris. All rights reserved.
//

#import "MyTableViewController.h"

#import "PTTextViewCell.h"

@interface MyTableViewController () <PTTextViewCellDelegate>

@property (nonatomic, strong) NSString *text;

@property (nonatomic, strong) NSAttributedString *attributedText;

@end

@implementation MyTableViewController

//===============================================
#pragma mark -
#pragma mark Initialization
//===============================================

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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
    
    _attributedText = [[NSAttributedString alloc] initWithString:self.text attributes:@{NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-Medium" size:20.0]}]; // Futura-CondensedMedium AvenirNextCondensed-Medium
}

//===============================================
#pragma mark -
#pragma mark View
//===============================================

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    
    [self.tableView registerClass:[PTTextViewCell class] forCellReuseIdentifier:PTTextViewCellReuseIdentifier];
    
//    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([PTTextViewCell class]) bundle:nil] forCellReuseIdentifier:PTTextViewCellReuseIdentifier];
    
    UIBarButtonItem *keyboardDismissButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
    self.navigationItem.rightBarButtonItem = keyboardDismissButton;
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

@end
