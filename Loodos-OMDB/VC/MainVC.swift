

import UIKit

class MainVC: UIViewController {
    // MARK: - UI Variables
    var activityIndicator = UIActivityIndicatorView()
    let noResults = UILabel()
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            configureCollectionView(collectionView: collectionView, direction: .vertical, minLineSpacing: 5, minInteritemSpacing: 0)
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.register(UINib(nibName: String(describing: MovieCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: MovieCell.CellConstants.identifier.self))
        }
    }
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            // Change color of the SearchBar's text.
            if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
                textfield.textColor = .darkGray
            }
            searchBar.delegate = self
        }
    }
    
    // MARK: - Network Variables
    private let networkManager = NetworkManager()
    
    // MARK: - Model Variables
    var searchedMovies: Movie?
    
    // MARK: - Variables for Segue (for Detail Screen)
    var selectedMovieImdbId: String = ""
    var mainToDetailVcName = "mainToDetailVC"
    
    // MARK: - Base Life Cycle Funcs
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    // MARK: - GET Request for Search
    func loadSearchedMovies(title: String) {
        showActivityIndicator(activityIndicator: activityIndicator)
        networkManager.fetchSearchResult(title: title, completion: { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let searchedMovies):
                strongSelf.searchedMovies = searchedMovies
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            case .failure(let error):
                self?.showAlert(errorTitle: "Network Error", errorMessage: error.localizedDescription)
                print(error.localizedDescription)
            }
        })
        hideActivityIndicator(activityIndicator: activityIndicator)
    }
    // MARK: - Segue Process
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == mainToDetailVcName) {
            if let destinationVC = segue.destination as? DetailVC {
                destinationVC.ImdbId = selectedMovieImdbId
            }
        }
    }
}

extension MainVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {

    // MARK: - SearchBar Functions
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text?.removeAll()
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text?.isEmpty == false {
            DispatchQueue.main.async {
                self.loadSearchedMovies(title: searchBar.text ?? "")
                self.searchBar.endEditing(true)
            }
        } else {
            self.showAlert(errorTitle: "Wrong Input!", errorMessage: "Searched title is null.")
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.isEmpty == false {
            DispatchQueue.main.async {
                self.loadSearchedMovies(title: searchBar.text ?? "")
            }
        }
    }
    // MARK: - CollectionView Functions
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let id = searchedMovies?.search?[indexPath.row].imdbId {
            selectedMovieImdbId = id
            performSegue(withIdentifier: mainToDetailVcName, sender: nil)
        }
    }
    
    func configureCollectionView(collectionView: UICollectionView, direction: UICollectionView.ScrollDirection, minLineSpacing: Int, minInteritemSpacing: Int) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = direction
        layout.minimumLineSpacing = CGFloat(minLineSpacing)
        layout.minimumInteritemSpacing = CGFloat(minInteritemSpacing)
        collectionView.setCollectionViewLayout(layout, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top: 30, left: 40, bottom: 30, right: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let gridLayout = collectionViewLayout as? UICollectionViewFlowLayout
            let widthPerItem = collectionView.frame.width / 3 - gridLayout!.minimumInteritemSpacing
        return CGSize(width: widthPerItem, height: widthPerItem * 1.75)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchedMovies?.search?.count ?? self.zeroResultFound(label: noResults)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.CellConstants.identifier.self, for: indexPath as IndexPath) as? MovieCell else { return UICollectionViewCell() }
        self.hideZeroResultFound(label: noResults)
        cell.configure(title: searchedMovies?.search?[indexPath.row].title ?? "", year: searchedMovies?.search?[indexPath.row].year ?? "", imageURL: searchedMovies?.search?[indexPath.row].poster ?? "")
        return cell
    }
}

