//
//  MyCollectionViewCell.swift
//  TableViewPractice
//
//  Created by Zuping Li on 1/18/19.
//  Copyright © 2019 Zuping Li. All rights reserved.
//

import UIKit

class MyCollectionViewCell: UICollectionViewCell {
    let backgroundImageView = UIImageView()
    let textLabel = UILabel()
    
    override init(frame: CGRect = CGRect.zero) {
        super.init(frame: frame)
        
        self.contentView.addSubview(backgroundImageView)
        self.contentView.addSubview(textLabel)
        self.backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        self.textLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.backgroundImageView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor).isActive = true
        self.backgroundImageView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor).isActive = true
        self.backgroundImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        self.backgroundImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        
        self.textLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor).isActive = true
        self.textLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor).isActive = true
        self.textLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        self.textLabel.textAlignment = .center
        self.textLabel.font = UIFont.boldSystemFont(ofSize: 20)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.textLabel.text = nil
        self.backgroundImageView.image = nil
    }
}
