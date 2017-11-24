//
//  ViewController.m
//  LengthLimit
//
//  Created by Mac mini on 2017/11/24.
//  Copyright © 2017年 Azcdragon. All rights reserved.
//

#import "ViewController.h"
#import "UITextView+LengthLimit.h"
#import "UITextField+LengthLimit.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(100, 500, 200, 200)];
    textView.backgroundColor = [UIColor blackColor];
    textView.textColor = [UIColor whiteColor];
    [self.view addSubview:textView];
    [textView addObserverTextChangeWithMAXLENGTH:100 WithType:(ImportChatTypeEnglish)];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(100, 300, 200, 30)];
    textField.backgroundColor = [UIColor grayColor];
    textField.placeholder = @"这是textField";
    [self.view addSubview:textField];
    [textField addObserverTextChangeWithMAXLENGTH:10 WithType:(ImportChatTypeNumber)];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
