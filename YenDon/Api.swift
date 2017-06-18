//
//  Api.swift
//  YenDon
//
//  Created by 横島健一 on 2017/06/18.
//  Copyright © 2017年 info.tmpla. All rights reserved.
//

import Alamofire

private let host = "https://example.com"
// https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.xchange%20where%20pair%20in%20(%22USDVND,VNDJPY,AUDVND%22)&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys
struct Api {
    let url:String
    let method: HTTPMethod
    let parameters: Parameters
    
    init(path: String, method: HTTPMethod = .get, parameters: Parameters = [:]) {
        url = host + path
        self.method = method
        self.parameters = parameters
    
    }
    
    func request(success: @escaping(_ data: Dictionary<String, Any>) ->Void, fail: @escaping(_ error: Error?) -> Void) {
        Alamofire.request(url, method: method, parameters: parameters).responseJSON { response in
            if response.result.ifSuccess {
                success(response.result.value as! Dictionary)
            } else {
                fail(response.result.error)
            }
        
        }
    }
}

