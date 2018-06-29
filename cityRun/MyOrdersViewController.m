//
//  MyOrdersViewController.m
//  cityRun
//
//  Created by Basir Alam on 04/04/17.
//  Copyright © 2017 Basir. All rights reserved.
//

#import "MyOrdersViewController.h"
#import "CurrentOrderTableViewCell.h"
#import "PreviousOrderTableViewCell.h"
#import "DetailedMyOrderViewController.h"
@interface MyOrdersViewController ()<ProcessDataDelegate>
{
    IBOutlet UITableView *myOrderTable;
    DataFetch *_dataFetch;
    NSDictionary *dataDic;
    
    
}
@end

@implementation MyOrdersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _dataFetch = [[DataFetch alloc]init];
    _dataFetch.delegate = self;
    self.title = @"My Orders";
    //[self setBackgroundImage];
    [self navigationColorSet];
    [self fetchMyOrderDetails];
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


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[[dataDic objectForKey:@"data"] valueForKey:@"billing_amount"] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CurrentOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CurrentOrderTableViewCell" forIndexPath:indexPath];
    
    cell.backgroundColor = cell.contentView.backgroundColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    cell.lblSellerName.text = [[[dataDic objectForKey:@"data"] objectAtIndex:indexPath.row] valueForKey:@"sellername"];
    cell.lblPrice.text = [NSString stringWithFormat:@"Total: %@",[NSString stringWithFormat:@"$%@",[[[dataDic objectForKey:@"data"] objectAtIndex:indexPath.row] valueForKey:@"billing_amount"]]];
    cell.lblStatus.text = [[[dataDic objectForKey:@"data"] objectAtIndex:indexPath.row] valueForKey:@"status"];
    cell.lblZIP.text = [[[dataDic objectForKey:@"data"] objectAtIndex:indexPath.row] valueForKey:@"zipcode"];
    cell.lblAddress.text = [NSString stringWithFormat:@"%@, %@, %@",[[[dataDic objectForKey:@"data"] objectAtIndex:indexPath.row] valueForKey:@"address"],[[[dataDic objectForKey:@"data"] objectAtIndex:indexPath.row] valueForKey:@"city"],[[[dataDic objectForKey:@"data"] objectAtIndex:indexPath.row] valueForKey:@"country"]] ;
    
    //    IS_IPHONE_6 or IS_IPHONE_7
    if(IS_IPHONE_6){
        //        cell.productImageWidthLC.constant = 95;
        cell.btnWidthLayout.constant = 90;
        cell.lblPrice.font = [UIFont systemFontOfSize:14.0];
        
    }
    //    IS_IPHONE_5 or IS_IPHONE_4_OR_LESS
    else if(IS_IPHONE_5 || IS_IPHONE_4_OR_LESS){
        //        cell.productImageWidthLC.constant = 95;
        cell.btnWidthLayout.constant = 70;
        cell.lblPrice.font = [UIFont systemFontOfSize:12.0];
        
    }else{
        //        cell.productImageWidthLC.constant = 106;
    }
   
    return cell;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailedMyOrderViewController *dMyOrderVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailedMyOrderViewController"];
    dMyOrderVC.cart_id = [[[dataDic objectForKey:@"data"] objectAtIndex:indexPath.row] valueForKey:@"cart_id"];
    [self.navigationController pushViewController:dMyOrderVC animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (IS_IPAD) {
        return 135;
    }else{
        return 130;
    }
}

#pragma mark - Delete Cart Value

-(void)fetchMyOrderDetails{
    
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
    

    NSDictionary *cartDic = @{@"actiontype":@"my_orders",
                              @"user_id":[[[NSUserDefaults standardUserDefaults] valueForKey:@"loginDetails"] valueForKey:@"user_id"],
                              @"device_id":deviceToken,
                              };
    NSLog(@"%@",cartDic);
    [_dataFetch requestURL:KBaseUrl method:@"POST" dic:cartDic from:@"fetchMyOrderDetails" type:@"json"];
}


#pragma mark - Process Successful
- (void) processSuccessful :(NSDictionary *)data1 :(NSString *)JsonFor{
    NSLog(@"%@",data1);
    
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    dataDic = [[NSDictionary alloc]init];
    dataDic = data1;
    
    [myOrderTable reloadData];
}


-(void)processNotSucessful:(NSString *)string{
    
}

@end
