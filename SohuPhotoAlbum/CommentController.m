//
//  CommentController.m
//  SohuPhotoAlbum
//
//  Created by sohu on 13-5-2.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import "CommentController.h"
#import "UIImageView+WebCache.h"
#import "EmojiUnit.h"
#import "PhotoWallController.h"

@interface CommentController ()

@end

@implementation CommentController

@synthesize ownerId;
@synthesize sourceId;
@synthesize imageUrl;

- (void)dealloc
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self];
}

- (id)initWithSourceId:(NSString *)AsourceId andSoruceType:(source_type)Atype withBgImageURL:(NSString * )bgUrl WithOwnerID:(NSString *)ownID
{
    self = [super init];
    if (self) {
        self.sourceId = AsourceId;
        type = Atype;
        self.imageUrl = bgUrl;
        self.ownerId = ownID;
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center addObserver:self selector:@selector(commentkeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [center addObserver:self selector:@selector(commentkeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = BASEWALLCOLOR;
    [self addBgView];
    [self addTableView];
    [self addCommentView];
    _dataSourceArray = [NSMutableArray arrayWithCapacity:0];
    [self refrshDataFromNetWork];
}
- (void)addBgView
{
    _myBgView  = [[UIImageView alloc] initWithFrame:_myTableView.bounds];
    _myBgView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:_myBgView];
    UIImageView * maskImageView = [[UIImageView alloc] initWithFrame:_myBgView.bounds];
    [_myBgView addSubview:maskImageView];
    maskImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    maskImageView.backgroundColor = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.3];
    self.view.clipsToBounds = YES;
    __weak UIImageView * bgViewSelf = _myBgView;
    __weak CommentController * weakSelf = self;
    [_myBgView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@_w640",self.imageUrl]] placeholderImage:[UIImage imageNamed:@"1.png"] success:^(UIImage *image) {
        CGSize size = [weakSelf getIdentifyImageSizeWithImageView:image];
        bgViewSelf.frame = (CGRect){0, 0,size};
        bgViewSelf.center = CGPointMake(weakSelf.view.bounds.size.width /2.f, weakSelf.view.bounds.size.height /2.f);
    } failure:^(NSError *error) {
        
    }];
}

- (void)addTableView
{
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, 320, self.view.bounds.size.height - 44 - 38) style:UITableViewStylePlain];
    _myTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.separatorColor = [UIColor clearColor];
    _myTableView.backgroundColor = [UIColor clearColor];
    
    _refresHeadView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, - 60, 320, 60) arrowImageName:nil textColor:[UIColor grayColor] backGroundColor:[UIColor clearColor]];
    _refresHeadView.delegate = self;
    [_myTableView addSubview:_refresHeadView];
    [self.view addSubview:_myTableView];
    
    _moreFootView = [[SCPMoreTableFootView alloc] initWithFrame:CGRectMake(0, 0, 320, 60) WithLodingImage:[UIImage imageNamed:@"load_more_pics.png"] endImage:[UIImage imageNamed:@"end_bg.png"] WithBackGroud:[UIColor clearColor]];
    _moreFootView.delegate = self;
    
}
- (void)addCommentView
{
    commentView = [[MakeCommentView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 38, 320, 38)];
    [self.view addSubview:commentView];
    commentView.delegte = self;
    [commentView addresignFirTapOnView:self.view];
}

- (CGSize)getIdentifyImageSizeWithImageView:(UIImage *)image
{
    if (!image) return CGSizeZero;
    CGFloat w = image.size.width;
    CGFloat h = image.size.height;
    CGRect frameRect = self.view.bounds;
    CGRect rect = CGRectZero;
    CGFloat scale = MAX(frameRect.size.width / w, frameRect.size.height / h);
    rect = CGRectMake(0, 0, w * scale, h * scale);
    return rect.size;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.navigationItem setHidesBackButton:YES];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
    if (!_navBar){
        _navBar = [[CustomizationNavBar alloc] initwithDelegate:self];
        _navBar.normalBar.image = [UIImage imageNamed:@"navbarnoline.png"];
        [_navBar.nLeftButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
        _navBar.nLabelText.text = @"评论";
    }
    if (!_navBar.superview)
        [self.navigationController.navigationBar addSubview:_navBar];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_navBar removeFromSuperview];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackOpaque];
    [commentView.textView resignFirstResponder];
}
#pragma mark KeyBord
- (void)commentkeyboardWillShow:(NSNotification *)notification
{
    NSDictionary * dic = [notification userInfo];
    CGFloat heigth = [[dic objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    NSNumber *duration = [dic objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    [UIView animateWithDuration:[duration doubleValue]?[duration doubleValue] : 0.25 animations:^{
        commentView.frame = CGRectMake(0, self.view.frame.size.height - 38 - heigth, 320, 38);
    }];
}
- (void)commentkeyboardWillHide:(NSNotification *)notification
{
    NSDictionary * dic = [notification userInfo];
    NSNumber *duration = [dic objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    [UIView animateWithDuration:[duration doubleValue]?[duration doubleValue] : 0.25 animations:^{
        commentView.frame = CGRectMake(0, self.view.frame.size.height - 38, 320, 38);
    }];
}

- (void)commetButtonClick:(UIButton *)button
{
    
    if ([EmojiUnit stringContainsEmoji:commentView.textView.internalTextView.text]) {
        PopAlertView * tip = [[PopAlertView alloc] initWithTitle:nil message:@"评论内容不能包含特殊字符或表情" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [tip show];
        return;
    }
    
    if (_isSending) return;
    _isSending  = YES;
    [RequestManager postCommentWithSourceType:type andSourceID:sourceId onwerID:self.ownerId andAccessToken:[LoginStateManager currentToken] comment:commentView.textView.internalTextView.text success:^(NSString *response) {
        [_dataSourceArray insertObject:[self getCommentSoureWithComment:commentView.textView.internalTextView.text] atIndex:0];
        commentView.textView.internalTextView.text = nil;
        [commentView.textView resignFirstResponder];
        [_myTableView reloadData];
        _isSending  = NO;
    } failure:^(NSString *error) {
        [commentView.textView resignFirstResponder];
        _isSending  = NO;
    }];
}

- (CommentCellDeteSource *)getCommentSoureWithComment:(NSString *)comment
{
    CommentCellDeteSource * dataSource = [[CommentCellDeteSource alloc] init];
    dataSource.portraitUrl = [userInfo objectForKey:@"user_icon"];
    dataSource.userName = [userInfo objectForKey:@"user_nick"];
    dataSource.userId = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"user_id"]];
    dataSource.commentStr = comment;
    return dataSource;
}
#pragma mark - refresh
- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView *)view
{
    return [NSDate date];
}
- (void)reloadTableViewDataSource
{
    _isLoading = YES;
    [self refrshDataFromNetWork];
}
- (void)doneRefrshLoadingTableViewData
{
    _isLoading = NO;
    [_refresHeadView egoRefreshScrollViewDataSourceDidFinishedLoading:_myTableView];
}

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view
{
    [self reloadTableViewDataSource];
}
- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view
{
    return _isLoading;
}
- (void)refeshOnce:(id)sender
{
    [_refresHeadView refreshImmediately];
    [self reloadTableViewDataSource];
}

#pragma mark - more
- (void)scpMoreTableFootViewDelegateDidTriggerRefresh:(SCPMoreTableFootView *)view
{
    [self moreTableViewDataSource];
}
- (BOOL)scpMoreTableFootViewDelegateDataSourceIsLoading:(SCPMoreTableFootView *)view
{
    return _isLoading;
}
- (void)moreTableViewDataSource
{
    _isLoading = YES;
    [self getMoreFromNetWork];
}
- (void)doneMoreLoadingTableViewData
{
    _isLoading = NO;
    [_moreFootView scpMoreScrollViewDataSourceDidFinishedLoading:_myTableView];
}

#pragma mark refrshDataFromNetWork
- (void)refrshDataFromNetWork
{
    [RequestManager getCommentWithSourceType:type andSourceID:sourceId page:0 success:^(NSString *response) {
        [_dataSourceArray removeAllObjects];
        [self addDataSourceWithArray:[[response JSONValue] objectForKey:@"comments"]];
        [self doneRefrshLoadingTableViewData];

    } failure:^(NSString *error) {
        [self doneRefrshLoadingTableViewData];
    }];
    [RequestManager getUserInfoWithId:[LoginStateManager currentUserId] success:^(NSString *response) {
        userInfo = [response JSONValue];
    } failure:^(NSString *error) {
        [self addDataSourceWithArray:nil];
    }];
}
- (void)addDataSourceWithArray:(NSArray *)array
{
    for (int i = 0; i < array.count; i++)
        [_dataSourceArray addObject:[self getCellDataSourceFromInfo:[array objectAtIndex:i]]];
    [_myTableView reloadData];
}
- (CommentCellDeteSource *)getCellDataSourceFromInfo:(NSDictionary *)info
{
    CommentCellDeteSource * data = [[CommentCellDeteSource alloc] init];
    data.userId = [NSString stringWithFormat:@"%@",[info objectForKey:@"user_id"]];
    data.userName = [info objectForKey:@"user_nick"];
    data.commentStr = [info objectForKey:@"content"];
    data.portraitUrl = [info objectForKey:@"avatar"];
    return data;
}
- (void)getMoreFromNetWork
{
    if (_dataSourceArray.count && _dataSourceArray.count%20) return;
    [RequestManager getCommentWithSourceType:type andSourceID:sourceId page:_dataSourceArray.count / 20 + 1 success:^(NSString *response) {
        [self addDataSourceWithArray:[[response JSONValue] objectForKey:@"comments"]];
        [self doneMoreLoadingTableViewData];
    } failure:^(NSString *error) {
        [self doneMoreLoadingTableViewData];
    }];
}

#pragma mark TableView Delegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_refresHeadView egoRefreshScrollViewDidEndDragging:scrollView];
    [_moreFootView scpMoreScrollViewDidEndDragging:scrollView];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_refresHeadView egoRefreshScrollViewDidScroll:scrollView];
    [_moreFootView scpMoreScrollViewDidScroll:scrollView isAutoLoadMore:YES WithIsLoadingPoint:&_isLoading];
}
#pragma mark -tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSourceArray count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < _dataSourceArray.count){
        CommentCellDeteSource * source = [_dataSourceArray objectAtIndex:indexPath.row];
        return [source cellHeigth];
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentify = @"CELL";
    CommentCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (!cell) {
        cell = [[CommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
        cell.delegate = self;
    }
    if (indexPath.row < _dataSourceArray.count)
        cell.dataSource = [_dataSourceArray objectAtIndex:indexPath.row];
    return cell;
}
#pragma mark Action
- (void)backButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)cusNavigationBar:(CustomizationNavBar *)bar buttonClick:(UIButton *)button isUPLoadState:(BOOL)isupload
{
    if (button.tag == LEFTBUTTON) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)commentCell:(CommentCell *)cell clickPortrait:(id)sender
{
    [self.navigationController pushViewController:[[PhotoWallController alloc] initWithOwnerID:[[cell dataSource] userId] isRootController:NO] animated:YES];
}
- (void)makeCommentView:(MakeCommentView *)view commentClick:(UIButton *)button
{
    [self commetButtonClick:button];
}
@end
