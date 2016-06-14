//
//  CRDesignableView.swift
//  Corner
//
//  Created by dliu on 6/12/16.
//  Copyright © 2016 ijiejiao. All rights reserved.
//

import UIKit

@IBDesignable class CRDesignableView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
}


@IBDesignable class CRDesignableLabel: UILabel {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
}

@IBDesignable class CRDashLineView : UIView {
    
    var _lineColor : UIColor = UIColor.clearColor()
    
    var _dashCount : Int = 0
    
    override init(frame: CGRect) {
        super.init(frame:frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBInspectable var lineColor : UIColor {
        get {
            return _lineColor
        }
        set {
            _lineColor = newValue
        }
    }
    
    @IBInspectable var dashCount : Int {
        get {
            return _dashCount
        }
        set {
            _dashCount = newValue
        }
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        let context = UIGraphicsGetCurrentContext();
        CGContextMoveToPoint(context, 0, self.frame.height)
        CGContextAddLineToPoint(context, self.frame.width, self.frame.height)
        CGContextSetLineDash(context, 0, [4, 2], _dashCount)
        CGContextSetLineWidth(context, 1.0)
        CGContextSetStrokeColorWithColor(context, _lineColor.CGColor)
        CGContextStrokePath(context)
    }
}
