//
//  FlixAppMain.swift
//  FlixApp
//
//  Created by Xiaoyi Liu on 9/9/18.
//  Copyright © 2018 Xiaoyi Liu. All rights reserved.
//

import UIKit

class FlixAppMain: UIViewController, UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    var movieList : [[String : Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        
        
        // create url and url request
        // "!"-unswrap
        let url = URL(string:"https://api.themoviedb.org/3/movie/now_playing?api_key=   ")!
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
                self.movieList = movies
                
                self.tableView.reloadData()
            }
        }
        // call task
        task.resume()
    }
    
    // table view data source protocol
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        
        let movie = movieList[indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    


}
