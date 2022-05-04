import UIKit
import PureLayout
import MovieAppData

class MovieListViewController: UIViewController, UISearchBarDelegate {
    var searchBar: UISearchBar!
    
    static var initialMovieList: InitialMovieListController!
    static var searchMovieList: SearchMovieController!
    static var movieDetails: MovieDetailsController!
    
    var networkService: NetworkService = NetworkService()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeNavigationView()
        
        addControllers()
        createViews()
        addConstraints()
        styleViews()
    }
    
    private func addControllers() {
        MovieListViewController.initialMovieList = InitialMovieListController()
        MovieListViewController.searchMovieList = SearchMovieController()
        MovieListViewController.movieDetails = MovieDetailsController()
        
        MovieListViewController.searchMovieList.view.isHidden = true
        MovieListViewController.movieDetails.view.isHidden = true
        
        view.addSubview(MovieListViewController.initialMovieList.view)
        view.addSubview(MovieListViewController.searchMovieList.view)
        view.addSubview(MovieListViewController.movieDetails.view)
                
        addChild(MovieListViewController.initialMovieList)
        addChild(MovieListViewController.searchMovieList)
        addChild(MovieListViewController.movieDetails)
    }
    
    private func createViews() {
        searchBar = UISearchBar()
        searchBar.delegate = self

        view.addSubview(searchBar)
    }
    
    private func addConstraints() {
        // search bar constraints
        searchBar.autoPinEdge(toSuperviewEdge: .top, withInset: 22)
        searchBar.autoPinEdge(toSuperviewEdge: .leading, withInset: 18)
        searchBar.autoPinEdge(toSuperviewEdge: .trailing, withInset: 19)
        
        // initialMovieList constraints
        MovieListViewController.initialMovieList.view.autoPinEdge(.top, to: .bottom, of: searchBar, withOffset: 8)
        MovieListViewController.initialMovieList.view.autoPinEdge(toSuperviewEdge: .leading)
        MovieListViewController.initialMovieList.view.autoPinEdge(toSuperviewEdge: .trailing)
        MovieListViewController.initialMovieList.view.autoPinEdge(toSuperviewEdge: .bottom)
        
        // searchMovieList constraints
        MovieListViewController.searchMovieList.view.autoPinEdge(.top, to: .bottom, of: searchBar, withOffset: 8)
        MovieListViewController.searchMovieList.view.autoPinEdge(toSuperviewEdge: .leading)
        MovieListViewController.searchMovieList.view.autoPinEdge(toSuperviewEdge: .trailing)
        MovieListViewController.searchMovieList.view.autoPinEdge(toSuperviewEdge: .bottom)
        
        // movieDetails contstraints
        MovieListViewController.movieDetails.view.autoPinEdge(toSuperviewEdge: .top)
        MovieListViewController.movieDetails.view.autoPinEdge(toSuperviewEdge: .leading)
        MovieListViewController.movieDetails.view.autoPinEdge(toSuperviewEdge: .trailing)
        MovieListViewController.movieDetails.view.autoPinEdge(toSuperviewEdge: .bottom)
    }
    
    private func styleViews() {
        view.backgroundColor = .white
        
        searchBar.tintColor = .systemGray
        searchBar.placeholder = "Search"
        searchBar.layer.cornerRadius = 10
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 0.043, green: 0.145, blue: 0.247, alpha: 1)
        appearance.shadowColor = .clear

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.isTranslucent = false
        
        navigationController?.navigationBar.tintColor = .systemGreen
    }
    
        
    private func initializeNavigationView() {
        let title = UILabel()
        
        title.font = UIFont(name: "HelveticaNeue-Bold", size: 25)
        title.text = "TMDB"
        title.textColor = .systemGreen
        
        navigationItem.titleView = title
    }
    
    // search bar actions
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        MovieListViewController.initialMovieList.view.isHidden = true
        MovieListViewController.searchMovieList.view.isHidden = false
        MovieListViewController.movieDetails.view.isHidden = true
        
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    // ne radi
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        MovieListViewController.initialMovieList.view.isHidden = false
        MovieListViewController.searchMovieList.view.isHidden = true
        MovieListViewController.movieDetails.view.isHidden = true

        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
    }
    
    func showDetailsPage() {
        MovieListViewController.initialMovieList.view.isHidden = true
        MovieListViewController.searchMovieList.view.isHidden = true
        MovieListViewController.movieDetails.view.isHidden = false
    }
    
}
