//
//  DLMessageCenterCellNode.h
//  PocketSLH
//
//  Created by LiYanQin on 2018/2/7.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

@class DLMessageCenterCellNode;

@protocol DLMessageCenterCellNodeDelegate <NSObject>

@optional

- (void)messageCenterCellNode:(DLMessageCenterCellNode *)cell didSelectWithOrderId:(NSString *)orderId msgId:(NSString *)msgId;

@end

@interface DLMessageCenterCellNode : ASCellNode

@property (nonatomic, assign) NSInteger horizonMargin;

@property (nonatomic, weak) id <DLMessageCenterCellNodeDelegate> delegate;

- (instancetype)initWithConfigureContent:(NSDictionary *)configureContent cellData:(NSDictionary *)cellData;

@end
