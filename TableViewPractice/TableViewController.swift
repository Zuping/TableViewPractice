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
                let jsonData = try JSONSerialization.jsonObject(with: filedata, options: .mutableContainers)
                if let jsonArr = jsonData as? [Any] {
                    data.reserveCapacity(jsonArr.count)
                    for i in 0 ..< jsonArr.count {
                        if let item = jsonArr[i] as? Dictionary<String, String> {
                            let rowData = RowData(i, item["fore_ground"]!, item["back_ground"]!)
                            data.append(rowData)
                        } else {
                            continue
                        }
                    }
                }
            } catch let error as Error? {
                print(error ?? "Error loading local json file!")
            }
        }
        
        
//        guard let url = URL(string: "https://jsonplaceholder.typicode.com/todos") else {return}
//        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
//            guard let dataResponse = data,
//                error == nil else {
//                    print(error?.localizedDescription ?? "Response Error")
//                    return }
//            do{
//                //here dataResponse received from a network request
//                let jsonResponse = try JSONSerialization.jsonObject(with:
//                    dataResponse, options: [])
//                print(jsonResponse) //Response result
//            } catch let parsingError {
//                print("Error", parsingError)
//            }
//        }
//        task.resume()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        guard let myCell = cell as? TableViewCell else {
            assert(false, "Invalid cell class")
        }

        let row = data[indexPath.row]
        myCell.myLabel.text = String(row.rowNum)
        if let image = row.image {
            myCell.myImageView.image = image
        } else {
            self.loadImage(for: indexPath, with: row)
        }
        return myCell
    }
 
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let myCollectionViewController = MyCollectionViewController()
        self.navigationController?.pushViewController(myCollectionViewController, animated: true)
    }
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
    
    func loadImage(for indexPath: IndexPath, with rowData: RowData) {
        imageDownLoaderUrlSession.downLoadImage(rowData.imageURL) { (image: UIImage?, error: Error?) in
            if let image = image {
                rowData.image = image
                if let cell = self.tableView.cellForRow(at: indexPath) as? TableViewCell {
                    cell.myImageView.image = image
                }
            }
        }
    }
    
    // MARK: - UITableViewDataSourcePrefetching
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            let rowData = self.data[indexPath.row]
            if rowData.image != nil {
                continue
            }
            self.loadImage(for: indexPath, with: rowData)
        }
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            let rowData = self.data[indexPath.row]
            imageDownLoaderUrlSession.cancelTask(rowData.imageURL)
        }
    }
}
