//
//  ConfigureFileHelper.m
//  ViewLayout
//
//  Created by LiYanQin on 2018/3/2.
//  Copyright © 2018年 liyanqin. All rights reserved.
//

#import "ConfigureFileHelper.h"
#import "RaptureXML/RXMLElement.h"
#import "DLViewLayoutTags.h"

static NSArray *sectionArray; //消息中心cell类型

static NSDictionary *styleDic; //消息中心style

@implementation ConfigureFileHelper

+ (void)setupData {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"messageCenterPocketslh.xml" ofType:nil];
    NSString *xmlStr = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    RXMLElement *rootElement = [RXMLElement elementFromXMLString:xmlStr encoding:NSUTF8StringEncoding];
    if (!rootElement.xmlDoc) return;
    
    //content
    NSMutableArray *destSections = [[NSMutableArray alloc] init];
    NSArray *sections = [rootElement children:@"section"];
    for (RXMLElement *sectionElement in sections) {
        NSMutableDictionary *sectionDic = [[NSMutableDictionary alloc] init];
        
        for (NSString *name in sectionElement.attributeNames) {
            sectionDic[name] = [sectionElement attribute:name];
        }
        
        NSMutableArray *divs = [[NSMutableArray alloc] init];
        [sectionElement iterate:@"field" usingBlock:^(RXMLElement *divElement) {
            [divs addObject:[[self messageCenterConvertAttributeToDict:divElement] copy]];
        }];
        [sectionDic setObject:[divs copy] forKey:DLMCChildrenFieldsTag];
        [destSections addObject:[sectionDic copy]];
    }
    sectionArray = [destSections copy];
    
    //style
    [rootElement iterate:@"style" usingBlock:^(RXMLElement *element) {
        NSString *text = element.text;
        NSData *contentData = [text dataUsingEncoding:NSUTF8StringEncoding];
        styleDic = [NSJSONSerialization JSONObjectWithData:contentData options:0 error:NULL];
    }];
}

+ (NSMutableDictionary *)messageCenterConvertAttributeToDict:(RXMLElement *)element {
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    NSArray *fieldChildren = [element children:@"field"];
    if (fieldChildren.count > 0) {
        NSMutableArray *childrenFields = [NSMutableArray array];
        [fieldChildren enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [childrenFields addObject:[self messageCenterConvertAttributeToDict:obj]];
        }];
        attributes[DLMCChildrenFieldsTag] = childrenFields;
        attributes[DLMCStyleTag] = [element attribute:DLMCStyleTag];
    } else {
        NSArray *attributeNames = element.attributeNames;
        for (NSString *name in attributeNames) {
            NSString *value = [element attribute:name];
            attributes[name] = value;
        }
    }
    return attributes;
}

+ (NSArray *)sectionArray {
    return [sectionArray copy];
}

+ (NSDictionary *)styleDic {
    return styleDic;
}

@end
