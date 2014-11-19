//
//  JVCMediaManagerViewController.m
//  CloudSEE_II
//
//  Created by Yanghu on 11/13/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCMediaManagerViewController.h"
#import "JVCPhotoViewController.h"
#import "JVCMediaMacro.h"
#import "JVCRGBColorMacro.h"
#import "JVCRGBHelper.h"
@interface JVCMediaManagerViewController ()
{
    NSMutableArray *_mArrayList;
    
    NSInteger iType;//标识是图片还是视频 another 的标识

}

@end

@implementation JVCMediaManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title= LOCALANGER(@"jvc_more_media_title");
    _mArrayList  = [[NSMutableArray alloc] init];
    [_mArrayList addObject:LOCALANGER(@"home_photos")];
    [_mArrayList addObject:LOCALANGER(@"home_videos")];
  //  [_mArrayList addObject:LOCALANGER(@"home_anothers")];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_mArrayList release];
    [super dealloc];
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
    return _mArrayList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    for (id contentView in cell.contentView.subviews ) {
        [contentView removeFromSuperview];
    }
    
    cell.backgroundColor = [UIColor clearColor];

    
    UIImage *ibgHeader = [UIImage imageNamed:[NSString stringWithFormat:@"mor_pm%d",indexPath.row+1]];
    UIImageView *imageViewHeader = [[UIImageView alloc] initWithFrame:CGRectMake(20,(cell.height -ibgHeader.size.height )/2.0, ibgHeader.size.width, ibgHeader.size.height)];
    imageViewHeader.image = ibgHeader;
    [cell.contentView addSubview:imageViewHeader];
    [imageViewHeader release];
    
    /**
     *  获取颜色值处理
     */
    JVCRGBHelper *rgbLabelHelper      = [JVCRGBHelper shareJVCRGBHelper];
    UIColor *labColor  = [rgbLabelHelper rgbColorForKey:kJVCRGBColorMacroLoginGray];
    
    UILabel *_lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(imageViewHeader.frame.origin.x+imageViewHeader.frame.size.width+10,imageViewHeader.top, cell.width, ibgHeader.size.height)];
    _lblTitle.backgroundColor = [UIColor clearColor];
    if (labColor) {
        _lblTitle.textColor = labColor;

    }
    _lblTitle.text = [_mArrayList objectAtIndex:indexPath.row];
    [cell.contentView addSubview:_lblTitle];
    [_lblTitle release];

    
    //横线
    UIImage *imgLine = [UIImage imageNamed:@"mor_line.png"];
    UIImageView *HeadlineImageView = [[UIImageView alloc] initWithFrame:CGRectMake((cell.width- imgLine.size.width)/2.0, cell.height - imgLine.size.height, imgLine.size.width, imgLine.size.height)];
    HeadlineImageView.image = imgLine;
    [cell.contentView addSubview:HeadlineImageView];
    [HeadlineImageView release];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    iType = indexPath.row;
    [self clickToShowPhoto:indexPath.row];
    
}

-(void)alAssetsDatecallBack:(NSMutableArray *)photoDatas;
{
    
    if (!photoDatas) {
        [[JVCAlertHelper shareAlertHelper] alertHidenToastOnWindow];
     
        [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:LOCALANGER(@"home_get_alum_error")];
        return;
    }
//    if (photoDatas.count == 0) {
//        
//        [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:LOCALANGER(@"jvc_more_media_no_date")];
//        return;
//
//    }
    [self performSelectorOnMainThread:@selector(gotoPhotoData:) withObject:photoDatas waitUntilDone:NO];
    
}

-(void)gotoPhotoData:(NSMutableArray *)photoDatas{
    
    [[JVCAlertHelper shareAlertHelper] alertHidenToastOnWindow];
    
    JVCPhotoViewController *photoViewCon = [[JVCPhotoViewController alloc] initWithDatasource:photoDatas];
    //[self presentViewController:photoViewCon animated:YES completion:nil];
    photoViewCon.hidesBottomBarWhenPushed = YES;
    photoViewCon.typeTitle = iType;
    switch (iType) {
            
        case TYPE_PHOTO:
            photoViewCon.title = LOCALANGER(@"home_photos");
            break;
        case TYPE_VIDEO:
            photoViewCon.title =LOCALANGER(@"home_videos");
            break;
        default:
            photoViewCon.title = LOCALANGER(@"home_anothers");
            break;
    }
    [self.navigationController pushViewController:photoViewCon animated:YES];
    
    [photoViewCon release];
    
    
}

-(void)clickToShowPhoto:(NSInteger )typeIntge{
    
    JVCConstansALAssetsMathHelper *ALER=[[[JVCConstansALAssetsMathHelper alloc] init] autorelease];
    ALER.AseeetDelegate=self;
    switch (typeIntge) {
        case 0:
            [ALER returnAblumGroupNameArrayDatas:(NSString *)kKYCustomPhotoAlbumName mathType:MATH_TYPE_PHOTO];
            break;
        case 1:
            [ALER returnAblumGroupNameArrayDatas:(NSString *)kKYCustomVideoAlbumName mathType:MATH_TYPE_VIDEO];
            break;
        default:
            [ALER returnAblumGroupNameArrayDatas:(NSString *)kKShare_Photo mathType:MATH_TYPE_PHOTO];
            break;
    }
    //    [ALER returnAblumGroupNameArrayDatas:kKYCustomPhotoAlbumName];
    
    [[JVCAlertHelper shareAlertHelper ]alertShowToastOnWindow];
    
}


@end
