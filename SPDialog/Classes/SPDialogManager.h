//
//  SPDialogManager.h
//  SPDialog
//
//  Created by GheniAblez on 2023/8/21.
//

#import <Foundation/Foundation.h>
#import "SPDialog.h"

NS_ASSUME_NONNULL_BEGIN

@interface SPDialogManager : NSObject

//share instance
+ (instancetype)sharedInstance;

//add dialog
- (void)addDialog:(SPDialog *)dialog key:(NSString *)key;

//remove dialog
- (void)removeDialog:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
