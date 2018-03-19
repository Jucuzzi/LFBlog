//
//  AddDynamicViewController.m
//  LFBlog
//
//  Created by 王力丰 on 2018/3/8.
//  Copyright © 2018年 LiFeng Wang. All rights reserved.
//

#import "AddDynamicViewController.h"
#import "DynamicViewModel.h"
#import "UIImage+Extension.h"
#import "TZImagePickerController.h"
#import <Photos/Photos.h>
#import "UIImageView+WebCache.m"

@interface AddDynamicViewController ()<UITextViewDelegate,TZImagePickerControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{
    UIView *buttomView;
    UITextView *dynamicContent;
    UICollectionView *collection;
}
@property (nonatomic, strong) NSMutableArray *imgArr;
@property (nonatomic, strong) DynamicViewModel *viewModel;
@property (nonatomic, assign) BOOL isKeyboardUped;

@property (nonatomic, assign) BOOL isRequesting;

@property (nonatomic ,strong)TZImagePickerController *imagePickerVc;

@end

@implementation AddDynamicViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initTitle];
    [self initView];
    [self initNotification];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 初始化方法
- (void)initData {
    // 调用viewModel的bindComplete方法确保viewModel初始化完成
    [self.viewModel bindComplete];
    self.imgArr = [[NSMutableArray alloc]initWithCapacity:0];
}

- (void)initNotification {
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)initTitle {
    self.title = @"发布新动态";
}

- (void)initView {
    self.view.backgroundColor = [UIColor whiteColor];
    
    dynamicContent = [[UITextView alloc]initWithFrame:CGRectMake(20, 20 , SCREEN_WIDTH - 40, 160)];
    [self.view addSubview:dynamicContent];
    dynamicContent.textColor = [UIColor lightGrayColor];
    dynamicContent.delegate = self;
    dynamicContent.font = [UIFont systemFontOfSize:17.f];
    dynamicContent.text = @"分享点好东西...";
    
    //放入底部进行评论的文本输入框
    buttomView = [[UIView alloc]initWithFrame:CGRectMake(0, DEFAULT_HEIGHT - 60, SCREEN_WIDTH, 60)];
    buttomView.backgroundColor = [UIColor whiteColor];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [buttomView addSubview:lineView];
//    commentView = [[UITextField alloc]initWithFrame:CGRectMake(10, 5, SCREEN_WIDTH - 20-80, 40)];
//    commentView.layer.borderColor = DEFAULT_BLUE_COLOR.CGColor;
//    commentView.layer.borderWidth = 1;
//    [buttomView addSubview:commentView];
    UIButton *photoButton = [[UIButton alloc]initWithFrame:CGRectMake(25, 7.5, 45, 45)];
    [photoButton setImage:[[UIImage imageNamed:@"photoIcon"] imageWithColor:DEFAULT_BLUE_COLOR] forState:UIControlStateNormal];
    [photoButton addTarget:self action:@selector(addPhoto) forControlEvents:UIControlEventTouchUpInside];
    [buttomView addSubview:photoButton];
    
    UIButton *connectButton = [[UIButton alloc]initWithFrame:CGRectMake(85, 7.5, 45, 45)];
    [connectButton setImage:[[UIImage imageNamed:@"connectIcon"] imageWithColor:DEFAULT_BLUE_COLOR] forState:UIControlStateNormal];
//    [connectButton addTarget:self action:@selector(connection) forControlEvents:UIControlEventTouchUpInside];
    [buttomView addSubview:connectButton];
    
    UIButton *submitButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-30-80, 10, 80, 40)];
    [submitButton setTitle:@"发布" forState:UIControlStateNormal];
    submitButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [submitButton setBackgroundImage:[UIImage imageFromColor:DEFAULT_BLUE_COLOR size:CGSizeMake(80, 40)] forState:UIControlStateNormal];
    submitButton.layer.borderColor = DEFAULT_BLUE_COLOR.CGColor;
    submitButton.layer.cornerRadius = 20.f;
    submitButton.layer.masksToBounds = YES;
    submitButton.layer.borderWidth = 1;
    [submitButton addTarget:self action:@selector(addCommentBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [buttomView addSubview:submitButton];
    
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    collection = [[UICollectionView alloc]initWithFrame:CGRectMake(10, 200, SCREEN_WIDTH - 20, 300) collectionViewLayout:flowLayout]; // 自定义的布局对象
    collection.backgroundColor = [UIColor whiteColor];
    collection.dataSource = self;
    collection.delegate = self;
    [self.view addSubview:collection];
    [collection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [collection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headCell"];
    [collection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footerCell"];
    
    [self.view addSubview:buttomView];
}


#pragma mark ---- UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _imgArr.count +1;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
//    cell.backgroundColor = [UIColor blackColor];
    if (indexPath.row == _imgArr.count) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, (SCREEN_WIDTH - 50)/4, (SCREEN_WIDTH - 50)/4)];
        imageView.image = [[UIImage imageNamed:@"addPhotoIcon"]imageWithColor:[UIColor lightGrayColor]];
        cell.backgroundColor = [UIColor whiteColor];
        [cell.contentView addSubview:imageView];
    } else {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, (SCREEN_WIDTH - 50)/4, (SCREEN_WIDTH - 50)/4)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",LFBlogUserIconPath,_imgArr[indexPath.row]]] placeholderImage:[[UIImage alloc]init]];
        [imageView clipsToBounds];
        imageView.layer.masksToBounds = YES;
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        [cell.contentView addSubview:imageView];
    }
    
    return cell;
}

// 和UITableView类似，UICollectionView也可设置段头段尾
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"headCell" forIndexPath:indexPath];
        if(headerView == nil)
        {
            headerView = [[UICollectionReusableView alloc] init];
        }
        headerView.backgroundColor = [UIColor grayColor];
        
        return headerView;
    }
    else if([kind isEqualToString:UICollectionElementKindSectionFooter])
    {
        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"footerCell" forIndexPath:indexPath];
        if(footerView == nil)
        {
            footerView = [[UICollectionReusableView alloc] init];
        }
        footerView.backgroundColor = [UIColor lightGrayColor];
        
        return footerView;
    }
    
    return nil;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath
{
    
}




#pragma mark ---- UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return (CGSize){(SCREEN_WIDTH - 50)/4,(SCREEN_WIDTH - 50)/4};
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 0, 10, 0);
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.f;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.f;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return (CGSize){SCREEN_WIDTH,0};
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return (CGSize){SCREEN_WIDTH,0};
}




#pragma mark ---- UICollectionViewDelegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

// 点击高亮
- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
//    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
//    cell.backgroundColor = [UIColor greenColor];
}


// 选中某item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == _imgArr.count) {
        [self addPhoto];
    }
}




#pragma mark - 逻辑处理方法

- (void)addPhoto {
    [self presentViewController:self.imagePickerVc animated:YES completion:nil];
}

- (void)addCommentBtnClicked {
    [dynamicContent resignFirstResponder];
    [self addDynamicRequestStart];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat height = keyboardFrame.origin.y;
    CGFloat transformY = height;
    CGRect frame = buttomView.frame;
    frame.origin.y = transformY - 60 -STATUSBAR_HEIGHT - NAV_TITLE_HEIGHT;
    buttomView.frame = frame;
    _isKeyboardUped = YES;
}

- (void)keyboardWillHide:(NSNotification *)notification {
    //恢复到默认y为0的状态，有时候要考虑导航栏要+64
    CGRect frame = buttomView.frame;
    frame.origin.y =  DEFAULT_HEIGHT - 60;
    buttomView.frame = frame;
    _isKeyboardUped = NO;
}

#pragma mark - TZImagePickerControllerDelegate
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto{
    CGFloat scale = [UIScreen mainScreen].scale;
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.resizeMode = PHImageRequestOptionsResizeModeExact;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    
    /** 遍历选择的所有图片*/
    for (NSInteger i = 0; i < assets.count; i++) {
        PHAsset *asset = assets[i];
        CGSize size = CGSizeMake(asset.pixelWidth / scale, asset.pixelHeight / scale);
//
        /** 获取图片*/
        [[PHImageManager defaultManager] requestImageForAsset:asset
                                                   targetSize:size
                                                  contentMode:PHImageContentModeDefault
                                                      options:options
                                                resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                                    [_imagePickerVc showProgressHUD];
                                                    [self uploadImageWithImage:result];
                                                }];
    }
}

#pragma mark - 云端请求方法
- (void)addDynamicRequestStart {
    self.viewModel.detailContent = dynamicContent.text;
    [self.imgArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx>0) {
             self.viewModel.photoIds = [NSString stringWithFormat:@"%@,%@",self.viewModel.photoIds,obj];
        } else {
            self.viewModel.photoIds = [NSString stringWithFormat:@"%@",obj];
        }
       
    }];
    @weakify(self);
    [[self.viewModel.addDynamicCommand execute:nil] subscribeNext:^(NSDictionary *returnData) {
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark - 云端请求方法
//举报别人发布的评论
- (void)uploadImageWithImage:(UIImage *)image{
    self.isRequesting = YES;
    @weakify(self);
    [[self.viewModel.uploadImageCommand execute:image] subscribeNext:^(NSDictionary *returnData) {
        @strongify(self)
        if (![returnData[@"result"] isEqualToString:@"failed"]) {
            [_imagePickerVc hideProgressHUD];
            [_imagePickerVc dismissViewControllerAnimated:YES completion:^{
            }];
            [self.imgArr addObject:returnData[@"photoPath"]];
            [collection reloadData];
        }
    }];
}

#pragma mark - UITextViewDelegate
-(BOOL)textViewShouldEndEditing:(UITextView *)textView {
    [dynamicContent resignFirstResponder];
    return YES;
}

- (DynamicViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[DynamicViewModel alloc] init];
    }
    return _viewModel;
}

-(TZImagePickerController *)imagePickerVc
{
    _imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    _imagePickerVc.allowPickingOriginalPhoto = YES;
    
    _imagePickerVc.naviBgColor = [UIColor whiteColor];
    _imagePickerVc.naviTitleColor = [UIColor blackColor];
    _imagePickerVc.barItemTextColor = [UIColor blackColor];
    _imagePickerVc.barItemTextFont = [UIFont systemFontOfSize:17.f];
    _imagePickerVc.isStatusBarDefault = YES;
//    _imagePickerVc.autoDismiss = NO;
    _imagePickerVc.delegate = self;
    _imagePickerVc.cropRect = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH);
    _imagePickerVc.preferredLanguage = @"zh-Hans";
    _imagePickerVc.allowTakePicture = NO;
    _imagePickerVc.allowPickingVideo = NO;
    _imagePickerVc.allowPickingGif = NO;
    return _imagePickerVc;
}

@end
