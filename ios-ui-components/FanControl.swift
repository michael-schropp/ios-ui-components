//
//  FanControl.swift
//  ios-ui-components
//
//  Created by michael.schropp on 04/04/2017.
//  Copyright © 2017 Michael Schropp. All rights reserved.
//

import UIKit

/**
 Another description
 
 - important: Make sure you read this
 - returns: a Llama spotter rating between 0 and 1 as a Float
 - parameter totalLlamas: The number of Llamas spotted on the trip
 
 More description
 */
class FanControl: UIControl {
    
    fileprivate var numberOfOptions:Int = 0
    fileprivate var children:[FanControlItem] = []
    fileprivate var selectedView:FanControlItem?
    fileprivate var timer:Timer?
    
    
    /** position of first item. default is above view
     value is in degrees. 0 would be right, 90 top and 180 is left
     from center. default is 135
     */
    var startAngle:CGFloat = 135
    
    /** returns last segment pressed. default is -1 if no segment is pressed
     */
    var selectedIndex: Int = -1 {
        didSet{
            sendActions(for: .valueChanged)
        }
    }
    
    /** size of the items, default is {50,50}
     */
    var itemSize:CGSize = CGSize.init(width: 50, height: 50)
    
    /** radius where items are positioned. default is 100
     */
    var radius:CGFloat = 100
    
    /** backgroundColor of items
     */
    var itemColor = UIColor.lightGray
    
    /**
     Setup the FanControl with images
     
     - parameter images: An array of UIImage objects
    */
    func setupWithImages(_ images:[UIImage]) {
        children.removeAll()
        for image in images {
            let control = FanControlItem()
            control.imageView.image = image.withRenderingMode(.alwaysTemplate)
            children.append(control)
        }
        numberOfOptions = children.count
    }
   
    /**
     Setup the FanControl with images
     
     - parameter titles: An array of String objects
     */
    func setupWithTitles(_ titles:[String]) {
        children.removeAll()
        for name in titles {
            let control = FanControlItem()
            control.title = name
            children.append(control)
        }
        numberOfOptions = children.count
    }
    
    /**
     Setup the FanControl with images
     
     - parameter items: An array of FanControlItem objects
     */
    func setupWithItems(_ items:[FanControlItem]) {
        children = items
        numberOfOptions = items.count
    }
    
    override var isSelected: Bool {
        didSet{
            if isSelected {
                activateUI()
            } else {
                deactivateUI(animated: true)
            }
        }
    }
    
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: false, block: {timer in
            self.isSelected = true
        })
        animateToTransform(CGAffineTransform.init(scaleX: 0.95, y: 0.95))
        return true
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        
        let point = touch.location(in: self)
        
        if let view = (children.filter{ (view) -> Bool in
            return (distance(a: view.oldCenter, b: point) < (itemSize.width + 10))
        }).first {
            selectView(view: view)
        } else {
            selectedView = nil
            deselectViews(views: children)
        }
        return true
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        
        timer?.invalidate()
        
        if let selectedView = selectedView {
            animateView(view: selectedView)
            
            selectedIndex = children.index(of: selectedView)!
        } else {
            selectedIndex = -1
        }
        isSelected = false
    }
    
    fileprivate func activateUI() {
        
        var index = 0
        for child in children {
            
            let angle:CGFloat = CGFloat(min(45, 360/numberOfOptions))
            let radAngle = ((CGFloat(index) * angle) - startAngle) / 180 * CGFloat.pi
            
            let x = radius * cos(radAngle) + bounds.width / 2
            let y = radius * sin(radAngle) + bounds.width / 2
            
            child.transform = CGAffineTransform.identity
            child.frame = bounds
            child.frame.size = itemSize
            child.layer.cornerRadius = itemSize.width / 2
            child.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
            child.backgroundColor = itemColor
            child.normalBackgroundColor = itemColor
            child.alpha = 0.0
            addSubview(child)
            
            let delay = (0.25 / TimeInterval(numberOfOptions)) * TimeInterval(index)
            
            UIView.animate(withDuration: 1.35, delay: 0.05 + delay, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.0, options: [.curveEaseInOut], animations: {
                child.center = CGPoint.init(x: x, y: y)
                child.oldCenter = CGPoint.init(x: x, y: y)
                child.alpha = 1.0
                child.transform = CGAffineTransform.identity
            }, completion: { complete in
            })
            
            index += 1
        }
    }
    
    fileprivate func deselectViews(views:[FanControlItem]) {
        for other in children {
            UIView.animate(withDuration: 0.15, delay: 0, options: [], animations: {
                
                other.center = other.oldCenter
                other.transform = CGAffineTransform.identity
                other.isHighlighted = false
            }, completion: {
                complete in
                
            })
        }
    }
    
    fileprivate func animateToTransform(_ transform:CGAffineTransform) {
        
        UIView.animate(withDuration: 0.25, delay: 0, options: [], animations: {
            self.transform = transform
        }, completion: {
            complete in
            
        })
    }
    
    fileprivate func deactivateUI(animated:Bool) {
        
        animateToTransform(CGAffineTransform.identity)
        for child in children.filter({$0 != selectedView}) {
            
            UIView.animate(withDuration: 0.25, delay: 0, options: [], animations: {
                child.center = CGPoint.init(x: self.bounds.width / 2, y: self.bounds.width / 2)
                child.alpha = 0.0
                child.transform = CGAffineTransform.init(scaleX: 0.75, y: 0.75)
            }, completion: {
                complete in
                
            })
        }
        selectedView?.isHighlighted = false
        selectedView = nil
    }
    
    
    
    fileprivate func selectView(view:FanControlItem) {
        
        guard selectedView != view else {return}
        
        selectedView = view
        
        deselectViews(views: children)
        let newCenterX = (view.center.x - bounds.width / 2) * 1.2
        let newCenterY = (view.center.y - bounds.width / 2) * 1.2
        let newCenter = CGPoint.init(x: newCenterX + bounds.width / 2, y: newCenterY + bounds.width / 2)
        
        UIView.animate(withDuration: 0.15, delay: 0, options: [], animations: {
            
            view.isHighlighted = true
            view.transform = CGAffineTransform.init(scaleX: 1.25, y: 1.25)
            view.center = newCenter
        }, completion: {
            complete in
            
        })
        
    }
    
    fileprivate func distance(a: CGPoint, b: CGPoint) -> CGFloat {
        let xDist = a.x - b.x
        let yDist = a.y - b.y
        return CGFloat(sqrt((xDist * xDist) + (yDist * yDist)))
    }
    
    
    fileprivate func animateView(view:UIView) {
        
        view.layer.opacity = 0.0
        
        let transformAnimation = CABasicAnimation.init(keyPath: "transform")
        transformAnimation.duration = 0.1
        transformAnimation.repeatCount = 4
        transformAnimation.autoreverses = true
        transformAnimation.isRemovedOnCompletion = true
        transformAnimation.toValue = NSValue.init(caTransform3D: CATransform3DMakeScale(1.125, 1.125, 1.0))
        view.layer.add(transformAnimation, forKey: "transform")
        
        let alphaAnimation = CABasicAnimation.init(keyPath: "opacity")
        alphaAnimation.duration = 0.3
        alphaAnimation.isRemovedOnCompletion = true
        alphaAnimation.toValue = 0.0
        alphaAnimation.fromValue = 1.0
        view.layer.add(alphaAnimation, forKey: "opacity")
    }
    
}
