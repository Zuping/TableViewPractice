//
//  ImageDownloaderURLSession.swift
//  TableViewPractice
//
//  Created by Zuping Li on 1/15/19.
//  Copyright © 2019 Zuping Li. All rights reserved.
//

import UIKit

class ImageDownloaderURLSession: NSObject {
    private let imageCache = NSCache<NSString, UIImage>()
    private var taskMap = [String: URLSessionDataTask]()
    
    public func downLoadImage(_ urlString: String, completion: @escaping (_ image: UIImage?, _ error: Error? ) -> Void) {
        if let cachedImage = self.imageCache.object(forKey: urlString as NSString) {
            completion(cachedImage, nil)
        } else {
            weak var weakSelf = self
            let url = URL(string: urlString)
            let task = URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                //error handling
                if let error = error {
                    print(error)
                    return
                }
                
                if let data = data, let downloadedImage = UIImage(data: data) {
                    guard let obj = weakSelf else { return }
                    obj.imageCache.setObject(downloadedImage, forKey: urlString as NSString)
                    DispatchQueue.main.async {
                        completion(downloadedImage, nil)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(nil, NSError.init(domain: urlString, code: -1, userInfo: nil))
                    }
                }
            })
            taskMap[urlString] = task
            task.resume()
        }
    }
    
    public func cancelTask(_ imageURL: String) {
        if let task = taskMap[imageURL] {
            task.cancel()
        }
    }
}
