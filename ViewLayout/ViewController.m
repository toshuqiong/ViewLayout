//
//  ViewController.m
//  ViewLayout
//
//  Created by LiYanQin on 2018/3/2.
//  Copyright © 2018年 liyanqin. All rights reserved.
//

#import "ViewController.h"
#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "DLStyleService.h"
#import "RXMLElement.h"
#import "ConfigureFileHelper.h"
#import "DLMessageCenterCellNode.h"

@import Masonry;

@interface ViewController () <ASTableDataSource,ASTableDelegate>

@property (nonatomic, strong) NSDictionary *item;

@property (nonatomic, strong) ASTableNode *tableNode;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _item = @{
        @"tagOne": @"40",
        @"unread": @"1",
        @"msgId": @"1",
        @"createdDate": @"2017-04-17 09: 28: 02",
        @"body": @{
            @"title": @"新订单",
            @"text":@"您收到了新的销售订单",
            @"clientName": @"浮光掠影",
            @"phone": @"15006886968",
            @"styleCount": @"12",
            @"detCount": @"122",
            @"totalSum": @"2612",
            @"orderId": @"1123"
        }
        };
    [ConfigureFileHelper setupData];
    
    [self setupView];
}



- (void)setupView {
    self.title = @"消息中心";
    self.view.backgroundColor = [UIColor whiteColor];
    
    _tableNode = [[ASTableNode alloc] initWithStyle:UITableViewStylePlain];
    _tableNode.backgroundColor = [DLStyleService colorFromHexString:@"#eeeeee"];
    _tableNode.dataSource = self;
    _tableNode.delegate = self;
    _tableNode.view.sectionHeaderHeight = 25;
    
    _tableNode.view.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubnode:_tableNode];
    [_tableNode.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - tablenode datasource

- (NSInteger)numberOfSectionsInTableNode:(ASTableNode *)tableNode {
    return 1;
}

- (NSInteger)tableNode:(ASTableNode *)tableNode numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (ASCellNode *)tableNode:(ASTableNode *)tableNode nodeForRowAtIndexPath:(NSIndexPath *)indexPath {
        NSDictionary *cellConfigure;
        for (NSDictionary *sectionDic in [ConfigureFileHelper sectionArray]) {
            if ([@"40" isEqualToString:sectionDic[@"tagOne"]]) {
                cellConfigure = sectionDic;
                break;
            }
        }
        
    //配置cell，如新订单
    DLMessageCenterCellNode *cellNode = [[DLMessageCenterCellNode alloc] initWithConfigureContent:cellConfigure cellData:_item[@"body"]];
    cellNode.horizonMargin = 27;
    cellNode.selectionStyle = UITableViewCellSelectionStyleNone;
    return cellNode;
}


@end
