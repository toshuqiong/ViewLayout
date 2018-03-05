//
//  DLListTextStyle.m
//  PocketSLH
//
//  Created by LiYanQin on 2017/12/22.
//

#import "DLListTextStyle.h"
#import "DLStyleService.h"
#import "DLViewLayoutTags.h"

@implementation DLListTextStyle

+ (NSDictionary *)textNodeStyle:(NSDictionary *)style {
    NSMutableParagraphStyle *ps = [[NSMutableParagraphStyle alloc] init];
    [ps setAlignment:NSTextAlignmentLeft];
    
    UIFont *font = [self fontWithStyle:style];
    UIColor *color = [self colorWithStyle:style];
    NSTextAlignment textAlign = [self textAlignWithStyle:style];
    if (textAlign) {
        [ps setAlignment:textAlign];
    }
    
    return @{
             NSFontAttributeName:font ? font: [UIFont systemFontOfSize:13.0],
             NSForegroundColorAttributeName: color ? color:[DLStyleService colorFromHexString:@"#9d9d9d"],
             NSParagraphStyleAttributeName:ps
             };
}

+ (UIFont *)fontWithStyle:(NSDictionary *)style {
    NSString *font = style[DLMCFontSizeTag];
    NSString *destfont = nil;
    if (font) {
        destfont = [font substringToIndex:font.length-2];
        return [UIFont systemFontOfSize:destfont.integerValue];
    }
    return nil;
}

+ (UIColor *)colorWithStyle:(NSDictionary *)style {
    NSString *color = style[DLMCColorTag];
    if (color) {
        return [DLStyleService colorFromHexString:color];
    }
    return nil;
}

+ (NSTextAlignment)textAlignWithStyle:(NSDictionary *)style {
    NSString *textAlign = style[DLMCTextAlignTag];
    if (textAlign) {
        if ([textAlign isEqualToString:@"center"]) {
            return NSTextAlignmentCenter;
        }else if ([textAlign isEqualToString:@"left"]) {
            return NSTextAlignmentLeft;
        }else if ([textAlign isEqualToString:@"right"]) {
            return NSTextAlignmentRight;
        }
    }
    return NSTextAlignmentLeft;
}

@end
