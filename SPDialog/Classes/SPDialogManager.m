//
//  SPDialogManager.m
//  SPDialog
//
//  Created by GheniAblez on 2023/8/21.
//

#import "SPDialogManager.h"

@interface SPDialogManager()

@property (nonatomic, strong) NSMutableDictionary *dialogDic;

@end

@implementation SPDialogManager

+ (instancetype)sharedInstance {
    static SPDialogManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SPDialogManager alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _dialogDic = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)addDialog:(SPDialog *)dialog key:(NSString *)key {
    if (!dialog || !key) {
        return;
    }
    [_dialogDic setObject:dialog forKey:key];
}

- (void)removeDialog:(NSString *)key {
    if (!key) {
        return;
    }
    [_dialogDic removeObjectForKey:key];
}

@end
