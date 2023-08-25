//
//  SPViewController.m
//  SPDialog
//
//  Created by sayiwen on 08/21/2023.
//  Copyright (c) 2023 sayiwen. All rights reserved.
//

#import "SPViewController.h"
#import <SPDialog/SPDialog.h>
#import <SPLayout/SPLayout.h>


@interface SPViewController ()

@end

@implementation SPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = SPColor.background;
	// Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)showDialog:(id)sender {
    
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
