# SPDialog

[![CI Status](https://img.shields.io/travis/sayiwen/SPDialog.svg?style=flat)](https://travis-ci.org/sayiwen/SPDialog)
[![Version](https://img.shields.io/cocoapods/v/SPDialog.svg?style=flat)](https://cocoapods.org/pods/SPDialog)
[![License](https://img.shields.io/cocoapods/l/SPDialog.svg?style=flat)](https://cocoapods.org/pods/SPDialog)
[![Platform](https://img.shields.io/cocoapods/p/SPDialog.svg?style=flat)](https://cocoapods.org/pods/SPDialog)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.


## Usage
```objc

#import <SPDialog/SPDialog.h>

NSString *content = @"«يەنە بىر شەھەر» تور تىياتىرىدا ھەربىر ئوبرازنىڭ ئۆزىگە تەۋە ھېكايىسى بولىدۇ. ھەربىر ئوبراز ئاساسلىق لىنىيەگە زىچ مۇناسىۋەتلىك بولۇپ، كىشىلەر قەلبىدىكى قاراڭغۇلۇقنى، يەنى مەنپەئەتپەرەسلىك، نەپسانىيەتچىلىك، شۆھرەتپەرەسلىكنى خۇددى يوللۇقتەك كۆرسىتىپ يورۇقلۇققا ئەپ چىققۇچى ئوبراز ئىسكەندەر ئەپەندى بىلەن كىشىلەر قەلبىدىكى ئاق كۆڭۈللۈك، ئاددىي- ساددىلىق، قانائەت ۋە ئەقىل-پاراسەت، مەردۇ-مەردانىلىككە سىمۋول قىلىنغان قەھۋەخانا خوجايىنى سۇلايمان ئەپەندىم ئىككىسىنىڭ نەچچە ئەسىرلەردىن بۇيان داۋام ئېتىپ كېلىۋاتقان زىددىيىتى سۆزلىنىدۇ. بۇ زىددىيەت ئىككى ئوبرازنىڭ بىۋاستە ئۇچرىشىشىدىن ئەمەس بەلكى «يەنە بىر شەھەر»دىكى، بارلىق ئاددىي كىشىلەردىن تارتىپ يۇقىرى قاتلامدىكى باي كارخانىچىلارغىچە، ئالاھىدە ئىقتىدارلىق كىشىلەرگىچە ئايرىم-ئايرىم ھېكايىسىنىڭ باغلىنىشىدىن شەكىللىنىدۇ ھەم راۋاجلىنىدۇ. ";

SPDialog *dialog = [SPDialog create:SPString(@"ئەسكەرتىش") content:content];
dialog.animationType = SPDialogAnimationTypeSlideLeft;
[dialog show];
dialog.onConfirm = ^{
    NSLog(@"confirm");
};

SPDialog *loadingDialog = [SPDialog loading];
dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [loadingDialog dismiss];
});
//[SPDialog loadingHideAfter:3 animationType:SPDialogAnimationTypeSlideRight];

//create 4 toast style
NSArray *styles = @[
    @(SPDialogToastStyleSuccess),
    @(SPDialogToastStyleError),
    @(SPDialogToastStyleWarning),
    @(SPDialogToastStyleInfo)
];
for (int i = 0; i < styles.count; i++) {
    SPDialogToastStyle style = [styles[i] integerValue];
    //run after i sec
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(i * 2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SPDialog toast:@"ياخشىمۇ سىز ئەپەندىم " hideAfter:2 style:style];
    });

}
```

![image](https://raw.githubusercontent.com/sayiwen/SPDialog-OC/main/demo.png)

## Requirements

## Installation

SPDialog is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'SPDialog'
```

## Author

sayiwen, sayiwen@163.com

## License

SPDialog is available under the MIT license. See the LICENSE file for more info.
