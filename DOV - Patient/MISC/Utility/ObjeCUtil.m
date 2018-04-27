//
//  ObjeCUtil.m
//  Bosala
//


//http://iossolves.blogspot.in/2014/01/encoding-emoji-characters-iosobjectivec.html


#import "ObjeCUtil.h"
#import <UIKit/UIKit.h>

@implementation ObjeCUtil

+ (NSString *)getEncodeEmojiMessage:(NSString *)msg {
    
    NSString *uniText       = [NSString stringWithUTF8String:[msg UTF8String]];
    NSData *msgData         = [uniText dataUsingEncoding:NSNonLossyASCIIStringEncoding];
    NSString *encodedMsg    = [[NSString alloc] initWithData:msgData encoding:NSUTF8StringEncoding];
    //NSLog(@"Encoded Message:%@",encodedMsg);
    return encodedMsg;
}

+ (NSString *)getDecodeEmojiMessage:(NSString *)msg {
    /* NSString *str = @"Happy to help you \U0001F608";
     
     NSData *data = [str dataUsingEncoding:NSNonLossyASCIIStringEncoding];
     NSString *valueUnicode = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
     
     
     NSData *dataa = [valueUnicode dataUsingEncoding:NSUTF8StringEncoding];
     NSString *valueEmoj = [[NSString alloc] initWithData:dataa encoding:NSNonLossyASCIIStringEncoding];
     NSLog(@"emojiString: %@", valueEmoj);
     //cell.textView.text = valueEmoj;*/
    
    const char *jsonString      = [msg UTF8String];
    NSData *jsonData            = [NSData dataWithBytes: jsonString length:strlen(jsonString)];
    NSString *msgString         = [[NSString alloc] initWithData:jsonData encoding: NSNonLossyASCIIStringEncoding];
   // NSLog(@"Decoded Message:%@",msgString);
    return msgString;
}

/**
 **     Display LikeTumb Image as an attachement on Chat Cell
 **/

+ (NSAttributedString *)getAttributeMessage:(NSString *)text
{
    static NSString * kLikeTumbImageE = @"socialyoulike";

    //**    Find out Range where we want to show image
    NSRange rangeOfImage = [text rangeOfString:kLikeTumbImageE];
    NSTextAttachment *attachment    = [[NSTextAttachment alloc] init];
    attachment.image                = [UIImage  imageNamed:kLikeTumbImageE];
    
    NSAttributedString *attachmentString    = [NSAttributedString attributedStringWithAttachment:attachment];
    
    NSMutableAttributedString *attribString   = [[NSMutableAttributedString alloc] initWithString:text];
    
    [attribString replaceCharactersInRange:rangeOfImage withAttributedString:attachmentString];
    return attribString;
}


@end
