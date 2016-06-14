//
//  CRVerticalCenterButton.swift
//  Corner
//
//  Created by dliu on 6/14/16.
//  Copyright © 2016 ijiejiao. All rights reserved.
//

import UIKit

class CRVerticalCenterButton: UIButton {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        let spacing: CGFloat = 6.0
        
        let imageSize = self.imageView!.frame.size
        
        self.titleEdgeInsets = UIEdgeInsetsMake(0, -imageSize.width, -(imageSize.height + spacing), 0)
        
        let titleSize = self.titleLabel!.frame.size
        
        self.imageEdgeInsets = UIEdgeInsetsMake(-(titleSize.height + spacing), 0, 0, -titleSize.width)
        
    }
}

class CRExchangeButton: UIButton {
    
    override func imageRectForContentRect(contentRect: CGRect) -> CGRect {
        var frame = super.imageRectForContentRect(contentRect)
        frame.origin.x = CGRectGetMaxX(contentRect) - CGRectGetWidth(frame) -  self.imageEdgeInsets.right + self.imageEdgeInsets.left + 3;
        return frame;

    }
    
    override func titleRectForContentRect(contentRect: CGRect) -> CGRect {
        var frame = super.titleRectForContentRect(contentRect)
        frame.origin.x = CGRectGetMinX(frame) - CGRectGetWidth(self.imageRectForContentRect(contentRect));
        return frame;
    }
}
