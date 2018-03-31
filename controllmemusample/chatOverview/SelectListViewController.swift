//
//  SelectListViewController.swift
//  controllmemusample
//
//  Created by tatsumi kentaro on 2018/02/27.
//  Copyright © 2018年 tatsumi kentaro. All rights reserved.
//

import UIKit

class SelectListViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    
    @IBOutlet weak var mainTable: UITableView!
    
    let titleArray = ["購入した商品のチャット","商品投稿","投稿イベント"]
    let chatArray = ["自分の購入した商品のチャット","購入された商品のチャット"]
    let postProductArray = ["自分の投稿した商品"]
    let postEventArray = ["自分の投稿したイベント"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTable.dataSource = self
        mainTable.delegate = self
        mainTable.rowHeight = 60
        self.navigationItem.title = "チャット・投稿情報"
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return chatArray.count
        case 1:
            return postProductArray.count
        case 2:
            return postEventArray.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        switch indexPath.section {
        case 0:
            
            cell.textLabel?.text = chatArray[indexPath.row]
        case 1:
            cell.textLabel?.text = postProductArray[indexPath.row]
        case 2:
            cell.textLabel?.text = postEventArray[indexPath.row]
            
        default:
            break
        }
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        return titleArray[section]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0{
            performSegue(withIdentifier: "myBuyingChat", sender: nil)
        }
        if indexPath.section == 0 && indexPath.row == 1{
            performSegue(withIdentifier: "mySelling", sender: nil)
        }
        if indexPath.section == 1 && indexPath.row == 0{
            performSegue(withIdentifier: "myProductPost", sender: nil)
        }
        if indexPath.section == 2 && indexPath.row == 0 {
            performSegue(withIdentifier: "MyPostEvent", sender: nil)
        }
        
        print("section\(indexPath.section),row\(indexPath.row)")
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerTitle = view as? UITableViewHeaderFooterView {
            headerTitle.textLabel?.textColor = UIColor.orange
        }
    }
    
}
