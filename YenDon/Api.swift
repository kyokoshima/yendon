//
//  Api.swift
//  YenDon
//
//  Created by 横島健一 on 2017/06/18.
//  Copyright © 2017年 info.tmpla. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

private let host = "https://query.yahooapis.com/v1/public/yql"
// https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.xchange%20where%20pair%20in%20(%22USDVND,VNDJPY,AUDVND%22)&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys
//https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.xchange%20where%20pair%20in%20(%22EURUSD%22%2C%22GBPUSD%22)&format=json&diagnostics=true&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback=
struct Api {
    let url:String = host
    let method: HTTPMethod = .get
    let parameters: Parameters
    
    
    init( pairs: Array<String> = ["JPYVND"]) {
        let pairs = Set(pairs)
        let pairsWithValue = pairs.map {
            return "\"\($0)\""
            }.joined(separator: ",")
        self.parameters = [ "format": "json",
                            "env": "store://datatables.org/alltableswithkeys",
                            "q": "select * from yahoo.finance.xchange where pair in (\(pairsWithValue))"
        ]
        
    }
    
    func request(_ pairs: Array<String>, success: @escaping(_ data: JSON) -> Void, fail: @escaping(_ error: Error?) -> Void) {
        let pairs = Set(pairs)
        let pairsWithValue = pairs.map {
            return "\"\($0)\""
        }.joined(separator: ",")
        let params = ["format": "json",
                      "env": "store://datatables.org/alltableswithkeys",
                      "q": "select * from yahoo.finance.xchange where pair in (\(pairsWithValue))"]
        Alamofire.request(url, method: method, parameters: params).responseJSON { response in
            switch response.result {
            case .success(let value):
                let records = JSON(value)["query"]["results"]["rate"]
                success(records)
                
            case .failure(let error):
                fail(error)
                //            if response.result.isSuccess {
                //                let records = JSON(response.result.value)
                //                success(records)
                //            } else {
                //                fail(response.result.error)
                //            }
            }
        }

    }
    
    func request(success: @escaping(_ data: Dictionary<String, Any>) ->Void, fail: @escaping(_ error: Error?) -> Void) {
//        debugPrint(parameters)
        Alamofire.request(url, method: method, parameters: parameters).responseJSON { response in
            if response.result.isSuccess {
                success(response.result.value as! Dictionary)
            } else {
                fail(response.result.error)
            }
            
        }
    }
}

