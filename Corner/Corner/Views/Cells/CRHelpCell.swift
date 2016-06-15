//
//  CRHelpCell.swift
//  Corner
//
//  Created by dliu on 6/12/16.
//  Copyright © 2016 ijiejiao. All rights reserved.
//

import UIKit

class CRHelpCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var locationLabel: CRDesignableLabel!
    
    @IBOutlet weak var helpCountLabel: UILabel!
    
    @IBOutlet weak var contentImageView: UIImageView!
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateContent(booth: CRBooth?) {
        self.titleLabel.text = booth?.boothName
        self.contentLabel.text = booth?.boothStory
            self.locationLabel.text = booth?.location
        if let likeCnt = booth?.likeCount {
            self.helpCountLabel.text = "\(likeCnt)"
        } else {
            self.helpCountLabel.text = "0"
        }
        if let thumb = booth?.thumnail {
            self.contentImageView.sd_setImageWithURL(NSURL(string:thumb), placeholderImage: UIImage(named: g_placeholer))
        } else {
            self.contentImageView.image = UIImage(named: g_placeholer)
        }
        self.distanceLabel.text = booth?.distance
    }
}
