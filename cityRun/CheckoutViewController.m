//
//  CheckoutViewController.m
//  cityRun
//
//  Created by Basir Alam on 04/04/17.
//  Copyright © 2017 Basir. All rights reserved.
//



#import "CheckoutViewController.h"

@interface CheckoutViewController ()<ProcessDataDelegate>
{
    IBOutlet NSLayoutConstraint *textFieldWidthLayout;
    IBOutlet NSLayoutConstraint *textFieldHeightLayout;
    IBOutlet NSLayoutConstraint *textFiledTopLayout;
    IBOutlet UIView *thankyouAlertView;
    IBOutlet NSLayoutConstraint *textViewHeightLayout;
    IBOutlet SAMTextView *txtViewOrderNote;
    IBOutlet SAMTextView *txtDeliveryNote;
    
    DataFetch *_dataFetch;
    
    //Setting textField
    IBOutlet ACFloatingTextField *txtName;
    IBOutlet ACFloatingTextField *txtAddress;
    IBOutlet ACFloatingTextFieldOriginal *txtZip;
    IBOutlet ACFloatingTextFieldOriginal *txtCity;
    IBOutlet ACFloatingTextField *txtCountry;
    IBOutlet ACFloatingTextField *txtPhone;
    IBOutlet ACFloatingTextField *txtEmail;
    
    IBOutlet UILabel *lblMsgUserName;
    IBOutlet UILabel *lblMsgOrderDate;
    IBOutlet UILabel *lblMsgItemCount;
    IBOutlet UITextView *txtVwMsgAddress;
    
    IBOutlet UIScrollView *bgScrollView;
    
    
}
@property (strong, nonatomic) PayPalConfiguration *configuration;

@end

@implementation CheckoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view...
    
    _dataFetch = [[DataFetch alloc]init];
    _dataFetch.delegate = self;
    
    //[self setBackgroundImage];
    //[self setBackgroundImageOfBG2];
    
    bgScrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
}

#pragma mark - Set Constants And Fonts

-(void)setBackgroundImageOfBG2
{
    txtDeliveryNote.placeholder = @"Delivery Note";
    txtViewOrderNote.placeholder = @"Order Note";
    
    txtDeliveryNote.layer.borderWidth = 1.0f;
    txtDeliveryNote.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    txtViewOrderNote.layer.borderWidth = 1.0f;
    txtViewOrderNote.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    if (IS_IPAD) {
        textViewHeightLayout.constant = 100.0f;
        textFieldWidthLayout.constant = 400.0f;
        textFiledTopLayout.constant = 150.0f;
    }else if(IS_IPHONE_6P){
        textViewHeightLayout.constant = 100.0f;
        textFieldWidthLayout.constant = 310.0f;
        textFiledTopLayout.constant = 30;

        
    }else if(IS_IPHONE_6){
        textViewHeightLayout.constant = 100.0f;
        textFieldWidthLayout.constant = 300.0f;
        textFiledTopLayout.constant = 30;

    }else if (IS_IPHONE_5){
        
        textViewHeightLayout.constant = 80.0f;
        textFieldWidthLayout.constant = 250.0f;
        textFiledTopLayout.constant = 30;

    }else{
        
    }

}

#pragma mark - Touches Began
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [bgScrollView endEditing:YES];
}

#pragma mark - scrollViewWillBeginDragging

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma mark - Continue Shopping Action

- (IBAction)btnContinueShoppingAction:(id)sender {
    [thankyouAlertView removeFromSuperview];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Close Popup Action

- (IBAction)btnClosePopupAction:(id)sender {
    [thankyouAlertView removeFromSuperview];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Setup PayPal

-(void)setupPayPal{
    _configuration = [[PayPalConfiguration alloc]init];
    _configuration.acceptCreditCards = YES;
    _configuration.merchantName = @"citiRunn Seller";
    _configuration.merchantPrivacyPolicyURL = [NSURL URLWithString:@"https://www.paypal.com/us/webapps/mpp/ua/privacy-full"];
    _configuration.merchantUserAgreementURL = [NSURL URLWithString:@"https://www.paypal.com/us/webapps/mpp/ua/legalhub-full"];
    _configuration.languageOrLocale = [NSLocale preferredLanguages] [0];
    _configuration.payPalShippingAddressOption = PayPalShippingAddressOptionPayPal;
    NSLog(@"Pay Pal SDK = %@",[PayPalMobile libraryVersion]);
}


#pragma mark - Payment Action

- (IBAction)btnPaymentAction:(id)sender {
    
    if (txtName.text.length == 0 || txtAddress.text.length == 0 || txtZip.text.length == 0 || txtCity.text.length == 0 || txtCountry.text.length == 0 || txtEmail.text.length == 0) {
                
        [self setAlertMessage:@"Error!" :@"Fields are empty."];
        
    }else if (![self validateEmailWithString:txtEmail.text]) {
        
        [self setAlertMessage:@"Error!" :@"Please enter valid email address and password."];
        
    }
    else{
        
        if (txtViewOrderNote.text.length == 0) {
            txtViewOrderNote.text = @"";
        }else if (txtDeliveryNote.text.length == 0){
            txtDeliveryNote.text = @"";
        }
        
        [self setupPaymentWithTaxAndOther];
    }
    
}
-(void)setupPaymentWithTaxAndOther{
    
    /*
     PayPalItem * item1 = [PayPalItem itemWithName:@"song1" withQuantity:1 withPrice:[NSDecimalNumber decimalNumberWithString:@"30"] withCurrency:@"USD" withSku:@"Song1-1122"];
     
     PayPalItem * item2 = [PayPalItem itemWithName:@"song2" withQuantity:1 withPrice:[NSDecimalNumber decimalNumberWithString:@"30"] withCurrency:@"USD" withSku:@"Song2-1133"];
     
     NSArray* items = @[item1,item2];
     NSDecimalNumber *subTotal = [PayPalItem totalPriceForItems:items];
     NSDecimalNumber* shipping = [[NSDecimalNumber alloc]initWithString:@"5.0"];
     NSDecimalNumber* tax = [[NSDecimalNumber alloc]initWithString:@"2.0"];
     PayPalPaymentDetails* paymentDetails = [PayPalPaymentDetails paymentDetailsWithSubtotal:subTotal withShipping:shipping  withTax:tax];
     */
    
    NSDecimalNumber *total= [NSDecimalNumber decimalNumberWithString:_billing_amount];
    PayPalPayment *payments=[[PayPalPayment alloc]init];
    payments.amount=total;
    NSLog(@"%@",total);
    payments.currencyCode=@"USD";
    payments.shortDescription=@"citiRunn Payments";
    
    //    payments.items=items;
    //    payments.paymentDetails=paymentDetails;
    //    payments.payeeEmail = @"";
    
    if(!payments.processable)
    {
        
    }
    
    PayPalPaymentViewController *paymentViewController=[[PayPalPaymentViewController alloc]initWithPayment:payments configuration:self.configuration delegate:self];
    [self presentViewController:paymentViewController animated:YES completion:nil];
}

#pragma mark - payPal Payment Did Cancel

- (void)payPalPaymentDidCancel:(nonnull PayPalPaymentViewController *)paymentViewController{
    NSLog(@"Payment cancelled");
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - payPal Payment did CompletePayment

- (void)payPalPaymentViewController:(nonnull PayPalPaymentViewController *)paymentViewController
                 didCompletePayment:(nonnull PayPalPayment *)completedPayment{
    
    NSLog(@"Payment success");
    //    NSLog(@"%@",completedPayment);
    //
    //    NSDictionary *payDetails =@{@"CurrencyCode":completedPayment.currencyCode,
    //                                @"Amount":completedPayment.amount,
    //                                @"ShortDescription":completedPayment.shortDescription,
    //                                @"email_id":completedPayment.payeeEmail,
    //                                };
    //
    //    NSDictionary *data = @{@"userid":@"user001",
    //                           @"paydata":payDetails,
    //                           };
    //
    //    NSLog(@"%@",data);
    //    if (data == (id)[NSNull null]) {
    //        // tel is null
    //    }
    
    [self checkoutDetailsMethod:completedPayment.payeeEmail];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Add Alert Subview To Center

-(void)addAlertSubviewToCenter{
    thankyouAlertView.center = CGPointMake(self.view.frame.size.width  / 2,
                                           self.view.frame.size.height / 2);
    
    thankyouAlertView.layer.cornerRadius = 10.0f;
    [UIView transitionWithView:thankyouAlertView
                      duration:0.2
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        [self.view setAlpha:0.5];
                        [self.view.window addSubview:thankyouAlertView];
                        [self setAlertDetails];
                    } completion:nil];
}

-(void)setAlertDetails{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm"];
//     or @"yyyy-MM-dd hh:mm:ss a" if you prefer the time with AM/PM
    
            lblMsgUserName.text = txtName.text;
            lblMsgOrderDate.text = [NSString stringWithFormat:@"Order Date: %@",[dateFormatter stringFromDate:[NSDate date]]];
            lblMsgItemCount.text = [NSString stringWithFormat:@"    %@ Items shipping to:",_items];
            txtVwMsgAddress.text = [NSString stringWithFormat:@"%@\n%@\n%@\n%@",txtAddress.text,txtCity.text,txtCountry.text,txtZip.text];

}
-(void)checkoutDetailsMethod:(NSString *)emailStr{
    
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    NSString *deviceToken ;
    NSString *email_id ;
    
#if TARGET_IPHONE_SIMULATOR
    
    deviceToken = @"396dc0b8baa8698843ad2f7e5088039c49da5bffb1171aa7252e9affa53efe21";
#else
    
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"deviceID"] == nil) {
        deviceToken = @"396dc0b8baa8698843ad2f7e5088039c49da5bffb1171aa7252e9affa53efe21";
    }else{
        deviceToken = [[NSUserDefaults standardUserDefaults]valueForKey:@"deviceID"];
    }
#endif
    
    
    if (emailStr == nil) {
        email_id = @"";
    }else{
        email_id = emailStr;
    }
    
    
        NSDictionary *checkoutDic = @{@"actiontype":@"checkout",
                                      @"device_id":deviceToken,
                                      @"name":txtName.text,
                                      @"address":txtAddress.text,
                                      @"zipcode":txtZip.text,
                                      @"city":txtCity.text,
                                      @"country":txtCountry.text,
                                      @"phone":txtPhone.text,
                                      @"email":txtEmail.text,
                                      @"ordernote":txtViewOrderNote.text,
                                      @"deliverynote":txtDeliveryNote.text,
                                      @"cart_id":_cart_id,
                                      @"user_id":[[[NSUserDefaults standardUserDefaults] valueForKey:@"loginDetails"] valueForKey:@"user_id"],
                                      @"email_id":email_id,
                                      @"billing_amount":_billing_amount
                                      };
        NSLog(@"%@",checkoutDic);
        [_dataFetch requestURL:KBaseUrl method:@"POST" dic:checkoutDic from:@"checkoutDetailsMethod" type:@"json"];
    

}

#pragma mark - Process Successful
- (void) processSuccessful :(NSDictionary *)data1 :(NSString *)JsonFor{
    NSLog(@"%@",data1);
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    if ([[data1 objectForKey:@"success"] isEqual:@"no"]) {
        
        [self setAlertMessage:@"Error!" :@"Something went wrong. Please try again."];
        
    }else{
        
        [self addAlertSubviewToCenter];
        
        //        [self setAlertMessage:@"Success!" :@"Product successfully added to your shopping cart."];
    }
    
}
-(void)processNotSucessful:(NSString *)string{
    [self setAlertMessage:@"Error!" :@"Something went wrong. Please try again."];
}


@end
