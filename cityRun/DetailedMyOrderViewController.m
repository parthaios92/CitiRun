//
//  DetailedMyOrderViewController.m
//  citiRun
//
//  Created by Basir Alam on 16/05/17.
//  Copyright © 2017 Basir. All rights reserved.
//

#import "DetailedMyOrderViewController.h"
#import "CurrentOrderTableViewCell.h"

@interface DetailedMyOrderViewController ()<ProcessDataDelegate>
{
    DataFetch *_dataFetch;
    NSDictionary *dataDic;
    IBOutlet UITableView *detalsTableView;

}
@end

@implementation DetailedMyOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Order Details";
    _dataFetch = [[DataFetch alloc]init];
    _dataFetch.delegate = self;
    [self setBackgroundImage];
    [self fetchDetailedMyOrderDetails:_cart_id];

}

//#pragma mark - Set Constants And Fonts
//
//-(void)setConstantsAndFonts:(NSInteger)height{
//    if (IS_IPAD) {
//        totalViewHeightLayout.constant = 240;
//        if (cartViewHeghtLayout.constant<=550) {
//            cartViewHeghtLayout.constant = 150*height+50;
//        }else{
//            cartViewHeghtLayout.constant = 550;
//        }
//        
//    }else if(IS_IPHONE_5 || IS_IPHONE_4_OR_LESS){
//        //        totalViewLayout.constant = 140;
//    }else{
//        
//    }
//    
//}
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

    cell.lblProductName.text = [[[dataDic objectForKey:@"data"] objectAtIndex:indexPath.row] valueForKey:@"product"];
    cell.lblDetailedPrice.text = [NSString stringWithFormat:@"$%@",[[[dataDic objectForKey:@"data"] objectAtIndex:indexPath.row] valueForKey:@"price"]];
    cell.lblCategory.text = [NSString stringWithFormat:@"Category: %@",[[[dataDic objectForKey:@"data"] objectAtIndex:indexPath.row] valueForKey:@"category"]];
    cell.lblQuantity.text = [NSString stringWithFormat:@"Quantity: %@",[[[dataDic objectForKey:@"data"] objectAtIndex:indexPath.row] valueForKey:@"quantity"]];
    [cell.imgProduct sd_setImageWithURL:[NSURL URLWithString:[[[dataDic objectForKey:@"data"] objectAtIndex:indexPath.row] valueForKey:@"image"]]];

    
    //    IS_IPHONE_5 or IS_IPHONE_4_OR_LESS
    if(IS_IPHONE_5 || IS_IPHONE_4_OR_LESS){
        //        cell.productImageWidthLC.constant = 95;
    }else{
        //        cell.productImageWidthLC.constant = 106;
    }
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (IS_IPAD) {
        return 100;
    }else{
        return 90;
    }
}

#pragma mark - Delete Cart Value

-(void)fetchDetailedMyOrderDetails:(NSString *)cartID{
    
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    
    NSDictionary *cartDic = @{@"actiontype":@"order_details",
                              @"cart_id":cartID
                              };
    NSLog(@"%@",cartDic);
    [_dataFetch requestURL:KBaseUrl method:@"POST" dic:cartDic from:@"fetchDetailedMyOrderDetails" type:@"json"];
}


#pragma mark - Process Successful
- (void) processSuccessful :(NSDictionary *)data1 :(NSString *)JsonFor{
    NSLog(@"%@",data1);
    
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    dataDic = [[NSDictionary alloc]init];
    dataDic = data1;
    
    [detalsTableView reloadData];
}


-(void)processNotSucessful:(NSString *)string{
    
}

@end
