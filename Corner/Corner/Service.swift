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
        _get(["query_type":"recommendation"], completion: completion)
    }
    
    class func priority(completion:((booths: [CRBooth]?)-> Void)?){
        _get(["query_type":"priority"], completion: completion)
    }
    
    class func boothsFilterByDistance(distance: Int, category: String, order: String, completion: boothsCompletion?) {
        let parameters: [String: AnyObject] = ["query_type":"combined", "my_position":self.position(), "query_params":["distance": 50 * 1000, "category":category, "order_by":order]]
        _get(parameters, completion: completion)
    }
    
    class func boothDetail(boothId id: String, completion:((CRBooth?)->Void)?) {
        Alamofire.request(.GET, "http://api.ijiejiao.cn/v1/booth/\(id)").responseJSON {
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