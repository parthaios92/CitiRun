//
//  CartViewController.m
//  cityRun
//
//  Created by Basir Alam on 03/04/17.
//  Copyright © 2017 Basir. All rights reserved.
//

#import "CartViewController.h"
#import "CartTableViewCell.h"
#import "CartTotalTableViewCell.h"
#import "CheckoutViewController.h"
#import "WebViewController.h"
@interface CartViewController ()<ProcessDataDelegate>
{
    IBOutlet UITableView *itemTable;
    IBOutlet UITableView *totalTable;
    
    IBOutlet ShadowDrop *itemBgView;
    IBOutlet ShadowDrop *totalBgView;
    
    IBOutlet NSLayoutConstraint *tableviewHeightLayout;
    NSMutableArray* titleArray;
    IBOutlet NSLayoutConstraint *totalViewHeightLayout;
    IBOutlet NSLayoutConstraint *cartViewHeghtLayout;
    
    DataFetch *_dataFetch;
    
    IBOutlet ShadowDrop *iam21View;
    IBOutlet UIButton *btn21;
    IBOutlet UIButton *btnProceed;
    BOOL isSelected;
    NSDictionary *dataDic;
    
    IBOutlet UILabel *txtSellerName;
    BOOL isLiquor;
    NSString *deviceToken ;
    
    UIView *transView;
    
}
@end

@implementation CartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    transView = [[UIView alloc] initWithFrame:self.view.bounds];

    _dataFetch = [[DataFetch alloc]init];
    _dataFetch.delegate = self;
    
    [itemBgView setHidden:NO];
    [totalBgView setHidden:NO];
    
    [self navigationColorSet];
    //[self setBackgroundImage];
    //[self setConstantsAndFonts];
    [self getCartValue];
    
}



#pragma mark - Set Constants And Fonts

-(void)setConstantsAndFonts:(NSInteger)height{
    if (IS_IPAD) {
        totalViewHeightLayout.constant = 240;
        if (cartViewHeghtLayout.constant<=550) {
            cartViewHeghtLayout.constant = 150*height+50;
        }else{
            cartViewHeghtLayout.constant = 550;
        }
        
    }else if(IS_IPHONE_6P){
        totalViewHeightLayout.constant = 220;
        if (cartViewHeghtLayout.constant<=300) {
            cartViewHeghtLayout.constant = 120*height+50;
            
        }else{
            cartViewHeghtLayout.constant = 120*height+50;
        }

        
    }else if(IS_IPHONE_6){
        totalViewHeightLayout.constant = 220;
        if (cartViewHeghtLayout.constant<=300) {
            cartViewHeghtLayout.constant = 120*height+50;
            
        }else{
            cartViewHeghtLayout.constant = 120*height+50;
        }
    }
    else if(IS_IPHONE_5 || IS_IPHONE_4_OR_LESS){
        totalViewHeightLayout.constant = 120;
        if (cartViewHeghtLayout.constant<=300) {
            cartViewHeghtLayout.constant = 120*height+50;

        }else{
            cartViewHeghtLayout.constant = 120*height+50;
        }
    }else{
        totalViewHeightLayout.constant = 220;

    }
    
}

#pragma mark NavigationColor Set

-(void)navigationColorSet{
    
    UINavigationBar *bar = [self.navigationController navigationBar];
    [bar setTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:122/255.0 green:175/255.0 blue:72/255.0 alpha:1.0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == itemTable) {
        if ([[[dataDic objectForKey:@"data"] valueForKey:@"product_id"] count] == 0) {
            [itemBgView setHidden:YES];
            [totalBgView setHidden:YES];
        }else{
            [itemBgView setHidden:NO];
            [totalBgView setHidden:NO];
            [self setConstantsAndFonts:[[[dataDic objectForKey:@"data"] valueForKey:@"product_id"] count]];

        }
        return [[[dataDic objectForKey:@"data"] valueForKey:@"product_id"] count];

    }else{
        return 4;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == itemTable) {
        CartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CartTableViewCell" forIndexPath:indexPath];
        
        if (IS_IPAD) {
            cell.imgViewWeightLayout.constant = 130;
        }else{
            
        }
        cell.backgroundColor = cell.contentView.backgroundColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        //Setting For incrememnt
        cell.btnIncrement.tag = indexPath.row;
        [cell.btnIncrement addTarget:self action:@selector(incrementMethod:) forControlEvents:UIControlEventTouchUpInside];
        
        //Setting For decrement
        cell.btnDecrement.tag = indexPath.row;
        [cell.btnDecrement addTarget:self action:@selector(decrementMethod:) forControlEvents:UIControlEventTouchUpInside];
        
        //Setting For Delete cell
        cell.btnDelete.tag = indexPath.row;
        [cell.btnDelete addTarget:self action:@selector(deleteMethod:) forControlEvents:UIControlEventTouchUpInside];
        
        //Setting For TextFiled tag
        cell.txtProductCount.tag = indexPath.row;
        
        //Setting For Delete cell
        cell.btnShowMenu.tag = indexPath.row;
        [cell.btnShowMenu addTarget:self action:@selector(showMenuAction:) forControlEvents:UIControlEventTouchUpInside];
        
        if ([[[[dataDic objectForKey:@"data"] objectAtIndex:indexPath.row] valueForKey:@"category"] isEqual:@"Liquor"]) {
            isLiquor = YES;
        }
        
        cell.lblProductName.text = [[[dataDic objectForKey:@"data"] objectAtIndex:indexPath.row] valueForKey:@"name"];
        cell.txtProductCount.text = [NSString stringWithFormat:@"%@",[[[dataDic objectForKey:@"data"] objectAtIndex:indexPath.row] valueForKey:@"amount"]];
        cell.lblPrice.text = [NSString stringWithFormat:@"$%@",[[[dataDic objectForKey:@"data"] objectAtIndex:indexPath.row] valueForKey:@"price"]];
        cell.lblCategory.text = [[[dataDic objectForKey:@"data"] objectAtIndex:indexPath.row] valueForKey:@"category"];
        [cell.productImg sd_setImageWithURL:[NSURL URLWithString:[[[dataDic objectForKey:@"data"] objectAtIndex:indexPath.row] valueForKey:@"image"]]];

        return cell;
        
    }else{
        CartTotalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CartTotalTableViewCell" forIndexPath:indexPath];
        cell.lblTitle.text = [titleArray objectAtIndex:indexPath.row];
        if (indexPath.row == 0) {
            cell.lblAmount.text = [NSString stringWithFormat:@"$%@",[dataDic objectForKey:@"product_total"]];
        }else if (indexPath.row == 1){
            cell.lblAmount.text = [NSString stringWithFormat:@"$%@",[dataDic objectForKey:@"service_tax"]];
        }else if (indexPath.row == 2){
            cell.lblAmount.text = [NSString stringWithFormat:@"$%@",[dataDic objectForKey:@"delivery_charge"]];
        }
        else{
            cell.lblAmount.text = [NSString stringWithFormat:@"$%@",[dataDic objectForKey:@"bill_total"]];
        }
        return cell;
    }
    
    //    IS_IPHONE_5 or IS_IPHONE_4_OR_LESS
    if(IS_IPHONE_5 || IS_IPHONE_4_OR_LESS){
        //        cell.productImageWidthLC.constant = 95;
    }else{
        //        cell.productImageWidthLC.constant = 106;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == itemTable) {
        if (IS_IPAD) {
            return 150;
        }else{
            return 120;
        }
    }else{
        if (IS_IPAD) {
            return 60;
        }else{
            if(IS_IPHONE_5 || IS_IPHONE_4_OR_LESS){
                return 30;
            }else{
                return 55;
            }
        }
    }
    
}


#pragma mark - Show Menu Action

-(void)showMenuAction:(id)sender{
    NSLog(@"showMenuAction Tag %ld",(long)[sender tag]);
}

#pragma mark - Delete Method

-(void)deleteMethod:(id)sender{
    
    NSLog(@"Delete Tag %ld",(long)[sender tag]);
    
//    NSString *productID = [[[dataDic objectForKey:@"data"] objectAtIndex:[sender tag]] valueForKey:@"product_id"];
    
    NSString *productID = [NSString stringWithFormat:@"%@",[[[dataDic objectForKey:@"data"] objectAtIndex:[sender tag]] valueForKey:@"store_id"]];
    NSLog(@"%@",productID);
    NSLog(@"%@",[[[dataDic objectForKey:@"data"] objectAtIndex:[sender tag]] valueForKey:@"cart_id"]);

    [self deleteCartValueWithCartId:[[[dataDic objectForKey:@"data"] objectAtIndex:[sender tag]] valueForKey:@"cart_id"] productId:productID];
}

#pragma mark - Increment Method

-(void)incrementMethod:(id)sender{
    NSLog(@"Increment Tag %ld",(long)[sender tag]);

    NSString *qty = [[[dataDic objectForKey:@"data"] objectAtIndex:[sender tag]] valueForKey:@"amount"];
    NSString *productID = [[[dataDic objectForKey:@"data"] objectAtIndex:[sender tag]] valueForKey:@"product_id"];
//    NSString *pStatus = @"increment";
    NSString *pStatus = [NSString stringWithFormat:@"%ld",[[[[dataDic objectForKey:@"data"] objectAtIndex:[sender tag]] valueForKey:@"amount"] integerValue]+1] ;
    [self changeCartValuesWithPid:productID qty:qty status:pStatus];
}

#pragma mark - Decrement Method

-(void)decrementMethod:(id)sender{
    NSLog(@"Decrement Tag %ld",(long)[sender tag]);
    
    NSString *qty = [[[dataDic objectForKey:@"data"] objectAtIndex:[sender tag]] valueForKey:@"amount"];
    NSString *productID = [[[dataDic objectForKey:@"data"] objectAtIndex:[sender tag]] valueForKey:@"product_id"];
//    NSString *pStatus = @"decrement";
    NSString *pStatus;
    NSLog(@"%@",[[[dataDic objectForKey:@"data"] objectAtIndex:[sender tag]] valueForKey:@"amount"]);
    if (([[[[dataDic objectForKey:@"data"] objectAtIndex:[sender tag]] valueForKey:@"amount"] integerValue] != 1)) {
        pStatus = [NSString stringWithFormat:@"%ld",[[[[dataDic objectForKey:@"data"] objectAtIndex:[sender tag]] valueForKey:@"amount"] integerValue]-1];
        [self changeCartValuesWithPid:productID qty:qty status:pStatus];

    }else{

    }

}

#pragma mark - Add Alert Subview To Center

-(void)addAlertSubviewToCenter{
    
    [self addTransparentView];
    iam21View.center = CGPointMake(self.view.frame.size.width  / 2,
                                   self.view.frame.size.height / 2);
    
    iam21View.layer.cornerRadius = 10.0f;
    [UIView transitionWithView:iam21View
                      duration:0.2
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        //                        [self.view setAlpha:0.5];
                        [self.view addSubview:iam21View];
                    } completion:nil];
}

-(void)addTransparentView{
    transView.backgroundColor=[UIColor blackColor];
    transView.alpha = 0.5;
    [self.view addSubview:transView];
}

- (IBAction)btnTnCAction:(id)sender {
    WebViewController *webVC = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
    webVC.from = @"Terms and Conditions";
    [self.navigationController pushViewController:webVC animated:YES];

}

- (IBAction)btnClose21ViewAction:(id)sender {
    [transView removeFromSuperview];
    [iam21View removeFromSuperview];
}
- (IBAction)btn21Action:(id)sender {
    btn21.selected =! btn21.selected;
    if (btn21.selected) {
        isSelected = YES;
    }else{
        isSelected = NO;
    }
}
- (IBAction)btnProceedAction:(id)sender {
    if (btn21.selected) {
        // [self.view setAlpha:1.0];
        [transView removeFromSuperview];
        [iam21View removeFromSuperview];
        btn21.selected = NO;
        
        CheckoutViewController *checkoutVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CheckoutViewController"];
        
        checkoutVC.billing_amount = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"bill_total"]];
        checkoutVC.cart_id = [dataDic objectForKey:@"cart_id"];
        checkoutVC.items = [NSString stringWithFormat:@"%lu",[[[dataDic objectForKey:@"data"] valueForKey:@"product_id"] count]];
        
        [self.navigationController pushViewController:checkoutVC animated:YES];
        
    }else{
        [self setAlertMessage:@"Error!" :@"Please click on checkbox to proceed."];
    }
    
}

#pragma mark - Proceed To Checkout Action

- (IBAction)btnProceedToCheckoutAction:(id)sender {
    
    [self addAlertSubviewToCenter];
    
}

#pragma mark - Delete Cart Value

-(void)deleteCartValueWithCartId:(NSString *)cart_id productId:(NSString *)product_id{
    
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    NSString *uniqueIdentifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSLog(@"%@",uniqueIdentifier);
    
    
    NSDictionary *cartDic = @{@"actiontype":@"removefromcart",
                              @"user_id":[[[NSUserDefaults standardUserDefaults] valueForKey:@"loginDetails"] valueForKey:@"user_id"],
                              @"cart_id":cart_id,
                              @"device_id":uniqueIdentifier,
                              @"store_id":product_id,
                              };
    NSLog(@"%@",cartDic);
    [_dataFetch requestURL:KBaseUrl method:@"POST" dic:cartDic from:@"getCartValue" type:@"json"];
}


#pragma mark - Get Cart Value

-(void)getCartValue{
    
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    
    
    NSString *uniqueIdentifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSLog(@"%@",uniqueIdentifier);
    
//    NSLog(@"dev id:%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"deviceID"]);
//    NSLog(@"dev id: %@",deviceToken);
    NSLog(@"user id:%@",[[[NSUserDefaults standardUserDefaults] valueForKey:@"loginDetails"] valueForKey:@"user_id"]);
    
    NSDictionary *cartDic = @{@"actiontype":@"fetch_cart",
                              @"user_id":[[[NSUserDefaults standardUserDefaults] valueForKey:@"loginDetails"] valueForKey:@"user_id"],
                              @"device_id":uniqueIdentifier,
                              };
    NSLog(@"%@",cartDic);
    [_dataFetch requestURL:KBaseUrl method:@"POST" dic:cartDic from:@"getCartValue" type:@"json"];
}

#pragma mark - Get Cart Value

-(void)changeCartValuesWithPid:(NSString *)pid qty:(NSString *)pQty status: (NSString *) status{
    
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    NSString *deviceToken ;
    
#if TARGET_IPHONE_SIMULATOR
    
    deviceToken = @"396dc0b8baa8698843ad2f7e5088039c49da5bffb1171aa7252e9affa53efe21";
#else
    
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"deviceID"] == nil) {
        deviceToken = @"396dc0b8baa8698843ad2f7e5088039c49da5bffb1171aa7252e9affa53efe21";
    }else{
        deviceToken = [[NSUserDefaults standardUserDefaults]valueForKey:@"deviceID"];
    }
#endif
    
    NSLog(@"dev id:%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"deviceID"]);
    NSLog(@"dev id: %@",deviceToken);

    
    NSDictionary *chabgeDic = @{@"actiontype":@"cart_add_del",
                                @"user_id":[[[NSUserDefaults standardUserDefaults] valueForKey:@"loginDetails"] valueForKey:@"user_id"],
                                @"product_id":pid,
                                @"status":status,
                                @"device_id":deviceToken,
                                };
    NSLog(@"%@",chabgeDic);
    [_dataFetch requestURL:KBaseUrl method:@"POST" dic:chabgeDic from:@"changeCartValues" type:@"json"];
    
}
#pragma mark - Process Successful
- (void) processSuccessful :(NSDictionary *)data1 :(NSString *)JsonFor{
    NSLog(@"%@",data1);
    
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    dataDic = [[NSDictionary alloc]init];
    if ([JsonFor isEqual:@"getCartValue"]) {
        if ([data1 valueForKey:@"data"] == (id)[NSNull null] || data1 == nil) {
            // tel is null
            NSLog(@"Null value is data");
            //            [self alertset:@"No Data!" :@"Server not responding please try after sometime"];
            
        }else{
            if ([[data1 objectForKey:@"available"] isEqual:@"yes"]) {
                
                dataDic = data1;
                
                
                txtSellerName.text = [dataDic objectForKey:@"sellername"];
                titleArray=[[NSMutableArray alloc]initWithObjects:[NSString stringWithFormat:@"Total %lu items",[[[dataDic objectForKey:@"data"] valueForKey:@"product_id"] count]],@"Vat and service tax",@"Delivery charges",@"Bill Total",nil];
                
                
            }else if ([[data1 objectForKey:@"success"] isEqual:@"yes"]){
                
                [self getCartValue];
            }
            else{
                [itemBgView setHidden:YES];
                [totalBgView setHidden:YES];
                [self setAlertMessage:@"Empty Cart!" :@"Your cart is empty."];
            }
            [itemTable reloadData];
            [totalTable reloadData];
            
        }
    }
    else if([JsonFor isEqual:@"changeCartValues"]){
        if ([[data1 objectForKey:@"available"] isEqual:@"yes"]) {
            
            dataDic = data1;
            
             txtSellerName.text = [dataDic objectForKey:@"sellername"];
            titleArray=[[NSMutableArray alloc]initWithObjects:[NSString stringWithFormat:@"Total %lu items",[[[dataDic objectForKey:@"data"] valueForKey:@"product_id"] count]],@"Vat and service tax",@"Delivery charges",@"Bill Total",nil];
            
        }else{
            [self setAlertMessage:@"Error!" :@"Server not responding please try after sometime"];
        }
        [itemTable reloadData];
        [totalTable reloadData];
    }
    
}
-(void)reloadCartData{
    
}
-(void)processNotSucessful:(NSString *)string{
    
}

@end
