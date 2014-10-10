//
//  JVCDropDownView.h
//  CloudSEE_II
//
//  Created by Yanghu on 10/10/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {

    deleteType_SelectUser   = 0, //删除正在选中
    deleteType_DeleteAll    = 1, //全部删除


}DeleteType;
@class JVCUserInfoModel;
@protocol DropDownViewDelegate <NSObject>

/**
 *  删除到没有账号了，用通知试图把弹出的试图收起来
 */
- (void)deleteLastAccountCallBack:(int)type;

/**
 *  选中账号
 *
 *  @param index 选中账号的索引
 */
- (void)didSelectAccountWithIndex:(JVCUserInfoModel *)model;

@end

@interface JVCDropDownView : UIView<UITableViewDelegate,UITableViewDataSource>
{
    id<DropDownViewDelegate>dropDownDelegate;
}
@property(nonatomic,assign)id<DropDownViewDelegate>dropDownDelegate;
/**
 *  显示按下的frmae
 *
 *  @param frame <#frame description#>
 */
- (void)showDropDownViewWithFrame:(CGRect)frame  selectUserName:(NSString *)selectUser;

/**
 *  隐藏DropView
 */
- (void)hidenDropDownView;

@end
