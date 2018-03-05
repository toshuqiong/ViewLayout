//
//  DLMessageCenterCellNode.m
//  PocketSLH
//
//  Created by LiYanQin on 2018/2/7.
//

#import "DLMessageCenterCellNode.h"
#import "ConfigureFileHelper.h"
#import "DLASyncDisplayLayoutSvc.h"
#import "DLListTextStyle.h"
#import "DLViewLayoutTags.h"

#define getNotNilValue(value) ((value) ? (value) : @"")

@interface DLMessageCenterCellNode ()

@property (nonatomic, strong) ASDisplayNode *backContainerNode;
@property (nonatomic, strong) NSDictionary *configureData;
@property (nonatomic, strong) NSDictionary *cellData;
@property (nonatomic, strong) DLASyncDisplayLayoutSvc *layoutSvc;
@property (nonatomic, strong) NSMutableDictionary *nodeDic;

@end

@implementation DLMessageCenterCellNode

- (instancetype)initWithConfigureContent:(NSDictionary *)configureContent cellData:(NSDictionary *)cellData {
    self = [super init];
    if (self) {
        _configureData = configureContent;
        _cellData = cellData;
        self.automaticallyManagesSubnodes = YES;
        _backContainerNode = [[ASDisplayNode alloc] init];
        _backContainerNode.backgroundColor = [UIColor whiteColor];
        _backContainerNode.layer.cornerRadius = 6;
        
        UITapGestureRecognizer *showDetailTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSelect)];
        [self.view addGestureRecognizer:showDetailTap];
        self.layoutSvc = [[DLASyncDisplayLayoutSvc alloc] initWithStyle:[ConfigureFileHelper styleDic]];
        [self setupCellWithConfigureItem:_configureData nodeItem:self.nodeDic];
    }
    return self;
}

//布局用
- (void)setupCellWithConfigureItem:(NSDictionary *)contentItem nodeItem:(NSMutableDictionary *)nodeItem {
    nodeItem[DLMCStyleTag] = contentItem[DLMCStyleTag];
    
    NSMutableArray *children = contentItem[DLMCChildrenFieldsTag];
    NSMutableArray *childrenNode = [NSMutableArray array];
    for (NSMutableDictionary *item in children) {
        NSMutableArray *subchildren = item[DLMCChildrenFieldsTag];
        if (subchildren && subchildren.count > 0) {
            NSMutableDictionary *subNode = [NSMutableDictionary dictionary];
            subNode[DLMCStyleTag] = item[DLMCStyleTag];
            [self setupCellWithConfigureItem:item nodeItem:subNode];
            [childrenNode addObject:subNode];
        }else if ([item[DLMCStyleTag] isEqualToString:@"display"]) {
            [childrenNode addObject:[self.layoutSvc displayNodeWithContentItem:item]];
        } else if ([item[DLMCStyleTag] isEqualToString:@"image"]) {
            id<ASLayoutElement> node = [self.layoutSvc imageNodeWithContentItem:item];
            ASNetworkImageNode *imageNode = (ASNetworkImageNode *)node;
            if ([imageNode isKindOfClass:[ASLayoutSpec class]]) {
                imageNode = (ASNetworkImageNode *)((ASLayoutSpec *)imageNode).child;
            }
            imageNode.contentMode = UIViewContentModeScaleAspectFill;
            imageNode.defaultImage = [UIImage imageNamed:@"slh_logo"];
            imageNode.URL = [NSURL URLWithString:[self.cellData valueForKeyPath:item[@"name"]]];
            [childrenNode addObject:node];
        }
        else {
            NSDictionary *style = [self.layoutSvc styleWithContentItem:item];
            NSDictionary *attributes = [DLListTextStyle textNodeStyle:style];
            NSString *clabel = item[@"clabel"];
            NSString *name = item[@"name"];
            NSString *content = _cellData[name];
            NSString *destStr = [NSString stringWithFormat:@"%@%@",getNotNilValue(clabel),getNotNilValue(content)];
            
            id element = [self.layoutSvc textNodeWithContentItem:item];
            ASTextNode *textNode;
            if ([element isKindOfClass:[ASLayoutSpec class]]) {
                textNode = (ASTextNode *)((ASLayoutSpec *)element).child;
                [childrenNode addObject:element];
            }else {
                textNode = (ASTextNode *)element;
                [childrenNode addObject:textNode];
            }
            textNode.attributedText = [[NSAttributedString alloc] initWithString:destStr attributes:attributes];
            
        }
    }
    
    nodeItem[DLMCChildrenFieldsTag] = childrenNode;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
    ASLayoutSpec *spec = [self.layoutSvc layoutWithNodeItem:self.nodeDic];
    ASInsetLayoutSpec *destSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(12, 15, 12, 15) child:spec];
    ASBackgroundLayoutSpec *backSpec = [ASBackgroundLayoutSpec backgroundLayoutSpecWithChild:destSpec background:_backContainerNode];
    ASInsetLayoutSpec *insentSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(0, _horizonMargin, 0, _horizonMargin) child:backSpec];
    return insentSpec;
}

#pragma mark - User Interaction

- (void)didSelect {
    if ([self.delegate respondsToSelector:@selector(messageCenterCellNode:didSelectWithOrderId:msgId:)]) {
        [self.delegate messageCenterCellNode:self didSelectWithOrderId:_cellData[_configureData[@"pkkey"]] msgId:_cellData[@"id"]];
    }
}

#pragma mark - Setters and Getters

- (NSMutableDictionary *)nodeDic {
    if (!_nodeDic) {
        _nodeDic = [[NSMutableDictionary alloc] init];
    }
    return _nodeDic;
}

@end
