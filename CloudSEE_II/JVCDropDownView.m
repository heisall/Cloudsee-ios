//
//  JVCDropDownView.m
//  CloudSEE_II
//
//  Created by Yanghu on 10/10/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCDropDownView.h"
#import "JVCUserInfoModel.h"
#import "JVCDataBaseHelper.h"
#import "JVCRGBHelper.h"
@interface JVCDropDownView()
{
    UITableView *_tableView;
    
    NSMutableArray *_arrayAccountList;
    
    NSString *selctuserName;
}
@end
@implementation JVCDropDownView
@synthesize dropDownDelegate;
static const int KOrigin_X  = 1;//距离左边的距离10
static const int KLabelWith = 200;//label的宽度
static const int KSeperate  = 10;//间距5



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.clipsToBounds = YES;
        
        _arrayAccountList = [[NSMutableArray alloc] initWithCapacity:10];
        
        
    }
    return self;
}

/**
 *  显示按下的frmae
 *
 *  @param frame 索引
 */
- (void)showDropDownViewWithFrame:(CGRect)frame  selectUserName:(NSString *)selectUser
{
    if (selectUser) {
        
        [selctuserName release];
    }
    selctuserName = [selectUser retain];
    [_arrayAccountList removeAllObjects];
    
    NSArray *arrayUser = [[JVCDataBaseHelper shareDataBaseHelper] getAllUsers];
    [_arrayAccountList addObjectsFromArray:arrayUser];
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self addSubview:_tableView];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView release];
        
    }else{
        
        [_tableView reloadData];
    }
    
    self.frame = frame;
    
}

/**
 *  隐藏DropView
 */
- (void)hidenDropDownView
{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 0);
}

#pragma mark tableview 的委托方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrayAccountList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndetify = @"cellIndentify";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetify];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndetify] autorelease];
    }
    
    /**
     *  清除cell上面的内容
     */
    for (UIView *viewContent  in cell.contentView.subviews) {
        
        [viewContent removeFromSuperview];
    }
    
    JVCUserInfoModel *useModel = [_arrayAccountList objectAtIndex:indexPath.row];
    
    /**
     *  选中的标识
     */
    UIImage *imgCellS = [UIImage imageNamed:@"log_select.png"];
    UIImageView *imageViewCell = [[UIImageView alloc] initWithFrame:CGRectMake(KOrigin_X, (cell.frame.size.height-imgCellS.size.height)/2.0, imgCellS.size.width, imgCellS.size.height)];
    [cell.contentView addSubview:imageViewCell];
    [imageViewCell release];
    imageViewCell.hidden = YES;
    
    JVCRGBHelper *rgbLabelHelper      = [JVCRGBHelper shareJVCRGBHelper];
    UIColor *btnColorGray  = [rgbLabelHelper rgbColorForKey:kJVCRGBColorMacroLoginGray];
    UIColor *btnColorBlue  = [rgbLabelHelper rgbColorForKey:kJVCRGBColorMacroLoginBlue];
    
    //用户名
    UILabel *lblName = [[UILabel alloc] initWithFrame:CGRectMake(imageViewCell.frame.origin.x+imageViewCell.frame.size.width+KSeperate, imageViewCell.frame.origin.y, KLabelWith, imageViewCell.frame.size.height)];
    [cell.contentView addSubview:lblName];
    lblName.text = useModel.userName;
    [lblName release];

    
    if ([useModel.userName isEqualToString:selctuserName]) {
        
        imageViewCell.image = imgCellS;
        lblName.textColor = btnColorBlue;
    }else{
        
        lblName.textColor = btnColorGray;
    }

    
    
    return cell;
}

#pragma mark 点击时间
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{   
    if (dropDownDelegate !=nil && [dropDownDelegate respondsToSelector:@selector(didSelectAccountWithIndex:)]) {
        
        JVCUserInfoModel *model = [_arrayAccountList objectAtIndex:indexPath.row];
        
        [dropDownDelegate didSelectAccountWithIndex:model];
    }
}

#pragma mark 删除操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    JVCUserInfoModel *model = [_arrayAccountList objectAtIndex:indexPath.row];
    
    [model retain];
    
    //删除账号
    [[JVCDataBaseHelper shareDataBaseHelper] deleteUserInfoWithUserName:model.userName];

    [_arrayAccountList removeObjectAtIndex:indexPath.row];
    
    [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationBottom];
    
    if (_arrayAccountList.count == 0) {//没有数据了，告诉夫视图收起
        
        if (dropDownDelegate !=nil && [dropDownDelegate respondsToSelector:@selector(deleteLastAccountCallBack:)]) {
            
            [dropDownDelegate deleteLastAccountCallBack: deleteType_DeleteAll];
        }
        
    }else if([model.userName isEqualToString:selctuserName])//删除选中的
    {
        if (dropDownDelegate !=nil && [dropDownDelegate respondsToSelector:@selector(deleteLastAccountCallBack:)]) {
            
            [dropDownDelegate deleteLastAccountCallBack:deleteType_SelectUser];
        }
    }
    
    [model release];

}

- (void)dealloc
{
    [selctuserName release];
    
    [_arrayAccountList release];
    
    [_tableView release];
    
    [super dealloc];
}

@end
