//
//  MessageCenterController.m
//  Pet
//
//  Created by mac on 2020/1/9.
//  Copyright © 2020年 mac. All rights reserved.
//

#import "MessageCenterController.h"

#pragma mark - Message Item Model
#pragma mark -

@interface MessageItemModel : NSObject
@property (nonatomic, copy) NSString * messageTitle;
@property (nonatomic, copy) NSString * messageContent;
@property (nonatomic, copy) NSString * messageTime;
@end

@implementation MessageItemModel
@end

#pragma mark - Message List ViewController
#pragma mark -

#import "MessageItemCell.h"

static NSString * MessageItemCellIdentifier = @"MessageItemCell";

@interface MessageCenterController ()
@property (nonatomic, strong) NSMutableArray<MessageItemModel *> * dataSource;
@end

@implementation MessageCenterController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"站内信";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:MessageItemCellIdentifier bundle:nil] forCellReuseIdentifier:MessageItemCellIdentifier];
}

#pragma mark - tableview datasource and delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageItemCell * cell = [tableView dequeueReusableCellWithIdentifier:MessageItemCellIdentifier forIndexPath:indexPath];
    [self configCell:cell atIndexPath:indexPath];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView fd_heightForCellWithIdentifier:MessageItemCellIdentifier configuration:^(id cell) {
        [self configCell:cell atIndexPath:indexPath];
    }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - config cell

-(void)configCell:(MessageItemCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    MessageItemModel * model = self.dataSource[indexPath.row];
    cell.messageTitle = model.messageTitle;
    cell.messageContent = model.messageContent;
    cell.messageTime = model.messageTime;
}

#pragma mark - setters and getters

-(NSMutableArray<MessageItemModel *> *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
        MessageItemModel * model = [[MessageItemModel alloc]init];
        model.messageTitle = @"新订单";
        model.messageContent = @"您有新订单已经成功生成,单号为:20200101nc001,起始城市为:南昌市,重点城市为:安阳市,请耐心等待!";
        model.messageTime = @"2020-01-02 08:11:12";
        
        MessageItemModel * model1 = [[MessageItemModel alloc]init];
        model1.messageTitle = @"入港提示";
        model1.messageContent = @"您的订单已经入港,您可以在待发货中查看订单!";
        model1.messageTime = @"2020-01-02 08:11:12";
        
        [_dataSource addObject:model];
        [_dataSource addObject:model1];
        
    }
    return _dataSource;
}
@end
