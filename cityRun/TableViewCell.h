//
//  TableViewCell.h
//  citiRun
//
//  Created by Abhishek Mitra on 12/06/18.
//  Copyright © 2018 Basir. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIView *cellView;
@property (strong, nonatomic) IBOutlet UIImageView *storeImage;

@property (strong, nonatomic) IBOutlet UILabel *lblStoreName;

@property (strong, nonatomic) IBOutlet UILabel *lblStoreAddress;

@end
