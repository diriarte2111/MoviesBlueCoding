//
//  WatchListViewController.swift
//  MoviesBlue
//
//  Created by David Iriarte on 9/4/19.
//  Copyright © 2019 davidIriarte. All rights reserved.
//

import UIKit

class WatchListViewController: UIViewController {
    
    var titleLabel : UILabel!
    var closeButton : UIButton!
    var separatorLine : UIView!
    var tableView : UITableView!
    var noItemsAddedLabel : UILabel!
    var repository : MovieRepository!
    
    var movies : [Movie] = []
    
    init(repository: MovieRepository) {
        super.init(nibName: nil, bundle: nil)
        self.repository = repository
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        
        titleLabel = UILabel.init()
        titleLabel.text = "Watch List"
        titleLabel.textColor = UIColor.black
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: "HelveticaRoundedLTStd-BdCn", size: 15)
        self.view.addSubview(titleLabel)
        
        noItemsAddedLabel = UILabel.init()
        noItemsAddedLabel.text = "No movies added to watch list."
        noItemsAddedLabel.numberOfLines = 0
        noItemsAddedLabel.textColor = UIColor.black
        noItemsAddedLabel.textAlignment = .center
        noItemsAddedLabel.font = UIFont(name: "HelveticaRoundedLTStd-BdCn", size: 15)
        self.view.addSubview(noItemsAddedLabel)
        
        closeButton = UIButton.init(type: .custom)
        closeButton.setImage(UIImage.init(named: "close_icon"), for: .normal)
        closeButton.addTarget(self, action: #selector(closeButtonTouched), for:.touchUpInside)
        self.view.addSubview(closeButton)
        
        separatorLine = UIView.init()
        separatorLine.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        self.view.addSubview(separatorLine)
        
        tableView = UITableView.init()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.view.addSubview(tableView)
    
        movies = repository.getAllWatchListMovies()
        tableView.isHidden = (movies.count == 0)
    }
    
    @objc func closeButtonTouched(_ button:UIButton){
       self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        closeButton.frame = CGRect(x: 10, y: UIApplication.shared.statusBarFrame.height + 5, width: 40, height: 40)
        titleLabel.frame = CGRect(x: 0, y: UIApplication.shared.statusBarFrame.height + 5, width: self.view.frame.width, height: 40)
        separatorLine.frame = CGRect(x: 0, y: titleLabel.frame.maxY + 5, width: self.view.frame.width, height: 1)
        let originY : CGFloat = separatorLine.frame.maxY
        tableView.frame = CGRect(x: 0, y: originY, width: self.view.frame.width, height: self.view.frame.height - originY)
        noItemsAddedLabel.frame = tableView.frame
    }
}

extension WatchListViewController : UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movie = movies[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        cell.textLabel!.text = movie.title
        cell.textLabel?.numberOfLines = 0

        return cell
    }
}
