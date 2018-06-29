//
//  ProductListTableViewCell.h
//  cityRun
//
//  Created by Basir Alam on 22/03/17.
//  Copyright © 2017 Basir. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductListTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *productImageWidthLC;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellTrailingLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellLeadingLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellBottomLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellTopLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnViewDetailsHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnViewDetailsWidth;

// Declair property of labels
@property (strong, nonatomic) IBOutlet UILabel *lblStoreName;
@property (strong, nonatomic) IBOutlet UILabel *lblStoreDistance;
@property (strong, nonatomic) IBOutlet UIImageView *imgStoreRating;
@property (strong, nonatomic) IBOutlet UILabel *lblStartingFrom;
@property (strong, nonatomic) IBOutlet UIButton *btnViewDetails;


@end
