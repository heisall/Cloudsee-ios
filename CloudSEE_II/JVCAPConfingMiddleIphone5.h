//
//  JVCAPConfingMiddleIphone5.h
//  project_NewApMiddle
//
//  Created by Yanghu on 10/20/14.
//  Copyright (c) 2014 Jovision. All rights reserved.
//

#import <UIKit/UIKit.h>

enum OPERATIONBTNCLICKTYPEPLAY
{
    OPERATIONAPBTNCLICKTYPE_AUDIO         =   0,//音频对讲
    OPERATIONAPBTNCLICKTYPE_YTOPERATION   =   1,//云台
    OPERATIONAPBTNCLICKTYPE_Talk          =   2,//对讲
};

@protocol JVCAPConfingMiddleIphone5Delegate <NSObject>

/**
 *  选中中间按钮的回调
 *
 *  @param clickBtnType btn的索引
 */
-  (void)operationMiddleIphone5APBtnCallBack:(int)clickBtnType;

@end

@interface JVCAPConfingMiddleIphone5 : UIView
{
    id<JVCAPConfingMiddleIphone5Delegate>delegateIphone5BtnCallBack;
}
@property(nonatomic,assign)id<JVCAPConfingMiddleIphone5Delegate>delegateIphone5BtnCallBack;



/**
 *  这个方法之前，一定要设置view的frame
 *  显示音频监听、云台、远程回放view
 *
 *  @param titleArray  主title
 *  @param detailArray 副title
 */
- (void)updateViewWithTitleArray:(NSArray *)titleArray detailArray:(NSArray *)detailArray;

/**
 *  设置btn为选中状态
 *
 *  @param selectIndex 索引
 */
- (void)setBtnSelect:(int)selectIndex;

/**
 *  设置btn为非选中状态
 *
 *  @param selectIndex 索引
 */
- (void)setBtnUnSelect:(int)selectIndex;

/**
 *  获取btn的选中状态
 *
 *  @param selectIndex 索引
 */
- (BOOL)getBtnSelectState:(int)selectIndex;

/**
 *  设置btn全为非选中状态
 */
- (void)setAllBtnUnSelect;

/**
 *  获取相应的view
 *
 *  @param selectIndex 索引
 *
 *  @return 相应的veiw
 */
- (UIView *)getSelectbgView:(int)selectIndex;
@end
