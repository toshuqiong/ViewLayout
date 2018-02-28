//
//  DLListTextStyle.m
//  PocketSLH
//
//  Created by LiYanQin on 2017/12/22.
//

#import "DLListTextStyle.h"

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
             NSForegroundColorAttributeName: color ? color:[self colorFromHexString:@"#9d9d9d"],
             NSParagraphStyleAttributeName:ps
             };
}

+ (UIFont *)fontWithStyle:(NSDictionary *)style {
    NSString *font = style[@"font-size"];
    NSString *destfont = nil;
    if (font) {
        destfont = [font substringToIndex:font.length-2];
        return [UIFont systemFontOfSize:destfont.integerValue];
    }
    return nil;
}

+ (UIColor *)colorWithStyle:(NSDictionary *)style {
    NSString *color = style[@"color"];
    if (color) {
        return [self colorFromHexString:color];
    }
    return nil;
}

+ (NSTextAlignment)textAlignWithStyle:(NSDictionary *)style {
    NSString *textAlign = style[@"text-align"];
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

+ (instancetype)colorFromHexString:(NSString *)hexString
{
    unsigned rgbValue = 0;
    hexString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner scanHexInt:&rgbValue];
    
    return [[self class] colorWithR:((rgbValue & 0xFF0000) >> 16) G:((rgbValue & 0xFF00) >> 8) B:(rgbValue & 0xFF) A:1.0];
}

+ (instancetype)colorWithR:(CGFloat)red G:(CGFloat)green B:(CGFloat)blue A:(CGFloat)alpha
{
    return [[self class] colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:alpha];
}

@end
