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


class Service: NSObject {
    
    class func recommend(completion:((booths: [CRBooth]?)-> Void)?){
        _get(["query_type":"recommendation"], completion: completion)
    }
    
    class func priority(completion:((booths: [CRBooth]?)-> Void)?){
        _get(["query_type":"priority"], completion: completion)
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
}
