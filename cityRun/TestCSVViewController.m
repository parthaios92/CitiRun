//
//  TestCSVViewController.m
//  cityRun
//
//  Created by Basir Alam on 07/04/17.
//  Copyright © 2017 Basir. All rights reserved.
//

#import "TestCSVViewController.h"
#import "TestCSVCellTableViewCell.h"
@interface TestCSVViewController ()

@end

@implementation TestCSVViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSMutableArray *colA = [NSMutableArray array];
    NSMutableArray *colB = [NSMutableArray array];
    NSMutableArray *colC = [NSMutableArray array];
    NSMutableArray *colD = [NSMutableArray array];

    
    NSString *fileContents = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"pujaLocation" ofType:@"csv"] encoding:NSUTF8StringEncoding error:nil ];
    
    NSArray *rows = [fileContents componentsSeparatedByString:@";"];
    NSLog(@"%@",rows);
    for (NSString *row in rows){
        NSArray* columns = [row componentsSeparatedByString:@","];
        NSLog(@"%@",columns);
        [colA addObject:columns[0]];
        [colB addObject:columns[1]];
//        [colC addObject:columns[2]];
//        [colD addObject:columns[3]];
    }
    NSLog(@"%@",colA);
    NSLog(@"%@",colB);
    NSLog(@"%@",colC);
//    NSLog(@"%@",colD);

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
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TestCSVCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TestCSVCellTableViewCell" forIndexPath:indexPath];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

@end
