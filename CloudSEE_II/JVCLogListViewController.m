//
//  JVCLogListViewController.m
//  CloudSEE_II
//
//  Created by chenzhenyang on 14-11-19.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import "JVCLogListViewController.h"
#import "JVCAccountHelper.h"
#import "JVCLogHelper.h"
#import "JVCLogShowViewController.h"


@interface JVCLogListViewController (){

    NSMutableArray *maLogList;
}

@end

@implementation JVCLogListViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
      self.navigationController.navigationBarHidden  = NO;
    self.title  = NSLocalizedString(@"JVCLog_Title", nil);
    maLogList= [[NSMutableArray alloc] init];
    [maLogList addObject:(NSString *)kAppLogPath];
    [maLogList addObject:(NSString *)kDeviceManagerLogPath];
    [maLogList addObject:(NSString *)kLoginManagerLogPath];
    [maLogList addObject:(NSString *)ACCOUNTSERVICELOG];
}

-(void)dealloc{
    
    [maLogList release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark ---------- tableView dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return maLogList.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    for ( UIView *_tVC in cell.contentView.subviews) {
        [_tVC removeFromSuperview];
    }
    
    cell.textLabel.text = NSLocalizedString([maLogList objectAtIndex:indexPath.row], nil);
   
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    JVCLogShowViewController *logShowViewController = [[JVCLogShowViewController alloc] init];
    logShowViewController.strLogPath                = [maLogList objectAtIndex:indexPath.row];
    logShowViewController.title                     = NSLocalizedString([maLogList objectAtIndex:indexPath.row], nil);
    [self.navigationController pushViewController:logShowViewController animated:YES];
    [logShowViewController release];
}

@end
