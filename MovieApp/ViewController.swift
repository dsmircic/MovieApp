//
//  ViewController.swift
//  MovieApp
//
//  Created by Dino Smirčić on 20.03.2022..
//

import UIKit
import PureLayout

class ViewController: UIViewController {
    
    private var stackView: UIStackView!
    private var topView: UIView!
    private var bottomView: UIView!
    
    private let titleFontStyle = UIFont(name: "HelveticaNeue-Bold", size: 14)
    private let descriptionFontStyle = UIFont(name: "Proxima Nova", size: 14)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildViews()
    }
    
    private func buildViews() {
        initializeStackView()
        
        initializeTopView()
        initializeBottomView()
        
        stackView.addArrangedSubview(topView)
        stackView.addArrangedSubview(bottomView)
        
        view.addSubview(stackView)
        stackView.autoPinEdgesToSuperviewEdges()
    }
    
    private func initializeStackView () {
        stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = 0
    }
    
    private func initializeTopView () {
        topView = UIView()
        
        topView.autoSetDimension(.height, toSize: 343)
        
        let backgroundImage = UIImageView()
        backgroundImage.image = UIImage(named: "iron_man")
        backgroundImage.clipsToBounds = true
        backgroundImage.contentMode = .scaleAspectFill

        topView.addSubview(backgroundImage)
        backgroundImage.autoPinEdgesToSuperviewEdges()
        
        let userScore = UILabel()
        userScore.text = "76% user score"
        userScore.textColor = .white
        userScore.font = descriptionFontStyle

        let movieTitleFont = UIFont(name: "HelveticaNeue-Bold", size: 35)
        let movieTitleLabel = UILabel()

        movieTitleLabel.font = movieTitleFont
        movieTitleLabel.textColor = .white
        movieTitleLabel.text = "Iron Man (2008)"

        let releaseDate = createDescriptionLabel(text: "05/02/2008 (US)")
        releaseDate.textColor = .white

        let genre = createDescriptionLabel(text: "Action, Science Fictrion, Adventure 2h 6m")
        genre.textColor = .white

        let favoriteButton = UIImageView(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
        favoriteButton.image = UIImage(named: "fav_button")
        favoriteButton.bounds = CGRect(x: 0, y: 0, width: 15, height: 15)

        topView.addSubview(userScore)
        topView.addSubview(movieTitleLabel)
        topView.addSubview(releaseDate)
        topView.addSubview(genre)
        topView.addSubview(favoriteButton)

        userScore.autoPinEdge(toSuperviewEdge: .top, withInset: 132)
        userScore.autoPinEdge(toSuperviewEdge: .leading, withInset: 10)

        movieTitleLabel.autoPinEdge(.top, to: .bottom, of: userScore, withOffset: 18)
        movieTitleLabel.autoPinEdge(.leading, to: .leading, of: topView, withOffset: 10)

        releaseDate.autoPinEdge(.top, to: .bottom, of: movieTitleLabel, withOffset: 18)
        releaseDate.autoPinEdge(.leading, to: .leading, of: topView, withOffset: 10)

        genre.autoPinEdge(.top, to: .bottom, of: releaseDate, withOffset: 10)
        genre.autoPinEdge(.leading, to: .leading, of: topView, withOffset: 10)

        favoriteButton.autoPinEdge(.top, to: .bottom, of: genre, withOffset: 10)
        favoriteButton.autoPinEdge(.leading, to: .leading, of: topView, withOffset: 10)
        favoriteButton.autoSetDimensions(to: CGSize(width: 25, height: 25))
        
        
    }
    
    private func createTitleLabel (text: String) -> UILabel {
        let title = UILabel()
        
        title.text = text
        title.font = titleFontStyle
        
        return title
    }
    
    private func createDescriptionLabel (text: String) -> UILabel {
        let mDescription = UILabel()
        
        mDescription.text = text
        mDescription.numberOfLines = 0
        mDescription.lineBreakMode = .byWordWrapping
        mDescription.font = descriptionFontStyle
        
        return mDescription
    }
    
    private func createMovieInfoStack () -> UIStackView {
        let stack = UIStackView()
        
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 26
        
        return stack
    }
    
    private func createCrewStack () -> UIStackView {
        let stack = UIStackView()
        
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 8
        
        return stack
    }
    
    private func initializeBottomView () {
        bottomView = UIView()
        
        bottomView.autoSetDimension(.height, toSize: view.bounds.height - 343)
        bottomView.autoSetDimension(.width, toSize: view.bounds.width)
        
        let overview = UILabel()
        overview.text = "Overview"
        overview.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        
        let movieDescription = createDescriptionLabel(text: "After being held in an Afgan cave, billionaire Tony Stark creates a unique, weaponized suit of armor to fight evil.")

        bottomView.addSubview(overview)
        bottomView.addSubview(movieDescription)

        overview.autoPinEdge(.top, to: .top, of: bottomView, withOffset: 20)
        overview.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)

        movieDescription.autoPinEdge(.top, to: .bottom, of: overview, withOffset: 15)
        movieDescription.autoPinEdge(.leading, to: .leading, of: bottomView, withOffset: 16)
        movieDescription.autoPinEdge(toSuperviewEdge: .trailing, withInset: 30)
        
        let topMovieInfoStack = createMovieInfoStack()
        let bottomMovieInfoStack = createMovieInfoStack()
        bottomView.addSubview(topMovieInfoStack)
        bottomView.addSubview(bottomMovieInfoStack)
        
        topMovieInfoStack.autoPinEdge(.top, to: .bottom, of: movieDescription, withOffset: 44)
        bottomMovieInfoStack.autoPinEdge(.top, to: .bottom, of: topMovieInfoStack, withOffset: 22)
        
        topMovieInfoStack.autoSetDimension(.height, toSize: 44)
        topMovieInfoStack.autoSetDimension(.width, toSize: bottomView.bounds.width)
        
        bottomMovieInfoStack.autoSetDimension(.height, toSize: 44)
        bottomMovieInfoStack.autoSetDimension(.width, toSize: bottomView.bounds.width)
        
        topMovieInfoStack.autoPinEdge(toSuperviewEdge: .trailing, withInset: 30)
        topMovieInfoStack.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
        
        bottomMovieInfoStack.autoPinEdge(toSuperviewEdge: .trailing, withInset: 30)
        bottomMovieInfoStack.autoPinEdge(toSuperviewEdge: .leading, withInset: 18)
        
        let dhStack = createCrewStack()
        let jkStack = createCrewStack()
        let jfStack = createCrewStack()
        
        let dh = createTitleLabel(text: "Don Heck")
        let dhD = createDescriptionLabel(text: "Characters")
        
        dhStack.addArrangedSubview(dh)
        dhStack.addArrangedSubview(dhD)
        topMovieInfoStack.addArrangedSubview(dhStack)
        
        let jk = createTitleLabel(text: "John Kirby")
        let jkD = createDescriptionLabel(text: "Characters")
        
        jkStack.addArrangedSubview(jk)
        jkStack.addArrangedSubview(jkD)
        topMovieInfoStack.addArrangedSubview(jkStack)
        
        let jf = createTitleLabel(text: "John Favreau")
        let jfD = createDescriptionLabel(text: "Director")
        
        jfStack.addArrangedSubview(jf)
        jfStack.addArrangedSubview(jfD)
        topMovieInfoStack.addArrangedSubview(jfStack)
        
        let dhStack2 = createCrewStack()
        let jmStack = createCrewStack()
        let mhStack = createCrewStack()
        
        let dh2 = createTitleLabel(text: "Don Heck")
        let dh2D = createDescriptionLabel(text: "Characters")
        
        dhStack2.addArrangedSubview(dh2)
        dhStack2.addArrangedSubview(dh2D)
        bottomMovieInfoStack.addArrangedSubview(dhStack2)
        
        let jm = createTitleLabel(text: "Jack Marcum")
        let jmD = createDescriptionLabel(text: "Screenplay")
        
        jmStack.addArrangedSubview(jm)
        jmStack.addArrangedSubview(jmD)
        bottomMovieInfoStack.addArrangedSubview(jmStack)
        
        let mh = createTitleLabel(text: "Matt Holloway")
        let mhD = createDescriptionLabel(text: "Screenplay")
        
        mhStack.addArrangedSubview(mh)
        mhStack.addArrangedSubview(mhD)
        bottomMovieInfoStack.addArrangedSubview(mhStack)
        
//        let crew: [String : String] = ["Don Heck" : "Characters", "Jack Kirby" : "Characters", "Jon Favreau" : "Director"]
//
//        for member in crew.keys {
//            let crewStack = createCrewStack()
//            let memberName = createTitleLabel(text: member)
//
//            guard
//                let mem = crew[member] else {return}
//
//            let memberDescription = createDescriptionLabel(text: mem)
//
//            crewStack.addArrangedSubview(memberName)
//            crewStack.addArrangedSubview(memberDescription)
//
//            topMovieInfoStack.addArrangedSubview(crewStack)
//        }
        
        
    }

}

