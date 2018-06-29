//
//  CurrentOrderTableViewCell.h
//  cityRun
//
//  Created by Basir Alam on 04/04/17.
//  Copyright © 2017 Basir. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CurrentOrderTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *btnWidthLayout;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *btnHeightLayout;
@property (strong, nonatomic) IBOutlet UILabel *lblSellerName;
@property (strong, nonatomic) IBOutlet UILabel *lblStatus;
@property (strong, nonatomic) IBOutlet UILabel *lblPrice;
@property (strong, nonatomic) IBOutlet UIButton *btnGetInvoice;
@property (strong, nonatomic) IBOutlet UILabel *lblAddress;
@property (strong, nonatomic) IBOutlet UILabel *lblZIP;
@property (strong, nonatomic) IBOutlet UILabel *lblDetailedPrice;


//DetailedMyOrder
@property (strong, nonatomic) IBOutlet UIImageView *imgProduct;
@property (strong, nonatomic) IBOutlet UILabel *lblProductName;
@property (strong, nonatomic) IBOutlet UILabel *lblCategory;
@property (strong, nonatomic) IBOutlet UILabel *lblQuantity;



@end
