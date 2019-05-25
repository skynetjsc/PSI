//
//  PSlideImageCell.swift
//  LianChat
//
//  Created by Mac on 1/28/19.
//  Copyright © 2019 Padi. All rights reserved.
//

import AVKit
import AVFoundation
import UIKit

extension Date {
    static func dateComponentFrom(second: Double) -> DateComponents {
        let interval = TimeInterval(second)
        let date1 = Date()
        let date2 = Date(timeInterval: interval, since: date1)
        let c = NSCalendar.current
        
        var components = c.dateComponents([.year,.month,.day,.hour,.minute,.second,.weekday], from: date1, to: date2)
        components.calendar = c
        return components
    }
}

class PSlideImageCell: UICollectionViewCell {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var containView: UIView!
    
    @IBOutlet weak var playerContainView: UIView!
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var controlView: UIView!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var playSlider: UISlider!
    @IBOutlet weak var labTotal: UILabel!
    @IBOutlet weak var labCurrent: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTrailingConstraint: NSLayoutConstraint!
    
    var viewModel: PSlideImageCellVM? {
        didSet {
            bindData()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        scrollView.delegate = self
        scrollView.minimumZoomScale = 0.5
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        tapGesture.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(tapGesture)
    }
    
    func bindData() {
        guard let viewModel = self.viewModel else { return }

        if let imageModel = viewModel.model as? PImageModel {
            if imageModel.typeInt == 2 { // video
                self.scrollView.isHidden = true
                self.playerContainView.isHidden = false
                // https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4
                if let url = URL(string: imageModel.image) {
                    viewModel.playerItem = AVPlayerItem(url: url)
                    viewModel.player = AVPlayer(playerItem: viewModel.playerItem)
                    
                    let playerLayer = AVPlayerLayer(player: viewModel.player!)
                    playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
                    playerLayer.frame = self.playerView.frame
                    self.playerView.layer.addSublayer(playerLayer)
                    
                    let duration: CMTime = viewModel.playerItem?.asset.duration ?? CMTime(seconds: 0, preferredTimescale: 0)
                    let seconds: Float64 = CMTimeGetSeconds(duration)
                    
                    playSlider!.maximumValue = Float(seconds)
                    playSlider!.isContinuous = false
                    playSlider!.tintColor = UIColor.green
                    self.labCurrent.text = self.convert(second: Double(0))
                    self.labTotal.text = self.convert(second: Double(seconds))
                    
                    viewModel.player!.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: DispatchQueue.main) { [weak self] (CMTime) -> Void in
                        guard let self = self else { return }
                        if viewModel.isUpdateTime {
                            return
                        }
                        if viewModel.player!.currentItem?.status == .readyToPlay {
                            let time : Float64 = CMTimeGetSeconds(viewModel.player!.currentTime())
                            self.playSlider!.value = Float(time)
                            self.labCurrent.text = self.convert(second: Double(time))
                        }
                    }
                    
                    if viewModel.currentIndex == viewModel.indexPath.row {
                        //viewModel.player?.play()
                    }
                    
                    NotificationCenter.default.addObserver(self,
                                                           selector: #selector(playerItemDidReachEnd(notification:)),
                                                           name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                                           object: viewModel.player?.currentItem)
                }
            } else {
                self.scrollView.isHidden = false
                self.playerContainView.isHidden = true
                let placeholderImage = UIImage.imageWithColor(UIColor.lightGray, size: CGSize(width: 1, height: 1))
                self.image.image = placeholderImage
                if imageModel.image.count > 0 {
                    let url = URL(string: imageModel.image)
                    self.image?.kf.setImage(with: url, placeholder: placeholderImage, options: [.transition(.fade(1))], progressBlock: nil, completionHandler: nil)
                }
            }
        } else if let image = viewModel.model as? UIImage {
            self.scrollView.isHidden = false
            self.playerContainView.isHidden = true
            self.image.image = image
        }
    }
    
    func updateMinZoomScaleForSize(size: CGSize) {
        let widthScale = size.width / image.bounds.width
        let heightScale = size.height / image.bounds.height
        let minScale = min(widthScale, heightScale)
        // 2
        //scrollView.minimumZoomScale = minScale
        // 3
        scrollView.zoomScale = minScale
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateMinZoomScaleForSize(size: containView.size)
    }
    
    func updateConstraintsForSize(size: CGSize) {
        // 2
        let yOffset = max(0, (size.height - image.frame.height) / 2)
        imageViewTopConstraint.constant = yOffset
        imageViewBottomConstraint.constant = yOffset
        // 3
        let xOffset = max(0, (size.width - image.frame.width) / 2)
        imageViewLeadingConstraint.constant = xOffset
        imageViewTrailingConstraint.constant = xOffset
        
        containView.layoutIfNeeded()
    }
    
    @objc func handleDoubleTap(gestureRecognizer: UIGestureRecognizer) {
        if self.scrollView.zoomScale > self.scrollView.minimumZoomScale {
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
        } else {
            scrollView.setZoomScale(scrollView.maximumZoomScale, animated: true)
        }
    }
    
    func convert(second: Double) -> String {
        let component =  Date.dateComponentFrom(second: second)
        if let hour = component.hour ,
            let min = component.minute ,
            let sec = component.second {
            
            let fix =  hour > 0 ? NSString(format: "%02d:", hour) : ""
            return NSString(format: "%@%02d:%02d", fix,min,sec) as String
        } else {
            return "-:-"
        }
    }
    
    @objc func playerItemDidReachEnd(notification: Notification) {
        if let p: AVPlayerItem = notification.object as? AVPlayerItem {
            p.seek(to: CMTime.zero)
            btnPlay.setImage(#imageLiteral(resourceName: "play_white_icon"), for: .normal)
        }
    }
    
    // MARK: - Action methods
    
    @IBAction func btnAction() {
        guard let viewModel = self.viewModel else { return }
        if viewModel.player?.rate == 0 {
            viewModel.player!.play()
            btnPlay.setImage(#imageLiteral(resourceName: "pause_white_icon"), for: .normal)
        } else {
            viewModel.player!.pause()
            btnPlay.setImage(#imageLiteral(resourceName: "play_white_icon"), for: .normal)
        }
    }
    
    @IBAction func sliderValueChange(slider: UISlider) {
        guard let viewModel = self.viewModel else { return }
        viewModel.isUpdateTime = true
        let seconds : Int64 = Int64(playSlider.value)
        let targetTime:CMTime = CMTimeMake(value: seconds, timescale: 1)
        
        viewModel.player!.seek(to: targetTime) { [unowned self] (finish) in
            viewModel.isUpdateTime = false
        }
        
        if viewModel.player!.rate == 0 {
            viewModel.player?.play()
        }
    }
}

extension PSlideImageCell: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        // 1
        return image
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateConstraintsForSize(size: containView.bounds.size)  // 4
    }
}


