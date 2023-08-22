//
//  SPDialog.m
//  SPDialog
//
//  Created by GheniAblez on 2023/8/21.
//

#import "SPDialog.h"
#import "SPDialogManager.h"
#import <SPLayout/SPLayout.h>

@interface SPDialog()<UIGestureRecognizerDelegate>

//window
@property (nonatomic, strong) UIWindow *window;

//view controller
@property (nonatomic, strong) UIViewController *viewController;

//container view
@property (nonatomic, weak) UIView *containerView;

//title label
@property (nonatomic, weak) UILabel *titleLabel;

//content label
@property (nonatomic, weak) UITextView *contentView;

//cancel button
@property (nonatomic, weak) UIButton *cancelButton;

//confirm button
@property (nonatomic, weak) UIButton *confirmButton;


#pragma mark - data

//title
@property (nonatomic, copy) NSString *title;

//attributed content

@property (nonatomic, copy) NSAttributedString *attributedContent;

//content
@property (nonatomic, copy) NSString *content;

//cancel
@property (nonatomic, copy) NSString *cancel;

//confirm
@property (nonatomic, copy) NSString *confirm;

//content view
@property (nonatomic, strong) UIView *customContentView;

@end

@implementation SPDialog


+ (SPDialog *)create:(NSString *)title attributedContent:(NSAttributedString *)content cancel:(NSString *)cancel confirm:(NSString *)confirm {
    SPDialog *dialog = [[SPDialog alloc] init];
    dialog.title = title;
    dialog.attributedContent = content;
    dialog.cancel = cancel;
    dialog.confirm = confirm;
    [[SPDialogManager sharedInstance] addDialog:dialog key:[NSString stringWithFormat:@"%p", dialog]];
    return dialog;
}

+ (SPDialog *)create:(NSString *)title content:(NSString *)content cancel:(NSString *)cancel confirm:(NSString *)confirm {
    SPDialog *dialog = [[SPDialog alloc] init];
    dialog.title = title;
    dialog.content = content;
    dialog.cancel = cancel;
    dialog.confirm = confirm;
    [[SPDialogManager sharedInstance] addDialog:dialog key:[NSString stringWithFormat:@"%p", dialog]];
    return dialog;
}

+ (SPDialog *)create:(NSString *)title content:(NSString *)content{
    return [self create:title content:content cancel:SPString(@"Cancel") confirm:SPString(@"Yes")];
}

+ (SPDialog *)createWithContent:(NSString *)content{
    return [self create:@"" content:content cancel:SPString(@"Cancel") confirm:SPString(@"Yes")];
}

+ (SPDialog *)create:(UIView *)contentView {
    SPDialog *dialog = [[SPDialog alloc] init];
    dialog.customContentView = contentView;
    [[SPDialogManager sharedInstance] addDialog:dialog key:[NSString stringWithFormat:@"%p", dialog]];
    return dialog;
}

#pragma mark - loading

+ (SPDialog *)loading{
    return [SPDialog loadingHideAfter:NSIntegerMax];
}

+ (SPDialog *)loadingHideAfter:(NSTimeInterval)delay{
    return [SPDialog loadingHideAfter:delay animationType:SPDialogAnimationTypeNone];
}

+ (SPDialog *)loadingHideAfter:(NSTimeInterval)delay animationType:(SPDialogAnimationType)animationType{
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [indicator setHidesWhenStopped:YES];
    indicator.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    [indicator.layer setCornerRadius:6];
    [indicator.layer setMasksToBounds:YES];
    [indicator setTransform:CGAffineTransformMakeScale(1.5, 1.5)];
    [indicator startAnimating];
    SPLayout.layout(indicator).size(CGSizeMake(50, 50)).install();
    
    SPDialog *dialog = [SPDialog create:indicator];
    dialog.showMask = NO;
    dialog.animationType = animationType;
    [dialog show];
    [dialog performSelector:@selector(dismiss) withObject:nil afterDelay:delay];
    return dialog;
}


#pragma mark - toast
+ (SPDialog *)toast:(NSString *)content{
    return [SPDialog toast:content hideAfter:2];
}

+ (SPDialog *)toast:(NSString *)content hideAfter:(NSTimeInterval)delay{
    return [SPDialog toast:content hideAfter:delay style:SPDialogToastStyleDefault];
}

+ (SPDialog *)toast:(NSString *)content hideAfter:(NSTimeInterval)delay style:(SPDialogToastStyle)style{
    UILabel *label = [[UILabel alloc] init];
    label.text = content;
    label.font = SPFont.smallBody;
    label.textAlignment = NSTextAlignmentCenter;
    
    switch (style) {
        case SPDialogToastStyleSuccess:
            label.textColor = SPColor.white;
            label.backgroundColor = SPColor.success;
            break;
        case SPDialogToastStyleInfo:
            label.textColor = SPColor.white;
            label.backgroundColor = SPColor.info;
            break;
        case SPDialogToastStyleWarning:
            label.textColor = SPColor.white;
            label.backgroundColor = SPColor.warning;
            break;
        case SPDialogToastStyleError:
            label.textColor = SPColor.white;
            label.backgroundColor = SPColor.danger;
            break;
        default:{
            label.textColor = SPColor.text;
            label.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
        }
    }
    
    label.layer.cornerRadius = 4;
    label.clipsToBounds = YES;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:content];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 4;
    paragraphStyle.firstLineHeadIndent = 20;
    paragraphStyle.headIndent = 10;
    paragraphStyle.tailIndent = -10;
    paragraphStyle.alignment = NSTextAlignmentJustified;
    paragraphStyle.baseWritingDirection = SPTheme.getWritingDirection;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, content.length)];
    label.attributedText = attributedString;
    [label sizeToFit];
    CGFloat maxWidth = [UIScreen mainScreen].bounds.size.width - 100;
    NSInteger lines = ceil(label.frame.size.width/maxWidth);
    if(lines > 1){
        label.numberOfLines = lines+1;
        label.frame = CGRectMake(0, 0, maxWidth, (label.frame.size.height + 5) * lines+1);
        CGSize size = label.frame.size;
        SPLayout.layout(label).size(CGSizeMake(size.width,size.height + 20)).install();
    }else{
        label.attributedText = nil;
        label.text = content;
        [label sizeToFit];
        CGSize size = label.frame.size;
        SPLayout.layout(label).size(CGSizeMake(size.width + 20,size.height + 20)).install();
    }
    SPDialog *dialog = [SPDialog create:label];
    dialog.showMask = NO;
    dialog.animationType = SPDialogAnimationTypeToast;
    [dialog show];
    [dialog performSelector:@selector(dismiss) withObject:nil afterDelay:delay];
    return dialog;
}

- (instancetype)init{
    self = [super init];
    if(self){
        self.showMask = YES;
    }
    return self;
}

//setupview
- (void)setupView{
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    window.windowLevel = UIWindowLevelAlert;
    window.backgroundColor = [UIColor clearColor];
    window.hidden = NO;
    self.window = window;
    
    //view controller
    UIViewController *viewController = [[UIViewController alloc] init];
    viewController.view.backgroundColor = _showMask?[UIColor colorWithWhite:0 alpha:0.3]:[UIColor clearColor];
    viewController.view.alpha = 0.0;
    
    if(_showMask){
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        tapGesture.delegate = self;
        [viewController.view addGestureRecognizer:tapGesture];
    }
    
    self.viewController = viewController;
    window.rootViewController = viewController;

    if(self.customContentView == nil){
        [self setupDefaultView];
    }else{
        [self.viewController.view addSubview:self.customContentView];
    }
    
    //layout
    [self layout];
}


//setup default view
- (void)setupDefaultView{
    //container view
    UIView *containerView = [[UIView alloc] init];
    containerView.backgroundColor = SPColor.secondBackground;
    containerView.layer.cornerRadius = 8;
    containerView.clipsToBounds = YES;
    [self.viewController.view addSubview:containerView];
    self.containerView = containerView;
    
    //title label
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = SPColor.primary;
    titleLabel.font = SPFont.title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [containerView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    //content label
    UITextView *contentView = [[UITextView alloc] init];
    contentView.textColor = SPColor.text;
    contentView.font = SPFont.body;
    contentView.textAlignment = NSTextAlignmentCenter;
    contentView.editable = NO;
    contentView.scrollEnabled = NO;
    contentView.backgroundColor = [UIColor clearColor];
    
    [containerView addSubview:contentView];
    self.contentView = contentView;
    
    //cancel button
    UIButton *cancelButton = [[UIButton alloc] init];
    cancelButton.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.1];
    [cancelButton setTitleColor:SPColor.text forState:UIControlStateNormal];
    cancelButton.titleLabel.font = SPFont.smallBody;
    [cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [containerView addSubview:cancelButton];
    self.cancelButton = cancelButton;
    
    //confirm button
    UIButton *confirmButton = [[UIButton alloc] init];
    confirmButton.backgroundColor = SPColor.primary;
    [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    confirmButton.titleLabel.font = SPFont.smallBody;
    [confirmButton addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
    [containerView addSubview:confirmButton];
    self.confirmButton = confirmButton;
}

- (void)makeContentViewJustify{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;
    paragraphStyle.alignment = NSTextAlignmentJustified;
    
    NSWritingDirection direction = NSWritingDirectionRightToLeft;
    if(SPTheme.getTextAlignment == NSTextAlignmentLeft){
        direction = NSWritingDirectionLeftToRight;
    }
    paragraphStyle.baseWritingDirection = direction;
    
    //color attribute
    NSDictionary *attributes = @{
        NSParagraphStyleAttributeName: paragraphStyle,
        NSFontAttributeName: self.contentView.font,
        NSForegroundColorAttributeName: self.contentView.textColor,
    };
    self.contentView.attributedText = [[NSAttributedString alloc] initWithString:self.content attributes:attributes];
}

//layout
- (void)layout{
    
    if(self.customContentView){
        [self layoutContainerView:self.customContentView];
    }else{
        [self layoutContainerView:self.containerView];
        
        SPLayout.layout(self.titleLabel)
            .centerX(self.containerView)
            .topToTopOfMargin(self.containerView,20)
            .install();
        
        SPLayout.layout(self.contentView)
            .topToBottomOfMargin(self.titleLabel,10)
            .rightToRightOfMargin(self.containerView,15)
            .leftToLeftOfMargin(self.containerView,15)
            .install();
        
        SPLayout.layout(self.cancelButton)
            .topToBottomOfMargin(self.contentView,20)
            .leftToLeftOf(self.containerView)
            .bottomToBottomOf(self.containerView)
            .height(44)
            .install();
        
        SPLayout.layout(self.confirmButton)
            .centerY(self.cancelButton)
            .leftToRightOf(self.cancelButton)
            .rightToRightOf(self.containerView)
            .height(44)
            .widthEqual(self.cancelButton)
            .install();
    }
}

//layout for animation
-(void)layoutContainerView:(UIView *)containerView{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    SPLayout *layout = SPLayout.update(containerView);
    switch (self.animationType) {
        case SPDialogAnimationTypeSlideLeft:
            layout.centerY(self.viewController.view).centerXMargin(self.viewController.view,screenSize.width);
            break;
        case SPDialogAnimationTypeSlideRight:
            layout.centerY(self.viewController.view).centerXMargin(self.viewController.view,screenSize.width * -1);
            break;
        case SPDialogAnimationTypeSlideBottom:
            layout.centerX(self.viewController.view).centerYMargin(self.viewController.view,screenSize.height);
            break;
        case SPDialogAnimationTypeSlideTop:
            layout.centerX(self.viewController.view).centerYMargin(self.viewController.view,screenSize.height * -1);
            break;
        case SPDialogAnimationTypeToast:
            layout.bottomToBottomOfMargin(self.viewController.view,-1 * containerView.frame.size.height).centerX(self.viewController.view);
            break;
        default:
            layout.center(self.viewController.view);
            break;
    }
    if(self.customContentView == nil){
        layout.widthEqualWithMultiplier(self.viewController.view,0.8);
    }
    layout.install();
}

- (UILabel *)getTitleLabel{
    return self.titleLabel;
}

- (UITextView *)getContentView{
    return self.contentView;
}

- (UIButton *)getCancelButton{
    return self.cancelButton;
}

- (UIButton *)getConfirmButton{
    return self.confirmButton;
}

//cancel action
- (void)cancelAction{
    [self dismiss];
}

//confirm action
- (void)confirmAction{
    if(self.onConfirm){
        self.onConfirm();
        [self dismiss];
    }
}

- (void)show {
    
    [self setupView];
    
    [self.window makeKeyAndVisible];
    
    //after 100ms
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.viewController.view.alpha = 1;
            
            UIView *containerView = self.customContentView ? self.customContentView : self.containerView;
            
            switch (self.animationType) {
                case SPDialogAnimationTypeSlideBottom:
                case SPDialogAnimationTypeSlideTop:{
                    SPLayout.update(containerView)
                        .centerYMargin(self.viewController.view,0)
                        .install();
                    break;
                }
                case SPDialogAnimationTypeSlideLeft:
                case SPDialogAnimationTypeSlideRight:{
                    SPLayout.update(containerView)
                        .centerXMargin(self.viewController.view,0)
                        .install();
                    break;
                }
                case SPDialogAnimationTypeToast:
                    SPLayout.update(containerView)
                        .bottomToBottomOfMargin(self.viewController.view,100)
                        .install();
                    break;
                default:
                    break;
            }
            [self.viewController.view layoutIfNeeded];
        } completion:nil];
        
    });
    
    if(self.customContentView == nil){
        self.titleLabel.text = self.title;
        if([self.title isEqualToString:@""]){
            SPLayout.update(self.titleLabel).height(0).install();
            SPLayout.update(self.contentView).topToTopOfMargin(self.containerView,10).install();
            [self.containerView layoutIfNeeded];
        }
        if(self.attributedContent){
            self.contentView.attributedText = self.attributedContent;
        }else{
            self.contentView.text = self.content;
            [self makeContentViewJustify];
        }
        [self.cancelButton setTitle:self.cancel forState:UIControlStateNormal];
        [self.confirmButton setTitle:self.confirm forState:UIControlStateNormal];
    }
    
}

- (void)dismiss {
    [UIView animateWithDuration:0.3 animations:^{
        [self dismissAnimation];
    } completion:^(BOOL finished) {
        if(self.onDismiss){
            self.onDismiss();
        }
        self.window.hidden = YES;
        [[SPDialogManager sharedInstance] removeDialog:[NSString stringWithFormat:@"%p", self]];
    }];
}

- (void)dismissAnimation{
    self.viewController.view.alpha = 0.0;
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    UIView *containerView = self.customContentView ? self.customContentView : self.containerView;
    SPLayout *layout = SPLayout.update(containerView);
    switch (self.animationType) {
        case SPDialogAnimationTypeSlideTop:
            layout.centerYMargin(self.viewController.view,screenSize.height);
            break;
        case SPDialogAnimationTypeSlideBottom:
            layout.centerYMargin(self.viewController.view,screenSize.height * -1);
            break;
        case SPDialogAnimationTypeSlideLeft:
            layout.centerXMargin(self.viewController.view,screenSize.width * -1);
            break;
        case SPDialogAnimationTypeSlideRight:
            layout.centerXMargin(self.viewController.view,screenSize.width);
            break;
        case SPDialogAnimationTypeToast:
            layout.bottomToBottomOfMargin(self.viewController.view,-1 * containerView.frame.size.height);
            break;
        default:
            break;
    }
    layout.install();
    [self.viewController.view layoutIfNeeded];
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if(touch.view == self.viewController.view){
        return YES;
    }
    return NO;
}

@end
