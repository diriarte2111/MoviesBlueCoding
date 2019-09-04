//
//  WatchListTableViewCell.swift
//  MoviesBlue
//
//  Created by David Iriarte on 9/4/19.
//  Copyright © 2019 davidIriarte. All rights reserved.
//

import UIKit

class WatchListTableViewCell: UITableViewCell {
    
    var movieTitleLabel : UILabel!
    var separatorLine : UIView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialSetup() {
        
        selectionStyle = .none
        backgroundColor = UIColor.clear
        
        movieTitleLabel = UILabel.init()
        movieTitleLabel.backgroundColor = UIColor.clear
        movieTitleLabel.textColor = UIColor.black
        movieTitleLabel.textAlignment = .left
        movieTitleLabel.numberOfLines = 0
        movieTitleLabel.minimumScaleFactor = 0.5
        movieTitleLabel.adjustsFontSizeToFitWidth = true
        movieTitleLabel.font = UIFont(name: "HelveticaRoundedLTStd-BdCn", size: 16)
        contentView.addSubview(movieTitleLabel)
        
        separatorLine = UIView.init()
        separatorLine.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        self.contentView.addSubview(separatorLine)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        movieTitleLabel.frame = CGRect(x: 10, y: 0, width: self.frame.width - 20, height: self.frame.height)
        separatorLine.frame = CGRect(x: 0, y: self.frame.height - 1, width: self.frame.width, height: 1)
    }
    

}
