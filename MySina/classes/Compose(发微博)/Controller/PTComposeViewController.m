//
//  PTMessageViewController.m
//  SinaBlog
//
//  Created by hpt on 16/4/10.
//  Copyright © 2016年 PT. All rights reserved.
//

#import "PTComposeViewController.h"
#import "PTComposeToolBar.h"
#import "PTComposePhotosView.h"
#import "PTAccountTool.h"
#import "PTAccount.h"
#import "PTSendStatusParam.h"
#import "PTSendStatusResult.h"
#import "PTStatusTool.h"
#import "PTEmotionKeyboard.h"
#import "PTEmotion.h"
#import "PTEmotionTextView.h"

@interface PTComposeViewController () <PTComposeToolBarDelegate, UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) PTEmotionTextView *textView;

@property (nonatomic, strong) PTComposeToolBar *toolBar;

@property (nonatomic, strong) PTComposePhotosView *photosView;

@property (nonatomic, strong) PTEmotionKeyboard *keyboard;

/** 是否正在切换键盘 */
@property (nonatomic, assign, getter = isChangingKeyboard) BOOL changingKeyboard;

@end

@implementation PTComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 设置导航栏
    [self setupNav];
    
    // 设置textView
    [self setupTextView];
    
    // 设置toolBar
    [self setupToolBar];
    
    // 监听表情选中的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionDidSelected:) name:PTEmotionDidSelectedNotification object:nil];
    // 监听删除按钮点击的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionDidDeleted:) name:PTEmotionDidDeletedNotification object:nil];
}

/**
 *  view显示完毕的时候再弹出键盘，避免显示控制器view的时候会卡住
 */
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 成为第一响应者（叫出键盘，模拟器需打开键盘）
    [self.textView becomeFirstResponder];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [self.view endEditing:animated];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 *  textView懒加载
 */
- (PTEmotionTextView *)textView
{
    if (!_textView) {
        PTEmotionTextView *textView = [[PTEmotionTextView alloc] init];
        // 允许垂直弹簧效果
        textView.alwaysBounceVertical = YES;
        textView.frame = self.view.bounds;
        
        // 控制器成为代理
        textView.delegate = self;
        [self.view addSubview:textView];
        _textView = textView;
        
        // 监听键盘显示，隐藏状态
		    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
		    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
				
    }
    return _textView;
}

- (PTEmotionKeyboard *)keyboard
{
	if (!_keyboard) {
		self.keyboard = [PTEmotionKeyboard keyboard];
		self.keyboard.width = ScreenWidth;
        self.keyboard.height = 253;
	}
	return _keyboard;
}

- (PTComposeToolBar *)toolBar
{
    if (!_toolBar) {
        _toolBar = [[PTComposeToolBar alloc] init];
        // 初始化隐藏
        _toolBar.alpha = 0.0;
        _toolBar.delegate = self;
        
        [self.view addSubview:_toolBar];
    }
    return _toolBar;
}

- (PTComposePhotosView *)photosView
{
    if (!_photosView) {
        _photosView = [[PTComposePhotosView alloc] init];
        _photosView.backgroundColor = [UIColor yellowColor];
        _photosView.width = self.view.width;
        _photosView.height = self.textView.height;
        _photosView.x = 0;
        _photosView.y = 100;
        
        [self.textView addSubview:_photosView];
    }
    return _photosView;
}
/**
 *  设置textView
 */
- (void)setupTextView
{
	self.textView.placeholder = @"分享新鲜事...";
	self.textView.font = [UIFont systemFontOfSize:16];
	
}

- (void)setupToolBar
{
    // toolBar在最底部
    self.toolBar.x = 0;
    self.toolBar.width = self.view.width;
    self.toolBar.height = 44;
    self.toolBar.y = self.view.height - _toolBar.height;
}

- (void)setupNav
{
    self.title = @"发微博";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStyleDone target:self action:@selector(send)];
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

- (void)cancel
{
	PTLog(@"cancel---");
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)send
{
	PTLog(@"发微博---");
	// 1.发表微博
	if (self.photosView.subviews.count) {
		[self sendStatusWithImage];
		
	} else {
		[self sendStatusWithoutImage];
	}
	// 2.关闭控制器
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  发表有图片的微博
 */
- (void)sendStatusWithImage
{
		// 1.封装请求参数
		PTSendStatusParam *param = [PTSendStatusParam param];
		param.status = self.textView.realText;
		
		UIImageView *imageView = [self.photosView.subviews lastObject];
		
		// 2.发送一张图片微博微博
		[PTStatusTool sendStatusWithParam:param image:imageView.image fileName:@"MyImages" success:^(PTStatus *status) {
			[MBProgressHUD showSuccess:@"发表成功"];
//			PTLog(@"发送的微博---%@", status);
			
		} failure:^(NSError *error) {
			[MBProgressHUD showError:@"发表失败"];
//            PTLog(@"发表失败---%@", error);
		}];
}

/**
 *  发表没有图片的微博
 */
- (void)sendStatusWithoutImage
{
		// 1.封装请求参数
		PTSendStatusParam *param = [PTSendStatusParam param];
		param.status = self.textView.realText;
		
		// 2.发送一条微博
		[PTStatusTool sendStatusWithParam:param success:^(PTStatus *status) {
			[MBProgressHUD showSuccess:@"发表成功"];
//			PTLog(@"发送的微博---%@", status);
			
		} failure:^(NSError *error) {
			[MBProgressHUD showError:@"发表失败"];
//            PTLog(@"发表失败---%@", error);
		}];
}

#pragma mark - 键盘处理
/**
 *  键盘即将隐藏
 */
- (void)keyboardWillHide:(NSNotification *)noti
{
    if (self.isChangingKeyboard) return;
    
//    PTLog(@"%@", noti.userInfo);
    NSDictionary *userInfo = noti.userInfo;
    
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^ {
        self.toolBar.transform = CGAffineTransformIdentity;
        
    }];
}

/**
 *  键盘即将弹出
 */
- (void)keyboardWillShow:(NSNotification *)noti
{
//    PTLog(@"%@", noti.userInfo);
    NSDictionary *userInfo = noti.userInfo;
    
    // 获取键盘弹出需要的时间
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 取出键盘高度
    CGRect keyboardFrame= [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGFloat keyboardHeight = keyboardFrame.size.height;
//    PTLog(@"%f--%f", keyboardHeight, keyboardFrame.size.width);
    
    [UIView animateWithDuration:duration animations:^ {
        self.toolBar.transform = CGAffineTransformMakeTranslation(0, -keyboardHeight);
        self.toolBar.alpha = 1.0;
    }];
}

#pragma mark - UITextViewDelegate/UIScrollViewDelegate
/**
 *  当用户开始拖拽scrollView时调用
 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

- (void)textViewDidChange:(UITextView *)textView
{
    // 有文字时发送按钮enable
    self.navigationItem.rightBarButtonItem.enabled = textView.hasText;
}

#pragma mark - PTComposeToolBarDelegate
/**
 *  监听toolbar内部按钮的点击
 */
- (void)composeToolBar:(PTComposeToolBar *)composeToolBar didClickButton:(PTComposeToolBarButtonType)buttonType
{
	switch (buttonType) {
		case PTComposeToolBarButtonTypeCamera:
			[self openCamera];
			break;
		
		case PTComposeToolBarButtonTypePicture:
			[self openPicture];
			break;
		
		case PTComposeToolBarButtonTypeEmotion:
			[self openEmotion];
			break;
			
		default:
			break;
	}
}

/**
 * UIImagePickerControllerSourceTypeCamera
 * UIImagePickerControllerSourceTypePhotoLibrary
 * UIImagePickerControllerSourceTypeSavedPhotosAlbum
 */
- (void)openCamera
{
    PTLog(@"openCamera");
		// 如果不支持照相功能
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
    	 [MBProgressHUD showError:@"无法打开相机"];
    	 return;
    }
    
    // 支持照相功能
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
    ipc.delegate = self;
    [self presentViewController:ipc animated:YES completion:nil];
}

- (void)openPicture
{
    PTLog(@"openPicture");
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
    	 [MBProgressHUD showError:@"无法打开图库"];
    	 return;
    }
    
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    ipc.delegate = self;
    [self presentViewController:ipc animated:YES completion:nil];
}

- (void)openEmotion
{
//	PTLog(@"打开表情包...");
	// 正在切换键盘
    self.changingKeyboard = YES;
  
	if (self.textView.inputView) { // 当前显示的是自定义键盘，切换为系统自带的键盘
        self.textView.inputView = nil;
        // 若此时隐藏，需将键盘toolbar拉下
        self.changingKeyboard = NO;
        // toolbar的表情按钮显示笑脸图片
        self.toolBar.showEmotionButton = YES;
//        // 重新加载系统键盘，该方法无动画效果
//        [self.textView reloadInputViews];
        [self.textView resignFirstResponder];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.textView becomeFirstResponder];
        });
		
	} else {
        self.textView.inputView = self.keyboard;
        // toolbar的表情按钮显示键盘图片
        self.toolBar.showEmotionButton = NO;
        // 更换键盘需要将键盘关闭后重新打开
        [self.textView resignFirstResponder];
        // 若此时隐藏，需将键盘toolbar拉下
        self.changingKeyboard = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.textView becomeFirstResponder];
        });
	}
}

/**
 *  当表情选中的时候调用
 *
 *  @param note 里面包含了选中的表情
 */
- (void)emotionDidSelected:(NSNotification *)note
{
    PTEmotion *emotion = note.userInfo[PTSelectedEmotion];
//    PTLog(@"%@ %@", emotion.chs, emotion.emoji);
	// 1.拼接表情
    [self.textView appendEmotion:emotion];
    
    // 2.检测文字长度
    [self textViewDidChange:self.textView];
}

- (void)emotionDidDeleted:(NSNotification *)note
{
		// 往回删
    [self.textView deleteBackward];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    // 1.取出选中的图片
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    // 2.添加图片到相册中
    [self.photosView addImage:image];
}

@end
