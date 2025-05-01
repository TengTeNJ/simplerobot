//
//  CameraPickVC.swift
//  Runner
//
//  Created by 孟恒 on 2025/3/5.
//

import UIKit

/// 相机捡球VC
import AVFoundation
import CoreML
import CoreMedia
import UIKit
import Vision
import Flutter
import Accelerate


var mlRobotModel = try! robot(configuration: mlRobotmodelConfig).model

var mlRobotmodelConfig: MLModelConfiguration = {
  let config = MLModelConfiguration()

  if #available(iOS 17.0, *) {
    config.setValue(1, forKey: "experimentalMLE5EngineUsage")
  }

  return config
}()

/// 鹰眼捡球界面的类别
extension CameraCalibrationController {
    
    /// 校准View
    func setUpKeyPointUi() {

        
       // videoPreview = UIView(frame: CGRect(x: 0, y: 0, width: Constants.ScreenWidth, height: Constants.ScreenWidth))
        videoPreview = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        
        view.addSubview(videoPreview)
       // view.addSubview(cameraMaskView)

        
        let backbtn = UIButton(frame: CGRect(x: 32, y: 32, width: 52, height: 52))
        backbtn.setImage(UIImage(named: "back_icon"), for: .normal)
        backbtn.backgroundColor = UIColor(red: 233/255.0, green: 100/255.0, blue: 21/255.0, alpha: 1.0)
        backbtn.contentEdgeInsets = UIEdgeInsets(top: 16, left: 20, bottom: 16, right: 20)
        backbtn.imageView?.frame = CGRect(x: 0, y: 0, width: 10, height: 20)
        backbtn.layer.cornerRadius = 26
        backbtn.clipsToBounds = true
        backbtn.addTarget(self, action: #selector(back(_:)), for: .touchUpInside)
        self.backBtn = backbtn
        view.addSubview(backbtn)
        
        let readybtn = UIButton(type: .custom)
        readybtn.frame = CGRect(x: Constants.ScreenWidth - 32 - 52, y: 32, width: 52, height: 52)
        readybtn.setImage(UIImage(named: "ready_icon.png"), for: .normal)
              
        readybtn.backgroundColor = UIColor(red: 156/255.0, green: 156/255.0, blue: 156/255.0, alpha: 0.85)
        readybtn.addTarget(self, action: #selector(nextAction(_:)), for: .touchUpInside)
        readybtn.contentEdgeInsets = UIEdgeInsets(top: 20, left: 17, bottom: 17, right: 14)
        readybtn.imageView?.contentMode = .scaleAspectFit
        readybtn.imageView?.frame = CGRect(x: 0, y: 0, width: 20, height: 15)
        readybtn.layer.cornerRadius = 26
        readybtn.clipsToBounds = true
        view.addSubview(readybtn)
        self.readyBtn = readybtn
        
        
        
       
        let desLabel = UILabel(frame: CGRect(x: 100, y: Constants.ScreenHeight - 120, width: Constants.ScreenWidth - 100*2, height: 46))
        desLabel.text = """
        Please position the key points of the court within the calibration
        circle to achieve field of view calibration.
        """
        desLabel.numberOfLines = 2
        desLabel.textColor = .white
        desLabel.textAlignment = .center
        view.addSubview(desLabel)
        self.desLab = desLabel
        
        createKeyPoint()
        
        
    }

    /// 四个关键点
    func createKeyPoint() {
        
       // double scale = 1.0;
        //std::vector<cv::Point2f> srcPoints = {cv::Point2f(323 * scale, 112 * scale), cv::Point2f(424* scale, 110*scale),
         //   cv::Point2f(618 * scale, 143 * scale), cv::Point2f(548 * scale, 168 * scale)};
        /// 固定坐标写死四个点
        let scale = 1.0;
        point1 = CommonTool.createVIew(CGRect(x: 323 * scale, y: 112 * scale, width: 15, height: 15))
        view.addSubview(point1)
        point2 = CommonTool.createVIew(CGRect(x: 424 * scale, y: 110 * scale, width: 15, height: 15))
        view.addSubview(point2)
        point3 = CommonTool.createVIew(CGRect(x: 618 * scale, y: 143 * scale, width: 15, height: 15))
        view.addSubview(point3)
        point4 = CommonTool.createVIew(CGRect(x: 548 * scale, y: 168 * scale, width: 15, height: 15))
        view.addSubview(point4)
    }
   
    /// 关键点界面的元素是否隐藏
    func keyPointElementIsHidden(_ ishidden: Bool) {
        self.point1.isHidden = ishidden
        self.point2.isHidden = ishidden
        self.point3.isHidden = ishidden
        self.point4.isHidden = ishidden
        
        self.backBtn.isHidden = ishidden
        self.readyBtn.isHidden = ishidden
        self.desLab.isHidden = ishidden
        

    }
   
    
    // MARK: - 修改视频流宽高比(与训练YOLO模型保持一致 1920*1080)
    func resizePixelBuffer(_ pixelBuffer: CVPixelBuffer, toSize size: CGSize) -> CVPixelBuffer? {
        // Lock the base address of the pixel buffer
        CVPixelBufferLockBaseAddress(pixelBuffer, .readOnly)
        
        // Get information about the pixel buffer
        let baseAddress = CVPixelBufferGetBaseAddress(pixelBuffer)
        let bytesPerRow = CVPixelBufferGetBytesPerRow(pixelBuffer)
        let width = CVPixelBufferGetWidth(pixelBuffer)
        let height = CVPixelBufferGetHeight(pixelBuffer)
        
        // Create a new pixel buffer with the desired size
        var newPixelBuffer: CVPixelBuffer?
        let options = [kCVPixelBufferCGImageCompatibilityKey: true, kCVPixelBufferCGBitmapContextCompatibilityKey: true] as CFDictionary
        CVPixelBufferCreate(kCFAllocatorDefault, Int(size.width), Int(size.height), kCVPixelFormatType_32BGRA, options, &newPixelBuffer)
        
        // Lock the base address of the new pixel buffer
        CVPixelBufferLockBaseAddress(newPixelBuffer!, .readOnly)
        
        // Get the base address of the new pixel buffer
        let newBaseAddress = CVPixelBufferGetBaseAddress(newPixelBuffer!)
        
        // Perform the scaling using vImage
        var sourceBuffer = vImage_Buffer(data: baseAddress, height: vImagePixelCount(height), width: vImagePixelCount(width), rowBytes: bytesPerRow)
        var destinationBuffer = vImage_Buffer(data: newBaseAddress, height: vImagePixelCount(size.height), width: vImagePixelCount(size.width), rowBytes: CVPixelBufferGetBytesPerRow(newPixelBuffer!))
        
        let scaleError = vImageScale_ARGB8888(&sourceBuffer, &destinationBuffer, nil, 0)
        
        // Unlock the base addresses
        CVPixelBufferUnlockBaseAddress(pixelBuffer, .readOnly)
        CVPixelBufferUnlockBaseAddress(newPixelBuffer!, .readOnly)
        
        if scaleError != kvImageNoError {
            return nil
        }
        
        return newPixelBuffer
    }
    
}


