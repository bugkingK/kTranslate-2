//
//  Presenter.swift
//  Translate-Text
//
//  Created by moon on 04/09/2019.
//  Copyright © 2019 Bugking. All rights reserved.
//

import Cocoa

class Presenter: NSObject {
    
    override init() { }
    
    fileprivate var vcCurrent:NSViewController?
    fileprivate var m_vw_container:NSView!
    
    fileprivate var targetViewController:NSViewController!
    fileprivate var contentViewController:NSViewController!
    fileprivate var frameView:NSView!
    fileprivate var m_height_content:CGFloat = 100
    
    static func instance() -> Presenter {
        return Presenter()
    }
    
    func setTarget(_ target:NSViewController, _ frameView:NSView) -> Presenter {
        self.targetViewController = target
        self.frameView = frameView
        self.m_vw_container = NSView()
        self.m_vw_container.translatesAutoresizingMaskIntoConstraints = false
        target.view.addSubview(m_vw_container)
        NSLayoutConstraint.activate([
            m_vw_container.topAnchor.constraint(equalTo: frameView.bottomAnchor),
            m_vw_container.leadingAnchor.constraint(equalTo: frameView.leadingAnchor),
            m_vw_container.trailingAnchor.constraint(equalTo: frameView.trailingAnchor),
        ])
        m_vw_container.isHidden = true
        return self
    }
    
    func setHeight(_ height:CGFloat) -> Presenter {
        m_height_content = height
        m_vw_container.heightAnchor.constraint(equalToConstant: m_height_content).isActive = true
        return self
    }
    
    func setContent(_ content:NSViewController) -> Presenter {
        contentViewController = content
        return self
    }
    
    func toggle(completion:((_ vc:NSViewController)->())? = nil) {
        if m_vw_container.isHidden {
           popup_show()
        } else {
            popup_dismiss()
        }
        
        completion?(contentViewController)
    }
    
    func popup_show() {
        bindToViewController()
        m_vw_container.isHidden = false
    }
    
    func popup_dismiss() {
        removeViewController()
        m_vw_container.isHidden = true
    }
    
    fileprivate func bindToViewController() {
        if vcCurrent != nil {
            self.removeViewController()
        }
        
        targetViewController.addChild(contentViewController)
        m_vw_container.addSubview(contentViewController.view)
        
        contentViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentViewController.view.leadingAnchor.constraint(equalTo: m_vw_container.leadingAnchor),
            contentViewController.view.trailingAnchor.constraint(equalTo: m_vw_container.trailingAnchor),
            contentViewController.view.topAnchor.constraint(equalTo: m_vw_container.topAnchor),
            contentViewController.view.bottomAnchor.constraint(equalTo: m_vw_container.bottomAnchor)
        ])
        
        vcCurrent = contentViewController
    }
    
    fileprivate func removeViewController() {
        vcCurrent?.view.removeFromSuperview()
        vcCurrent?.removeFromParent()
    }
    
    public func clean() {
        m_vw_container = nil
        targetViewController = nil
        contentViewController = nil
        frameView = nil
        self.removeViewController()
    }

}
