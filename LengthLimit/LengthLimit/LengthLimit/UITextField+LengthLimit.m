//
//  UITextField+LengthLimit.m
//  LengthLimit
//
//  Created by Mac mini on 2017/11/24.
//  Copyright © 2017年 Azcdragon. All rights reserved.
//

#import "UITextField+LengthLimit.h"
#import <objc/runtime.h>

@implementation UITextField (LengthLimit)


- (void)setMAXLENGTH:(NSNumber *)_MAXLENGTH {
    objc_setAssociatedObject(self, @"MAXLENGTH", _MAXLENGTH, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)MAXLENGTH {
    return objc_getAssociatedObject(self, @"MAXLENGTH");
}
- (void)setRegular:(NSNumber *)_regular {
    objc_setAssociatedObject(self, @"regular", _regular, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)regular {
    return objc_getAssociatedObject(self, @"regular");
}
- (void)setTextRang:(NSRange )_textRang {
    NSValue *value = [NSValue valueWithRange:_textRang];
    objc_setAssociatedObject(self, @"textRang",value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSRange )textRang {
    NSValue *rang = objc_getAssociatedObject(self, @"textRang");
    return rang.rangeValue;
}
/**********text光标位置的获取************/
- (NSRange) selectedRangeTextField
{
    UITextPosition* beginning = self.beginningOfDocument;
    
    UITextRange* selectedRange = self.selectedTextRange;
    UITextPosition* selectionStart = selectedRange.start;
    UITextPosition* selectionEnd = selectedRange.end;
    
    const NSInteger location = [self offsetFromPosition:beginning toPosition:selectionStart];
    const NSInteger length = [self offsetFromPosition:selectionStart toPosition:selectionEnd];
    
    return NSMakeRange(location, length);
}
//光标的赋值
- (void) setSelectedRange:(NSRange) range  // 备注：UITextField必须为第一响应者才有效
{
    if (range.location >= [self.MAXLENGTH integerValue]) {
        return;
    }
    UITextPosition* beginning = self.beginningOfDocument;
    
    UITextPosition* startPosition = [self positionFromPosition:beginning offset:range.location];
    UITextPosition* endPosition = [self positionFromPosition:beginning offset:range.location + range.length];
    UITextRange* selectionRange = [self textRangeFromPosition:startPosition toPosition:endPosition];
    
    [self setSelectedTextRange:selectionRange];
}
/*************************/

- (void)addObserverTextChangeWithMAXLENGTH:(NSInteger)MAXLENGTH WithType:(ImportChatType)type{
    self.MAXLENGTH = [NSNumber numberWithInteger:MAXLENGTH];
    self.regular = [self ImportChatTypeToRegular:type];
    [self addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
}
- (void)textFieldDidChange:(id)sender
{
    self.textRang = [self selectedRangeTextField];
    NSLog(@"length:%ld    location:%ld",self.textRang.length,self.textRang.location);
    
    UITextField *textField = self;
    NSString *toBeString = textField.text;
    
    //获取高亮部分
    UITextRange *selectedRange = [textField markedTextRange];
    UITextPosition *position1 = [textField positionFromPosition:selectedRange.start offset:0];
    
    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!position1 || !selectedRange)
        {
        //        NSString *patth = [self ImportChatTypeToRegular:self.importType];
        if (self.regular.length) {
            toBeString = [self stringisMyNeed:self.text andPattern:self.regular];
            textField.text = toBeString;
        }
        if (toBeString.length > [self.MAXLENGTH integerValue])
            {
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:[self.MAXLENGTH integerValue]];
            if (rangeIndex.length == 1)
                {
                textField.text = [toBeString substringToIndex:[self.MAXLENGTH integerValue]];
                }
            else
                {
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, [self.MAXLENGTH integerValue])];
                textField.text = [toBeString substringWithRange:rangeRange];
                }
            }
        }
    [self setSelectedRange:self.textRang];
}
- (NSString *)ImportChatTypeToRegular:(ImportChatType)type{
    NSString *retuStr;
    switch (type) {
        case ImportChatTypeNumber:
            retuStr = @"[0-9]";
            break;
        case ImportChatTypeEnglish:
            retuStr = @"[A-Za-z]";
            break;
        case ImportChatTypeChinese:
            retuStr = @"[\u4e00-\u9fa5]";
            break;
        case ImportChatTypePunctuation:
            retuStr = @"[\\p{P}\\p{Z}+=^~<>$¥]";
            break;
        case ImportChatTypeNumberAndEnglish:
            retuStr = @"[0-9]|[A-Za-z]";
            break;
        case ImportChatTypeNumberAndChinese:
            retuStr = @"[0-9]|[\u4e00-\u9fa5]";
            break;
        case ImportChatTypeNumberAndPunctuation:
            retuStr = @"[0-9]|[\\p{P}\\p{Z}+=^~<>$¥]";
            break;
        case ImportChatTypeEnglishAndChinese:
            retuStr = @"[A-Za-z\u4e00-\u9fa5]";
            break;
        case ImportChatTypeEnglishAndPunctuation:
            retuStr = @"[A-Za-z]|[\\p{P}\\p{Z}+=^~<>$¥]";
            break;
        case ImportChatTypeChineseAndPunctuation:
            retuStr = @"[\u4e00-\u9fa5]|[\\p{P}\\p{Z}+=^~<>$¥]";
            break;
        case ImportChatTypeNumberEnglishChinese:
            retuStr = @"[0-9A-Za-z\u4e00-\u9fa5]";
            break;
        case ImportChatTypeNumberEnglishChinesePunctuation:
            retuStr = @"[0-9A-Za-z\u4e00-\u9fa5]|[\\p{P}\\p{Z}+=^~<>$¥]";
            break;
        case ImportChatTypeAll:
            retuStr = @"";
            break;
            
        default:
            break;
    }
    return retuStr;
}
- (NSString *)stringisMyNeed:(NSString *)str andPattern:(NSString *)pattern{
    
    NSRange range;
    for(int i=0; i<str.length; i+=range.length){
        range = [str rangeOfComposedCharacterSequenceAtIndex:i];
        NSString *s = [str substringWithRange:range];
        BOOL isdel = [self isNeed:s WithPattern:pattern];
        if (!isdel) {
            str = [str stringByReplacingCharactersInRange:range withString:@""];
            i-=range.length;
        }
    }
    return str;
}

- (BOOL)isNeed:(NSString *)str WithPattern:(NSString *)pattern{
    //[0-9]|[A-Za-z]|[\u4e00-\u9fa5]
    NSRegularExpression *tLetterRegularExpression = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSUInteger tLetterMatchCount = [tLetterRegularExpression numberOfMatchesInString:str options:NSMatchingReportProgress range:NSMakeRange(0, str.length)];
    //    NSLog(@"%ld",tLetterMatchCount);
    if(tLetterMatchCount>=1){
        return YES;
    }else{
        self.textRang = NSMakeRange(self.textRang.location - 1, self.textRang.length);
        return NO;
    }
}





@end
