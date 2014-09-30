//
//  JVCBaseGeneralTableViewController.m
//  CloudSEE_II
//
//  Created by Yanghu on 9/30/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCBaseGeneralTableViewController.h"

static const int  NavicationViewControllersCountINTableView = 1;//navicationbar的viewcontroller的数量，1标示根试图


@interface JVCBaseGeneralTableViewController ()

@end

@implementation JVCBaseGeneralTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
   
        if (self) {
            
            /**
             *  解决父类UIViewController带导航条添加ScorllView坐标系下沉64像素的问题（ios7）
             
             */
            
            if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
            {
                self.edgesForExtendedLayout = UIRectEdgeNone;
                
            }
        }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //处理UIViewController的可视区域的高度
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
    {
        
        CGRect contentRect = self.view.frame;
        
        //减去导航条的高度
        if (!self.navigationController.navigationBarHidden) {
            
            contentRect.size.height = contentRect.size.height - self.navigationController.navigationBar.frame.size.height;
            
            //减去状态栏的高度
            if (![UIApplication sharedApplication].statusBarHidden) {
                
                contentRect.size.height = contentRect.size.height - [UIApplication sharedApplication].statusBarFrame.size.height;
            }
            
        }
        
        if ((self.tabBarController !=nil) && !self.tabBarController.tabBar.hidden) {
            
            contentRect.size.height = contentRect.size.height - self.tabBarController.tabBar.height;
        }
        

        
        self.view.frame = contentRect;
    }
    
    if (self.navigationController.viewControllers.count != NavicationViewControllersCountINTableView) {//不是顶级试图
        
        NSString *path= nil;
        
        path = [[NSBundle mainBundle] pathForResource:@"nav_back" ofType:@"png"];
        
        if (path == nil) {
            
            path = [[NSBundle mainBundle] pathForResource:@"nav_back@2x" ofType:@"png"];
            
        }
        UIImage *image = [[UIImage alloc] initWithContentsOfFile:path];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, image.size.width, image.size.height);
        [btn addTarget:self action:@selector(BackClick) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundImage:image forState:UIControlStateNormal];
        UIBarButtonItem *barButtonItem = [[UIBarButtonItem  alloc] initWithCustomView:btn];
        self.navigationItem.leftBarButtonItem = barButtonItem;
        [barButtonItem release];
        [image release];
        
    }
}

- (void)BackClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

//iOS 5
- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return (toInterfaceOrientation == UIDeviceOrientationPortrait);
    
}

//iOS 6
- (BOOL) shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

//#pragma mark - Table view data source
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//#warning Incomplete method implementation.
//    // Return the number of rows in the section.
//    return 0;
//}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
