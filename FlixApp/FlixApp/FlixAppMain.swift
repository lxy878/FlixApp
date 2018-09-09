//
//  FlixAppMain.swift
//  FlixApp
//
//  Created by Xiaoyi Liu on 9/9/18.
//  Copyright © 2018 Xiaoyi Liu. All rights reserved.
//

import UIKit

class FlixAppMain: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // create url and url request
        // "!"-unswrap
        let url = URL(string:"https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        // cachePolicy means what action url will do when network is connected.
        // reloadIgnoringLocalCacheData means that always load data from network, even the data is in the local cache (only for testing)
        let request =  URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        // get data
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error{
                print(error.localizedDescription)
            }else if let data = data {
                // create a dictionary for json data
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String:Any]
                //print(dataDictionary)
                // get data in dictionary of the "results" key
                let movies = dataDictionary["results"] as! [[String:Any]]
                for movie in movies{
                    let title = movie["title"] as! String
                    print(title)
                }
            }
        }
        // call task
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    


}
