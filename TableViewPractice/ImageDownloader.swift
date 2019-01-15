//
//  ImageDownLoader.swift
//  TableViewPractice
//
//  Created by Zuping Li on 12/7/18.
//  Copyright © 2018 Zuping Li. All rights reserved.
//

import UIKit

class ImageDownloader: NSObject {
    private let imageCache = NSCache<NSString, UIImage>()
    private let operationQueue = OperationQueue()
    private var cancelSet = Set<String>()
    
    override init() {
        super .init()
        self.operationQueue.maxConcurrentOperationCount = 3
    }
    
    public func downLoadImage(_ imageURL: String, _ completionHandler: @escaping (UIImage) -> Void) {
        // checks cache
        if let cachedImage = self.imageCache.object(forKey: imageURL as NSString) {
            completionHandler(cachedImage)
        }
        
        weak var weakSelf = self
        let newOp = BlockOperation.init {
            if self.cancelSet.contains(imageURL) {
                self.cancelSet.remove(imageURL)
                return
            }
            guard let url = URL(string: imageURL) else { return }
            guard let imageData = try? Data.init(contentsOf: url) else { return }
            if !imageData.isEmpty {
                let downloadedImage = UIImage(data: imageData)!
                guard let obj = weakSelf else { return }
                obj.imageCache.setObject(downloadedImage, forKey: imageURL as NSString)
            }
        }
        newOp.completionBlock = {
            print("Debug: \(imageURL)")
            guard let obj = weakSelf else { return }
            DispatchQueue.main.async(execute: {
                if let image = obj.imageCache.object(forKey: imageURL as NSString) {
                    completionHandler(image)
                } else {
                    // handle error
                    print("Debug: image not ready \(imageURL)")
                }
            })
        }
        self.operationQueue.addOperation(newOp)
    }
    
    public func cancelTask(_ imageURL: String) {
        self.cancelSet.insert(imageURL)
    }
}
