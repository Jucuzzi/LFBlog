//
//  EditorViewController.m
//  RichTextEditorDemo
//
//  Created by za4tech on 2017/12/15.
//  Copyright © 2017年 Junior. All rights reserved.
//

#import "EditorViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import "YYKit.h"
#import "TZImagePickerController.h"
#import "BlocksKit+UIKit.h"
#import "Tool.h"
#import "InformationViewModel.h"
#define kDevice_Is_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

@interface EditorViewController ()<YYTextViewDelegate,TZImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) InformationViewModel *viewModel;
@property (nonatomic ,strong)UIButton * publishBtn;

@property (nonatomic, strong) YYTextView *contentTextView;
@property (nonatomic ,strong)TZImagePickerController *imagePickerVc;
@property (nonatomic ,assign)CGFloat keyboardHeight;
@property (nonatomic ,assign)CGFloat navHeight;

@property (nonatomic ,strong)NSMutableArray * imagesArr;    //存放图片
@property (nonatomic ,strong)NSMutableArray * imageUrlsArr; // 存放图片url
@property (nonatomic ,strong)NSMutableArray * desArr;       //存放图片描述
@property (nonatomic ,strong)NSString * contentStr;       // 带有标签的文章内容
@end

@implementation EditorViewController

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
    [self initNotification];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupSubViews];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark - 初始化方法

- (void)initData {
    // 调用viewModel的bindComplete方法确保viewModel初始化完成
    [self.viewModel bindComplete];
    _navHeight = NAV_TITLE_HEIGHT;
}

- (void)initTitle {
     self.title = @"发布图文";
}

- (void)initNotification {
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
}

/**
 设置UI布局
 */
- (void)setupSubViews {
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithCustomView:self.publishBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    // 图文正文输入框
    [self.view addSubview:self.contentTextView];
}

/**
 获取键盘高度
 */
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    self.keyboardHeight = keyboardRect.size.height +NAV_TITLE_HEIGHT+STATUSBAR_HEIGHT;
}

/**
 插入图片
 
 @param image 图片image
 */
- (void)setupImage:(UIImage *)image {
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithAttributedString:self.contentTextView.attributedText];
    UIFont *font = [UIFont systemFontOfSize:15];
    
    NSData *imgData = UIImageJPEGRepresentation(image, 0.9);
    YYImage *img = [YYImage imageWithData:imgData];
    img.preloadAllAnimatedImageFrames = YES;
    YYAnimatedImageView *imageView = [[YYAnimatedImageView alloc] initWithImage:image];
    imageView.autoPlayAnimatedImage = NO;
    imageView.clipsToBounds = YES;
    [imageView startAnimating];
    CGSize size = imageView.size;
    CGFloat textViewWidth = kScreenWidth - 32.0;
    size = CGSizeMake(textViewWidth, size.height * textViewWidth / size.width);
    NSMutableAttributedString *attachText = [NSMutableAttributedString attachmentStringWithContent:imageView contentMode:UIViewContentModeScaleAspectFit attachmentSize:size alignToFont:font alignment:YYTextVerticalAlignmentCenter];
    
    
    YYTextView * desTextView = [YYTextView new];
    desTextView.delegate = self;
    desTextView.contentInset = UIEdgeInsetsMake(5, 50, -5, -50);
    desTextView.text = @"可在此编辑图片描述信息";
//    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
//    style.alignment = NSTextAlignmentCenter;
//    NSAttributedString *attri = [[NSAttributedString alloc] initWithString:@"可在此编辑图片描述信息" attributes:@{ NSParagraphStyleAttributeName:style}];
//    desTextView.placeholderAttributedText = attri;
    desTextView.bounds = CGRectMake(0, 0, kScreenWidth - 32, 50);
    desTextView.font = [UIFont systemFontOfSize:12];
    desTextView.textAlignment = NSTextAlignmentCenter;
    desTextView.textColor = [UIColor grayColor];
    desTextView.scrollEnabled = NO;
    NSMutableAttributedString *attachText2 = [NSMutableAttributedString attachmentStringWithContent:desTextView contentMode:UIViewContentModeCenter attachmentSize:desTextView.size alignToFont:[UIFont systemFontOfSize:12] alignment:YYTextVerticalAlignmentCenter];
    [attachText appendAttributedString:attachText2];
    
    //绑定图片和描述输入框
    [attachText setTextBinding:[YYTextBinding bindingWithDeleteConfirm:NO] range:attachText.rangeOfAll];
    
    [text insertAttributedString:attachText atIndex:self.contentTextView.selectedRange.location];
    [text appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n" attributes:nil]];
    
    text.font = font;
    self.contentTextView.attributedText = text;
    [self.contentTextView becomeFirstResponder];
    self.contentTextView.selectedRange = NSMakeRange(self.contentTextView.text.length, 0);
}


/**
 发布
 */
-(void)clickToPublish{
    [self.imagesArr removeAllObjects];
    [self.desArr removeAllObjects];
    [self.imageUrlsArr removeAllObjects];
    
    NSAttributedString *content = self.contentTextView.attributedText;
    NSString *text = [self.contentTextView.text copy];
    
    [content enumerateAttributesInRange:NSMakeRange(0, text.length) options:0 usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        YYTextAttachment *att = attrs[@"YYTextAttachment"];
        if (att) {
            if ([att.content isKindOfClass:[YYTextView class]]) {
                YYTextView * textView = att.content;
                [self.desArr addObject:textView.text];
            }else{
                YYAnimatedImageView *imgView = att.content;
                [self.imagesArr addObject:imgView.image];
//                [self.imageUrlsArr addObject:@"http://www.baidu.com"];
            }
        }
    }];
    [self uploadImageWithImageArr:self.imagesArr];
//    self.contentStr = [text stringByReplacingOccurrencesOfString:@"\U0000fffc\U0000fffc" withString:@"<我是图片>"];
//    [Tool makeHtmlString:_imageUrlsArr desArr:_desArr contentStr:_contentStr];
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
        
        /** 获取图片*/
        [[PHImageManager defaultManager] requestImageForAsset:asset
                                                   targetSize:size
                                                  contentMode:PHImageContentModeDefault
                                                      options:options
                                                resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                                    /** 刷新*/
                                                    [self setupImage:result];
                                                }];
    }
}

#pragma mark - 云端请求方法
//举报别人发布的评论
- (void)uploadImageWithImageArr:(NSArray *)arr{
    @weakify(self);
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [[self.viewModel.uploadImageCommand execute:obj] subscribeNext:^(NSDictionary *returnData) {
        }];
    }];
}


#pragma mark YYTextViewDelegate
- (void)textViewDidChange:(YYTextView *)textView{
    if (textView.text.length > 100 && textView.tag != 1000) {
        textView.text = [textView.text substringToIndex:100];
    }
}

//防止输入图片描述的输入框被键盘遮挡
-(void)textViewDidBeginEditing:(YYTextView *)textView{
    if (textView.tag != 1000) {
        if ((textView.origin.y + 50) >(kScreenHeight - self.keyboardHeight -NAV_TITLE_HEIGHT-STATUSBAR_HEIGHT)) {
            [self.contentTextView setContentOffset:CGPointMake(0, (textView.origin.y + 50) - (kScreenHeight - self.keyboardHeight -NAV_TITLE_HEIGHT-STATUSBAR_HEIGHT)) animated:YES];
        }
    }
}

#pragma mark - setter

- (YYTextView *)contentTextView {
    if (!_contentTextView) {
        YYTextView *textView = [[YYTextView alloc] initWithFrame:self.view.bounds];
        textView.tag = 1000;
        textView.textContainerInset = UIEdgeInsetsMake(20, 16, 20 +NAV_TITLE_HEIGHT+STATUSBAR_HEIGHT, 16);
        textView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        textView.scrollIndicatorInsets = textView.contentInset;
        textView.delegate = self;
        textView.placeholderText = @"写下您的见闻";
        textView.font = [UIFont systemFontOfSize:15];
        textView.placeholderFont = [UIFont systemFontOfSize:15];
        textView.selectedRange = NSMakeRange(textView.text.length, 0);
        textView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
        textView.allowsPasteImage = YES;
        textView.allowsPasteAttributedString = YES;
        textView.typingAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:15]};
        textView.inputAccessoryView = [self textViewBar];
        _contentTextView = textView;
    }
    return _contentTextView;
}

- (UIToolbar *)textViewBar {
    UIToolbar *bar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    // 空白格
    UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    // 关闭箭头
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 19, 11);
    [btn setImage:[UIImage imageNamed:@"icon_down2"] forState:UIControlStateNormal];
    [btn bk_addEventHandler:^(id sender) {
        [self.view endEditing:YES];
    } forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:btn];
    // 添加图片
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(0, 0, 20, 18);
    [btn1 setImage:[UIImage imageNamed:@"icon_addphoto"] forState:UIControlStateNormal];
    [btn1 bk_addEventHandler:^(id sender) {
        [self presentViewController:self.imagePickerVc animated:YES completion:nil];
    } forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:btn1];
    bar.items = @[left, space, right];
    return bar;
}

- (UIToolbar *)titleFieldBar {
    UIToolbar *bar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    // 空白格
    UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    // 关闭箭头
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 19, 11);
    
    [btn setImage:[UIImage imageNamed:@"icon_down2"] forState:UIControlStateNormal];
    [btn bk_addEventHandler:^(id sender) {
        [self.view endEditing:YES];
    } forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:btn];
    bar.items = @[left, space];
    
    return bar;
}

-(TZImagePickerController *)imagePickerVc
{
    _imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    _imagePickerVc.allowPickingOriginalPhoto = YES;
    
    _imagePickerVc.naviBgColor = [UIColor whiteColor];
    _imagePickerVc.naviTitleColor = [UIColor blackColor];
    _imagePickerVc.barItemTextColor = [UIColor blackColor];
    _imagePickerVc.barItemTextFont = [UIFont systemFontOfSize:17.f];
    _imagePickerVc.isStatusBarDefault = YES;
    _imagePickerVc.delegate = self;
    _imagePickerVc.allowTakePicture = NO;
    _imagePickerVc.allowPickingVideo = NO;
    _imagePickerVc.allowPickingGif = NO;
    return _imagePickerVc;
}

-(UIButton *)publishBtn
{
    if (!_publishBtn) {
        _publishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _publishBtn.bounds = CGRectMake(0, 0, 40, 44);
        [_publishBtn setTitle:@"发布" forState:UIControlStateNormal];
        [_publishBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _publishBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        [_publishBtn bk_addEventHandler:^(id sender) {
            [self clickToPublish];
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return _publishBtn;
}

-(NSMutableArray *)imageUrlsArr{
    if (!_imageUrlsArr) {
        _imageUrlsArr = [NSMutableArray array];
    }
    return _imageUrlsArr;
}
-(NSMutableArray *)imagesArr{
    if (!_imagesArr) {
        _imagesArr = [NSMutableArray array];
    }
    return _imagesArr;
}
-(NSMutableArray *)desArr{
    if (!_desArr) {
        _desArr = [NSMutableArray array];
    }
    return _desArr;
}

- (InformationViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[InformationViewModel alloc] init];
    }
    return _viewModel;
}
@end
