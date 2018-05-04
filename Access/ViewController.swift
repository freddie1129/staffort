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
        //gcRequest()
        
        
        
        let userID = "dropaphone"
        
       // retrieveTwitter(twitterId:userID,sinceId: "983456300179783680")
        

        retrieveTwitter(twitterId:userID,sinceId:nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func gcRequest(text : String, since_id : String, create_date : String) {
        //let urlAuthen = "https://api.twitter.com/oauth2/token";
        let urlAuthen = "https://language.googleapis.com/v1/documents:analyzeSentiment?key=AIzaSyAGwAOOPRKjSDxQZj4WJUhYM8zHTElywjI";
   
        let parameters: Parameters = [
            "encodingType": "UTF8",
            "document": [
                "type": "PLAIN_TEXT",
                "content": text,
            ]
        ]

        
        Alamofire.request(urlAuthen, method: .post, parameters: parameters,encoding: JSONEncoding.default).responseJSON
            { (response:DataResponse) in
                switch response.result {
                case .success(let value):
                    let jsonAuthen = JSON(value)
                    //print(jsonAuthen)
                    print("==========================")
                    print("twitter_id: \(since_id)")
                    print("create_time: \(create_date)")
                    print("twitter_content: \(text)")
                    print("magnitude: \(jsonAuthen["documentSentiment"]["magnitude"])")
                    print("score: \(jsonAuthen["documentSentiment"]["score"])")
                    print("\n")
                case .failure(let error):
                    print(error)
                    return
                }
        }

    }
    
    
    let twitterID = "dropaphone"
    func retrieveTwitter(twitterId:String,sinceId:String?) {
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
                    var parametersTimeLine : Parameters = Parameters();
                    parametersTimeLine["screen_name"] = twitterId;
                    if (sinceId != nil)
                    {
                        parametersTimeLine["since_id"] = sinceId;
                    }
                    
                    
                    // let parametersTimeLine: Parameters = ["screen_name": twitterID,
                    //                                       "since_id":"983456300179783680"]
                   // let parametersTimeLine: Parameters = ["screen_name": twitterId]
                    
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
                                   // print("==========================")
                                   // print("since_id: \(twitter["id"].description)")
                                   // print("create_time: \(twitter["created_at"].description)")
                                   // print("twitter_content: \(twitter["text"].description)")
                                   // print("\n")
                                    self.gcRequest(text: twitter["text"].description, since_id:  twitter["id"].description,create_date:  twitter["text"].description)
                                    
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
    
    
}

