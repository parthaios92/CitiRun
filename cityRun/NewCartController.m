//
//  NewCartController.m
//  citiRun
//
//  Created by @vi on 18/06/18.
//  Copyright © 2018 Basir. All rights reserved.
//

#import "NewCartController.h"
#import "AppDelegate.h"

@interface NewCartController ()<ProcessDataDelegate>{
    
    IBOutlet UILabel *lblCartValue;
    IBOutlet UIButton *cartBtnTitle;
    IBOutlet UILabel *lblCartBtn;
    IBOutlet UIButton *btnDecrement;
    IBOutlet UIButton *btnIncrement;
    
    IBOutlet UIImageView *menuDetailsImage;
    IBOutlet UILabel *lblDetailsMenuName;
    IBOutlet UITextView *txtViewMenuDetails;
    IBOutlet UILabel *lblDetailsMenuPrice;
    
    NSDictionary *dataDic;
    DataFetch *_dataFetch;
    
    
    int count;
    NSString * nbrStr;
    
}

@end

@implementation NewCartController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    lblCartValue.text = @"1";
    count = 1;
    [lblCartBtn setText:@"1"];
    btnDecrement.userInteractionEnabled = NO;
    
    _dataFetch = [[DataFetch alloc]init];
    _dataFetch.delegate = self;
    
    
    //NSLog(@"%@",_menuDetailsArray);
    
    [menuDetailsImage sd_setImageWithURL:[NSURL URLWithString:[_menuDetailsArray valueForKey:@"image"]]];
    lblDetailsMenuName.text = [_menuDetailsArray valueForKey:@"productname"];
    txtViewMenuDetails.text = [_menuDetailsArray valueForKey:@"description"];
    lblDetailsMenuPrice.text = [NSString stringWithFormat: @"$%@", [_menuDetailsArray valueForKey:@"price"]];
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [self navigationSet];
}

-(void)navigationSet{
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    
}

- (IBAction)btnIncrementAction:(id)sender {
    
    if (count >= 1){
        count++;
        nbrStr=[NSString stringWithFormat:@"%d",count];
         btnDecrement.userInteractionEnabled = YES;
        [lblCartValue setText:nbrStr];
        [cartBtnTitle setTitle:[NSString stringWithFormat: @"ADD %@ TO CART", nbrStr] forState:normal];
        [lblCartBtn setText:nbrStr];
        
    }else{
        
         btnDecrement.userInteractionEnabled = NO;
    }
}

- (IBAction)btnDecrementAction:(id)sender {
    
    if (count >= 2){
        btnDecrement.userInteractionEnabled = YES;
        count--;
        nbrStr=[NSString stringWithFormat:@"%d",count];
        [cartBtnTitle setTitle:[NSString stringWithFormat: @"ADD %@ TO CART", nbrStr] forState:normal];
        [lblCartValue setText:nbrStr];
        [lblCartBtn setText:nbrStr];
    }
    
}

- (IBAction)btnCartAction:(UIButton *)sender {
    
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    NSString *userId;
    
    if ([[[[NSUserDefaults standardUserDefaults] valueForKey:@"loginDetails"] valueForKey:@"user_id"] isEqual:@"anonymous"]){
        
        userId = @"";
        
    }else{
        
        userId = [[[NSUserDefaults standardUserDefaults] valueForKey:@"loginDetails"] valueForKey:@"user_id"];
    }
    
    NSString *uniqueIdentifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSLog(@"%@",uniqueIdentifier);
    
    
    NSDictionary *cartDic = @{@"actiontype":@"addtocart",
                              @"user_id":userId,
                              @"product_id":[_menuDetailsArray valueForKey:@"product_id"],
                              @"quantity":lblCartValue.text,
                              @"device_id":uniqueIdentifier,
                              @"store_id":[_menuDetailsArray valueForKey:@"storeid"],
                              @"price":[NSString stringWithFormat: @"$%@", [_menuDetailsArray valueForKey:@"price"]]
                              };
    NSLog(@"%@",cartDic);
    [_dataFetch requestURL:KBaseUrl method:@"POST" dic:cartDic from:@"getCartValue" type:@"json"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Process Successful
- (void) processSuccessful :(NSDictionary *)data1 :(NSString *)JsonFor{
    
    NSLog(@"%@",data1);
    
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    dataDic = [[NSDictionary alloc]init];
    if ([JsonFor isEqual:@"getCartValue"]) {
        if ([data1 valueForKey:@"data"] == (id)[NSNull null] || data1 == nil) {
            
            NSLog(@"Null value is data");
            
        }else{
            if ([[data1 objectForKey:@"success"] isEqual:@"yes"]) {
                
                dataDic = data1;
                
                NSString *checkCount = @"1";
                [[NSUserDefaults standardUserDefaults] setObject:checkCount forKey:@"preferenceName"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
//                NSLog(@"%@",[[NSUserDefaults standardUserDefaults]
//                             stringForKey:@"preferenceName"]);
                
                [self.navigationController popViewControllerAnimated:YES];
                
                
            }else{

                [self setAlertMessage:@"Empty Cart!" :@"Your cart is empty."];
            }

            
        }
    }

    
}

-(void)processNotSucessful:(NSString *)string{
    
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
