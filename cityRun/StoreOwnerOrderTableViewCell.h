//
//  StoreOwnerOrderTableViewCell.h
//  cityRun
//
//  Created by Basir Alam on 05/04/17.
//  Copyright © 2017 Basir. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoreOwnerOrderTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *imgWidthLayout;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *btnMoveHeightLayout;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *btnMoveWidthLayout;


@property (strong, nonatomic) IBOutlet UIButton *btnMoveToCompleted;
@property (strong, nonatomic) IBOutlet UIButton *btnDeliveryNote;
@property (strong, nonatomic) IBOutlet UIButton *btnOrderNote;


@property (strong, nonatomic) IBOutlet UILabel *lblBuyerName;
@property (strong, nonatomic) IBOutlet UILabel *lblAddress;
@property (strong, nonatomic) IBOutlet UILabel *lblZip;
@property (strong, nonatomic) IBOutlet UILabel *lblTotalPrice;


@property (strong, nonatomic) IBOutlet UIImageView *imgProduct;
@property (strong, nonatomic) IBOutlet UILabel *lblProductName;
@property (strong, nonatomic) IBOutlet UILabel *lblCategory;
@property (strong, nonatomic) IBOutlet UILabel *lblQty;
@property (strong, nonatomic) IBOutlet UILabel *lblPrice;

@end
