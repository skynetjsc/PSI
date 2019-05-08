//
//  WCustomFooterLoading.swift
//  WeWorld
//
//  Created by NhatQuang on 1/15/18.
//  Copyright © 2018 Paditech. All rights reserved.
//

import Foundation
import UIKit

open class CRFooterLoading: UIView, CRRefreshProtocol {
    
    static let crBundle = CRRefreshBundle.bundle(name: "NormalFooter", for: NormalFooterAnimator.self)
    
    open var loadingMoreDescription = ""
    open var noMoreDataDescription  = ""
    open var loadingDescription     = ""
    
    open var view: UIView { return self }
    open var duration: TimeInterval = 0.3
    open var insets: UIEdgeInsets   = .zero
    open var trigger: CGFloat       = 50.0
    open var execute: CGFloat       = 50.0
    open var endDelay: CGFloat      = 0
    open var hold: CGFloat          = 50
    
    fileprivate let titleLabel: UILabel = {
        let label = UILabel.init(frame: CGRect.zero)
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.textColor = UIColor.init(white: 160.0 / 255.0, alpha: 1.0)
        label.textAlignment = .center
        return label
    }()
    
    fileprivate let indicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView.init(style: .gray)
        indicatorView.isHidden = true
        return indicatorView
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel.text = loadingMoreDescription
        addSubview(titleLabel)
        addSubview(indicatorView)
    }
    
    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func refreshBegin(view: CRRefreshComponent) {
        indicatorView.startAnimating()
        titleLabel.text = loadingDescription
        indicatorView.isHidden = false
    }
    
    public func refreshWillEnd(view: CRRefreshComponent) {
        
    }
    
    open func refreshEnd(view: CRRefreshComponent, finish: Bool) {
        indicatorView.stopAnimating()
        titleLabel.text = loadingMoreDescription
        indicatorView.isHidden = true
    }
    
    open func refresh(view: CRRefreshComponent, progressDidChange progress: CGFloat) {
        
    }
    
    open func refresh(view: CRRefreshComponent, stateDidChange state: CRRefreshState) {
        switch state {
        case .refreshing :
            titleLabel.text = loadingDescription
            break
        case .noMoreData:
            titleLabel.text = noMoreDataDescription
            break
        case .pulling:
            titleLabel.text = loadingMoreDescription
            break
        default:
            break
        }
        setNeedsLayout()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        let s = self.bounds.size
        let w = s.width
        let h = s.height
        titleLabel.sizeToFit()
        titleLabel.center = CGPoint.init(x: w / 2.0, y: h / 2.0 - 5.0)
        indicatorView.center = CGPoint.init(x: titleLabel.frame.origin.x, y: titleLabel.center.y)
    }
}
