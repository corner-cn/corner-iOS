//
//  CRCategoryCell.swift
//  Corner
//
//  Created by dliu on 6/12/16.
//  Copyright © 2016 ijiejiao. All rights reserved.
//

import UIKit

class CRCategoryCell: UITableViewCell {

    @IBOutlet var images: [UIImageView]!
    
    @IBOutlet var titles: [UILabel]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateContent(imageURLs:[String]?, titleNames:[String]?) {
        if (imageURLs != nil && imageURLs!.count > 0
            && titleNames != nil && titleNames!.count > 0) {
            for index in 0...imageURLs!.count - 1 {
                let iv = images[index] as UIImageView
                iv.sd_setImageWithURL(NSURL.init(string: imageURLs![index] as String))
                let tv = titles[index]
                tv.text = titleNames![index]
            }
        }
    }
}
