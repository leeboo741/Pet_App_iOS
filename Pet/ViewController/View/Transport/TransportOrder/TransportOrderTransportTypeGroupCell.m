


//
//  TransportOrderTransportTypeCell.m
//  Pet
//
//  Created by mac on 2019/12/21.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "TransportOrderTransportTypeGroupCell.h"
#import "TransportTypeCell.h"


static NSString * TransportTypeCellName = @"TransportTypeCell";
static NSString * TransportTypeCellIdentifier = @"TransportTypeCellIdentifier";

static NSInteger TransportType_Show_Column = 3;
static NSInteger TransportType_Show_Row = 2;
static CGFloat Item_Height = 60;

@interface TransportOrderTransportTypeGroupCell () <UICollectionViewDelegate,UICollectionViewDataSource,TransportTypeCellDelegate>
@property (weak, nonatomic) IBOutlet UIView *boxView;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *boxViewHeightConstraint;

@end

@implementation TransportOrderTransportTypeGroupCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = Color_gray_1;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _boxView.layer.cornerRadius = 10;
    [_boxView addSubview:self.collectionView];
    self.boxViewHeightConstraint.constant = (Item_Height * TransportType_Show_Row) + 10;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(Item_Height * TransportType_Show_Row);
        make.top.left.equalTo(self.boxView).offset(5);
        make.bottom.right.equalTo(self.boxView).offset(-5);
    }];
}

#pragma mark - collection view delegate and datasource

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TransportTypeCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:TransportTypeCellIdentifier forIndexPath:indexPath];
    id<TransportTypeProtocol> transportTypeModel = self.transportTypeList[indexPath.row];
    cell.cellIconName = transportTypeModel.normalIconName;
    cell.cellTitle = transportTypeModel.normalTitle;
    cell.cellColor = transportTypeModel.normalColor;
    cell.cellSelectColor = transportTypeModel.selectColor;
    cell.cellDisableColor = transportTypeModel.disableColor;
    cell.typeIsDisable = transportTypeModel.typeIsDisable;
    cell.typeIsSelected = transportTypeModel.typeIsSelected;
    cell.delegate = self;
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.transportTypeList.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size = CGSizeMake(floor(self.collectionView.frame.size.width/ TransportType_Show_Column), floor(self.collectionView.frame.size.height/ TransportType_Show_Row));
    return size;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

#pragma mark - transport type cell delegate
-(void)transportTypeCellDidSelected:(TransportTypeCell *)cell{
    NSIndexPath * indexPath = [self.collectionView indexPathForCell:cell];
    if (_delegate && [_delegate respondsToSelector:@selector(transportTypeGroupCell:didSelectTransportTypeAtIndex:)]) {
        [_delegate transportTypeGroupCell:self didSelectTransportTypeAtIndex:indexPath.row];
    }
}

#pragma mark - setters and getters
-(UICollectionView *)collectionView{
    if (!_collectionView){
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView setCollectionViewLayout:flowLayout];
        [_collectionView registerNib:[UINib nibWithNibName:TransportTypeCellName bundle:nil] forCellWithReuseIdentifier:TransportTypeCellIdentifier];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
    }
    return _collectionView;
}

-(void)setTransportTypeList:(NSArray<id<TransportTypeProtocol>> *)transportTypeList{
    _transportTypeList = transportTypeList;
    [self.collectionView reloadData];
}

@end
