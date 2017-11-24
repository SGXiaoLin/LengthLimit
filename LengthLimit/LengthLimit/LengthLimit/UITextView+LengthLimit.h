//
//  UITextView+LengthLimit.h
//  LengthLimit
//
//  Created by Mac mini on 2017/11/24.
//  Copyright © 2017年 Azcdragon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImportChatType.h"

@interface UITextView (LengthLimit)


@property (nonatomic,strong)NSNumber *MAXLENGTH;//传入Integer类型的数据，
@property (nonatomic,copy)NSString *regular;//输入的数据类型的正则，
@property (nonatomic,assign) NSRange textRang;//光标的位置


- (void)addObserverTextChangeWithMAXLENGTH:(NSInteger)MAXLENGTH WithType:(ImportChatType)type;


@end
