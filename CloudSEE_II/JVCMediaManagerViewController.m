//
//  JVCMediaManagerViewController.m
//  CloudSEE_II
//
//  Created by Yanghu on 11/13/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCMediaManagerViewController.h"

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
    
    self.title= LOCALANGER(@"home_picture_browse");
    _mArrayList  = [[NSMutableArray alloc] init];
    [_mArrayList addObject:LOCALANGER(@"home_photos")];
    [_mArrayList addObject:LOCALANGER(@"home_videos")];
    [_mArrayList addObject:LOCALANGER(@"home_anothers")];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
//    self.tableView.backgroundView =nil;
//    self.tableView.backgroundColor =[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];

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
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return _mArrayList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIImage *imageCellBg = [UIImage imageNamed:@"moreOneCellBg.png"];
    return imageCellBg.size.height+20;
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
    /**
     *  背景
     */
    // Configure the cell...
    UIImage *imageCellBg = [UIImage imageNamed:@"moreOneCellBg.png"];
    
    UIImageView *imageViewBg = [[UIImageView alloc] initWithFrame:CGRectMake((cell.frame.size.width-imageCellBg.size.width)/2.0,10, imageCellBg.size.width,  imageCellBg.size.height)];
    imageViewBg.image = imageCellBg;
    imageViewBg.tag = 200;
    [cell.contentView addSubview:imageViewBg];
    [imageViewBg release];
    
    UIImage *ibgHeader = [UIImage imageNamed:[NSString stringWithFormat:@"photoManager%d",indexPath.row+1]];
    UIImageView *imageViewHeader = [[UIImageView alloc] initWithFrame:CGRectMake(20,10+ (imageViewBg.frame.size.height-ibgHeader.size.height)/2.0, ibgHeader.size.width, ibgHeader.size.height)];
    imageViewHeader.image = ibgHeader;
    [cell.contentView addSubview:imageViewHeader];
    [imageViewHeader release];
    
    UILabel *_lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(imageViewHeader.frame.origin.x+imageViewHeader.frame.size.width+10,10+(imageViewBg.frame.size.height-25)/2.0, 100, 25)];
    _lblTitle.backgroundColor = [UIColor clearColor];
    _lblTitle.text = [_mArrayList objectAtIndex:indexPath.row];
    [cell.contentView addSubview:_lblTitle];
    [_lblTitle release];
    
    //箭头标识
    UIImage *nextImage = [UIImage imageNamed:@"myVideo_next.png"];
    UIImageView *nextImageView = [[UIImageView alloc] initWithFrame:CGRectMake(285, _lblTitle.frame.origin.y+(25-nextImage.size.height)/2.0, nextImage.size.width, nextImage.size.height)];
    nextImageView.image = nextImage;
    [cell.contentView addSubview:nextImageView];
    [nextImageView release];
    
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    iType = indexPath.row;
    [self clickToShowPhoto:indexPath.row];
    
}

-(void)callBack:(NSMutableArray *)photoDatas{
    
    if (!photoDatas) {
        [[JVCAlertHelper shareAlertHelper] alertShowToastOnWindow];
     
        [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:LOCALANGER(@"home_get_alum_error")];
        return;
    }
    [self performSelectorOnMainThread:@selector(gotoPhotoData:) withObject:photoDatas waitUntilDone:NO];
    
}

-(void)gotoPhotoData:(NSMutableArray *)photoDatas{
    
    [[JVCAlertHelper shareAlertHelper] alertShowToastOnWindow];
    //    MBProgressHUD *huB = (MBProgressHUD *) [self.view viewWithTag:10000];
    //    huB.hidden = YES;
    //    [huB removeFromSuperview];
    
    photoViewController *photoViewCon = [[photoViewController alloc] initWithDatasource:photoDatas];
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
    
    ConstansALAssetsMath *ALER=[[[ConstansALAssetsMath alloc] init] autorelease];
    ALER.parent=self;
    ALER.callBackMath=@selector(callBack:);
    
    switch (typeIntge) {
        case 0:
            [ALER returnAblumGroupNameArrayDatas:kKYCustomPhotoAlbumName mathType:MATH_TYPE_PHOTO];
            break;
        case 1:
            [ALER returnAblumGroupNameArrayDatas:kKYCustomVideoAlbumName mathType:MATH_TYPE_VIDEO];
            break;
        default:
            [ALER returnAblumGroupNameArrayDatas:kKShare_Photo mathType:MATH_TYPE_PHOTO];
            break;
    }
    //    [ALER returnAblumGroupNameArrayDatas:kKYCustomPhotoAlbumName];
    
    [OperationSet showMBprogress];
    
}


@end
