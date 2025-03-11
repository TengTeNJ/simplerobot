//
//  OpenCVBridgeFile.h
//  Runner
//
//  Created by 孟恒 on 2025/3/3.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>




NS_ASSUME_NONNULL_BEGIN

@interface OpenCVBridgeFile : NSObject

-(void)callCppFunction:(NSString *)imageName;

- (UIImage *)transfromImage;

/// 获取单应性矩阵
- (void)calculateHomegraphyMatsss;
@end

NS_ASSUME_NONNULL_END
