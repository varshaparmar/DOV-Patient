//
//  ObjeCUtil.h
//  Bosala
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ObjeCUtil : NSObject

+(NSString *)getEncodeEmojiMessage:(NSString *)msg;
+(NSString *)getDecodeEmojiMessage:(NSString *)msg;
+(NSAttributedString *)getAttributeMessage:(NSString *)text;

@end
