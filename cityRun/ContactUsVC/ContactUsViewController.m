//
//  ContactUsViewController.m
//
//
//  Created by Basir Alam on 05/05/17.
//
//

#import "ContactUsViewController.h"

@interface ContactUsViewController ()<ProcessDataDelegate,UITextViewDelegate>
{
    IBOutlet ACFloatingTextFieldOriginal *txtSubject;
    IBOutlet SAMTextView *txtViewMessage;
    IBOutlet NSLayoutConstraint *textFieldWidthLayout;
    IBOutlet NSLayoutConstraint *textFieldHeightLayout;
    IBOutlet NSLayoutConstraint *textFiledTopLayout;
    
    DataFetch *_dataFetch;
    
    
}
@end

@implementation ContactUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Help Center";
    txtViewMessage.placeholder = @"Message";
    txtViewMessage.delegate = self;
    _dataFetch = [[DataFetch alloc]init];
    _dataFetch.delegate = self;
    
    
    [self setConstantsAndFonts];
  //  [self setBackgroundImage];
    [self navigationColorSet];
    
}
-(void)setConstantsAndFonts{
    
    txtViewMessage.layer.borderWidth = 1.0f;
    txtViewMessage.layer.borderColor = [[UIColor grayColor] CGColor];
    
    if (IS_IPAD) {
        textFieldHeightLayout.constant = 100.0f;
        textFieldWidthLayout.constant = 400.0f;
        textFiledTopLayout.constant = 150;
    }else{
        
    }
    
}

-(void)navigationColorSet{
    
    UINavigationBar *bar = [self.navigationController navigationBar];
    [bar setTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:122/255.0 green:175/255.0 blue:72/255.0 alpha:1.0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnSubmitAction:(id)sender {
    if (txtSubject.text.length == 0 || txtViewMessage.text.length == 0) {
        [self setAlertMessage:@"Blank Fields!" :@"Please fill the fields then click on submit."];

    }else{
        [self contactUsMethod];
    }
}

#pragma TextViewDelegate...

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [txtViewMessage resignFirstResponder];
        return NO;
    }
    
    return YES;
}

-(void)contactUsMethod{
    
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    NSDictionary *contactDic = @{@"actiontype":@"helpcenter",
                                 @"subject":txtSubject.text,
                                 @"message":txtViewMessage.text,
                                 @"user_type":[[[NSUserDefaults standardUserDefaults] valueForKey:@"loginDetails"] valueForKey:@"user_type"],
                                 @"user_id":[[[NSUserDefaults standardUserDefaults] valueForKey:@"loginDetails"] valueForKey:@"user_id"]
                                 };
    NSLog(@"%@",contactDic);
    [_dataFetch requestURL:KBaseUrl method:@"POST" dic:contactDic from:@"contactUsMethod" type:@"json"];
}

#pragma mark - Process Successful
- (void) processSuccessful :(NSDictionary *)data1 :(NSString *)JsonFor{
    NSLog(@"%@",data1);
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    if ([[data1 objectForKey:@"status"] isEqual:@"Feedback Sent"]) {
        
        [self setAlertMessage:@"Sent!" :@"Your message has been sent successfully."];
        txtSubject.text = nil;
        txtViewMessage.text = nil;
        
    }else{
        
        //        [self setAlertMessage:@"Success!" :@"Product successfully added to your shopping cart."];
    }
    
}
-(void)processNotSucessful:(NSString *)string{
    [self setAlertMessage:@"Error!" :@"Something went wrong. Please try again."];
}

@end
