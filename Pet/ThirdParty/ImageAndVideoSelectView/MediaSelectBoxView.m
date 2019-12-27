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
static CGFloat Item_Height = 180;
static CGFloat Box_Top = 0;
static CGFloat Box_Bottom = 0;
static CGFloat Box_left = 0;
static CGFloat Box_Right = 0;

@interface MediaSelectBoxView ()
<
MediaSelectItemDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
CTAssetsPickerControllerDelegate
>
@property (nonatomic, strong) UIView * boxView;
@property (nonatomic, strong) NSMutableArray<MediaSelectItemView *> * itemsArray;
@property (nonatomic, strong) MediaSelectItemView * addItem;
@property (nonatomic, assign) BOOL didSetup;
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
    [self addSubview:self.boxView];
    self.didSetup = NO;
    self.backgroundColor = Color_white_1;
    self.boxView.backgroundColor = Color_white_1;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self resetFrame];
}

-(CGSize)intrinsicContentSize{
    NSInteger row = 0;
    if (self.itemsArray.count % Show_Column == 0) {
        row = self.itemsArray.count/Show_Column;
    } else {
        row = self.itemsArray.count/Show_Column + 1;
    }
    CGFloat height = Item_Height * row;
    return CGSizeMake(self.frame.size.width, height+Box_Top-Box_Bottom);
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

-(void)layoutItems{
    if (self.didSetup) {
        return;
    }
    NSLog(@"box frame: %@",NSStringFromCGRect(self.boxView.frame));
    CGFloat itemWidth = self.boxView.frame.size.width / Show_Column;
    CGFloat itemHeight = Item_Height;
    for (int index = 0; index < self.itemsArray.count ; index ++) {
        NSInteger currentRow = index / Show_Column; // 当前行
        NSInteger currentColumn = index % Show_Column; // 当前列
        MediaSelectItemView * item = self.itemsArray[index];
        item.frame = CGRectMake(itemWidth * currentColumn, itemHeight * currentRow, itemWidth, itemHeight);
        
        NSLog(@"item frame: %@",NSStringFromCGRect(item.frame));
    }
    self.didSetup = YES;
}

-(void)resetFrame{
    if (self.didSetup) {
        return;
    }
    NSInteger row = 0;
    if (self.itemsArray.count % Show_Column == 0) {
        row = self.itemsArray.count/Show_Column;
    } else {
        row = self.itemsArray.count/Show_Column + 1;
    }
    CGFloat height = Item_Height * row;
    self.boxView.frame = CGRectMake(Box_left, Box_Top, self.frame.size.width - Box_left + Box_Right, height);
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height+Box_Top-Box_Bottom);
    [self layoutItems];
    NSLog(@"self frame :%@",NSStringFromCGRect(self.frame));
    if (_delegate && [_delegate respondsToSelector:@selector(mediaSelectBox:changeHeight:)]) {
        [_delegate mediaSelectBox:self changeHeight:self.frame.size.height];
    }
    self.didSetup = YES;
}

-(void)reloadItems{
    self.itemsArray = nil;
    [self itemsArray];
    [self addNewItemsWithModels:self.dataSource];
}

-(void)addNewItemWithModel:(id<MediaSelectItemProtocol>)model{
    MediaSelectItemView * item = [[MediaSelectItemView alloc]init];
    item.model = model;
    item.delegate = self;
    [self.boxView addSubview:item];
    [self.itemsArray insertObject:item atIndex:self.itemsArray.count -1];
    self.didSetup = NO;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

-(void)addNewItemsWithModels:(NSArray<id<MediaSelectItemProtocol>> *)models{
    for (id<MediaSelectItemProtocol>model in models) {
        MediaSelectItemView * item = [[MediaSelectItemView alloc]init];
        item.model = model;
        item.delegate = self;
        [self.boxView addSubview:item];
        [self.itemsArray insertObject:item atIndex:self.itemsArray.count -1];
    }
    self.didSetup = NO;
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
-(NSMutableArray<id<MediaSelectItemProtocol>> *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

-(NSMutableArray<MediaSelectItemView *> *)itemsArray{
    if (!_itemsArray){
        _itemsArray = [NSMutableArray array];
    }
    if (![_itemsArray containsObject:self.addItem]) {
        [_itemsArray addObject:self.addItem];
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
        [self.boxView addSubview:_addItem];
    }
    return _addItem;
}

-(UIView *)boxView{
    if (!_boxView) {
        _boxView = [[UIView alloc]init];
    }
    return _boxView;
}

@end
