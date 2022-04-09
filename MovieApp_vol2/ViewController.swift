import UIKit
import PureLayout
import MovieAppData

class MovieListViewController: UIViewController, UISearchBarDelegate {
    var searchBar: UISearchBar!
    var initialMovieList: InitialMovieListController!
    var searchMovieList: SearchMovieController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeNavigationView()
        
        addControllers()
        createViews()
        addConstraints()
        styleViews()
    }
    
    private func addControllers() {
        initialMovieList = InitialMovieListController()
        searchMovieList = SearchMovieController()
        searchMovieList.view.isHidden = true
        
        view.addSubview(initialMovieList.view)
        view.addSubview(searchMovieList.view)
                
        addChild(initialMovieList)
        addChild(searchMovieList)
    }
    
    private func createViews() {
        searchBar = UISearchBar()
        searchBar.delegate = self

        view.addSubview(searchBar)
        
//        searchBar.searchTextField.addTarget(self, action: #selector(switchViews), for: .touchUpInside)
//        searchBar.searchTextField.addTarget(self, action: #selector(switchViews), for: .touchUpOutside)
    }
    
    private func addConstraints() {
        // search bar constraints
        searchBar.autoPinEdge(toSuperviewEdge: .top, withInset: 22)
        searchBar.autoPinEdge(toSuperviewEdge: .leading, withInset: 18)
        searchBar.autoPinEdge(toSuperviewEdge: .trailing, withInset: 19)
        
        // initialMovieList constraints
        initialMovieList.view.autoPinEdge(.top, to: .bottom, of: searchBar, withOffset: 8)
        initialMovieList.view.autoPinEdge(toSuperviewEdge: .leading)
        initialMovieList.view.autoPinEdge(toSuperviewEdge: .trailing)
        initialMovieList.view.autoPinEdge(toSuperviewEdge: .bottom)
        
        // searchMovieList constraints
        searchMovieList.view.autoPinEdge(.top, to: .bottom, of: searchBar, withOffset: 8)
        searchMovieList.view.autoPinEdge(toSuperviewEdge: .leading)
        searchMovieList.view.autoPinEdge(toSuperviewEdge: .trailing)
        searchMovieList.view.autoPinEdge(toSuperviewEdge: .bottom)
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
        initialMovieList.view.isHidden = true
        searchMovieList.view.isHidden = false
        
//        present(vc, animated: true, completion: nil)
        
        searchBar.setShowsCancelButton(true, animated: true)
        print("Began editing")
    }
    
    // ne radi
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        initialMovieList.view.isHidden = false
        searchMovieList.view.isHidden = true

        searchBar.setShowsCancelButton(false, animated: true)
        print("Ended editing")
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        initialMovieList.view.isHidden = false
        searchMovieList.view.isHidden = true

        searchBar.setShowsCancelButton(false, animated: true)
    }

    
//    @objc
//    func switchViews() {
//
////        if (initialMovieList.view.isHidden) {
//            initialMovieList.view.isHidden = false
//            searchMovieList.view.isHidden = true
////        } else {
////            initialMovieList.view.isHidden = true
////            searchMovieList.view.isHidden = false
////        }
//
//        print("Views switched")
//    }
    
    
}
