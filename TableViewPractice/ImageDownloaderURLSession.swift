//
//  ImageDownloaderURLSession.swift
//  TableViewPractice
//
//  Created by Zuping Li on 1/15/19.
//  Copyright © 2019 Zuping Li. All rights reserved.
//

import UIKit

class ImageDownloaderURLSession: NSObject {
    func loadImageUsingCacheWithUrlString(_ urlString: String) {
        
        weak var weakSelf = self
        // download
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            //error handling
            if let error = error {
                print(error)
                return
            }
            if let downloadedImage = UIImage(data: data!) {
                guard let obj = weakSelf else { return }
                obj.imageCache.setObject(downloadedImage, forKey: urlString as NSString)
            }
        }).resume()
    }
}
