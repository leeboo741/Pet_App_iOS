//
//  ImageAndVideoSelectBox.m
//  Pet
//
//  Created by mac on 2019/12/26.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "ImageAndVideoSelectBox.h"
#import "ImageAndVideoSelectItemCell.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <CTAssetsPickerController/CTAssetsPickerController.h>
#import "MediaSelectItemModel.h"

static NSString * itemCellName = @"ImageAndVideoSelectItemCell";
static NSString * itemCellIdentifier = @"ImageAndVideoSelectItemCellIdentifier";

static NSInteger Show_Column = 3;
static CGFloat Item_Height = 180;

@interface ImageAndVideoSelectBox ()
<
UICollectionViewDelegate,
UICollectionViewDataSource,
ImageAndVideoSelectItemCellDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
CTAssetsPickerControllerDelegate
>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeightConstraint;

@end

@implementation ImageAndVideoSelectBox

#pragma mark - life cycle

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setUpDecoderView];
    }
    return self;
}

-(instancetype)init{
    self = [super init];
    if (self) {
        [self setUpDecoderView];
    }
    return self;
}


-(void)setUpDecoderView{
    [[NSBundle mainBundle] loadNibNamed:@"ImageAndVideoSelectBox" owner:self options:nil];
    self.view.frame = self.bounds;
    [self addSubview:self.view];
    
    self.dataSource = [NSMutableArray array];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:itemCellName bundle:nil] forCellWithReuseIdentifier:itemCellIdentifier];
    
}

#pragma mark - collection view delegate and datasource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSource.count + 1;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ImageAndVideoSelectItemCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:itemCellIdentifier forIndexPath:indexPath];
    [self configCell:cell atIndexPath:indexPath];
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size = CGSizeMake(floor(self.collectionView.frame.size.width/ Show_Column), Item_Height);
    return size;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

#pragma mark - config cell
-(void)configCell:(ImageAndVideoSelectItemCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    cell.delegate = self;
    
    if (indexPath.row == self.dataSource.count) {
        MediaSelectItemModel * model = [[MediaSelectItemModel alloc]init];
        model.type = MediaSelectItemType_ADD;
        cell.model = model;
    } else {
        id<MediaSelectItemProtocol> data = self.dataSource[indexPath.row];
        cell.model = data;
    }
}

#pragma mark - item cell delegate

-(void)tapImageAndVideoSelectItemCell:(ImageAndVideoSelectItemCell *)cell{
    NSIndexPath * indexPath = [self.collectionView indexPathForCell:cell];
    if (indexPath.row == self.dataSource.count) {
        [self tapAddMedia];
    } else {
        id<MediaSelectItemProtocol>data = self.dataSource[indexPath.row];
    }
}

#pragma mark - imagepicker viewcontroller delegate

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
        [self reloadData];
    }];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - ctassets controller delegate

-(void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
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
    }
    [picker dismissViewControllerAnimated:YES completion:^{
        [self reloadData];
    }];
}

-(void)assetsPickerControllerDidCancel:(CTAssetsPickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - event action
-(void)tapAddMedia{
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

#pragma mark - private method

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

/**
 重置高度
 */
-(void)resetCollectionViewHeight{
    NSInteger row = 0;
    if ((self.dataSource.count + 1) % Show_Column == 0) {
        row = (self.dataSource.count + 1) /Show_Column;
    } else {
        row = ((self.dataSource.count + 1) /Show_Column) + 1;
    }
    self.collectionViewHeightConstraint.constant = Item_Height * row;
    [self setNeedsUpdateConstraints];
    [self updateConstraints];
    [self layoutIfNeeded];
    [self.collectionView reloadData];
}

/**
 数据刷新
 */
-(void)reloadData{
    [self resetCollectionViewHeight];
    if (_delegate && [_delegate respondsToSelector:@selector(imageAndVideoSelectBox:reloadDataSource:)]) {
        [_delegate imageAndVideoSelectBox:self reloadDataSource:self.dataSource];
    }
}


#pragma mark - setters and getters

-(void)setDataSource:(NSMutableArray<id<MediaSelectItemProtocol>> *)dataSource{
    _dataSource = dataSource;
    [self resetCollectionViewHeight];
}

@end
