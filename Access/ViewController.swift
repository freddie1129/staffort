//
//  ViewController.swift
//  Access
//
//  Created by jackttc on 28/4/18.
//  Copyright © 2018 jackttc. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Foundation

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let twitterID = "dropaphone"
        let customerKey = "ZfyJo2mBTk1ZZELJRe7soNAyz"
        let customerSecret = "fOuA7PwFBrU64zX0ahlu7wiFPzXmN3xaHJFENAC0wVu71VZFrd"
        let keyValue = "\(customerKey):\(customerSecret)"
        let utf8strKey = keyValue.data(using: String.Encoding.utf8)
        let base64Encoded = utf8strKey!.base64EncodedString();
        let authen = "Basic \(String(describing: base64Encoded))";
        let urlAuthen = "https://api.twitter.com/oauth2/token";
        let urlTimeLine = "https://api.twitter.com/1.1/statuses/user_timeline.json";
        let headers = ["Authorization" : authen,
                       "Content-Type": "application/x-www-form-urlencoded"]
        let parameters: Parameters = ["grant_type": "client_credentials"]
        Alamofire.request(urlAuthen, method: .post, parameters: parameters,headers: headers).responseJSON
            { (response:DataResponse) in
                switch response.result {
                case .success(let value):
                    let jsonAuthen = JSON(value)
                    let token = jsonAuthen["access_token"].description
                    print("Token: \(token)")
                   // let parametersTimeLine: Parameters = ["screen_name": twitterID,
                   //                                       "since_id":"983456300179783680"]
                    let parametersTimeLine: Parameters = ["screen_name": twitterID]
                    
                    let timeLineAuthen = "Bearer \(token)";
                    let headersTimeLine = ["Authorization" : timeLineAuthen]
                    
                    Alamofire.request(urlTimeLine, parameters: parametersTimeLine,headers: headersTimeLine).responseJSON
                        {
                            (response1:DataResponse) in
                            switch response1.result {
                            case .success(let value):
                                let json = JSON(value)
                                for twitter in json.arrayValue
                                {
                                    print("==========================")
                                    print("ID: \(twitter["id"])")
                                    print("Time: \(twitter["created_at"])")
                                    print("Content: \(twitter["text"])")
                                }
                            case .failure(let error):
                                print(error)
                            }
                    }
                case .failure(let error):
                    print(error)
                    return
                }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

