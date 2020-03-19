//
//  MessageCenterController.m
//  Pet
//
//  Created by mac on 2020/1/9.
//  Copyright © 2020年 mac. All rights reserved.
//

#import "MessageCenterController.h"
#import "MessageManager.h"
#import "UITableViewController+AddMJRefresh.h"

#pragma mark - Message Item Model
#pragma mark -

@interface MessageItemModel : NSObject
@property (nonatomic, copy) NSString * messageTitle;
@property (nonatomic, copy) NSString * messageContent;
@property (nonatomic, copy) NSString * messageTime;
@property (nonatomic, copy) NSString * link;
+(MessageItemModel *)messageItemModelFromMessageEntity:(MessageEntity *)messageEntity;
+(NSArray<MessageItemModel *> *)getItemModelListByEntityList:(NSArray<MessageEntity *> *)entityList;
@end

@implementation MessageItemModel
+(MessageItemModel *)messageItemModelFromMessageEntity:(MessageEntity *)messageEntity{
    MessageItemModel * messageItemModel = [[MessageItemModel alloc]init];
    messageItemModel.messageTitle = messageEntity.messageTitle;
    messageItemModel.messageContent = messageEntity.messageContent;
    messageItemModel.messageTime = messageEntity.sendTime;
    messageItemModel.link = messageEntity.link;
    return messageItemModel;
}
+(NSArray<MessageItemModel *> *)getItemModelListByEntityList:(NSArray<MessageEntity *> *)entityList{
    NSMutableArray * array = [NSMutableArray array];
    for (MessageEntity * entity in entityList) {
        [array addObject:[MessageItemModel messageItemModelFromMessageEntity:entity]];
    }
    return array;
}
@end

#pragma mark - Message List ViewController
#pragma mark -

#import "MessageItemCell.h"

static NSString * MessageItemCellIdentifier = @"MessageItemCell";

static NSInteger Limit = 20;

@interface MessageCenterController ()
@property (nonatomic, strong) NSMutableArray<MessageItemModel *> * dataSource;
@property (nonatomic, assign) NSInteger offset;
@end

@implementation MessageCenterController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"站内信";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.offset = 0;
    [self addRefreshViewWithRefreshAction:@selector(refreshMessageList)];
    [self addLoadMoreViewWithLoadMoreAction:@selector(loadMoreMessageList)];
    [self.tableView registerNib:[UINib nibWithNibName:MessageItemCellIdentifier bundle:nil] forCellReuseIdentifier:MessageItemCellIdentifier];
    [self startRefresh];
}

#pragma mark - private method

-(void)refreshMessageList{
    self.offset = 0;
    __weak typeof(self) weakSelf = self;
    [self getMessageListWithOffset:self.offset success:^(id  _Nonnull data) {
        [weakSelf.dataSource removeAllObjects];
        [weakSelf.dataSource addObjectsFromArray:(NSArray *)data];
        [weakSelf endRefresh];
        [weakSelf.tableView reloadData];
    } fail:^(NSInteger code) {
        [weakSelf endRefresh];
    }];
}

-(void)loadMoreMessageList{
    __weak typeof(self) weakSelf = self;
    [self getMessageListWithOffset:self.offset success:^(id  _Nonnull data) {
        NSArray * dataArray =  (NSArray *)data;
        if (dataArray.count < Limit) {
            [weakSelf.tableView.mj_footer setState:MJRefreshStateNoMoreData];
        } else {
            [weakSelf.tableView.mj_footer setState:MJRefreshStateIdle];
        }
        [weakSelf.dataSource addObjectsFromArray:dataArray];
        [weakSelf.tableView reloadData];
        [weakSelf endLoadMore];
    } fail:^(NSInteger code) {
        [weakSelf endLoadMore];
    }];
}

-(void)getMessageListWithOffset:(NSInteger)offset success:(SuccessBlock)success fail:(FailBlock)fail{
    __weak typeof(self) weakSelf = self;
    [[MessageManager shareMessageManager] getMessageListWithOffset:offset limit:Limit success:^(id  _Nonnull data) {
        weakSelf.offset = weakSelf.offset + Limit;
        if (success) {
            success([MessageItemModel getItemModelListByEntityList:(NSArray *)data]);
        }
    } fail:^(NSInteger code) {
        if (fail) {
            fail(code);
        }
    }];
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
    MessageItemModel * model = self.dataSource[indexPath.row];
    MSLog(@"%@",model.link);
    [[MessageManager shareMessageManager] handlerMessageLinks:model.link];
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
    }
    return _dataSource;
}
@end
