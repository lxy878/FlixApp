//
//  SuperheroViewController.swift
//  FlixApp
//
//  Created by Xiaoyi Liu on 9/15/18.
//  Copyright © 2018 Xiaoyi Liu. All rights reserved.
//

import UIKit

class SuperheroViewController: UIViewController, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var posters : [[String:Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        fatchMovies()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posters.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PosterCell", for: indexPath) as! PosterCell
        
        // loading image
        let movie = posters[indexPath.item]
        if let posterPath = movie["poster_path"] as? String{
            let baseURL = "https://image.tmdb.org/t/p/w500"
            let posterURL = URL(string: baseURL + posterPath)!
                cell.PosterImage.af_setImage(withURL: posterURL)
        }
        return cell
    }
    
    func fatchMovies(){
        // create url and url request
        // "!"-unwrap
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
                self.posters = movies
                self.collectionView.reloadData()
                //self.refreshControl.endRefreshing()
            }
        }
        // call task
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
