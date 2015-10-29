//
//  EditCommentsController.m
//  LBzhihu
//
//  Created by lb on 15/10/29.
//  Copyright © 2015年 李波. All rights reserved.
//

#import "EditCommentsController.h"
#import "NetworkTool.h"

@interface EditCommentsController ()<UITextViewDelegate,UIScrollViewDelegate,UIAlertViewDelegate>
{
    UITextView *commentTextView;
    NSString *defaultString;
}
@end

@implementation EditCommentsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"评论";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *itm = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:(UIBarButtonItemStylePlain) target:self action:@selector(commmit)];
    self.navigationItem.rightBarButtonItem = itm;
    
    defaultString =  @"不友善的评论将会被删除，深度讨论会被优先展示。";
    CGFloat edge = 8;
    
    commentTextView = [[UITextView alloc] initWithFrame:CGRectMake(edge, edge, MAINSIZE.width - 2 * edge, MAINSIZE.height - 64 - 2 * edge)];
    commentTextView.text = defaultString;
    commentTextView.textColor = [UIColor grayColor];
    commentTextView.font = [UIFont fontWithName:commentTextView.font.fontName size:20];
    commentTextView.delegate = self;
    
    [self.view addSubview:commentTextView];
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    if ([commentTextView.text isEqualToString:defaultString]) {
        commentTextView.text = @"";
        commentTextView.textColor = [UIColor blackColor];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    if ([commentTextView.text isEqualToString:@""]) {
        commentTextView.text = defaultString;
        commentTextView.textColor = [UIColor grayColor];
    }

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [commentTextView resignFirstResponder];
}

- (void)commmit{
    NSString *result;
    
    if ([commentTextView.text isEqualToString:@""] || [commentTextView.text isEqualToString:defaultString]) {
        result = @"请输入评论";
    }else{
        result = @"提交评论成功";
    }
    
    [[[UIAlertView alloc] initWithTitle:result message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"知道了", nil] show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        return;
    }
    
    if ([commentTextView.text isEqualToString:@""] || [commentTextView.text isEqualToString:defaultString]) {
        return;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.barTintColor = HOMEHEADBACKGROUNDCOLOR;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
