//
//  TableViewCell.swift
//  TableViewPractice
//
//  Created by Zuping Li on 12/7/18.
//  Copyright © 2018 Zuping Li. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    let myImageView = UIImageView()
    let myLabel = UILabel()
    
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.myImageView.backgroundColor = UIColor.gray
        self.myImageView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.myImageView)
        self.myLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.myLabel)
        
        let constraint = self.myImageView.heightAnchor.constraint(equalToConstant: 80)
        constraint.priority = UILayoutPriority(999)
        constraint.isActive = true
        self.myImageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        self.myImageView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor).isActive = true
        self.myImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        self.myImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        
        self.myLabel.leftAnchor.constraint(equalTo: self.myImageView.rightAnchor, constant: 8).isActive = true
        self.myLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -16).isActive = true
        self.myLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func prepareForReuse() {
        self.myLabel.text = ""
        self.myImageView.image = nil
        super.prepareForReuse()
    }
}
