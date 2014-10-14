//
//  JVCDemoViewController.m
//  CloudSEE_II
//
//  Created by Yanghu on 10/14/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCDemoViewController.h"
#import "JVCDemoCell.h"
#import "JVCDeviceModel.h"
@interface JVCDemoViewController ()
{
    NSMutableArray *arrayDemoeList;
}

@end

@implementation JVCDemoViewController
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    
    if (self) {
    
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"演示点";

    // Do any additional setup after loading the view.
    [self initDemoArrayList];
    
    for (int i = 0;i<3;i++) {
        
        JVCDeviceModel *model = [[JVCDeviceModel alloc] init];
        model.yunShiTongNum = @"A361";
        model.userName = @"abc";
        model.passWord = @"123";
        model.nickName = @"测试";

        [arrayDemoeList addObject:model];
        [model release];
    }
    [self.tableView reloadData];
}

- (void)initDemoArrayList
{
    arrayDemoeList = [[NSMutableArray alloc] init];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return arrayDemoeList.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return KCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentify = @"cellIndentify";
    
    JVCDemoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentify];
    
    if (cell ==nil) {
        
        cell = [[[JVCDemoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentify] autorelease];
    }
    JVCDeviceModel *modelCell = [arrayDemoeList objectAtIndex:indexPath.row];
    [cell initCellWithModel:modelCell];
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dealloc
{
    [arrayDemoeList release];
    
    [super dealloc];
}

@end
