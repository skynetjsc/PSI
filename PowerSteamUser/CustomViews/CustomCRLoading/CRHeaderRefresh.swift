//
//  JPHeaderRefresh.swift
//  JAPA
//
//  Created by NhatQuang on 7/5/17.
//  Copyright © 2017 Paditech. All rights reserved.
//

import UIKit

class CRHeaderRefresh: UIView, CRRefreshProtocol {
    
    open var view: UIView { return self }
    open var duration: TimeInterval = 0.3
    open var insets: UIEdgeInsets   = .zero
    open var trigger: CGFloat       = 60.0
    open var execute: CGFloat       = 50.0
    open var endDelay: CGFloat      = 0
    public var hold: CGFloat        = 60
    
    fileprivate let indicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView.init(style: .gray)
        indicatorView.isHidden = true
        return indicatorView
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(indicatorView)
    }
    
    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func refreshBegin(view: CRRefreshComponent) {
        indicatorView.startAnimating()
        indicatorView.isHidden = false
    }
    
    public func refreshWillEnd(view: CRRefreshComponent) {
        
    }
    
    open func refreshEnd(view: CRRefreshComponent, finish: Bool) {
        indicatorView.stopAnimating()
        indicatorView.isHidden = true
    }
    
    open func refresh(view: CRRefreshComponent, progressDidChange progress: CGFloat) {

    }
    
    open func refresh(view: CRRefreshComponent, stateDidChange state: CRRefreshState) {
        switch state {
        case .refreshing:
            break
        case .pulling:
            self.indicatorView.isHidden = false
            self.indicatorView.startAnimating()
            break
        case .idle:
            self.indicatorView.isHidden = true
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
        indicatorView.center = CGPoint.init(x: w / 2.0, y: h / 2.0 - 5.0)
    }

}
