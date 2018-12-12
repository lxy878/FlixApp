//
//  FlixAppMain.swift
//  FlixApp
//
//  Created by Xiaoyi Liu on 9/9/18.
//  Copyright © 2018 Xiaoyi Liu. All rights reserved.
//

import UIKit
import AlamofireImage

class FlixAppMain: UIViewController, UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    var movieList : [[String : Any]] = []
    var refreshControl : UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(FlixAppMain.refresh(_:)), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        tableView.dataSource = self
        fatchMovies()
        
    }
    
    @objc func refresh(_ refreshControl : UIRefreshControl){
        //activityIndicator.startAnimating()
        fatchMovies()
        //activityIndicator.stopAnimating()
    }
    func fatchMovies(){
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
                self.alertMassage()
                //print(error.localizedDescription)
            }else if let data = data {
                // create a dictionary for json data
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String:Any]
                //print(dataDictionary)
                // get data in dictionary of the "results" key
                let movies = dataDictionary["results"] as! [[String:Any]]
                self.movieList = movies
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
        // call task
        task.resume()
    }
    func alertMassage(){
        let alertController = UIAlertController(title: "Can't Get Movies", message: "The internet connection appears to be offline.", preferredStyle: .alert)
        let tryAction = UIAlertAction(title: "Try Again", style: .cancel) { (action) in
            self.tableView.reloadData()
        }
        alertController.addAction(tryAction)
        present(alertController,animated: true){
            
        }
    }
    // table view data source protocol
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        
        // load titles and overviews of movies
        let movie = movieList[indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        
        // to load image, it requires base url, size, and filepath
        let posterPath = movie["poster_path"] as! String
        let baseURL = "https://image.tmdb.org/t/p/w500"
        let posterURL = URL(string: baseURL + posterPath)!
        cell.posterImage.af_setImage(withURL: posterURL)
        return cell
    }
    // sender cell to detail view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        if let indexPath = tableView.indexPath(for: cell){
            let movie = movieList[indexPath.row]
            // setting destination
            let detailViewControler = segue.destination as! DetailViewController
            detailViewControler.movie =  movie
            // remove gray selection
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    


}
