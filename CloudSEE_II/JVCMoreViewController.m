//
//  JVCMoreViewController.m
//  JVCEditDevice
//  更多界面
//  Created by chenzhenyang on 14-9-24.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import "JVCMoreViewController.h"
#import "JVCMoreUserCell.h"

static const int CELLHEIGHT_USERHEADER = 120;//账号名称以及头像的cell高度
static const int CELLHEIGHT_CONTENTH = 44;   //里面内容的cell高度

@interface JVCMoreViewController ()
{
    UITableView *_tableView;
}

@end

@implementation JVCMoreViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        UITabBarItem *moreItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"更多", nil) image:nil tag:1];
        [moreItem setFinishedSelectedImage:[UIImage imageNamed:@"tab_more_select.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"tab_more_unselect.png"]];
        self.tabBarItem = moreItem;
        [moreItem release];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = [UIColor whiteColor];
     //初始化tableview
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    
}

#pragma mark  tableview 的代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        return CELLHEIGHT_USERHEADER;
        
    }
    return CELLHEIGHT_CONTENTH;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        
        return 1;
        
    }

    return 3;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {//用户信息
        
        static NSString *cellIndentify = @"cellUserIndentifiy";
        
        JVCMoreUserCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentify];
        
        if (cell == nil) {
            
            cell = [[[JVCMoreUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentify] autorelease];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        
        [cell initMoreCellContentView];
        
        return cell;
        
    }else {
        
        static NSString *cellIndentify = @"cellIndentifiy";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentify];
        
        if (cell == nil) {
            
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentify] autorelease];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        
        cell.imageView.image = [UIImage imageNamed:@"mor_head_0.png"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        cell.textLabel.text = @"1";
        
        return cell;
    }
    
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_tableView release];
    _tableView = nil;
    
    [super dealloc];
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

@end
