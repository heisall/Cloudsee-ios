//
//  JVCOperaitonDeviceListTableViewViewController.m
//  CloudSEE_II
//
//  Created by David on 14/12/10.
//  Copyright (c) 2014年 David. All rights reserved.
//

#import "JVCOperaitonDeviceListTableViewViewController.h"
#import "JVCCloudSEENetworkMacro.h"
#import "UIImage+BundlePath.h"
@interface JVCOperaitonDeviceListTableViewViewController ()
{
    NSMutableArray *arrayDicKey;
}

@end

@implementation JVCOperaitonDeviceListTableViewViewController
@synthesize dicDeviceContent;

static NSString const *kDeviceAlarmSafe                           =  @"deviceSafe";           //安全防护

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initArrayKey];
    
}

- (void)dealloc
{
    [dicDeviceContent release];
    [arrayDicKey release];
    [super dealloc];
}

//初始化key值
- (void)initArrayKey
{
    arrayDicKey = [[NSMutableArray alloc] initWithCapacity:10];
    [arrayDicKey addObject:(NSString *)kDeviceAlarmSafe];
    [arrayDicKey addObject:(NSString *)kDevicePNMode];
    [arrayDicKey addObject:(NSString *)kDeviceFlashMode];
    [arrayDicKey addObject:(NSString *)kDeviceTimezone];
    
    NSMutableArray *arrayContent = [[NSMutableArray alloc] initWithCapacity:10];
    for (NSString *key in arrayDicKey) {
        NSString *keyValue = [self.dicDeviceContent objectForKey:key];
        if (keyValue.length<=0) {
            
            [arrayContent addObject:keyValue];
        }
    }
    [arrayDicKey removeObjectsInArray:arrayContent];
    [arrayContent release];
    
    
}

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return arrayDicKey.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentify = @"cellIndentify";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIndentify];
    if (cell == nil) {
        
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIndentify] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    UIImage *iconImage      = [[UIImage alloc] initWithContentsOfFile:[UIImage imageBundlePath:[arrayDicKey objectAtIndex:indexPath.section]]];
    cell.imageView.image    = iconImage;
    [iconImage              release];
    
     
    
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
