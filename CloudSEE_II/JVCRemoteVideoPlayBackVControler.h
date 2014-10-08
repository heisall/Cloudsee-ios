//
//  JVCRemoteVideoPlayBackVControler.h
//  CloudSEE_II
//
//  Created by Yanghu on 9/30/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCBaseWithGeneralViewController.h"
#import "JVCOperationController.h"

@interface JVCRemoteVideoPlayBackVControler : JVCBaseWithGeneralViewController<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate>{
@private UITableView *myTable;//表格对象
    BOOL  isFirstAddSheet ;// sheet是否第一次加载
    UILabel *selectTimeLabel;//日期
    NSMutableArray *nultArray ;
    JVCOperationController *_operationController;
    int _is_iSelectedRow;
    NSMutableString *_dateString;
    BOOL _isSendState;
    
    
}
@property(nonatomic,retain)NSMutableString *_dateString;
@property (nonatomic,retain) IBOutlet UITableView *myTable;
@property(nonatomic,retain)NSMutableArray *nultArray;
@property (nonatomic,retain) UIButton *_btnSearch;
@property (nonatomic ,retain) UILabel *selectTimeLabel;
@property int _is_iSelectedRow;
@property BOOL _isSendState;
@property(nonatomic,assign) JVCOperationController *_operationController;

-(void)gotoBack;



@end
