//
//  DLASyncDisplayLayoutSvc.m
//  PocketSLH
//
//  Created by LiYanQin on 2018/2/6.
//

#import "DLASyncDisplayLayoutSvc.h"
#import "DLViewLayoutTags.h"
#import "DLStyleService.h"

@interface DLASyncDisplayLayoutSvc ()

@property (nonatomic, strong) NSDictionary *style;

@end

@implementation DLASyncDisplayLayoutSvc

- (instancetype)initWithStyle:(NSDictionary *)style {
    if (self = [super init]) {
        _style = style;
    }
    return self;
}

- (void)setupNode:(ASDisplayNode *)node withStyle:(NSDictionary *)style {
    //在默认样式下自定义常规属性
    NSString *width = style[DLMCWidthTag];
    if (width && [width hasSuffix:@"pt"]) {
        node.style.width = ASDimensionMake(width);
    }else if(width && [width hasSuffix:@"%"]) {
        NSString *subWidth = [width substringToIndex:width.length - 1];
        float destWidth = subWidth.floatValue - 1;
        node.style.width = ASDimensionMake([NSString stringWithFormat:@"%f%%",destWidth]);
    }
    
    NSString *maxWidth = style[@"max-width"];
    node.style.maxWidth = ASDimensionMake(maxWidth);
    
    NSString *height = style[DLMCHeightTag];
    if (height) {
        node.style.height = ASDimensionMake(height);
    }
    
    NSString *color = style[DLMCBackgroundColorTag];
    if (color) {
        node.backgroundColor = [DLStyleService colorFromHexString:color];
    }
}

/**
 *  @author liyanqin
 *
 *  单个文本样式
 *
 */
- (id<ASLayoutElement>)textNodeWithContentItem:(NSMutableDictionary *)contentItem {
    ASTextNode *node = [[ASTextNode alloc] init];
    NSDictionary *style = [self styleWithContentItem:contentItem];
    [self setupNode:node withStyle:style];
    return [self configureSpecMargin:node withStyle:style];
}

- (id<ASLayoutElement>)displayNodeWithContentItem:(NSMutableDictionary *)contentItem {
    ASDisplayNode *node = [[ASDisplayNode alloc] init];
    NSDictionary *style = [self styleWithContentItem:contentItem];
    [self setupNode:node withStyle:style];
    return [self configureSpecMargin:node withStyle:style];
}

/**
 *  @author liyanqin
 *
 *  cell布局
 *
 */
- (ASLayoutSpec *)layoutWithNodeItem:(NSMutableDictionary *)nodeItem {
    NSMutableArray *children = nodeItem[DLMCChildrenFieldsTag];
    if (children) {
        NSMutableArray *allStack = [[NSMutableArray alloc] init];
        for (id item in children) {
            if ([[item class] isSubclassOfClass:[NSMutableDictionary class]]) {
                ASLayoutSpec *stack = [self layoutWithNodeItem:item];
                if (stack) {
                    [allStack addObject:stack];
                }
            }else {
//                if ([[item class] isSubclassOfClass:[ASImageNode class]]) {
//                    ASRatioLayoutSpec *newImageNode = [ASRatioLayoutSpec ratioLayoutSpecWithRatio:1 child:item];
//                    newImageNode.style.width = ((ASImageNode *)item).style.width;
//                    [allStack addObject:newImageNode];
//                }else {
                    [allStack addObject:item];
//                }
                
            }
        }
        nodeItem[DLMCChildrenFieldsTag] = allStack;
        return [self contentLayoutSpecWithContentItem:nodeItem];
    }
    return nil;
}

//布局解析
- (ASLayoutSpec *)contentLayoutSpecWithContentItem:(NSMutableDictionary *)contentItem  {
    NSMutableArray *childrenFields = contentItem[DLMCChildrenFieldsTag];
    ASLayoutSpec *Spec;
    if (childrenFields.count > 0) {
        NSDictionary *styleValue = [self styleWithContentItem:contentItem];
        
        NSString *flex_direction = styleValue[DLMCFlexDirectionTag];
        ASStackLayoutDirection direction;
        if ([flex_direction isEqualToString:@"row"]) {
            direction = ASStackLayoutDirectionHorizontal;
        }else {
            direction = ASStackLayoutDirectionVertical;
        }
        
        NSString *justify_content = styleValue[DLMCJustifyContentTag];
        ASStackLayoutJustifyContent justifyContent = ASStackLayoutJustifyContentStart;
        if ([justify_content isEqualToString:@"flex-start"]) {
            justifyContent = ASStackLayoutJustifyContentStart;
        }else if ([justify_content isEqualToString:@"center"]) {
            justifyContent = ASStackLayoutJustifyContentCenter;
        }else if ([justify_content isEqualToString:@"flex-end"]) {
            justifyContent = ASStackLayoutJustifyContentEnd;
        }else if ([justify_content isEqualToString:@"space-between"]) {
            justifyContent = ASStackLayoutJustifyContentSpaceBetween;
        }else if ([justify_content isEqualToString:@"space-around"]) {
            justifyContent = ASStackLayoutJustifyContentSpaceAround;
        }
        
        NSString *align_items = styleValue[DLMCAlignItemsTag];
        ASStackLayoutAlignItems alignItems = ASStackLayoutAlignItemsStart;
        if ([align_items isEqualToString:@"flex-start"]) {
            alignItems = ASStackLayoutAlignItemsStart;
        }else if ([align_items isEqualToString:@"center"]) {
            alignItems = ASStackLayoutAlignItemsCenter;
        }else if ([align_items isEqualToString:@"flex-end"]) {
            alignItems = ASStackLayoutAlignItemsEnd;
        }else if ([align_items isEqualToString:@"baseline"]) {
            alignItems = ASStackLayoutAlignItemsBaselineLast;
        }else if ([align_items isEqualToString:@"stretch"]) {
            alignItems = ASStackLayoutAlignItemsStretch;
        }
        
        NSString *flex_wrap = styleValue[DLMCFlexWrapTag];
        ASStackLayoutFlexWrap wrap;
        if ([flex_wrap isEqualToString:@"wrap"]) {
            wrap = ASStackLayoutFlexWrapWrap;
        }else {
            wrap = ASStackLayoutFlexWrapNoWrap;
        }
        
        Spec = [ASStackLayoutSpec stackLayoutSpecWithDirection:direction spacing:0 justifyContent:justifyContent alignItems:alignItems flexWrap:wrap alignContent:ASStackLayoutAlignContentStretch lineSpacing:0 children:childrenFields];
        
        NSString *width = styleValue[DLMCWidthTag];
        if (width) {
            Spec.style.width = ASDimensionMake(width);
        }
        NSString *height = styleValue[DLMCHeightTag];
        if (height) {
            Spec.style.height = ASDimensionMake(height);
        }
        
        Spec = (ASLayoutSpec *)[self configureSpecMargin:Spec withStyle:styleValue];
    }
    return Spec;
}

- (id<ASLayoutElement>)configureSpecMargin:(id<ASLayoutElement>)spec withStyle:(NSDictionary *)styleValue {
    NSString *marginTop = styleValue[DLMCMarginTopTag] ? styleValue[DLMCMarginTopTag]:0;
    NSString *marginLeft = styleValue[DLMCMarginLeftTag] ? styleValue[DLMCMarginLeftTag]:0;
    NSString *marginBottom = styleValue[DLMCMarginBottomTag] ? styleValue[DLMCMarginBottomTag]:0;
    NSString *marginRight = styleValue[DLMCMarginRightTag] ? styleValue[DLMCMarginRightTag]:0;
    
    if (marginTop || marginLeft || marginBottom || marginRight) {
        ASInsetLayoutSpec *insetSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(marginTop.integerValue,marginLeft.integerValue,marginBottom.integerValue,marginRight.integerValue) child:spec];
        return insetSpec;
        
        
    }
    return spec;
}

- (NSDictionary *)styleWithContentItem:(NSMutableDictionary *)contentItem {
    NSString *styleKey = contentItem[DLMCStyleTag];
    NSMutableDictionary *style = [[NSMutableDictionary alloc] init];
    for (NSString *key in [_style allKeys]) {
        if ([key isEqualToString:styleKey]) {
            style = [_style[key] mutableCopy];
            break;
        }
    }
    [style addEntriesFromDictionary:[self subStyleWithContentItem:contentItem]];
    return [style copy];
}

/**
 *  @author liyanqin
 *
 *  行内样式覆盖
 *
 */
- (NSDictionary *)subStyleWithContentItem:(NSMutableDictionary *)contentItem {
    NSMutableDictionary *style = [NSMutableDictionary dictionary];
    NSArray *att = @[DLMCFontSizeTag, DLMCColorTag, DLMCWidthTag, DLMCMarginLeftTag, DLMCHeightTag, DLMCMarginTopTag];
    [contentItem enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([att containsObject:key]) {
            [style setObject:obj forKey:key];
        }
    }];
    return style;
}

@end
