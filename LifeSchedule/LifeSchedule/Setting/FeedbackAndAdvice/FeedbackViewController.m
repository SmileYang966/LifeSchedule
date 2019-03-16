//
//  FeedbackViewController.m
//  LifeSchedule
//
//  Created by Evan Yang on 2019/3/15.
//  Copyright © 2019 EvanYang. All rights reserved.
//

#import "FeedbackViewController.h"
#import "SKPSMTPMessage.h"
#import "NSData+Base64Additions.h"
#import "MBProgressHUD.h"

@interface FeedbackViewController ()<SKPSMTPMessageDelegate>

@property (weak, nonatomic) IBOutlet UITextField *subjectTf;
@property (weak, nonatomic) IBOutlet UITextView *contentTv;

@property(nonatomic,strong) MBProgressHUD *progressHUD;

@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //1.Initalization
    [self initOperations];
    
    //2.Clicked the send button
    UIBarButtonItem *sendBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Send" style:UIBarButtonItemStylePlain target:self action:@selector(sendButtonClicked:)];
    self.navigationItem.rightBarButtonItem = sendBarButtonItem;
}

-(void)initOperations{
    //1. Content TextView
    self.contentTv.layer.backgroundColor = UIColor.clearColor.CGColor;
    self.contentTv.layer.borderColor = [UIColor colorWithRed:226/255.0 green:226/255.0 blue:226/255.0 alpha:1.0f].CGColor;
    self.contentTv.layer.borderWidth = 1.0f;
    self.contentTv.layer.cornerRadius = 8.0f;
    [self.contentTv.layer setMasksToBounds:YES];
    
    //2. Create a MBProgressHUD view
    self.progressHUD = [[MBProgressHUD alloc]initWithView:self.view];
    self.progressHUD.progress = 0.4f;
    self.progressHUD.dimBackground = YES;
    [self.view addSubview:self.progressHUD];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(void)sendButtonClicked:(UIBarButtonItem *)barButtonItem{
    //开始显示遮罩
     [self.progressHUD showAnimated:YES];
    
    //1. Collect subject info
    NSString *subjectInfo = self.subjectTf.text;

    //2. Collect content info
    NSString *contentTv = self.contentTv.text;

    //3. send mail from addr
    NSString *sendAddr = @"lifeschedule@163.com";

    //4. mail to addr
    NSString *toAddr = @"evanyang966@163.com";

    SKPSMTPMessage *sendMessage = [[SKPSMTPMessage alloc]init];
    sendMessage.fromEmail = sendAddr;
    sendMessage.toEmail = toAddr;
    sendMessage.relayHost = @"smtp.163.com";
    sendMessage.requiresAuth = YES;
    sendMessage.login = sendAddr;
    sendMessage.pass = @"lifeschedule966";
    sendMessage.subject = subjectInfo;
    sendMessage.wantsSecure = YES;
    sendMessage.delegate = self;

    NSDictionary *plainPart = [NSDictionary dictionaryWithObjectsAndKeys:@"text/plain",kSKPSMTPPartContentTypeKey,[NSString stringWithFormat:@"%@",contentTv]
                            ,kSKPSMTPPartMessageKey,@"8bit",kSKPSMTPPartContentTransferEncodingKey,nil];

    sendMessage.parts = [NSArray arrayWithObjects:plainPart, nil];
    [sendMessage send];
}

- (void)messageSent:(SKPSMTPMessage *)message{
    NSLog(@"messageSuccessed-----%@", message);
    [self showPopUpWithTitle:@"提示信息" message:@"发送成功!"];
}

- (void)messageFailed:(SKPSMTPMessage *)message error:(NSError *)error{
    NSLog(@"messageFailedToSend-----%@", message);
    [self showPopUpWithTitle:@"提示信息" message:@"发送失败，请稍后再试!"];
}

- (void)showPopUpWithTitle:(NSString *)title message:(NSString *)msg{
    //隐藏遮罩
    [self.progressHUD hideAnimated:YES];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }]];
    
    [self.navigationController presentViewController:alertController animated:YES completion:nil];
}

@end
