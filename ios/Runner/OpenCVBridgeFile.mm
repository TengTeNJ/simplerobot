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
      std::vector<cv::Point2f> srcPoints = {cv::Point2f(0, 0), cv::Point2f(inputImage.cols -1, 0),
                                            cv::Point2f(inputImage.cols-1, inputImage.rows-1), cv::Point2f(0, inputImage.rows -1)};
      std::vector<cv::Point2f> dstPoints = {cv::Point2f(0, 0), cv::Point2f(inputImage.cols - 1, 0),
                                            cv::Point2f(inputImage.cols - 100, inputImage.rows - 100), cv::Point2f(100, inputImage.rows - 100)};
      cv::Mat transformMatrix = cv::getPerspectiveTransform(srcPoints, dstPoints);

    // 调用封装的 warpPerspective 方法
      cv::Mat warpedImage = [self warpImage:inputImage
                                                   matrix:transformMatrix
                                                      size:cv::Size(inputImage.cols, inputImage.rows)];

    UIImage *handleImg = [self getImage:warpedImage];
    return  handleImg;
}


@end
