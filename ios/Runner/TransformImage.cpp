//
//  TransformImage.cpp
//  Runner
//
//  Created by 孟恒 on 2025/3/3.
//

#include "TransformImage.hpp"

#include <opencv2/opencv.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/imgproc/imgproc.hpp>

using namespace cv;
using namespace std;
///Users/mengheng/Desktop/WechatIMG37.jpg

void TransformImage::transform_image(const std::string& name) {
    
    // 读取图像
    Mat image = imread(name, IMREAD_COLOR);
    
    if (image.empty()) {
        std::cerr << "Error: Could not open or find the image." << std::endl;
    }
    
    // 定义源图像和目标图像的四个角点
    Point2f srcPoints[4] = {Point2f(0, 0), Point2f(image.cols - 1, 0), Point2f(image.cols - 1, image.rows - 1), Point2f(0, image.rows - 1)};
    Point2f dstPoints[4] = {Point2f(0, 0), Point2f(image.cols - 1, 0), Point2f(image.cols - 100, image.rows - 100), Point2f(100, image.rows - 100)};
    
    // 设置输出图像的大小
    Size dsize(image.cols, image.rows);
    
    // 计算透视变换矩阵
    Mat perspectiveMatrix = getPerspectiveTransform(srcPoints, dstPoints);
    
    // 创建输出图像
    Mat transformedImage;
    
    // 应用透视变换
    warpPerspective(image, transformedImage, perspectiveMatrix, dsize, INTER_LINEAR, BORDER_CONSTANT, Scalar(0, 0, 0));
    
    
    
    // 显示结果
//    namedWindow("Original Image", WINDOW_NORMAL);
//    imshow("Original Image", image);
//    
//    namedWindow("Transformed Image", WINDOW_NORMAL);
//    imshow("Transformed Image", transformedImage);
//    
//    waitKey(0);
//    
}


//int main(int argc, char** argv)
//{
//    
//    // 读取图像
//    Mat image = imread("/media/dingxin/data/study/OpenCV/sources/images/fruit_small.jpg", IMREAD_COLOR);
//    
//    if (image.empty()) {
//        std::cerr << "Error: Could not open or find the image." << std::endl;
//        return -1;
//    }
//    
//    // 定义源图像和目标图像的四个角点
//    Point2f srcPoints[4] = {Point2f(0, 0), Point2f(image.cols - 1, 0), Point2f(image.cols - 1, image.rows - 1), Point2f(0, image.rows - 1)};
//    Point2f dstPoints[4] = {Point2f(0, 0), Point2f(image.cols - 1, 0), Point2f(image.cols - 100, image.rows - 100), Point2f(100, image.rows - 100)};
//    
//    // 设置输出图像的大小
//    Size dsize(image.cols, image.rows);
//    
//    // 计算透视变换矩阵
//    Mat perspectiveMatrix = getPerspectiveTransform(srcPoints, dstPoints);
//    
//    // 创建输出图像
//    Mat transformedImage;
//    
//    // 应用透视变换
//    warpPerspective(image, transformedImage, perspectiveMatrix, dsize, INTER_LINEAR, BORDER_CONSTANT, Scalar(0, 0, 0));
//    
//    // 显示结果
//    namedWindow("Original Image", WINDOW_NORMAL);
//    imshow("Original Image", image);
//    
//    namedWindow("Transformed Image", WINDOW_NORMAL);
//    imshow("Transformed Image", transformedImage);
//    
//    waitKey(0);
//    
//    return 0;
//}
