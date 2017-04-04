//
//  FanControlItem.swift
//  ios-ui-components
//
//  Created by michael.schropp on 04/04/2017.
//  Copyright © 2017 Michael Schropp. All rights reserved.
//

import UIKit

/** position of first item. default is above view
 value is in degrees. 0 would be right, 90 top and 180 is left
 from center. default is 135
 */
class FanControlItem : UIView {
    
    var oldCenter:CGPoint = CGPoint.zero
    var normalBackgroundColor:UIColor = UIColor.white
    let titleLabel:UILabel = UILabel()
    let imageView:UIImageView = UIImageView()
    
    var isHighlighted:Bool = false {
        didSet{
            changeUIToHighlight(isHighlighted)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    fileprivate func changeUIToHighlight(_ hightlight: Bool) {
        if hightlight {
            titleLabel.textColor = tintColor
            imageView.tintColor = tintColor
        } else {
            titleLabel.textColor = UIColor.black
            imageView.tintColor = UIColor.black
        }
    }
    
    fileprivate func setupView() {
        
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.preferredFont(forTextStyle: .callout)
        addSubview(titleLabel)
        
        imageView.tintColor = UIColor.black
        addSubview(imageView)
    }
    
    var title:String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.frame = bounds
        imageView.frame = bounds
    }
}
