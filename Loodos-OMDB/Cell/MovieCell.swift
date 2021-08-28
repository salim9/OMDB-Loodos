

import UIKit
import Kingfisher


class MovieCell: UICollectionViewCell {
    //UI Variables
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    
    struct CellConstants {
        static let nibName = "MovieCell"
        static let identifier = "MovieCell"
    }
    
    func configure(title: String, year: String, imageURL: String) {
        layer.cornerRadius = 12
        movieTitleLabel.text = "\(title)"
        let url = URL(string: imageURL)
        posterImage?.kf.setImage(with: url, placeholder: UIImage(named:"loading")) { result in
           switch result {
           case .success(_):
               //print("Image: \(value.image). Got from: \(value.cacheType)")
                break
           case .failure(let error):
            self.posterImage.image = UIImage(named: "no-photo")
               print("Error: \(error)")
           }
         }
    }

}
