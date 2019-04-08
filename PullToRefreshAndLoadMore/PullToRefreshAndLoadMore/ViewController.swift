//
//  ViewController.swift
//  PullToRefreshAndLoadMore
//
//  Created by duycuong on 4/6/19.
//  Copyright © 2019 duycuong. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var list = [Int]()
    var pageNumber = 0
    var pageTotal = 3
    var pageSize = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loadMore()
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refreshData) , for: .valueChanged)
    }
    
    @objc func refreshData() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.list = [Int](0...10)
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }
        

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = String(list[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == list.count - 1 {
            guard pageNumber < pageTotal else { return }
            loadMore()
        }
        
    }
    
    func loadMore() {
        
        guard pageNumber < pageTotal else { return }
        
        let lastRequest = pageNumber == pageTotal - 1
        
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.list += [Int](0..<self.pageSize)
                self.tableView.reloadData()
                self.pageNumber += 1
                if lastRequest {
                    self.activityIndicator.stopAnimating()
                }
            }
    }

}

