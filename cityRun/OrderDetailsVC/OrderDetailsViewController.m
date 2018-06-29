//
//  OrderDetailsViewController.m
//  citiRun
//
//  Created by Basir Alam on 17/05/17.
//  Copyright © 2017 Basir. All rights reserved.
//

#import "OrderDetailsViewController.h"
#import "StoreOwnerOrderTableViewCell.h"
@interface OrderDetailsViewController ()<ProcessDataDelegate>
{
    //    Create object of DataFetch
    
    DataFetch *_dataFetch;
    NSDictionary* dataDic;
    IBOutlet UITableView *orderDetailsTable;

}
@end

@implementation OrderDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Detailed Orders";

    _dataFetch = [[DataFetch alloc]init];
    _dataFetch.delegate = self;
    //[self setBackgroundImage];
    [self navigationColorSet];
    [self fetchOrderDetailedData];
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

#pragma mark - TableView Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return [[[dataDic objectForKey:@"data"] valueForKey:@"status"] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

        StoreOwnerOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StoreOwnerOrderTableViewCell" forIndexPath:indexPath];
        cell.backgroundColor = cell.contentView.backgroundColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    
            
            [cell.imgProduct sd_setImageWithURL:[NSURL URLWithString:[[[dataDic objectForKey:@"data"] objectAtIndex:indexPath.row] valueForKey:@"image"]]];
            cell.lblProductName.text = [[[dataDic objectForKey:@"data"] objectAtIndex:indexPath.row] valueForKey:@"product"];
            cell.lblPrice.text = [[[dataDic objectForKey:@"data"] objectAtIndex:indexPath.row] valueForKey:@"price"];
            cell.lblQty.text = [[[dataDic objectForKey:@"data"] objectAtIndex:indexPath.row] valueForKey:@"quantity"];
            cell.lblCategory.text = [[[dataDic objectForKey:@"data"] objectAtIndex:indexPath.row] valueForKey:@"category"];
            
    
         return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
 
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

        if (IS_IPAD) {
            return 120;
        }else{
            return 90;
        }
}

-(void)fetchOrderDetailedData{
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    NSDictionary* getOrderDic = @{@"actiontype":@"new_order_details",
                                  @"cart_id":_cart_id
                                  };
    
    NSLog(@"%@",getOrderDic);
    [_dataFetch requestURL:KBaseUrl method:@"POST" dic:getOrderDic from:@"fetchOrderDetailedData" type:@"json"];
    
}

#pragma mark - Process Successful
- (void) processSuccessful :(NSDictionary *)data1 :(NSString *)JsonFor{
    
    orderDetailsTable.hidden = NO;
    
//    [refreshControl endRefreshing];
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    dataDic = [[NSDictionary alloc]init];
    
    NSLog(@"%@",data1);
    
    if ([JsonFor isEqual:@"fetchOrderDetailedData"]) {
        if ([data1 valueForKey:@"data"] == (id)[NSNull null] || data1 == nil) {
            // tel is null
            NSLog(@"Null value is data");
            //            [self alertset:@"No Data!" :@"Server not responding please try after sometime"];
            
        }else{
            if ([[data1 objectForKey:@"available"] isEqual:@"yes"]) {
                
                dataDic = data1;
                
                
            }else{
                orderDetailsTable.hidden = YES;
                //            [self alertset:@"ecoPODIUM App" :@"Server not responding please try after sometime"];
            }
            [orderDetailsTable reloadData];
            
        }
    }
    else if ([JsonFor isEqual:@"moveToCompletedMethod"]){
        if ([[data1 objectForKey:@"available"] isEqual:@"yes"]) {
            dataDic = data1;
            
            [orderDetailsTable reloadData];
            
        }else{
            orderDetailsTable.hidden = YES;
            
            //            [self alertset:@"ecoPODIUM App" :@"Server not responding please try after sometime"];
        }
        
    }
    
}

#pragma mark - Process Not Successful

-(void)processNotSucessful:(NSString *)string{
    
}


@end
