//
//  SuperheroViewController.swift
//  flix_demo_03
//
//  Created by Chengjiu Hong on 9/10/18.
//  Copyright © 2018 Chengjiu Hong. All rights reserved.
//

import UIKit

class SuperheroViewController: UIViewController, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    var movies: [[String:Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        fetchSuperheroMovie()
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = layout.minimumInteritemSpacing
        let cellPerLine:CGFloat = 2
        let interItemSpacingTotal = layout.minimumInteritemSpacing * (cellPerLine - 1)
        let width = collectionView.frame.size.width / cellPerLine - interItemSpacingTotal / cellPerLine
        layout.itemSize = CGSize(width: width, height: width * 3 / 2)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchSuperheroMovie(){
        let url = URL(string: "https://api.themoviedb.org/3/movie/260513/similar?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US&page=1")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        
//        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            
//            MBProgressHUD.hide(for: self.view, animated: true)
            
            if let error = error {
                print(error.localizedDescription)
                
//                self.alertController = UIAlertController(title: "Error", message: "\(error.localizedDescription)", preferredStyle: .alert)
//                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
//                    // handle cancel response here. Doing nothing will dismiss the view.
//                }
//                self.alertController.addAction(cancelAction)
//                DispatchQueue.global().async(execute: {
//                    DispatchQueue.main.sync{
//                        self.present(self.alertController, animated: true, completion: nil)
//                        
//                    }
//                })
                
            } else if let data = data {
                
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                let movies = dataDictionary["results"] as! [[String:Any]]
                self.movies = movies
//                self.filteredData = self.movies
//                self.refreshControl.endRefreshing()
                self.collectionView.reloadData()
                
            }
        }
        task.resume()
    }
    

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return movies.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PosterCell", for: indexPath) as! PosterCell
        let movie = movies[indexPath.item]
        if let posterPathString = movie["poster_path"] as? String {
            let baseURLString = "https://image.tmdb.org/t/p/w500"
            let posterURL = URL(string: baseURLString + posterPathString)!
            cell.posterImageView.af_setImage(withURL: posterURL)
        }
        return cell
    }
}
