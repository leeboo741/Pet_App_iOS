//
//  MediaSelectBoxView.m
//  Pet
//
//  Created by mac on 2019/12/27.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "MediaSelectBoxView.h"
#import "MediaSelectItemView.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <CTAssetsPickerController/CTAssetsPickerController.h>
#import "MediaSelectItemModel.h"

static NSInteger Show_Column = 3;
static CGFloat Item_Height = 150;

@interface MediaSelectBoxView ()
<
MediaSelectItemDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
CTAssetsPickerControllerDelegate
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
    self.didChangeDatasource = NO;
    self.backgroundColor = Color_white_1;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self resetConstrants];
    [self changeDatasource];
}

#pragma mark - media select item delegate

-(void)tapMediaSelectItem:(MediaSelectItemView *)item{
    if (item.model.type == MediaSelectItemType_ADD) {
        [self addMedia];
    }
}

#pragma mark - uiimagepicker viewcontroller delegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info{
    NSString * mediaType = info[UIImagePickerControllerMediaType];
    MediaSelectItemModel * model = [[MediaSelectItemModel alloc]init];
    if (mediaType == (NSString *)kUTTypeImage) {
        NSLog(@"选中图片");
        UIImage * orginImage = info[UIImagePickerControllerOriginalImage];
        NSDictionary * metaData = info[UIImagePickerControllerMediaMetadata];
        model.type = MediaSelectItemType_IMG;
        model.coverImage = orginImage;
    } else if (mediaType == (NSString *)kUTTypeMovie) {
        NSLog(@"选中视频");
        NSString * mediaUrl = info[UIImagePickerControllerMediaURL];
        model.type = MediaSelectItemType_VIDEO;
    } else {
        NSLog(@"选中未知");
        model.type = MediaSelectItemType_UNKOWN;
    }
    [self.dataSource addObject:model];
    [picker dismissViewControllerAnimated:YES completion:^{
        [self addNewItemWithModel:model];
    }];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - assetspicker viewcontroller delegate
-(void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    NSMutableArray * tempDataSource = [NSMutableArray array];
    for (PHAsset * asset in assets) {
        MediaSelectItemModel * model = [[MediaSelectItemModel alloc]init];
        if (asset.mediaType == PHAssetMediaTypeVideo) {
            NSLog(@"拍摄视频");
            model.type = MediaSelectItemType_VIDEO;
            
        } else if (asset.mediaType == PHAssetMediaTypeImage) {
            NSLog(@"拍摄图片");
            model.type = MediaSelectItemType_IMG;
            
        } else {
            NSLog(@"拍摄未知");
            model.type = MediaSelectItemType_UNKOWN;
        }
        [self.dataSource addObject:model];
        [tempDataSource addObject:model];
    }
    [picker dismissViewControllerAnimated:YES completion:^{
        [self addNewItemsWithModels:tempDataSource];
    }];
}

-(void)assetsPickerControllerDidCancel:(CTAssetsPickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - private method
// 通知数据改变
-(void)changeDatasource{
    if (self.didChangeDatasource) {
        self.didChangeDatasource = NO;
        if (_delegate && [_delegate respondsToSelector:@selector(mediaSelectBox:didChangeDataSource:)]) {
            [_delegate mediaSelectBox:self didChangeDataSource:self.dataSource];
        }
        NSInteger rowCount = self.itemsArray.count/ self.column;
        NSInteger lastColumn = self.itemsArray.count % self.column;
        if (lastColumn != 0) {
            rowCount = rowCount + 1;
        }
        self.rowCount = rowCount;
        if (_delegate && [_delegate respondsToSelector:@selector(mediaSelectBox:didChangeHeight:)]) {
            [_delegate mediaSelectBox:self didChangeHeight:self.rowCount * self.itemHeight];
        }
    }
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
}
// 数据重新载入
-(void)reloadItems{
    self.itemsArray = nil;
    [self itemsArray];
    [self addNewItemsWithModels:self.dataSource];
}
// 添加新item 单个
-(void)addNewItemWithModel:(id<MediaSelectItemProtocol>)model{
    MediaSelectItemView * item = [[MediaSelectItemView alloc]init];
    item.model = model;
    item.delegate = self;
    [self.itemsArray insertObject:item atIndex:self.itemsArray.count -1];
    [self addSubview:item];
    self.didChangeDatasource = YES;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}
// 添加新item 多个
-(void)addNewItemsWithModels:(NSArray<id<MediaSelectItemProtocol>> *)models{
    for (id<MediaSelectItemProtocol>model in models) {
        MediaSelectItemView * item = [[MediaSelectItemView alloc]init];
        item.model = model;
        item.delegate = self;
        [self.itemsArray insertObject:item atIndex:self.itemsArray.count -1];
        [self addSubview:item];
    }
    self.didChangeDatasource = YES;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

-(void)addMedia{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * alertAction1 = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showAlbum];
    }];
    UIAlertAction * alertAction2 = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showCamera];
    }];
    UIAlertAction * alertCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:alertAction1];
    [alertController addAction:alertAction2];
    [alertController addAction:alertCancel];
    UIViewController * viewController = Util_GetCurrentVC;
    [viewController presentViewController:alertController animated:YES completion:nil];
}

/**
 调用相册
 */
-(void)showAlbum{
    __weak typeof(self) weakSelf = self;
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status){
        dispatch_async(dispatch_get_main_queue(), ^{
            // init picker
            CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
            // set delegate
            picker.delegate = weakSelf;
            // Optionally present picker as a form sheet on iPad
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                picker.modalPresentationStyle = UIModalPresentationFormSheet;
            // present picker
            UIViewController * viewController = Util_GetCurrentVC;
            [viewController presentViewController:picker animated:YES completion:nil];
        });
    }];
}

/**
 调用摄像头
 */
-(void)showCamera{
    UIImagePickerController * imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.delegate = self;
    // 转场方式
    imagePickerController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    // 最大视频长度
    imagePickerController.videoMaximumDuration = 60;
    // 媒体类型
    imagePickerController.mediaTypes = @[(NSString *)kUTTypeMovie,(NSString *)kUTTypeImage];
    //视频上传质量
    imagePickerController.videoQuality = UIImagePickerControllerQualityTypeMedium;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    UIViewController * viewController = Util_GetCurrentVC;
    [viewController presentViewController:imagePickerController animated:YES completion:nil];
}

#pragma mark - setters and getters

-(void)setDataSource:(NSMutableArray<id<MediaSelectItemProtocol>> *)dataSource{
    _dataSource = dataSource;
    [self reloadItems];
}

-(void)setDelegate:(id<MediaSelectBoxViewDelegate>)delegate{
    _delegate = delegate;
    if (delegate && [delegate respondsToSelector:@selector(mediaSelectBox:didChangeHeight:)]) {
        [delegate mediaSelectBox:self didChangeHeight:self.rowCount * self.itemHeight];
    }
}

-(NSMutableArray<MediaSelectItemView *> *)itemsArray{
    if (!_itemsArray){
        _itemsArray = [NSMutableArray array];
    }
    if (![_itemsArray containsObject:self.addItem]) {
        [_itemsArray addObject:self.addItem];
        [self addSubview:_addItem];
        [self setNeedsLayout];
        [self layoutIfNeeded];
    } else {
        if ([_itemsArray lastObject] != self.addItem) {
            [_itemsArray removeObject:self.addItem];
            [_itemsArray addObject:self.addItem];
        }
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
