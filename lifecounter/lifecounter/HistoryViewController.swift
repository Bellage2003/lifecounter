//
//  HistoryViewController.swift
//  lifecounter
//
//  Created by Bella Ge on 2024/4/20.
//

import UIKit

class HistoryViewController: UIViewController, UITableViewDataSource {
    var historyData: [String] = []
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "HistoryCell")
        //view.addSubview(tableView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let tableViewWidth: CGFloat = view.bounds.width * 0.8
        let tableViewHeight: CGFloat = view.bounds.height * 0.8
        _ = CGSize(width: tableViewWidth, height: tableViewHeight)
        tableView.frame = CGRect(
            x: (view.bounds.width - tableViewWidth) / 2,
            y: (view.bounds.height - tableViewHeight) / 2,
            width: tableViewWidth,
            height: tableViewHeight
        )
        tableView.layer.cornerRadius = 10
        tableView.clipsToBounds = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath)
        cell.textLabel?.text = historyData[indexPath.row]
        return cell
    }
}

