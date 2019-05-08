//
//  CameraView.swift
//  anecel
//
//  Created by NhatQuang on 3/16/18.
//  Copyright © 2018 Paditech. All rights reserved.
//

import Foundation
import AVFoundation
import RxCocoa
import RxSwift
import UIKit


class CameraView: UIView {
	
	fileprivate var captureSession: AVCaptureSession?
	fileprivate var videoPreviewLayer: AVCaptureVideoPreviewLayer?
	fileprivate var capturePhotoOutput: AVCapturePhotoOutput?
    fileprivate var captureDevice: AVCaptureDevice? = {
        return  AVCaptureDevice.default(for: AVMediaType.video)
    }()
    
	override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setupCamera()
	}
	
	// Output
	let image = PublishSubject<UIImage>()
	
	override func layoutSubviews() {
		super.layoutSubviews()
        //print(self.layer.bounds)
		videoPreviewLayer?.frame = self.layer.bounds
	}
}

// MARK: - Setup camera
extension CameraView {
    
	func setupCamera() {
        self.clipsToBounds = true
		// Get an instance of the AVCaptureDevice class to initialize a device object
        // and provide the video as the media type parameter
		guard let captureDevice = self.captureDevice else {
            //fatalError("No video device found")
			return
		}
        
		do {
			// Get an instance of the AVCaptureDeviceInput class using the previous deivce object
			let input = try AVCaptureDeviceInput(device: captureDevice)
			
			// Initialize the captureSession object
			captureSession = AVCaptureSession()
			
			// Set the input devcie on the capture session
			captureSession?.addInput(input)
			
			// Get an instance of ACCapturePhotoOutput class
			capturePhotoOutput = AVCapturePhotoOutput()
			capturePhotoOutput?.isHighResolutionCaptureEnabled = true
			
			// Set the output on the capture session
			captureSession?.addOutput(capturePhotoOutput!)
			
			// Initialize a AVCaptureMetadataOutput object and set it as the input device
			let captureMetadataOutput = AVCaptureMetadataOutput()
			captureSession?.addOutput(captureMetadataOutput)
			
			// Set delegate and use the default dispatch queue to execute the call back
			captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
			captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
			
			//Initialise the video preview layer and add it as a sublayer to the viewPreview view's layer
			videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
			videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
			videoPreviewLayer?.frame = self.layer.bounds
            videoPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
            videoPreviewLayer?.masksToBounds = true
            self.clipsToBounds = true
			self.layer.addSublayer(videoPreviewLayer!)
			self.layer.masksToBounds = true
            
			//start video capture
			captureSession?.startRunning()
            
            // add PinchGesture
            let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(self.pinchGesture(recognizer:)))
            pinchGesture.delegate = self
            self.addGestureRecognizer(pinchGesture)
		} catch {
			//If any error occurs, simply print it out
			print(error)
			return
		}
	}
    
    @objc func pinchGesture(recognizer: UIPinchGestureRecognizer) {
        print(recognizer)
        
        //recognizer.view?.transform = (recognizer.view?.transform)!.scaledBy(x: recognizer.scale, y: recognizer.scale)
        //recognizer.scale = 1.0
        setZoomFactor(scale: recognizer.scale)
    }
    
    func setZoomFactor(scale: CGFloat) {
        guard let captureDevice = self.captureDevice else { return }
        
        do {
            try captureDevice.lockForConfiguration()
            captureDevice.videoZoomFactor = max(1.0, min(scale, captureDevice.activeFormat.videoMaxZoomFactor))
            captureDevice.unlockForConfiguration()
        } catch {
            //Catch error from lockForConfiguration
        }
    }
}

extension CameraView: UIGestureRecognizerDelegate {
    
    
}

extension CameraView: AVCaptureMetadataOutputObjectsDelegate {
    
	func metadataOutput(_ captureOutput: AVCaptureMetadataOutput,
						didOutput metadataObjects: [AVMetadataObject],
						from connection: AVCaptureConnection) {
		// Check if the metadataObjects array is contains at least one object.
		if metadataObjects.count == 0 {
			
			return
		}
		
		// Get the metadata object.
		let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
		
		if metadataObj.type == AVMetadataObject.ObjectType.qr {
			if metadataObj.stringValue != nil {
				
			}
		}
	}
}

extension CameraView: AVCapturePhotoCaptureDelegate {
    
    @available(iOS 11.0, *)
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        let imageData = photo.fileDataRepresentation()
        if let data = imageData, let image = UIImage(data: data) {
            self.image.onNext(image)
        }
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        if photoSampleBuffer != nil {
            let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(photoSampleBuffer!)
            let dataProvider = CGDataProvider(data: imageData! as CFData)
            let cgImageRef = CGImage.init(jpegDataProviderSource: dataProvider!, decode: nil, shouldInterpolate: true, intent: CGColorRenderingIntent.relativeColorimetric)
            let image = UIImage(cgImage: cgImageRef!, scale: 1.0, orientation: UIImage.Orientation.right)
            // Emit new image
            self.image.onNext(image)
        }
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishCaptureFor resolvedSettings: AVCaptureResolvedPhotoSettings, error: Error?) {
        guard error == nil else {
            print("Error in capture process: \(String(describing: error))")
            return
        }
    }
}

// MARK: - Action
extension CameraView {
    
	func takeImage() {
        guard let capturePhotoOutput = self.capturePhotoOutput, let _ = capturePhotoOutput.connection(with: AVMediaType.video) else { return }
		
        let settings: AVCapturePhotoSettings!
        if #available(iOS 11.0, *) {
            settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        } else {
            settings = AVCapturePhotoSettings(format: nil)
        }
        let previewPixelType = settings.availablePreviewPhotoPixelFormatTypes.first!
        let previewFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewPixelType,
                             kCVPixelBufferWidthKey as String: 160,
                             kCVPixelBufferHeightKey as String: 160]
        settings.previewPhotoFormat = previewFormat
        settings.isAutoStillImageStabilizationEnabled = true
        settings.flashMode = .off
        settings.isHighResolutionPhotoEnabled = false
        capturePhotoOutput.capturePhoto(with: settings, delegate: self)
	}
}







