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
#import "JVCDeviceHelper.h"
#import "JVCDeviceMacro.h"
#import "JVCDeviceSourceHelper.h"
#import "JVCChannelModel.h"
#import "JVCChannelScourseHelper.h"
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
    
    self.title = LOCALANGER(@"jvc_demo_title");

    // Do any additional setup after loading the view.
    [self initDemoArrayList];
    
    [self getDemoList];

}

- (void)initDemoArrayList
{
    arrayDemoeList = [[NSMutableArray alloc] init];
}
- (void)getDemoList
{
    [[JVCAlertHelper shareAlertHelper] alertShowToastOnWindow];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
     NSDictionary *tdicDemo = [[JVCDeviceHelper sharedDeviceLibrary] getDemoInfoList];
        
        DDLogVerbose(@"demo = %@",tdicDemo);
        
        dispatch_async(dispatch_get_main_queue(), ^{
        
            [[JVCAlertHelper shareAlertHelper] alertHidenToastOnWindow];

            if (![[JVCSystemUtility shareSystemUtilityInstance] judgeDictionIsNil:tdicDemo]) {
                
                NSArray *arrayDemo  =  [tdicDemo objectForKey:DEVICE_JSON_DLIST];
            
                NSMutableArray *arrayDeviceList = [[JVCDeviceSourceHelper shareDeviceSourceHelper] deviceListArray];

                [arrayDeviceList removeAllObjects];
                
                for (NSDictionary *tdicSingeDevie in arrayDemo) {

                    JVCDeviceModel *model = [[JVCDeviceModel alloc] init];
                    model.yunShiTongNum = [tdicSingeDevie objectForKey:DEVICE_JSON_DGUID];
                    model.userName = [tdicSingeDevie objectForKey:JK_DEVICE_Demo_USERNAME];
                    model.passWord = [tdicSingeDevie objectForKey:JK_DEVICE_Demo_PASSWORD];
                    [arrayDeviceList addObject:model];
                    [model release];
                    
                    int channelNum = [[tdicSingeDevie objectForKey:JK_DEVICE_Demo_CHANNEL_SUM] intValue];
                    if (channelNum>0) {
                        NSMutableArray *arrayChannel = [[JVCChannelScourseHelper shareChannelScourseHelper] ChannelListArray];
                        for (int i=0; i<channelNum; i++) {
                            NSString *nickName = [NSString stringWithFormat:@"%@_%d",model.yunShiTongNum,i];
                            
                            JVCChannelModel *modelChannel = [[JVCChannelModel alloc] initChannelWithystNum:model.yunShiTongNum nickName:nickName channelNum:i idNum:i];
                            [arrayChannel addObject:modelChannel];
                            [modelChannel release];
                        }
                    }
                }
                
                [self.tableView reloadData];

            }else{
            
                [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:LOCALANGER(@"jvc_demo_GetDate_error")];
            }
            
        });
    });
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
    return [[JVCDeviceSourceHelper shareDeviceSourceHelper] deviceListArray].count;
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
    JVCDeviceModel *modelCell = [[[JVCDeviceSourceHelper shareDeviceSourceHelper] deviceListArray] objectAtIndex:indexPath.row];
    [cell initCellWithModel:modelCell];
    NSString *imageName= nil;
    switch (indexPath.row%3) {
        case 0:
            imageName = @"dem_def0.png";
            break;
        case 1:
            imageName = @"dem_def0.png";
            break;
        case 2:
            imageName = @"dem_def0.png";
            break;
        default:
            break;
            
        NSString *imagePath = [UIImage imageBundlePath:@"imageName"];
        UIImage *image = [[UIImage alloc] initWithContentsOfFile:imagePath];
        cell.imageView.image = image;
        [image release];
    }
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
