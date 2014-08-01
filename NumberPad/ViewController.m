//
//  ViewController.m
//  NumberPad
//
//  Created by danal on 8/1/14.
//  Copyright (c) 2014 danal. All rights reserved.
//

#import "ViewController.h"
#import "NumberPad.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [[NumberPad instance] setReturnKey:NSLocalizedString(@"Done",nil)];
    _textField.inputView = [NumberPad instance];
    [_textField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return YES;
}


@end
