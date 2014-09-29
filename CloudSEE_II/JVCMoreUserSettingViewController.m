//
//  JVCMoreUserSettingViewController.m
//  CloudSEE_II
//
//  Created by Yanghu on 9/29/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCMoreUserSettingViewController.h"
#import "JVCMoreSettingHelper.h"
#import "JVCMoreUserSettingModel.h"

static const int kUSerSettingCellDefaultHeight  = 60;//系统的默认高度
static const int kUSerSettingCellFootViewHeigint = 20;//footview的高度

@interface JVCMoreUserSettingViewController ()
{
    NSMutableArray *arrayContent;//显示cell的数组
}

@end

@implementation JVCMoreUserSettingViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor grayColor];
    
    [self initarrayContent];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    [self.tableView reloadData];
    
    
}

/**
 *  初始化arrayContent显示内容
 */
- (void)initarrayContent
{
    arrayContent = [[NSMutableArray alloc] initWithCapacity:10];
    
    [arrayContent addObjectsFromArray:[[JVCMoreSettingHelper shareDataBaseHelper]getMoreUserSettingList]];

}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
   
    return arrayContent.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
     return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kUSerSettingCellDefaultHeight;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndetify = @"cellIndent";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetify];
    
    UIImage *imageBG = [UIImage imageNamed:@"mor_cellSigleBg.png"];

    if (cell ==nil) {
        
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndetify] autorelease];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.backgroundView = nil;
        
        cell.backgroundColor = [UIColor clearColor];

    }
    
    for (UIView *contentView in cell.contentView.subviews) {
        
        [contentView removeFromSuperview];
    }
    
    JVCMoreUserSettingModel *modelCell = [arrayContent objectAtIndex:indexPath.section];

    //背景
    UIImageView *imageViewBg = [[UIImageView alloc] initWithFrame:CGRectMake((cell.width -imageBG.size.width)/2.0 , (kUSerSettingCellDefaultHeight -imageBG.size.height)/2.0 , imageBG.size.width,  imageBG.size.height)];
    imageViewBg.image = imageBG;
    [cell addSubview:imageViewBg];
    [cell sendSubviewToBack:imageViewBg];
    [imageViewBg release];
    
    CGRect frame = imageViewBg.frame;
    frame.origin.x =imageViewBg.left+10;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:frame];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text =modelCell.titleString;
    [cell.contentView addSubview:titleLabel];
    [titleLabel release];
    
    switch (modelCell.typeFlag) {
      
        case TYPEFLAG_Indicator:
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        case TYPEFLAG_SWitch:
        {
            UISwitch *switchCell = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
            switchCell.center = CGPointMake(imageBG.size.width - switchCell.width, titleLabel.center.y);
            [switchCell addTarget:self action:@selector(editUsersetting:) forControlEvents:UIControlEventValueChanged];
            switchCell.tag = indexPath.section;
            [cell.contentView addSubview:switchCell];
            [switchCell release];
        }
            break;
        default:
            break;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return kUSerSettingCellFootViewHeigint;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *viewFoot = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, kUSerSettingCellFootViewHeigint)];
    viewFoot.backgroundColor = [UIColor clearColor];
    return  [viewFoot autorelease];
}


#pragma mark  switch的事件

- (void)editUsersetting:(UISwitch *)switchUser
{
    switch (switchUser.tag) {
        case 0://自动登录的
            
            break;
            
        default:
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {//修改密码
        

    }
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
