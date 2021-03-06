//
//  DLASyncDisplayLayoutSvc.h
//  PocketSLH
//
//  Created by LiYanQin on 2018/2/6.
//  11

#import <Foundation/Foundation.h>
#import <AsyncDisplayKit/AsyncDisplayKit.h>

//@import AsyncDisplayKit;

@interface DLASyncDisplayLayoutSvc : NSObject

/**
 *  @author liyanqin
 *
 *  初始化布局服务类
 *
 *  @param style xml文件样式
 *
 */
- (instancetype)initWithStyle:(NSDictionary *)style;

- (id<ASLayoutElement>)textNodeWithContentItem:(NSDictionary *)contentItem;

- (id<ASLayoutElement>)displayNodeWithContentItem:(NSDictionary *)contentItem;

- (id<ASLayoutElement>)imageNodeWithContentItem:(NSMutableDictionary *)contentItem;

- (ASLayoutSpec *)layoutWithNodeItem:(NSMutableDictionary *)nodeItem;

- (NSDictionary *)styleWithContentItem:(NSMutableDictionary *)contentItem;

@end
