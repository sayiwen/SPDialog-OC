//
//  SPDialog.h
//  SPDialog
//
//  Created by GheniAblez on 2023/8/21.
//

#import <Foundation/Foundation.h>
#import <SPTheme/SPTheme.h>

NS_ASSUME_NONNULL_BEGIN

//animation type enum
typedef NS_ENUM(NSUInteger, SPDialogAnimationType) {
    SPDialogAnimationTypeNone,
    SPDialogAnimationTypeFade,
    SPDialogAnimationTypeSlideBottom,
    SPDialogAnimationTypeSlideTop,
    SPDialogAnimationTypeSlideLeft,
    SPDialogAnimationTypeSlideRight,
    SPDialogAnimationTypeToast,
};
//toast style enum
typedef NS_ENUM(NSUInteger, SPDialogToastStyle) {
    SPDialogToastStyleDefault,
    SPDialogToastStyleSuccess,
    SPDialogToastStyleError,
    SPDialogToastStyleWarning,
    SPDialogToastStyleInfo
};

@interface SPDialog : NSObject

#pragma mark - dialog
+ (SPDialog *)create:(NSString *)title attributedContent:(NSAttributedString *)content cancel:(NSString *)cancel confirm:(NSString *)confirm;

+ (SPDialog *)create:(NSString *)title content:(NSString *)content cancel:(NSString *)cancel confirm:(NSString *)confirm;

+ (SPDialog *)create:(NSString *)title content:(NSString *)content;

+ (SPDialog *)createWithContent:(NSString *)content;

+ (SPDialog *)create:(UIView *)contentView;


#pragma mark - loading
+ (SPDialog *)loading;

+ (SPDialog *)loadingHideAfter:(NSTimeInterval)delay;

+ (SPDialog *)loadingHideAfter:(NSTimeInterval)delay animationType:(SPDialogAnimationType)animationType;


#pragma mark - toast
+ (SPDialog *)toast:(NSString *)content;

+ (SPDialog *)toast:(NSString *)content hideAfter:(NSTimeInterval)delay;

+ (SPDialog *)toast:(NSString *)content hideAfter:(NSTimeInterval)delay style:(SPDialogToastStyle)style;

//on confirm callback
@property (nonatomic, copy) void (^onConfirm)(void);

//ond dismiss callback
@property (nonatomic, copy) void (^onDismiss)(void);

//dialog animation type
@property (nonatomic, assign) SPDialogAnimationType animationType;

//show mask
@property (nonatomic, assign) BOOL showMask;

//show dialog
- (void)show;

//dismiss dialog
- (void)dismiss;

- (UIButton *)getCancelButton;

- (UIButton *)getConfirmButton;

//title label
- (UILabel *)getTitleLabel;

//content label
- (UITextView *)getContentView;

@end

NS_ASSUME_NONNULL_END
