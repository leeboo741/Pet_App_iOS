//
//  MediaSelectBoxView.m
//  Pet
//
//  Created by mac on 2019/12/27.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "MediaSelectBoxView.h"
#import "MediaSelectItemView.h"
#import "MediaSelectItemModel.h"
#import <TZImagePickerController/TZImagePickerController.h>
#import "PreviewViewController.h"


static NSInteger Show_Column = 3;
static CGFloat Item_Height = 150;

static NSInteger Max_Count = 9;
static CGFloat Max_Video_Length = 30;

@interface MediaSelectBoxView ()
<
MediaSelectItemDelegate
>
@property (nonatomic, strong) NSMutableArray<MediaSelectItemView *> * itemsArray;
@property (nonatomic, strong) MediaSelectItemView * addItem;
@property (nonatomic, assign) BOOL didChangeDatasource;
@property (nonatomic, assign) NSInteger column;
@property (nonatomic, assign) CGFloat itemHeight;
@property (nonatomic, assign) NSInteger rowCount;
@end

@implementation MediaSelectBoxView

#pragma mark - life cycle

-(instancetype)init{
    self = [super init];
    if (self) {
        [self setUpView];
    }
    return self;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setUpView];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpView];
    }
    return self;
}

-(void)setUpView{
    self.dataSource = [NSMutableArray array];
    self.backgroundColor = Color_white_1;
    self.ableDelete = YES;
}

-(void)layoutSubviews{
    [super layoutSubviews];
}

#pragma mark - media select item delegate

-(void)tapMediaSelectItem:(MediaSelectItemView *)item{
    if (item.model.type == MediaSelectItemType_ADD) {
        [self addMedia];
    } else {
        PreviewViewController * previewVC = [[PreviewViewController alloc]init];
        previewVC.currentIndex = [self.itemsArray indexOfObject:item];;
        previewVC.models =  [self getTZAssetsModelList];
        UIViewController * viewcontroller = Util_GetCurrentVC;
        [viewcontroller.navigationController pushViewController:previewVC animated:YES];
    }
}
-(void)deleteMediaSelectItem:(MediaSelectItemView *)item{
    NSInteger index = [self.itemsArray indexOfObject:item];
    [self deleteItemAtIndex:index];
}

#pragma mark - private method

/**
 将 数据 转换成 preview 能够使用的 TZAssetmodel list数据

 @return TZAssetmodel array
 */
-(NSMutableArray *)getTZAssetsModelList{
    NSMutableArray * assetModelList = [NSMutableArray array];
    for (MediaSelectItemModel * model in self.dataSource) {
        TZAssetModel * tzassetsModel = [[TZImageManager manager] createModelWithAsset:model.data];
        tzassetsModel.isSelected = YES;
        [assetModelList addObject:tzassetsModel];
    }
    return assetModelList;
}
// 数据重新载入
-(void)reloadItems{
    // addItem 不进入计算
    [self.itemsArray removeObject:self.addItem];
    
    // 求 item 和 data 数量
    NSInteger itemsCount = self.itemsArray.count;
    NSInteger datasCount = 0;
    if (self.dataSource != nil) {
        datasCount = self.dataSource.count;
    }
    // 取差值 绝对值
    NSInteger diffrence = abs((int)(itemsCount - datasCount)) ;
    
    // 如果 item 多于 data, 删减itemsarray
    // 如果 item 少于 data, 增加itemsarray
    // 如果 item 等于 data, 不变
    if (itemsCount  < datasCount) {
        for (NSInteger index = 0; index < diffrence; index ++) {
            MediaSelectItemView * item = [[MediaSelectItemView alloc]init];
            item.delegate = self;
            item.ableDelete = self.ableDelete;
            [self.itemsArray addObject:item];
            [self addSubview:item];
        }
    } else if (itemsCount > datasCount) {
        for (NSInteger index = 0; index < diffrence; index ++) {
            MediaSelectItemView * item = self.itemsArray.lastObject;
            [self.itemsArray removeObject:item];
            [item removeFromSuperview];
        }
    }
    
    for (NSInteger index = 0; index < self.itemsArray.count; index ++) {
        MediaSelectItemView * item = self.itemsArray[index];
        item.model = self.dataSource[index];
    }
    
    if (self.itemsArray.count < Max_Count) {
        [self.itemsArray addObject:self.addItem];
        if (![self.subviews containsObject:self.addItem]) {
            [self addSubview:self.addItem];
        }
    } else {
        if ([self.subviews containsObject:self.addItem]) {
            [self.addItem removeFromSuperview];
        }
    }
    [self resetConstrants];
}

// 刷新约束
-(void)resetConstrants{
    // 循环约束
    for (int index = 0; index < self.itemsArray.count; index ++) {
        // 获取当前 item
        MediaSelectItemView * item = self.itemsArray[index];
        // 计算当前 item 所在行和列
        NSInteger column = index % self.column;
        NSInteger row = index / self.column;
        // 当为最后一个 item 时 要相对于 self.bottom 约束
        // 当为第一个 item 时 相对于 self.left self.top 约束
        // 当为第一列 item 时 移动列 还要移动行，相对于上一行第一列约束， 即相对于 show_column 个数量之前的 item 约束
        // 除以上两种情况 在同一行 向后移位， item 相对于前一个 item.right item.top 约束
        if (index != self.itemsArray.count - 1) {
            if (row == 0 && column == 0) {
                [item mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.left.equalTo(self);
                    make.height.mas_equalTo(self.itemHeight);
                    make.width.mas_equalTo(self.frame.size.width / self.column);
                }];
            } else {
                MediaSelectItemView * targetItem;
                if (column == 0) {
                    targetItem = self.itemsArray[index - self.column];
                    [item mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(targetItem);
                        make.top.equalTo(targetItem.mas_bottom);
                        make.width.height.equalTo(targetItem);
                    }];
                } else {
                    targetItem = self.itemsArray[index - 1];
                    [item mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(targetItem.mas_right);
                        make.top.equalTo(targetItem);
                        make.width.height.equalTo(targetItem);
                    }];
                }
                
            }
        } else {
            if (row == 0 && column == 0) {
                [item mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.left.equalTo(self);
                    make.height.mas_equalTo(self.itemHeight);
                    make.width.mas_equalTo(self.frame.size.width / self.column);
                    make.bottom.equalTo(self);
                }];
            } else {
                MediaSelectItemView * targetItem;
                if (column == 0) {
                    targetItem = self.itemsArray[index - self.column];
                    [item mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(targetItem);
                        make.top.equalTo(targetItem.mas_bottom);
                        make.width.height.equalTo(targetItem);
                        make.bottom.equalTo(self);
                    }];
                } else {
                    targetItem = self.itemsArray[index - 1];
                    [item mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(targetItem.mas_right);
                        make.top.equalTo(targetItem);
                        make.width.height.equalTo(targetItem);
                        make.bottom.equalTo(self);
                    }];
                }
            }
        }
    }
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

-(void)deleteItemAtIndex:(NSInteger)index{
    [self.dataSource removeObjectAtIndex:index];
    if (_delegate && [_delegate respondsToSelector:@selector(mediaSelectBoxView:dataSourceDidChanged:)]) {
        [_delegate mediaSelectBoxView:self dataSourceDidChanged:self.dataSource];
    }
}

-(void)addMedia{
    NSMutableArray <PHAsset *>*assetsArray = @[].mutableCopy;
    for (MediaSelectItemModel *model in self.dataSource) {
        [assetsArray addObject:model.data];
    }
    __weak typeof(self)weakSelf = self;
    TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:Max_Count delegate:nil];
    imagePicker.selectedAssets = assetsArray; // 已经选中的资源文件列表
    imagePicker.allowPickingMultipleVideo = YES; // 是否允许多选视频
    imagePicker.allowPickingVideo = YES; // 是否允许选择视频
    imagePicker.videoMaximumDuration = Max_Video_Length; // 最大视频时间
    imagePicker.maxImagesCount = Max_Count; // 最大数量
    imagePicker.allowTakePicture = YES; // 允许拍摄图片
    imagePicker.allowTakeVideo = YES; // 允许拍摄视频
    imagePicker.allowCameraLocation = YES;//
    imagePicker.allowPickingOriginalPhoto = NO; // 是否允许选取原图
    [imagePicker setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        NSMutableArray *modelsArray = @[].mutableCopy;
        for (int i = 0; i < photos.count; i ++) {
            MediaSelectItemModel *model = [[MediaSelectItemModel alloc] init];
            model.coverImage = [photos objectAtIndex:i];
            model.data = [assets objectAtIndex:i];
            if (model.data.mediaType == PHAssetMediaTypeImage) {
                model.type = MediaSelectItemType_IMG;
            } else {
                model.type = MediaSelectItemType_VIDEO;
            }
            model.coverImagePath = [NSString stringWithFormat:@"%@%u.jpg",[self uuidString],arc4random_uniform(255)];
            [modelsArray addObject:model];
        }
        [weakSelf compareCurrentDataWithPickerData:modelsArray];
    }];
    UIViewController * viewController = Util_GetCurrentVC;
    [viewController presentViewController:imagePicker animated:YES completion:nil];
}

- (NSString *)uuidString {
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
    NSString *uuid = [NSString stringWithString:(__bridge NSString *)uuid_string_ref];
    CFRelease(uuid_ref);
    CFRelease(uuid_string_ref);
    return [uuid lowercaseString];
}
// 比对选择返回的数据 和当前数据 并重新刷新数据
-(void)compareCurrentDataWithPickerData:(NSArray<MediaSelectItemModel *> *)data{
    NSMutableArray * sameArray = [NSMutableArray array]; // 相同资源容器
    NSMutableArray * willInsertArray = [NSMutableArray arrayWithArray:data]; // 将要插入的资源容器
    NSMutableArray * willDeleteArray = [NSMutableArray arrayWithArray:self.dataSource]; // 将要删除的资源容器
    
    // 双重循环 比对出 相同的数据
    for (MediaSelectItemModel * oldModel in willDeleteArray) {
        for (MediaSelectItemModel * newModel in willInsertArray) {
            if ([oldModel.data.localIdentifier isEqualToString:newModel.data.localIdentifier]) {
                [sameArray addObject:oldModel];
            }
        }
    }
    
    // 双重循环 比对出来 真正要删除和真正要添加的数据
    for (MediaSelectItemModel * sameModel in sameArray) {
        [willDeleteArray removeObject:sameModel];
        MediaSelectItemModel * willDeleteModel;
        for (MediaSelectItemModel * newModel in willInsertArray) {
            if ([sameModel.data.localIdentifier isEqualToString:newModel.data.localIdentifier]) {
                willDeleteModel = newModel;
            }
        }
        if (willDeleteModel) {
            [willInsertArray removeObject:willDeleteModel];
        }
    }
    
    // 循环 删除要删除的数据
    NSMutableArray * resultArray = [NSMutableArray arrayWithArray:self.dataSource];
    for (MediaSelectItemModel * deleteModel in willDeleteArray) {
        MediaSelectItemModel * willDeleteModel;
        for (MediaSelectItemModel * resultModel in resultArray) {
            if ([deleteModel.data.localIdentifier isEqualToString:resultModel.data.localIdentifier]) {
                willDeleteModel = resultModel;
                break;
            }
        }
        if (willDeleteModel) {
            [resultArray removeObject:willDeleteModel];
        }
    }
    // 插入 要插入的数据
    [resultArray addObjectsFromArray:willInsertArray];
    // 重新赋值 datasource 触发 setter 方法 中的 重置数据 移除页面的原有item 重新addItem 并计算
    if (_delegate && [_delegate respondsToSelector:@selector(mediaSelectBoxView:dataSourceDidChanged:)]) {
        [_delegate mediaSelectBoxView:self dataSourceDidChanged:resultArray];
    }
}

#pragma mark - setters and getters

-(void)setDataSource:(NSMutableArray<MediaSelectItemModel *> *)dataSource{
    _dataSource = dataSource;
    [self reloadItems];
}

-(NSMutableArray<MediaSelectItemView *> *)itemsArray{
    if (!_itemsArray){
        _itemsArray = [NSMutableArray array];
    }
    return _itemsArray;
}

-(MediaSelectItemView *)addItem{
    if (!_addItem) {
        MediaSelectItemModel * addModel = [[MediaSelectItemModel alloc]init];
        addModel.type = MediaSelectItemType_ADD;
        _addItem = [[MediaSelectItemView alloc]init];
        _addItem.model = addModel;
        _addItem.delegate = self;
    }
    return _addItem;
}

-(NSInteger)column{
    if (_config && [_config respondsToSelector:@selector(numberOfMediaSelectBoxColumn)]) {
        return [_config numberOfMediaSelectBoxColumn];
    } else {
        return Show_Column;
    }
}

-(CGFloat)itemHeight{
    if (_config && [_config respondsToSelector:@selector(heightOfMediaSelectBoxItem)]) {
        return [_config heightOfMediaSelectBoxItem];
    } else {
        return Item_Height;
    }
}

@end
