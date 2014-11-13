//
//  JVCPhotoViewController.m
//  CloudSEE_II
//
//  Created by Yanghu on 11/13/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCPhotoViewController.h"
#define headView_height 36
@interface JVCPhotoViewController ()

@end

@implementation JVCPhotoViewController
@synthesize mArrayPhotoDatas,mArrayGroupDatas;

@synthesize  typeTitle;


- (id)initWithDatasource:(NSMutableArray *)datasource
{
    self = [self initWithStyle:UITableViewStylePlain];
    
    if (self) {
        
        self.mArrayPhotoDatas = datasource;
        [self getTableViewSourceData];
    }
    return self;
}

-(void)dealloc{
    
    
    [mArrayGroupDatas release];
    [mArrayPhotoDatas release];
    [super dealloc];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSMutableArray *groupDatas = [[NSMutableArray alloc] init];
    self.mArrayGroupDatas=groupDatas;
    [groupDatas release];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

-(void)getTableViewSourceData{
    
    
    [mArrayGroupDatas removeAllObjects];
    
    for (NSObject *object in self.mArrayPhotoDatas) {
        
        photoModelObj *photo = (photoModelObj *)object;
        
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit |
                                        NSMonthCalendarUnit | NSYearCalendarUnit fromDate:photo.dateCreateImageDate];
        
        NSUInteger month = [components month];
        NSUInteger year = [components year];
        NSUInteger day = [components day];
        
        photoGroupObj *group = ^photoGroupObj *{
            
            for (photoGroupObj *group in mArrayGroupDatas) {
                
                if (group.month == month && group.year == year&&group.day==day)
                    
                    return group;
            }
            return nil;
        }();
        
        if (group == nil) {
            
            group = [[photoGroupObj alloc] init];
            group.month = month;
            group.year = year;
            group.day=day;
            
            [group.mArrayPhotos addObject:photo];
            
            [mArrayGroupDatas addObject:group];
            
            [group release];
            
        } else {
            [group.mArrayPhotos addObject:photo];
        }
    }
    
    [self orderGroupNameListbyDate];
    [self.tableView reloadData];
}

/**
 *	根据日期排序
 */
-(void)orderGroupNameListbyDate{
    
    [self.mArrayGroupDatas sortUsingComparator:^NSComparisonResult(id a, id b) {
        
        photoGroupObj *firstGroup =(photoGroupObj *)a;
        photoGroupObj *secondgroup =(photoGroupObj *)b;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *groupDate1=[dateFormatter dateFromString:[NSString stringWithFormat:@"%d-%d-%d",firstGroup.year,firstGroup.month,firstGroup.day]];
        
        NSDate *groupDate2=[dateFormatter dateFromString:[NSString stringWithFormat:@"%d-%d-%d",secondgroup.year,secondgroup.month,
                                                          secondgroup.day]];
        [dateFormatter setDateFormat:@"yyyyMMdd"];
        
        NSInteger iDate1=[[dateFormatter stringFromDate:groupDate1] integerValue];
        
        NSInteger iDate2=[[dateFormatter stringFromDate:groupDate2] integerValue];
        
        [dateFormatter release];
        
        if (iDate2 > iDate1) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if (iDate1 < iDate2) {
            
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
        
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return [mArrayGroupDatas count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    photoGroupObj *group = (photoGroupObj *)[mArrayGroupDatas objectAtIndex:section];
    return group.mArrayPhotos.count % COLUMVALUE!=0?(group.mArrayPhotos.count / COLUMVALUE)+1:(group.mArrayPhotos.count / COLUMVALUE);
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell==nil) {
        
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
    }
    
    for (UIView *v in cell.contentView.subviews) {
        
        [v removeFromSuperview];
        v=nil;
    }
    photoGroupObj *group = (photoGroupObj *)[mArrayGroupDatas objectAtIndex:indexPath.section];
    
    
    int startIndex = indexPath.row * COLUMVALUE;
    
    int endIndex = (indexPath.row+1) * COLUMVALUE;
    
    
    if (endIndex >= group.mArrayPhotos.count)
        
        endIndex = group.mArrayPhotos.count;
    
    int iStart=0;
    
    for (int i = startIndex; i < endIndex; i++) {
        
        photoModelObj *photoObj=(photoModelObj*)[group.mArrayPhotos objectAtIndex:i];
        
        UIButton *thumbnailView = [UIButton  buttonWithType:UIButtonTypeCustom];
        thumbnailView.frame = CGRectMake(PADDING+(72 * iStart + PADDING * iStart), PADDING, 72, 72);
        thumbnailView.tag = i+[self getInPhotosByIndexValue:indexPath.section];
        thumbnailView.backgroundColor=[UIColor clearColor];
        //thumbnailView.image=photoObj.ImgSmall;
        [thumbnailView setBackgroundImage:photoObj.ImgSmall forState:UIControlStateNormal];
        [thumbnailView addTarget:self action:@selector(clickPic:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:thumbnailView];
        iStart++;
        
        if (self.typeTitle == TYPE_VIDEO) {
            UIImage *imgPlay = [UIImage imageNamed:@"home_video_play_photos.png"];
            UIImageView *imageviewPlay = [[UIImageView alloc] initWithFrame:CGRectMake(thumbnailView.frame.size.width - imgPlay.size.width, thumbnailView.frame.size.height-imgPlay.size.height, imgPlay.size.width, imgPlay.size.height)];
            imageviewPlay.image = imgPlay;
            [thumbnailView addSubview:imageviewPlay];
            [imageviewPlay release];
        }
    }
    
    return cell;
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return  headView_height;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    photoGroupObj *group = (photoGroupObj *)[mArrayGroupDatas objectAtIndex:section];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *date = [dateFormatter dateFromString:[NSString stringWithFormat:@"%i-%i-%i", group.year, group.month,group.day]];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *strDatetime = [dateFormatter stringFromDate:date];
    
    [dateFormatter release];
    
    UIView *v_headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, headView_height)] autorelease];
    v_headerView.backgroundColor=[UIColor clearColor];
    
    
    UILabel *v_headerLab = [[UILabel alloc] initWithFrame:CGRectMake(5.0, (headView_height-18.0)/2.0, v_headerView.frame.size.width-10.0, 18.0)];
    v_headerLab.backgroundColor = [UIColor clearColor];//设置v_headerLab的背景颜色
    v_headerLab.textColor = [UIColor blackColor];//设置v_headerLab的字体颜色
    v_headerLab.font = [UIFont systemFontOfSize:18];
    v_headerLab.textAlignment=UITextAlignmentLeft;
    v_headerLab.text=strDatetime;
    
    [v_headerView addSubview:v_headerLab];
    [v_headerLab release];
    return v_headerView;
    
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    photoGroupObj *group = (photoGroupObj *)[mArrayGroupDatas objectAtIndex:section];
//
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//
//    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//
//    NSDate *date = [dateFormatter dateFromString:[NSString stringWithFormat:@"%i-%i-%i", group.year, group.month,group.day]];
//
//    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//
//    NSString *resultString = [dateFormatter stringFromDate:date];
//    [dateFormatter release];
//
//    return resultString;
//}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 84;
}

/**
 *  得到Photo在整个图像集合的索引值
 *
 *  @param groupIndex 返回Photo在整个集合里面的索引
 */
-(int)getInPhotosByIndexValue:(int)groupIndex{
    
    int returnIndexValue=0;
    
    for (int i=0; i<groupIndex; i++) {
        photoGroupObj *groupObj=(photoGroupObj*)[mArrayGroupDatas objectAtIndex:i];
        
        //        if (groupIndex>=i) {
        //
        //            break;
        //        }
        
        returnIndexValue=returnIndexValue+groupObj.mArrayPhotos.count;
    }
    
    return returnIndexValue;
}

/**
 *  看大图事件
 */
- (void)clickPic:(id)sender
{
    UIButton *clickBtn=(UIButton*)sender;
    int index=clickBtn.tag;
    
    NSMutableArray  *photosMArrayDatas=[[NSMutableArray alloc] initWithCapacity:10];
    
    for (int i=0; i<[mArrayGroupDatas count]; i++) {
        
        photoGroupObj *groupObj=(photoGroupObj*)[mArrayGroupDatas objectAtIndex:i];
        
        [photosMArrayDatas addObjectsFromArray:groupObj.mArrayPhotos];
    }
    
    photoModelObj *cellPhotoObj = [photosMArrayDatas objectAtIndex:index];
    if (self.typeTitle == TYPE_VIDEO) {
        
        [self playMovie:[cellPhotoObj.videoUrl absoluteString]];
        return;
    }
    
    ShareViewController *_tShareVC = [[ShareViewController alloc] init];
    _tShareVC._index = index;
    _tShareVC._mArrayPictures = photosMArrayDatas;
    [self.navigationController pushViewController:_tShareVC animated:YES];
    [_tShareVC release];
    [photosMArrayDatas release];
    
    
    
}


-(void)playMovie:(NSString *)fileName{
    JDCSAppDelegate *delegate = (JDCSAppDelegate *)[UIApplication sharedApplication].delegate;
    AlarmVideoPlayViewController *videoPlay= [[AlarmVideoPlayViewController alloc] init];
    videoPlay._StrViedoPlay = fileName;
    videoPlay.title = LOCALANGER(@"home_videos");
    videoPlay.hidesBottomBarWhenPushed =YES;
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController pushViewController:videoPlay animated:YES];
    // [self.navigationController pushViewController:videoPlay animated:YES];
    [videoPlay release];
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
