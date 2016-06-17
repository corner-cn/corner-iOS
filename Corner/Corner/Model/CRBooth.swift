//
//  CRBooth.swift
//  Corner
//
//  Created by dliu on 6/15/16.
//  Copyright © 2016 ijiejiao. All rights reserved.
//


import UIKit

class CRBooth: NSObject {
    
    var boothId: String?
    var boothName: String?
    var boothOwner: String?
    var boothStory: String?
    
    var category: String?
    
    var location: String?
    var latitude: Double? = 0.0
    var longitude: Double? = 0.0
    var distance: String?
    var openTime: String?
    
    var likeCount: Int?
    
    var images: [String]?
    var thumnail: String?
    
    var likeStr: String {
        get {
            if let c = likeCount {
                return "\(c)人伸出援手"
            } else {
                return "需要你的帮助"
            }
        }
    }
    
    class func fromData(data:[String: AnyObject]?) -> CRBooth? {
        if let d = data {
            let booth = CRBooth()
            booth.boothId = d["booth_id"] as? String
            booth.boothName = d["booth_name"] as? String
            booth.boothOwner = d["booth_owner"] as? String
            booth.boothStory = d["booth_story"] as? String
            booth.category = d["category"] as? String
            booth.location = d["loc_text"] as? String
            booth.distance = d["distance"] as? String
            booth.openTime = d["open_time"] as? String
            booth.likeCount = d["check_in_num"] as? Int
            booth.images = d["image_urls"] as? [String]
            booth.thumnail = d["thumbnail_url"] as? String
            
            if let la = (d["loc_la"] as? String) {
                booth.latitude = Double(la)
            }
            
            if let lg = (d["loc_lo"] as? String) {
                booth.longitude = Double(lg)
            }
            
            return booth
        }
        return nil
    }
    
    class func fromArrayData(data: [[String: AnyObject]]?) -> [CRBooth] {
        var booths = [CRBooth]()
        if let arr = data {
            if arr.count > 0 {
                for d in arr {
                    if let booth = self.fromData(d) {
                        booths.append(booth)
                    }
                }
            }
        }
        return booths
    }
}
