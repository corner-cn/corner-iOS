//
//  Service.swift
//  Corner
//
//  Created by dliu on 6/15/16.
//  Copyright © 2016 ijiejiao. All rights reserved.
//

import UIKit
import Foundation
import Alamofire


typealias boothsCompletion = ([CRBooth]?)-> Void

class Service: NSObject {
    
    class func recommend(completion:((booths: [CRBooth]?)-> Void)?){
        _get(["query_type":"recommendation", "my_position": self.position()], completion: completion)
    }
    
    class func priority(completion:((booths: [CRBooth]?)-> Void)?){
        _get(["query_type":"priority", "my_position": self.position()], completion: completion)
    }
    
    class func boothsFilterByDistance(distance: Int, category: String, order: String, completion: boothsCompletion?) {
        let parameters: [String: AnyObject] = ["query_type":"combined", "my_position":self.position(), "query_params":["distance": 50 * 1000, "category":category, "order_by":order]]
        _get(parameters, completion: completion)
    }
    
    class func search(keyword keyword: String, completion: boothsCompletion?) {
        let parameters = ["query_type":"keywords", "query_params":["keywords": [keyword]]]
        _get(parameters, completion: completion)
    }
    
    class func newBooth(booth: CRBooth, completion:((CRBooth?)->Void)?) {
        var la = "0", lo = "0"
        if let x = g_location?.coordinate.latitude, y = g_location?.coordinate.longitude {
            la = "\(x)"
            lo = "\(y)"
        }
        let parameters: [String: AnyObject] = ["booth_name":booth.boothName!,
                                               "booth_owner": booth.boothOwner!,
                                               "category": booth.category!,
                                               "booth_story": booth.boothStory!,
                                               "open_time": booth.openTime!,
                                               "loc_text": booth.location!,
                                               "loc_la": la,
                                               "loc_lo": lo]
        Alamofire.request(.POST, "http://api.ijiejiao.cn/v1/booth/", parameters: parameters, encoding: .JSON, headers: nil).responseJSON {
            response in
            
            var booth: CRBooth? = nil
            
            switch response.result {
            case .Success:
                if let data = extract(response.result.value as? [String: AnyObject]) {
                    let booths = CRBooth.fromArrayData(data as? [[String: AnyObject]])
                    booth = booths.first
                }
            case .Failure:
                break
            }
            if completion != nil {
                completion!(booth)
            }
        }
    }
    
    class func uploadBoothImages(images: [UIImage], boothId: String, completion:((Bool)->Void)) {
        Alamofire.upload(
            .POST,
            "http://api.ijiejiao.cn/v1/image/\(boothId)",
            multipartFormData: { multipartFormData in
                for image in images {
                    let imageData = UIImageJPEGRepresentation(image, 0.6)
                    multipartFormData.appendBodyPart(data: imageData!, name:"image", mimeType: "image/jpeg")
                }
                multipartFormData.appendBodyPart(data: boothId.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!, name: "bid", mimeType: "text")
            },
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .Success(_,_,_):
                    completion(true)
                case .Failure(_):
                    completion(false)
                }
            }
        )
    }
    
    class func boothDetail(boothId id: String, completion:((CRBooth?)->Void)?) {
        Alamofire.request(.GET, "http://api.ijiejiao.cn/v1/booth/\(id)").responseJSON { response in
            var booth: CRBooth? = nil
            switch response.result {
            case .Success:
                if let data = extract(response.result.value as? [String: AnyObject]) {
                    let booths = CRBooth.fromArrayData(data as? [[String: AnyObject]])
                    booth = booths.first
                }
            case .Failure:
                break
            }
            if completion != nil {
                completion!(booth)
            }
        }
    }
    
    internal class func _get(parameters:[String: AnyObject]?, completion:((booths: [CRBooth]?)-> Void)?) {
        Alamofire.request(.POST, "http://api.ijiejiao.cn/v1/booths/", parameters:parameters, encoding: .JSON, headers: nil).responseJSON { response in
            var booths = [CRBooth]()
            switch response.result {
            case .Success:
                if let data = extract(response.result.value as? [String: AnyObject]) {
                    booths = CRBooth.fromArrayData(data as? [[String: AnyObject]])
                }
            case.Failure:
                print("failed")
            }
            if completion != nil {
                completion!(booths: booths)
            }
        }
    }
    
    class func extract (data: [String: AnyObject]?) -> AnyObject? {
        if let d = data {
            if let status = d["status"] as? Int {
                if status == 0 {
                    return d["data"]
                }
            }
        }
        return nil
    }
    
    class func position () -> [String: AnyObject] {
        if g_location != nil {
            if let la = g_location?.coordinate.latitude, lo = g_location?.coordinate.longitude {
                return ["longitude":"\(lo)", "latitude":"\(la)"]
            }
        }
        return ["longitude":"0", "latitude":"0"]
    }
}
