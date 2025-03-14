//  Ultralytics YOLO 🚀 - AGPL-3.0 License
//
//  Video Capture for Ultralytics YOLOv8 Preview on iOS
//  Part of the Ultralytics YOLO app, this file defines the VideoCapture class to interface with the device's camera,
//  facilitating real-time video capture and frame processing for YOLOv8 model previews.
//  Licensed under AGPL-3.0. For commercial use, refer to Ultralytics licensing: https://ultralytics.com/license
//  Access the source code: https://github.com/ultralytics/yolo-ios-app
//
//  This class encapsulates camera initialization, session management, and frame capture delegate callbacks.
//  It dynamically selects the best available camera device, configures video input and output, and manages
//  the capture session. It also provides methods to start and stop video capture and delivers captured frames
//  to a delegate implementing the VideoCaptureDelegate protocol.

import AVFoundation
import CoreVideo
import UIKit
import Photos
// Defines the protocol for handling video frame capture events.
public protocol VideoCaptureDelegate: AnyObject {
  func videoCapture(_ capture: VideoCapture, didCaptureVideoFrame: CMSampleBuffer)
}

// Identifies the best available camera device based on user preferences and device capabilities.
func bestCaptureDevice(for position: AVCaptureDevice.Position) -> AVCaptureDevice {
    // 选择超广角相机
           guard let videoDevice = AVCaptureDevice.default(.builtInUltraWideCamera, for: .video, position: .back) else {
               fatalError("No ultra-wide camera available")
           }
    return videoDevice
    
    if #available(iOS 13.0, *) {
        let deviceTypes: [AVCaptureDevice.DeviceType] = [
            //.builtInWideAngleCamera
               .builtInUltraWideCamera
           ]
           let discoverySession = AVCaptureDevice.DiscoverySession(
               deviceTypes: deviceTypes,
               mediaType: AVMediaType.video,
               position: position
           )
    
        return discoverySession.devices.first ?? AVCaptureDevice.init(uniqueID: "")!
       }
    
    
//    if position == .back {
//    // バックカメラの場合
//    if UserDefaults.standard.bool(forKey: "use_telephoto"),
//      let device = AVCaptureDevice.default(.builtInUltraWideCamera, for: .video, position: .back)
//    {
//      return device
//    } else if let device = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back)
//    {
//      return device
//    } else if let device = AVCaptureDevice.default(
//      .builtInWideAngleCamera, for: .video, position: .back)
//    {
//      return device
//    } else {
//      fatalError("Expected back camera device is not available.")
//    }
//  } else if position == .front {
//    // フロントカメラの場合
//    if let device = AVCaptureDevice.default(.builtInUltraWideCamera, for: .video, position: .front)
//    {
//      return device
//    } else if let device = AVCaptureDevice.default(
//      .builtInWideAngleCamera, for: .video, position: .front)
//    {
//      return device
//    } else {
//      fatalError("Expected front camera device is not available.")
//    }
//  } else {
//    fatalError("Unsupported camera position: \(position)")
//  }
}

public class VideoCapture: NSObject,AVCaptureFileOutputRecordingDelegate {
  public var previewLayer: AVCaptureVideoPreviewLayer?
  public weak var delegate: VideoCaptureDelegate?

  let captureDevice = bestCaptureDevice(for: .back)
  let captureSession = AVCaptureSession()
  let videoOutput = AVCaptureVideoDataOutput()
  var cameraOutput = AVCapturePhotoOutput()
  var movieFileOutput = AVCaptureMovieFileOutput() // 视频输出，保存视频用
  var isRecording = false // 是否正在录制视频

  let queue = DispatchQueue(label: "camera-queue")

  // Configures the camera and capture session with optional session presets.
  public func setUp(
    sessionPreset: AVCaptureSession.Preset = .hd1920x1080, completion: @escaping (Bool) -> Void
  ) {
    queue.async {
      let success = self.setUpCamera(sessionPreset: sessionPreset)
      DispatchQueue.main.async {
        completion(success)
      }
    }
  }

  // Internal method to configure camera inputs, outputs, and session properties.
  private func setUpCamera(sessionPreset: AVCaptureSession.Preset) -> Bool {
    captureSession.beginConfiguration()
    captureSession.sessionPreset = sessionPreset

    guard let videoInput = try? AVCaptureDeviceInput(device: captureDevice) else {
      return false
    }

    if captureSession.canAddInput(videoInput) {
      captureSession.addInput(videoInput)
    }
    if captureSession.canAddOutput(movieFileOutput) {
     captureSession.addOutput(movieFileOutput)
    }

    let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
    ///使用 AVLayerVideoGravity.resizeAspectFill 可以填充整个预览层，但可能会裁切部分内容
    previewLayer.videoGravity = .resizeAspectFill
    previewLayer.connection?.videoOrientation = .portrait
    self.previewLayer = previewLayer

    let settings: [String: Any] = [
      kCVPixelBufferPixelFormatTypeKey as String: NSNumber(value: kCVPixelFormatType_32BGRA)
    ]

    videoOutput.videoSettings = settings
    videoOutput.alwaysDiscardsLateVideoFrames = true
    videoOutput.setSampleBufferDelegate(self, queue: queue)
    if captureSession.canAddOutput(videoOutput) {
      captureSession.addOutput(videoOutput)
    }

    if captureSession.canAddOutput(cameraOutput) {
      captureSession.addOutput(cameraOutput)
    }
    switch UIDevice.current.orientation {
    case .portrait:
      videoOutput.connection(with: .video)?.videoOrientation = .portrait
    case .portraitUpsideDown:
      videoOutput.connection(with: .video)?.videoOrientation = .portraitUpsideDown
    case .landscapeRight:
      videoOutput.connection(with: .video)?.videoOrientation = .landscapeLeft
    case .landscapeLeft:
      videoOutput.connection(with: .video)?.videoOrientation = .landscapeRight
    default:
      videoOutput.connection(with: .video)?.videoOrientation = .portrait
    }

    if let connection = videoOutput.connection(with: .video) {
      self.previewLayer?.connection?.videoOrientation = connection.videoOrientation
    }
    do {
      try captureDevice.lockForConfiguration()
       if captureDevice.isFocusModeSupported(.continuousAutoFocus) {
           captureDevice.focusMode = .continuousAutoFocus
           captureDevice.focusPointOfInterest = CGPoint(x: 0.5, y: 0.5)
       } else {
           print("Continuous auto-focus not supported")
       }
        
      captureDevice.exposureMode = .continuousAutoExposure
      captureDevice.unlockForConfiguration()
    } catch {
      print("Unable to configure the capture device.")
      return false
    }

    captureSession.commitConfiguration()
    return true
  }

  // Starts the video capture session.
  public func start() {
    if !captureSession.isRunning {
      DispatchQueue.global(qos: .userInitiated).async { [weak self] in
        self?.captureSession.startRunning()
      }
    }
  }

  // Stops the video capture session.
  public func stop() {
    if captureSession.isRunning {
      captureSession.stopRunning()
    }
  }
    
    
  // 开始录制视频
  public func startRecordVideo() {
    
      if (isRecording) {
          // 停止录制
         movieFileOutput.stopRecording()
      } else {
          // 开始录制
          print("开始录制视频")
          let fileName = "\(Date().timeIntervalSince1970).mp4"
          let filePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(fileName)
          let fileURL = URL(fileURLWithPath: filePath)
          movieFileOutput.startRecording(to: fileURL, recordingDelegate: self)
          isRecording = !isRecording
      }
   }
    
  public func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: (any Error)?) {
    if let error = error {
                print("录制失败: \(error.localizedDescription)")
                return
            }
      DispatchQueue.main.async {
          // 保存到相册
         PHPhotoLibrary.requestAuthorization { status in
             if status == .authorized {
                 PHPhotoLibrary.shared().performChanges({
                     PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: outputFileURL)
                 }) { success, error in
                     if success {
                         print("视频已保存到相册")
                     } else {
                         print("保存失败: \(error?.localizedDescription ?? "未知错误")")
                     }
                 }
             } else {
                 print("用户未授权访问相册")
             }
         }
      }
}

  func updateVideoOrientation() {
    guard let connection = videoOutput.connection(with: .video) else { return }
    switch UIDevice.current.orientation {
    case .portrait:
      connection.videoOrientation = .portrait
    case .portraitUpsideDown:
      connection.videoOrientation = .portraitUpsideDown
    case .landscapeRight:
      connection.videoOrientation = .landscapeLeft
    case .landscapeLeft:
      connection.videoOrientation = .landscapeRight
    default:
      return
    }

    let currentInput = self.captureSession.inputs.first as? AVCaptureDeviceInput
    if currentInput?.device.position == .front {
      connection.isVideoMirrored = true
    } else {
      connection.isVideoMirrored = false
    }

    self.previewLayer?.connection?.videoOrientation = connection.videoOrientation
  }

}

// Extension to handle AVCaptureVideoDataOutputSampleBufferDelegate events.
extension VideoCapture: AVCaptureVideoDataOutputSampleBufferDelegate {
  public func captureOutput(
    _ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer,
    from connection: AVCaptureConnection
  ) {
    delegate?.videoCapture(self, didCaptureVideoFrame: sampleBuffer)
  }

  public func captureOutput(
    _ output: AVCaptureOutput, didDrop sampleBuffer: CMSampleBuffer,
    from connection: AVCaptureConnection
  ) {
    // Optionally handle dropped frames, e.g., due to full buffer.
  }
}
