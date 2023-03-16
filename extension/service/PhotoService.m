#import "PhotoService.h"
#import <Photos/Photos.h>

@implementation PhotoService

+(void)load{
    [[ESRegistry getInstance] registerService: @"PhotoService" withName: @"photo"];
}

-(BOOL)singleton{
    return YES;
}

- (NSArray *) loadGroupsWithType: (PHAssetCollectionType) type {
    NSMutableArray *groupList = [NSMutableArray array];

    PHFetchResult *groups = [PHAssetCollection
                             fetchAssetCollectionsWithType: type
                             subtype:PHAssetCollectionSubtypeAny
                             options:nil];

    [groups enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull collection, NSUInteger idx, BOOL * _Nonnull stop) {

        PHFetchOptions *option = [[PHFetchOptions alloc] init];
        option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
        PHFetchResult *photos = [PHAsset fetchAssetsInAssetCollection:collection
                                                              options:option];

        NSString *name = collection.localizedTitle;
        NSMutableArray *photoList = [NSMutableArray arrayWithCapacity: photos.count];

        [photos enumerateObjectsUsingBlock:^(PHAsset *  _Nonnull asset, NSUInteger idx, BOOL * _Nonnull stop) {
            if (asset.mediaType == PHAssetMediaTypeImage) {
                [photoList addObject: [[CAPLuaImage alloc] initWithAsset: asset]];
            }
        }];

        NSDictionary *group = @{@"name": name, @"type": @(collection.assetCollectionSubtype), @"photos": photoList};
        if (collection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumUserLibrary) {
            [groupList insertObject: group atIndex: 0];
        } else {
            [groupList addObject: group];
        }
    }];

    return groupList;
}

- (void) loadAllGroups: (LuaFunction *) func{
    NSMutableArray *groupList = [NSMutableArray array];

    [groupList addObjectsFromArray: [self loadGroupsWithType: PHAssetCollectionTypeSmartAlbum]];
    [groupList addObjectsFromArray: [self loadGroupsWithType: PHAssetCollectionTypeAlbum]];

    [func executeWithoutReturnValue: groupList, nil];
}

- (void) load: (LuaFunction *) func{
    if (![func isKindOfClass: [LuaFunction class]]) {
        return;
    }

    
    if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                [self loadAllGroups: func];
            } else {
                [func executeWithoutReturnValue];
            }
        }];
    } else if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized) {
        [self loadAllGroups: func];
    } else {
        [func executeWithoutReturnValue];
    }
}

-(LuaTable *)toLuaTable{
    LuaTable *tb = [[LuaTable alloc] init];
    [tb.map setValue: [NSNumber numberWithInt: 1] forKey: @"_VERSION"];

    return tb;
}
@end
