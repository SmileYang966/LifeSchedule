//
//  FeedbackViewController.m
//  LifeSchedule
//
//  Created by Evan Yang on 2019/3/15.
//  Copyright © 2019 EvanYang. All rights reserved.
//

#import "FeedbackViewController.h"

@interface FeedbackViewController ()

@property (weak, nonatomic) IBOutlet UITextField *subjectTf;
@property (weak, nonatomic) IBOutlet UITextView *contentTv;

@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIBarButtonItem *sendBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Send" style:UIBarButtonItemStylePlain target:self action:@selector(sendButtonClicked:)];
    self.navigationItem.rightBarButtonItem = sendBarButtonItem;
}

-(void)initOperations{
    //Content TextView
    self.contentTv.layer.backgroundColor = UIColor.clearColor.CGColor;
    self.contentTv.layer.borderColor = [UIColor colorWithRed:226/255.0 green:226/255.0 blue:226/255.0 alpha:1.0f].CGColor;
    self.contentTv.layer.borderWidth = 1.0f;
    self.contentTv.layer.cornerRadius = 8.0f;
    [self.contentTv.layer setMasksToBounds:YES];
}

-(void)sendButtonClicked:(UIBarButtonItem *)barButtonItem{

}

@end
