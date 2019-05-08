//
//  MediaSourceManager.swift
//  WeWorld
//
//  Created by NhatQuang on 1/4/18.
//  Copyright © 2018 Paditech. All rights reserved.
//

import Foundation
import UIKit
import Photos
import MobileCoreServices

class PMediaSource: NSObject {
    
    weak var sourceViewController: UIViewController?
    var allowsEditing = false
    var handleTakedImage: ((UIImage) -> Void)?
    
    init(sourceViewController: UIViewController, allowsEditing: Bool = false) {
        self.sourceViewController = sourceViewController
        self.allowsEditing = allowsEditing
    }
}

// MARK: - Action function

extension PMediaSource {
    
    func showOption(actions: [UIAlertAction]? = nil) {
        let fromLibraryAction = UIAlertAction(title: "choose_from_library".localized(), style: .default) { (alertAction) in
            self.getMedia(type: .photoLibrary)
        }
        let fromCameraAction = UIAlertAction(title: "take_a_photo".localized(), style: .default) { (alertAction) in
            // Check camera available on current device
            if !UIImagePickerController.isSourceTypeAvailable(.camera) {
                return
            }
            self.getMedia(type: .camera)
        }
        let cancelAction = UIAlertAction(title: "CANCEL".localized(), style: .cancel, handler: nil)
        let alertController = UIAlertController(title: "choose_media".localized(), message: nil, preferredStyle: .actionSheet)
        alertController.addAction(fromCameraAction)
        alertController.addAction(fromLibraryAction)
        actions?.forEach({ (action) in
            alertController.addAction(action)
        })
        
        alertController.addAction(cancelAction)
        sourceViewController?.present(alertController, animated: true, completion: nil)
    }
    
    private func showCamera() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.mediaTypes = [ kUTTypeImage as String ]
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = allowsEditing
        DispatchQueue.main.async {
            self.sourceViewController?.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    private func showPhoto() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.mediaTypes = [ kUTTypeImage as String ]
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = allowsEditing
        DispatchQueue.main.async {
            self.sourceViewController?.present(imagePicker, animated: true, completion: nil)
        }
    }
}

// MARK: - Delegate

extension PMediaSource: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        var selectedImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage)] as? UIImage
        if selectedImage == nil {
            selectedImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage
        }
        if let selectedImage = selectedImage {
            handleTakedImage?(selectedImage)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    // Helper function inserted by Swift 4.2 migrator.
    fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
        return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
    }
    
    // Helper function inserted by Swift 4.2 migrator.
    fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
        return input.rawValue
    }
}

// MARK: - Require permission again

extension PMediaSource {
    
    func getMedia(type: UIImagePickerController.SourceType) {
        switch type {
        case .camera:
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) -> Void in
                if granted == true {
                    self.showCamera()
                } else {
                    self.showAlertActionRequireMediaPermission(type: type)
                }
            })
        case .photoLibrary:
            PHPhotoLibrary.requestAuthorization({(status: PHAuthorizationStatus) in
                switch status {
                case .authorized:
                    self.showPhoto()
                case .denied:
                    self.showAlertActionRequireMediaPermission(type: type)
                default:
                    break
                }
            })
        default:
            break
        }
    }
    
    private func showAlertActionRequireMediaPermission(type: UIImagePickerController.SourceType) {
        let title = type == .camera ? LANGTEXT(key: "") : LANGTEXT(key: "")
        let message = type == .camera ? LANGTEXT(key: "”App”がカメラへのアクセスを求めています") :
            LANGTEXT(key:"”App”が写真へのアクセスを求めています")
        let settingTitle = type == .camera ? LANGTEXT(key:"設定") : LANGTEXT(key:"設定")
        let alertActionController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let settingAction = UIAlertAction(title: settingTitle, style: .default) { (action) in
            if #available(iOS 11.0, *) {
                UIApplication.shared.open(NSURL(string: UIApplication.openSettingsURLString)! as URL, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(NSURL(string: UIApplication.openSettingsURLString)! as URL)
            }
        }
        let cancelAction = UIAlertAction(title: LANGTEXT(key:"キャンセル"), style: .cancel, handler: nil)
        alertActionController.addAction(cancelAction)
        alertActionController.addAction(settingAction)
        
        DispatchQueue.main.async {
            self.sourceViewController?.present(alertActionController, animated: true, completion: nil)
        }
    }
}





