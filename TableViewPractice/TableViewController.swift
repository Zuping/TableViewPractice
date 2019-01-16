//
//  TableViewController.swift
//  TableViewPractice
//
//  Created by Zuping Li on 12/7/18.
//  Copyright © 2018 Zuping Li. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController, UITableViewDataSourcePrefetching {
    var data = [RowData]()
    let imageDownLoader = ImageDownloader()
    let imageDownLoaderUrlSession = ImageDownloaderURLSession()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "My images"
        tableView.prefetchDataSource = self
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "Cell")
        
        if let filepath = Bundle.main.path(forResource: "MOCK_DATA", ofType: "json") {
            do {
                let filedata = try Data(contentsOf: URL(fileURLWithPath: filepath))
                let jsonData = try JSONSerialization.jsonObject(with: filedata, options: JSONSerialization.ReadingOptions.mutableContainers)
                
                if let jsonArr = jsonData as? [Any] {
                    data.reserveCapacity(jsonArr.count)
                    for i in 0 ..< jsonArr.count {
                        let item = jsonArr[i] as! Dictionary<String, String>
                        let rowData = RowData(i, item["fore_ground"]!, item["back_ground"]!)
                        data.append(rowData)
                    }
                }
                
            } catch let error as Error? {
                print("error reading local data", error!)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell

        let row = data[indexPath.row]
        cell.myLabel.text = String(row.rowNum)
        if let image = row.image {
            cell.myImageView.image = image
        }
        return cell
    }
 
    // MARK: - Table view delegate
//    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        let rowData = self.data[indexPath.row]
//        if rowData.image != nil {
//            guard let visibleRows = tableView.indexPathsForVisibleRows else { return }
//            if visibleRows.contains(indexPath) {
//                self.tableView.reloadRows(at: [indexPath], with: .none)
//            }
//            return
//        }
//        imageDownLoader.downLoadImage(rowData.imageURL) { (image: UIImage) in
//            rowData.image = image
//            guard let visibleRows = tableView.indexPathsForVisibleRows else { return }
//            if visibleRows.contains(indexPath) {
//                 self.tableView.reloadRows(at: [indexPath], with: .none)
//            }
//            print("Debug: table view completion handler, row \(indexPath.row)")
//        }
//    }
//
//    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        let rowData = self.data[indexPath.row]
//        if rowData.image != nil {
//            return
//        }
//        imageDownLoader.cancelTask(rowData.imageURL)
//    }
    
    // MARK: - UITableViewDataSourcePrefetching
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            let rowData = self.data[indexPath.row]
            if rowData.image != nil {
                continue
            }
            imageDownLoaderUrlSession.downLoadImage(rowData.imageURL) { (image: UIImage?, error: Error?) in
                if let image = image {
                    rowData.image = image
                }
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            let rowData = self.data[indexPath.row]
            imageDownLoaderUrlSession.cancelTask(rowData.imageURL)
        }
    }
}
