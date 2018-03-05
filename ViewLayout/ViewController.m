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

@interface ViewController () <ASTableDataSource,ASTableDelegate>

@property (nonatomic, strong) NSArray *source;

@property (nonatomic, strong) ASTableNode *tableNode;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _source = @[@{
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
        },
        @{@"body": @{
                  @"text": @"APP性能的优化，一直都是任重而道远，对于如今需要承载更多信息的APP来说更是突出，值得庆幸的苹果在这方面做得至少比安卓让开发者省心。UIKit 控件虽然在大多数情况下都能满足用户对于流畅性的需求，但有时候还是难以达到理想效果。",
//                  @"src": @"http://ps.ssl.qhimg.com/dmfd/400_300_/t01959a351c5b317f86.jpg",
                  @"src": @"http://www.cool80.com/img.cool80/i/png/217/02.png",
                  @"url": @"http://texturegroup.org/docs/layout2-layoutspec-types.html#ascenterlayoutspec"
                  },
          @"tagOne": @"45"
          }];
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
    _tableNode.view.frame = self.view.bounds;
}

#pragma mark - tablenode datasource

- (NSInteger)numberOfSectionsInTableNode:(ASTableNode *)tableNode {
    return 1;
}

- (NSInteger)tableNode:(ASTableNode *)tableNode numberOfRowsInSection:(NSInteger)section {
    return _source.count;
}

- (ASCellNode *)tableNode:(ASTableNode *)tableNode nodeForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *item = _source[indexPath.row];
    NSDictionary *cellConfigure;
    for (NSDictionary *sectionDic in [ConfigureFileHelper sectionArray]) {
        if ([item[@"tagOne"] isEqualToString:sectionDic[@"tagOne"]]) {
            cellConfigure = sectionDic;
            break;
        }
    }
        
    //配置cell，如新订单
    DLMessageCenterCellNode *cellNode = [[DLMessageCenterCellNode alloc] initWithConfigureContent:cellConfigure cellData:item[@"body"]];
    cellNode.horizonMargin = 27;
    cellNode.selectionStyle = UITableViewCellSelectionStyleNone;
    return cellNode;
}


@end
