//
//  PartyListViewController.swift
//  DuesCalculateApp
//
//  Copyright © 2017年 TechLab. All rights reserved.
//

import UIKit
import RealmSwift

class PartyListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var parties: [Party]?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // NavigationBarのタイトルを設定
        self.navigationItem.title = "飲み会一覧"
        
        // NavigationBarの右側に+ボタンを配置する
        let rigthItem =  UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(tapAddButton))
        self.navigationItem.rightBarButtonItem = rigthItem
        
        parties = DBManager.searchParty()
        
        
        //自作セルをテーブルビューに登録する。
        let partyCell = UINib(nibName: "PartyTableViewCell", bundle: nil)
        tableView.register(partyCell, forCellReuseIdentifier: "PartyCell")
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        parties = DBManager.searchParty()
        tableView.reloadData()
    }
    
    @objc private func tapAddButton() {
        let vc = PartyAddViewController()
        let nc = UINavigationController(rootViewController: vc)
        present(nc, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        // 通常は引数のセクションで分岐して値を返却する
        return parties?.count ?? 0
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //セルを取得する。
        let cell = tableView.dequeueReusableCell(withIdentifier: "PartyCell", for: indexPath) as! PartyTableViewCell
        
        
        cell.partyName?.text = parties?[indexPath.row].partyName
        cell.date?.text = parties?[indexPath.row].date
        cell.partyId = parties?[indexPath.row].partyId
     
        return cell
     }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = PartyDetailViewController()
        navigationController?.pushViewController(vc, animated: true)
    	
    }

    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    
     // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data sourc
        
            let cell = tableView.cellForRow(at: indexPath) as! PartyTableViewCell
            
            DBManager.deleteParty(partyId: cell.partyId!)
            parties = DBManager.searchParty()
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        }
     }
 
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */


}
