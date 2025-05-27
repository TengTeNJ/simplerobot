//
//  OpenCVBridgeFile.m
//  Runner
//
//  Created by 孟恒 on 2025/3/3.
//

#import "OpenCVBridgeFile.h"
#import "TransformImage.hpp"

#include <opencv2/opencv.hpp>
#import <opencv2/imgproc/imgproc.hpp>
#import <opencv2/highgui/highgui.hpp>

@implementation OpenCVBridgeFile

- (void)callCppFunction:(NSString *)imageName {
    // 调用 C++ 方法
    TransformImage transform;
    transform.transform_image([imageName cStringUsingEncoding:NSUTF8StringEncoding]);
}

- (cv::Mat)warpImage:(cv::Mat)inputMat
              matrix:(cv::Mat)transformMatrix
                 size:(cv::Size)size {
    cv::Mat outputMat;
    cv::warpPerspective(inputMat, outputMat, transformMatrix, size);
    return outputMat;
}

- (UIImage *)getImage:(cv::Mat)cvMat
{
    //获取矩阵数据
    NSData *data = [NSData dataWithBytes:cvMat.data length:cvMat.elemSize()*cvMat.total()];
    //判断矩阵使用的颜色空间
    CGColorSpaceRef colorSpace;
    if (cvMat.elemSize() == 1) {
        colorSpace = CGColorSpaceCreateDeviceGray();
    } else {
        colorSpace = CGColorSpaceCreateDeviceRGB();
    }
    //创建数据privder
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    
    //获取bitmpa位数
    size_t bitsPerPixel = cvMat.elemSize()*8;
    //获取通道数
    size_t channels = cvMat.channels();
    //获取通道位深
    size_t bitsPerComponent = bitsPerPixel/channels;
    
    //创建位图信息  根据通道位深及通道数判断使用的位图信息
    CGBitmapInfo bitmapInfo;
    if(bitsPerComponent == 8){
        if(channels == 3){
            bitmapInfo = kCGImageAlphaNone | kCGImageByteOrderDefault;
        }else if(channels == 4){
            bitmapInfo = kCGImageAlphaPremultipliedLast | kCGImageByteOrderDefault;
        }else{
            printf("图片格式不支持");
            abort();
        }
    }else if(bitsPerComponent == 16){
        if(channels == 3){
            bitmapInfo = kCGImageAlphaNone | kCGImageByteOrder16Little;
        }else if(channels == 4){
            bitmapInfo = kCGImageAlphaPremultipliedLast | kCGImageByteOrder16Little;
        }else{
            printf("图片格式不支持");
            abort();
        }
    }else{
        printf("图片格式不支持");
        abort();
    }
    
   

    //根据矩阵及相关信息创建CGImageRef结构体
    CGImageRef imageRef = CGImageCreate(cvMat.cols, //矩阵宽度
                                        cvMat.rows, //矩阵列数
                                        bitsPerComponent,        //通道位深
                                        8 * cvMat.elemSize(),  //每个像素位深
                                        cvMat.step[0],  //每行占用字节数
                                        colorSpace,    //使用的颜色空间
                                        bitmapInfo,//通道排序、大小端读取顺序信息
                                        provider, //数据源
                                        NULL,   //解码数组 一般传null
                                        true, //是否抗锯齿
                                        kCGRenderingIntentDefault   //使用默认的渲染方式
                                        );
    // 通过cgImage转化出来UIImage对象
    UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
    //释放imageRef
    CGImageRelease(imageRef);
    //释放provider
    CGDataProviderRelease(provider);
    //释放颜色空间
    CGColorSpaceRelease(colorSpace);
    return finalImage;
}

- (UIImage *)transfromImage {
     NSString * path = [[NSBundle mainBundle] pathForResource:@"WechatIMG37" ofType:@"jpg"];
    // 读取输入图像
      cv::Mat inputImage = cv::imread([path cStringUsingEncoding:NSUTF8StringEncoding]);
    
      if (inputImage.empty()) {
          std::cerr << "Error: Image not loaded!" << std::endl;
          UIImage *img;
          return img;
      }

    
    //Point2f srcPoints[4] = {Point2f(0, 0), Point2f(image.cols - 1, 0), Point2f(image.cols - 1, image.rows - 1), Point2f(0, image.rows - 1)};
  //  Point2f dstPoints[4] = {Point2f(0, 0), Point2f(image.cols - 1, 0), Point2f(image.cols - 100, image.rows - 100), Point2f(100, image.rows - 100)};
    
      // 定义透视变换矩阵
      std::vector<cv::Point2f> srcPoints = {cv::Point2f(320, 116), cv::Point2f(430, 105),
                                            cv::Point2f(670, 124), cv::Point2f(586, 146)};
      std::vector<cv::Point2f> dstPoints = {cv::Point2f(0, 0), cv::Point2f(844, 0),
                                            cv::Point2f(844/2, 390), cv::Point2f(0, 390)};
      cv::Mat transformMatrix = cv::getPerspectiveTransform(srcPoints, dstPoints);

    // 调用封装的 warpPerspective 方法
      cv::Mat warpedImage = [self warpImage:inputImage
                                                   matrix:transformMatrix
                                                      size:cv::Size(inputImage.cols, inputImage.rows)];

    UIImage *handleImg = [self getImage:warpedImage];
    return  handleImg;
}

- (void)calculateHomegraphyMatsss {
    cv::Mat homographyMatrix = [self calculateHomegraphyMat];
//    cv::Mat homographyMatrix = [self calculateIPhone15HomegraphyMat];
}

- (void)calculateDynamicHomegraphyMatrix:(NSArray *)points {
    cv::Mat matrix = [self calculateDynamicHomegraphyMatrixss:points];
}

// 获取单应性矩阵
- (cv::Mat)calculateHomegraphyMat {
    // 将 CGPoint 转换为 OpenCV 的 Mat 格式
    // 13 pro 12 等 844**390.0 的关键点坐标
    double scale = 1.0;
    std::vector<cv::Point2f> srcPoints = {cv::Point2f(323 * scale, 112 * scale), cv::Point2f(424* scale, 110*scale),
        cv::Point2f(618 * scale, 143 * scale), cv::Point2f(548 * scale, 168 * scale)};
    
    // 13 pro 12 等 844**390.0 虚拟小地图上的四个点
    std::vector<cv::Point2f> dstPoints = {cv::Point2f(430, 138), cv::Point2f(516, 138),
                                          cv::Point2f(498, 280), cv::Point2f(430, 280)};
  
    cv::Mat homographyMatrix = cv::findHomography(srcPoints, dstPoints);
    // 逐元素访问并打印
    for (int i = 0; i < homographyMatrix.rows; i++) {
        for (int j = 0; j < homographyMatrix.cols; j++) {
            std::cout << homographyMatrix.at<double>(i, j) << " ";
        }
        std::cout << std::endl;
    }
    return homographyMatrix;
}

// 获取单应性矩阵
- (cv::Mat)calculateIPhone15HomegraphyMat {
    // 将 CGPoint 转换为 OpenCV 的 Mat 格式
    // 13 pro 12 等 844**390.0 的关键点坐标
    double scale = 1.0;
    std::vector<cv::Point2f> srcPoints = {cv::Point2f(323 * scale, 112 * scale), cv::Point2f(424* scale, 110*scale),
        cv::Point2f(618 * scale, 143 * scale), cv::Point2f(548 * scale, 168 * scale)};
    
    // 13 pro 12 等 844**390.0 的手机屏幕上的四个点
    std::vector<cv::Point2f> dstPoints = {cv::Point2f(430, 138), cv::Point2f(516, 138),
                                          cv::Point2f(516, 260), cv::Point2f(430, 260)};
  
    cv::Mat homographyMatrix = cv::findHomography(srcPoints, dstPoints);
    // 逐元素访问并打印
    for (int i = 0; i < homographyMatrix.rows; i++) {
        for (int j = 0; j < homographyMatrix.cols; j++) {
            std::cout << homographyMatrix.at<double>(i, j) << " ";
        }
        std::cout << std::endl;
    }
    return homographyMatrix;
}

- (cv::Mat)calculateDynamicHomegraphyMatrixss:(NSArray *)points {
       for (NSValue *value in points) {
           CGPoint point = [value CGPointValue];
       }
    CGPoint leftTopPoint = [points[0] CGPointValue];
    CGPoint rightTopPoint = [points[1] CGPointValue];
    CGPoint bottomLeftPoint = [points[2] CGPointValue];
    CGPoint bottomRightPoint = [points[3] CGPointValue];

    // 将 CGPoint 转换为 OpenCV 的 Mat 格式
    // 13 pro 12 等 844**390.0 的关键点坐标
    double scale = 1.0;
    std::vector<cv::Point2f> srcPoints = {cv::Point2f(leftTopPoint.x * scale, leftTopPoint.y * scale), cv::Point2f(rightTopPoint.x* scale, rightTopPoint.y*scale),
        cv::Point2f(bottomRightPoint.x * scale, bottomRightPoint.y * scale), cv::Point2f(bottomLeftPoint.x * scale, bottomLeftPoint.y * scale)};
    
    // 手机虚拟小地图对应的四个点
    std::vector<cv::Point2f> dstPoints = {cv::Point2f(430, 138), cv::Point2f(516, 138),
                                          cv::Point2f(516, 260), cv::Point2f(430, 260)};
  
    
    NSMutableArray *matrixs = [NSMutableArray new];
    cv::Mat homographyMatrix = cv::findHomography(srcPoints, dstPoints);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    // 逐元素访问并打印
    for (int i = 0; i < homographyMatrix.rows; i++) {
        for (int j = 0; j < homographyMatrix.cols; j++) {
            std::cout << homographyMatrix.at<double>(i, j) << " ";
            
            NSString *message = [NSString stringWithFormat:@"%d,%d", i, j];
            [defaults setFloat:homographyMatrix.at<double>(i, j) forKey:message];
        }
        std::cout << std::endl;
    }
    return homographyMatrix;
}

/// 转换成矩形
- (void)tranferRectangle {
    
    
}


@end
