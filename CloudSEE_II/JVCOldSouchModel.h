//
//  JVCOldSouchModel.h
//  CloudSEE_II
//
//  Created by Yanghu on 10/28/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JVCOldSouchModel : NSObject
{
	int         idnum;
	int          linkType;
    
	NSString  *channelName;          //yh备注 对应返回数据的   Name字段
	NSString  *channelNumber;       //
	NSString  *userName;              //                    LoginUser
	NSString  *password;                //                  LoginPwd
	NSString  *yunShiTongNum;              //               DeviceNum
	NSString  *ip;
	NSString  *port;
	int groupID;
	int passwordState;             // 1不保存 0表示保存
	int windowIndex;
	
	int byTCP;                      //0:tcp 1是UDP
	int localTry;                   //开启内网探测 1 开启 0  关闭
	BOOL isAuto;                    //云台是否已经开启自动
	NSString *deleteChannle;       //记录被删除的通道
    int LANSerchFlag;
    
    
    //杨虎扩充
    //标示是设备还是组还是通道  0:设备  1：通道  2：分组
    int flage;
    NSString *OID; //自己的id
    NSString *Owner;  //父类
    
    //通道特有的属性
    NSString *DeviceID;
    
    
    NSMutableArray *_imageModelDatas;  //存放设备(或通道)的图片实体集合
    BOOL isLoadImageURL;             //判断设备是否请求过通道图片
    
    //报警的信息
    NSString *badge;
    NSString *sound;
    NSString *time;
    
    int _isYSTState;
    BOOL _isCheckResult;
    
    BOOL isSearchByWifi;   //yes ：wifi 获取的   no：本地添加
    BOOL isGetByWifiNew;  //yes ：wifi 下新获取的  no ：早就存在的
    
    bool isNewAdd;//yes 新添加的  no 不是新添加的
    
    int onLineState;//1 在线   0：不在线
    int hasWifi;//0：没有wifi   1：有WiFi
    BOOL useWifi;//false  没有用WiFi  yes ：使用WiFi
    
    BOOL editByUser; // yes user修改   no：不是
    
}
@property(nonatomic)BOOL editByUser;
@property(nonatomic)int onLineState;
@property(nonatomic)int hasWifi;
@property(nonatomic)BOOL useWifi;
@property(nonatomic)    bool isNewAdd;

@property(nonatomic)BOOL isGetByWifiNew;
@property(nonatomic)BOOL isSearchByWifi;
@property int idnum;
@property int  linkType;
@property int  groupID;
@property(nonatomic,retain)NSString  *channelName;
@property(nonatomic,retain)NSString  *channelNumber;
@property(nonatomic,retain)NSString  *userName;
@property(nonatomic,retain)NSString  *password;
@property(nonatomic,retain)NSString  *yunShiTongNum;
@property(nonatomic,retain)NSString  *ip;
@property(nonatomic,retain)NSString  *port;
@property int  passwordState;
@property int windowIndex;
@property int byTCP;
@property int localTry,LANSerchFlag;
@property BOOL isAuto,isLoadImageURL,_isCheckResult;
@property (nonatomic,retain)NSString *deleteChannle;


//yh添加
@property(nonatomic,retain)    NSString *OID; //自己的id
@property(nonatomic,retain)    NSString *Owner;  //父类
@property(nonatomic,assign)    int flage;
@property(nonatomic,retain)    NSString *DeviceID;
@property(nonatomic,retain)    NSMutableArray *_imageModelDatas;
//报警的
@property(nonatomic,retain)    NSString *badge;

@property(nonatomic,retain)    NSString *sound;
@property(nonatomic,retain)     NSString *time;

@property  int _isYSTState;

@end
