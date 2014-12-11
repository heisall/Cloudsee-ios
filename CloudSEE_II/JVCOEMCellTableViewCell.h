//
//  JVCOEMCellTableViewCell.h
//  CloudSEE_II
//
//  Created by David on 14/12/11.
//  Copyright (c) 2014年 David. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCRoundSwitch.h"

@protocol JVCOEMCELLDelegate <NSObject>

//选中的事件，开关的
- (void)JVCOEMCELLClickCallBack:(int)indexType idObject:(id)object;

@end



@interface JVCOEMCellTableViewCell : UITableViewCell
{
    UILabel         *labelContent;
    DCRoundSwitch   *switchRound;
    NSArray         *contentArray;
    NSMutableDictionary *dicDevice;
    NSString        *stringCellIndetidy;
    id<JVCOEMCELLDelegate>delegateOEM;
}
@property(nonatomic,retain) UILabel     *labelContent;
@property(nonatomic,retain) DCRoundSwitch *switchRound;
@property(nonatomic,retain) NSArray         *contentArray;
@property(nonatomic,assign) id<JVCOEMCELLDelegate>delegateOEM;
@property(nonatomic,retain) NSMutableDictionary *dicDevice;
@property(nonatomic,retain) NSString        *stringCellIndetidy;

//初始化cell
- (void)initContentView;
@end
