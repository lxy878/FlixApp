//
//  DetailViewController.swift
//  FlixApp
//
//  Created by Xiaoyi Liu on 9/14/18.
//  Copyright © 2018 Xiaoyi Liu. All rights reserved.
//

import UIKit

enum movieKeys {
    static let title = "title"
    static let posterPath = "poster_path"
    static let releaseDate = "release_date"
    static let overview = "overview"
    static let backdropPath = "backdrop_path"
}
class DetailViewController: UIViewController {
    
    @IBOutlet weak var backdropPathLabel: UIImageView!
    @IBOutlet weak var posterPathLabel: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    var movie : [String:Any]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let movie = movie{
            titleLabel.text = movie[movieKeys.title] as? String
            releaseDateLabel.text = movie[movieKeys.releaseDate] as? String
            overviewLabel.text = movie[movieKeys.overview] as? String
            overviewLabel.sizeToFit()
            
            let backdropString = movie[movieKeys.backdropPath] as! String
        let baseURL = "https://image.tmdb.org/t/p/w500"
            let backdropURL = URL(string: baseURL + backdropString)!
            backdropPathLabel.af_setImage(withURL: backdropURL)
            let posterString = movie[movieKeys.posterPath] as! String
            let posterURL = URL(string: baseURL + posterString)!
            posterPathLabel.af_setImage(withURL: posterURL)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
