//
//  PSlideImageCellVM.swift
//  LianChat
//
//  Created by Mac on 2/21/19.
//  Copyright © 2019 Padi. All rights reserved.
//

import AVKit
import AVFoundation
import Foundation

class PSlideImageCellVM {
    
    var model: Any!
    var indexPath: IndexPath!
    var currentIndex: Int = 0
    var isUpdateTime = false
    var timeObserver: Any?
    var player: AVPlayer?
    var playerItem: AVPlayerItem?
    
    init(model: Any, at indexPath: IndexPath, currentIndex: Int = 0) {
        self.model = model
        self.indexPath = indexPath
        self.currentIndex = currentIndex
    }
}
