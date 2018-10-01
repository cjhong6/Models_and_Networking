//
//  NowPlayingViewController.swift
//  flix_demo_03
//
//  Created by Chengjiu Hong on 8/29/18.
//  Copyright © 2018 Chengjiu Hong. All rights reserved.
//

import UIKit
import AlamofireImage
import MBProgressHUD

class NowPlayingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var movies: [[String:Any]] = []
    var refreshControl:UIRefreshControl!
    var alertController = UIAlertController()
    var filteredData: [[String:Any]] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        tableView.dataSource = self
        fetchMovie()
        
    }
    
    
    func refreshControlAction(_ refreshControl: UIRefreshControl){
        fetchMovie()
    }
    
    func fetchMovie(){
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            
            MBProgressHUD.hide(for: self.view, animated: true)
            
            if let error = error {
                print(error.localizedDescription)
                
                self.alertController = UIAlertController(title: "Error", message: "\(error.localizedDescription)", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                    // handle cancel response here. Doing nothing will dismiss the view.
                }
                self.alertController.addAction(cancelAction)
                DispatchQueue.global().async(execute: {
                    DispatchQueue.main.sync{
                        self.present(self.alertController, animated: true, completion: nil)
                        
                    }
                })
                
            } else if let data = data {
                
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                let movies = dataDictionary["results"] as! [[String:Any]]
                self.movies = movies
                self.filteredData = self.movies
                self.refreshControl.endRefreshing()
                self.tableView.reloadData()
                
            }
        }
        task.resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return self.filteredData.count
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        let movie = self.filteredData[indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        
        cell.title.text = title
        cell.overview.text = overview
        
        let posterPathString = movie["poster_path"] as! String
        let baseURLString = "https://image.tmdb.org/t/p/w500"
        let posterURL = URL(string: baseURLString + posterPathString)!
        
        cell.posterImageView.af_setImage(withURL: posterURL)
        
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = searchText.isEmpty ? movies : movies.filter { (movie: [String:Any]) -> Bool in
            return (movie["title"] as! String).range(of: searchText, options: .caseInsensitive) != nil
        }
        
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        if let indexPath = tableView.indexPath(for: cell){
            let movie = movies[indexPath.row]
            let detailViewController = segue.destination as! DetailViewController
            detailViewController.movie = movie
        }
        
    }
    
}
