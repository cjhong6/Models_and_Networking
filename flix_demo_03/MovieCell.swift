//
//  MovieCell.swift
//  flix_demo_03
//
//  Created by Chengjiu Hong on 9/1/18.
//  Copyright © 2018 Chengjiu Hong. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var overview: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    
    var movie: Movie!{
        didSet{
            title.text = movie.title
            overview.text = movie.overview
            if movie.posterURL != nil {
               posterImageView.af_setImage(withURL: movie.posterURL!)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
