//
//  MyProductViewController.m
//  cityRun
//
//  Created by Basir Alam on 05/04/17.
//  Copyright © 2017 Basir. All rights reserved.
//

#import "StoreOwnerProductViewController.h"
#import "StoreOwnerProductTableViewCell.h"
#import "StoreOwnerOrderViewController.h"
#import "ProductUploadViewController.h"
@interface StoreOwnerProductViewController ()<ProcessDataDelegate>
{
    //    Create object of DataFetch
    DataFetch *_dataFetch;
    NSDictionary* dataDic;

    IBOutlet UITableView *myProductTable;
}
@end

@implementation StoreOwnerProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _dataFetch = [[DataFetch alloc]init];
    _dataFetch.delegate = self;

    self.title = @"My Products";
    [self setBackgroundImage];
    [self fetchProductData];


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
    return [[[dataDic objectForKey:@"data"] valueForKey:@"id"] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

        StoreOwnerProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StoreOwnerProductTableViewCell" forIndexPath:indexPath];
    
    [cell.productImgView sd_setImageWithURL:[NSURL URLWithString:[[[dataDic objectForKey:@"data"] objectAtIndex:indexPath.row] valueForKey:@"iamge"]]];
//    [cell.productImgView sd_setImageWithURL:[NSURL URLWithString:@"www.appsforcompany.com/citirun/app/images/images.jpg"]];
    
    cell.lblProductName.text = [[[dataDic objectForKey:@"data"] objectAtIndex:indexPath.row] valueForKey:@"productname"];
    cell.lblPrice.text =[NSString stringWithFormat:@"$%@",[[[dataDic objectForKey:@"data"] objectAtIndex:indexPath.row] valueForKey:@"price"]];
    cell.lblQty.text = [[[dataDic objectForKey:@"data"] objectAtIndex:indexPath.row] valueForKey:@"quantity"];
    cell.lblCategory.text = [[[dataDic objectForKey:@"data"] objectAtIndex:indexPath.row] valueForKey:@"category"];
    cell.lblSubCategory.text = [[[dataDic objectForKey:@"data"] objectAtIndex:indexPath.row] valueForKey:@"sub_category"];

    
        return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (IS_IPAD) {
        return 160;
    }else{
        return 138;
    }
}
-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"   Edit   " handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        //insert your editAction here
        NSLog(@"Edit");
    }];
    editAction.backgroundColor = [UIColor colorWithRed:74/256.0 green:214/256.0 blue:171/256.0 alpha:1.0];
    
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Delete"  handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        //insert your deleteAction here
        NSLog(@"Delete");
    }];
    deleteAction.backgroundColor = [UIColor colorWithRed:62/256.0 green:178/256.0 blue:143/256.0 alpha:1.0];
    
    
    UITableViewRowAction *disableAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Disable"  handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        //insert your deleteAction here
        NSLog(@"Disable");
    }];
    disableAction.backgroundColor = [UIColor colorWithRed:41/256.0 green:118/256.0 blue:95/256.0 alpha:1.0];
    
    return @[deleteAction,editAction,disableAction];
}
- (IBAction)btnPresentAction:(id)sender {
    
    StoreOwnerOrderViewController * orderVC = [self.storyboard instantiateViewControllerWithIdentifier:@"StoreOwnerOrderViewController"];
    [self presentViewController:orderVC animated:YES completion:nil];
}

- (IBAction)btnAddNewProductAction:(id)sender {
    ProductUploadViewController * productVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ProductUploadViewController"];
    [self.navigationController pushViewController:productVC animated:YES];
}

-(void)fetchProductData{
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    NSDictionary* getProductDic = @{@"actiontype":@"product_list",
                                    @"user_id":[[[NSUserDefaults standardUserDefaults] valueForKey:@"loginDetails"] valueForKey:@"user_id"]
                                  };
    
    NSLog(@"%@",getProductDic);
    [_dataFetch requestURL:KBaseUrl method:@"POST" dic:getProductDic from:@"fetchProductData" type:@"json"];
    
}

#pragma mark - Process Successful
- (void) processSuccessful :(NSDictionary *)data1 :(NSString *)JsonFor{
    
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    dataDic = [[NSDictionary alloc]init];
    
    NSLog(@"%@",data1);
    
    if ([JsonFor isEqual:@"fetchProductData"]) {
        if ([data1 valueForKey:@"data"] == (id)[NSNull null] || data1 == nil) {
            // tel is null
            NSLog(@"Null value is data");
            //            [self alertset:@"No Data!" :@"Server not responding please try after sometime"];
            
        }else{
            if ([[data1 objectForKey:@"available"] isEqual:@"yes"]) {
                
                dataDic = data1;
                
            }else{
                //            [self alertset:@"ecoPODIUM App" :@"Server not responding please try after sometime"];
            }
            [myProductTable reloadData];
            
        }
    }
    
}

#pragma mark - Process Not Successful

-(void)processNotSucessful:(NSString *)string{
    
}


@end
