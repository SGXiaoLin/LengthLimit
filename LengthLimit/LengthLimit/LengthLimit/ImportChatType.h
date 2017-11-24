//
//  ImportChatType.h
//  LengthLimit
//
//  Created by Mac mini on 2017/11/24.
//  Copyright © 2017年 Azcdragon. All rights reserved.
//

#ifndef ImportChatType_h
#define ImportChatType_h

typedef NS_ENUM(NSInteger,ImportChatType) {
    ImportChatTypeNumber,                           //纯数字
    ImportChatTypeEnglish,                          //英文
    ImportChatTypeChinese,                          //汉字
    ImportChatTypePunctuation,                      //标点
    ImportChatTypeNumberAndEnglish,                 //数字加英文
    ImportChatTypeNumberAndChinese,                 //数字加中文
    ImportChatTypeNumberAndPunctuation,             //数字加标点
    ImportChatTypeEnglishAndChinese,                //英文加中文
    ImportChatTypeEnglishAndPunctuation,            //英文加标点
    ImportChatTypeChineseAndPunctuation,            //中文加标点
    ImportChatTypeNumberEnglishChinese,             //数字中文英文
    ImportChatTypeNumberEnglishChinesePunctuation,  //数字中文英文标点
    ImportChatTypeAll,                              //不限
};
#endif /* ImportChatType_h */
