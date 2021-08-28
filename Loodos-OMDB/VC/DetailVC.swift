

import UIKit

class DetailVC: UIViewController {
    var ImdbId: String = ""
    // MARK: - Network Variables
    private let networkManager = NetworkManager()
    // MARK: - Model Variables
    var detailOfMovie: MovieDetail?
    
    // MARK: - UI Variables
    var activityIndicator = UIActivityIndicatorView()
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var runtimeLabel: UILabel!
    @IBOutlet weak var releasedLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var actorsLabel: UILabel!
    @IBOutlet weak var plotLabel: UITextView!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    
    // MARK: - Base Life Cycle Funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        hideUIComponents(hideBool: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        loadDetailsOfMovie(imdbId: ImdbId)
    }
    
    func hideUIComponents(hideBool: Bool) {
        let components = [genreLabel, posterImageView, titleLabel, yearLabel, runtimeLabel, releasedLabel, directorLabel, actorsLabel, plotLabel, languageLabel]
        for i in components {
            i?.isHidden = hideBool
        }
    }
    
    func loadDetailsOfMovie(imdbId: String) {
        showActivityIndicator(activityIndicator: activityIndicator)
        networkManager.fetchDetailResult(imdbId: imdbId, completion: { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let movie):
                strongSelf.detailOfMovie = movie
                if let movieDetail = self?.detailOfMovie {
                    self?.postAnalyticsLogs(detailOfMovie: movieDetail)
                    self?.configureUI(detailOfMovie: movieDetail)
                }
            case .failure(let error):
                self?.showAlert(errorTitle: "Network Error", errorMessage: error.localizedDescription)
                print(error.localizedDescription)
            }
        })
        hideActivityIndicator(activityIndicator: activityIndicator)
    }
    
    func configureUI(detailOfMovie: MovieDetail?) {
        if let movie = detailOfMovie {
            titleLabel.text = movie.title
            yearLabel.text = movie.year
            runtimeLabel.text = movie.runtime
            releasedLabel.text = movie.released
            directorLabel.text = movie.director
            actorsLabel.text = movie.actors
            plotLabel.text = movie.plot
            languageLabel.text = movie.language
            genreLabel.text = movie.genre
            configurePosterImage(imageURL: movie.poster ?? "")
            hideUIComponents(hideBool: false)
        } else {
            self.showAlert(errorTitle: "No Results", errorMessage: "Could not find any information about this movie")
        }
    }
    
    func configurePosterImage(imageURL: String) {
        let url = URL(string: imageURL)
        posterImageView?.kf.setImage(with: url, placeholder: UIImage(named:"loading")) { result in
           switch result {
           case .success(_):
               //print("Image: \(value.image). Got from: \(value.cacheType)")
                break
           case .failure(let error):
            self.posterImageView.image = UIImage(named: "no-photo")
               print("Error: \(error)")
           }
        }
    }
}
