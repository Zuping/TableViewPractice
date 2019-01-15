//
//  RowData.swift
//  TableViewPractice
//
//  Created by Zuping Li on 12/7/18.
//  Copyright © 2018 Zuping Li. All rights reserved.
//

import UIKit

class RowData: NSObject {
    let rowNum: Int
    let foreground: String
    var background: String
    var image: UIImage?
    
    var imageURL: String {
        return "https://dummyimage.com/600x600/\(background)/\(foreground).png&text=IMG\(rowNum)"
    }
    
    public init(_ rowNum: Int, _ foreground: String, _ background: String) {
        self.rowNum = rowNum
        self.foreground = String(foreground[foreground.index(after: foreground.startIndex)...])
        self.background = String(background[background.index(after: background.startIndex)...])
        super.init()
    }
}
