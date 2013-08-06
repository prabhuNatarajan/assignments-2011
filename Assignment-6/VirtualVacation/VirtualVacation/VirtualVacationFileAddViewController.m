//
//  VirtualVacationFileAddViewController.m
//  VirtualVacation
//
//  Created by Apple on 14/06/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import "VirtualVacationFileAddViewController.h"

#define VACATION_NAME_PLACEHOLDER @"Vacation Name"
#define MIN_LENGHT 3
#define MAX_LENGTH 12
#define ERROR_MSG_STRING_TOO_SHORT @"Vacation name should contain min. %d characters"
#define ERROR_MSG_STRING_TOO_LONG @"Vacation name should contain no more than %d characters"
#define ERROR_MSG_STRING_CONTAINS_ILLEGAL_CHARACTERS @"Vacation name contains unsupported characters."
#define ERROR_MSG_STRING_CONTAINS_ILLEGAL_CHARACTERS_2 @"Supported characters are : letters (A-Z,a-z) and digits(0-9)"
#define ERROR_MSG_DUPLICATED_STRING @"Vacation named :\"%@\" already exists!"

@interface VirtualVacationFileAddViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabelExtended;

@end

@implementation VirtualVacationFileAddViewController

- (BOOL)checkIfTextFieldValid
{
    NSInteger length = [self.nameTextField.text length];
    NSString *value = self.nameTextField.text;
    NSString *myRegex = @"[A-Za-z0-9]*";
    NSPredicate *myTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", myRegex];
    self.statusLabelExtended.text = nil;
    self.statusLabel.text = nil;
    if (length < MIN_LENGHT)
    {
        self.statusLabel.text = [NSString stringWithFormat:ERROR_MSG_STRING_TOO_SHORT, MIN_LENGHT];
    } else if (length > MAX_LENGTH)
    {
        self.statusLabel.text = [NSString stringWithFormat:ERROR_MSG_STRING_TOO_LONG, MAX_LENGTH];
    } else if (![myTest evaluateWithObject:value])
    {
        self.statusLabel.text = ERROR_MSG_STRING_CONTAINS_ILLEGAL_CHARACTERS;
        self.statusLabelExtended.text = ERROR_MSG_STRING_CONTAINS_ILLEGAL_CHARACTERS_2;
    } else if ([self.delegate VirtualvacationFileAddViewController:self asksIfVacationWithGivenNameExists:value])
    {
        self.statusLabelExtended.text = [NSString stringWithFormat:ERROR_MSG_DUPLICATED_STRING, value];
    } else
    {
        return YES;
    }
    return NO;
}

- (IBAction)cancel:(UIButton *)sender
{
    [self.delegate VirtualvacationFileAddViewController:self didAddVacation:nil];
}

- (IBAction)save:(UIButton *)sender
{
    if ([self checkIfTextFieldValid])
    {
        [self.delegate VirtualvacationFileAddViewController:self didAddVacation:self.nameTextField.text];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([self checkIfTextFieldValid])
    {
        [textField resignFirstResponder];
        [self.delegate VirtualvacationFileAddViewController:self didAddVacation:textField.text];
        return YES;
    }
    return NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.nameTextField.placeholder = VACATION_NAME_PLACEHOLDER;
    self.nameTextField.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.nameTextField becomeFirstResponder];
    self.statusLabel.text = nil;
    self.statusLabelExtended.text = nil;
}

@end
