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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateContent() {
        self.contentImageView.sd_setImageWithURL(NSURL.init(string: "http://codingstuff.org/wp-content/uploads/2014/08/Hackathon_TLV_2013_-_48.jpg"))
    }
}
