//
//  MyCollectionViewController.swift
//  TableViewPractice
//
//  Created by Zuping Li on 1/18/19.
//  Copyright © 2019 Zuping Li. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class MyCollectionViewController: UICollectionViewController {
    
    var dataArray = [RowData]()
    let imageDownLoaderUrlSession = ImageDownloaderURLSession()
    
    init() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        super.init(collectionViewLayout: flowLayout)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        if let filepath = Bundle.main.path(forResource: "MOCK_DATA", ofType: "json") {
            do {
                let fileData = try Data(contentsOf: URL(fileURLWithPath: filepath))
                let jsonData = try JSONSerialization.jsonObject(with: fileData, options: .mutableContainers)
                if let jsonArr = jsonData as? [Any] {
                    dataArray.reserveCapacity(jsonArr.count)
                    for i in 0 ..< jsonArr.count {
                        guard let item = jsonArr[i] as? Dictionary<String, String> else { continue }
                        guard let foreground = item["fore_ground"] else { continue }
                        guard let background = item["back_ground"] else { continue }
                        let rowData = RowData(i, foreground, background)
                        dataArray.append(rowData)
                    }
                }
            } catch let error as Error? {
                print(error ?? "Error loading local json file!")
            }
        }

        // Register cell classes
        guard let collectionView = self.collectionView else { return }
        collectionView.prefetchDataSource = self
        collectionView.register(MyCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        guard let myCell = cell as? MyCollectionViewCell else {
            assert(false, "Invalid cell class")
        }
        // Configure the cell
        myCell.textLabel.text = "\(indexPath.item)"
        
        let rowData = self.dataArray[indexPath.item]
        if let image = rowData.image {
            myCell.backgroundImageView.image = image
        } else {
            self.loadImage(for: indexPath, with: rowData)
        }
    
        return myCell
    }
    
    func loadImage(for indexPath: IndexPath, with rowData: RowData) {
        imageDownLoaderUrlSession.downLoadImage(rowData.imageURL) { (image: UIImage?, error: Error?) in
            if let image = image {
                rowData.image = image
                if let cell = self.collectionView?.cellForItem(at: indexPath) as? MyCollectionViewCell {
                    cell.backgroundImageView.image = image
                }
            }
        }
    }
}

extension MyCollectionViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let viewSize = self.view.frame.size
        let width = viewSize.width
        let numOfCellInRow = 3
        let cellWidth = width / CGFloat(numOfCellInRow) - 10
        return CGSize(width: cellWidth, height: cellWidth)
    }
}

extension MyCollectionViewController: UICollectionViewDataSourcePrefetching {
    public func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            let rowData = self.dataArray[indexPath.item]
            if rowData.image != nil {
                continue
            }
            self.loadImage(for: indexPath, with: rowData)
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            let rowData = self.dataArray[indexPath.item]
            imageDownLoaderUrlSession.cancelTask(rowData.imageURL)
        }
    }
}
