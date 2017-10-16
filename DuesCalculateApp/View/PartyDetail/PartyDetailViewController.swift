//
//  PartyDetailViewController.swift
//  DuesCalculateApp
//
//  Copyright © 2017年 TechLab. All rights reserved.
//

import UIKit
import RealmSwift

class PartyDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var PartyDetailTable: UITableView!
    
    @IBOutlet weak var remainMember: UILabel!
    @IBOutlet weak var collectPrice: UILabel!
    @IBOutlet weak var surplusPrice: UILabel!
    @IBOutlet weak var sumPrice: UILabel!
    var members: [Member]?
    var pId: Int = 0
    var pName: String = "テスト"
    var memberName: String = "test"
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        test()

        // Do any additional setup after loading the view.
        
        //NavigationBarのタイトル右上に「+」を表示
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(editMember) )
        //NavigationBarのタイトル名取得
        pName = DBManager.searchPartyName(partyId: pId)
        members = DBManager.searchAllMember(partyId: pId)
        //var partyname = DBManager.searchPartyName(partyId: 4)
        //self.navigationItem.title = partyname
        self.navigationItem.title = pName
        
        //合計金額
        sumPrice.text = "test"
        //残り金額
        surplusPrice.text = "test"
        //実績金額
        collectPrice.text = "test"
        //残り人数
        remainMember.text = "test"

        //自作セルをテーブルビューに登録する。
        let memberCell = UINib(nibName: "CustomMemberCell", bundle: nil)
        PartyDetailTable.register(memberCell, forCellReuseIdentifier: "CustomMemberCell")
        
    }
    
    /// <#Description#>
    /// テストデータ投入
    func test() {
        let realm = try! Realm()
        let testTable = Party()
        testTable.partyId = 0
        testTable.partyName = "test"
        testTable.date = "20170914"
        testTable.totalAmount = 50000
        try! realm.write {
            realm.add(testTable, update: true)
        }
        let testTable1 = Member()
        testTable1.partyId = 0
        testTable1.memberName = "藤井隆司"
        testTable1.mailAddress = "test@tis.co.jp"
        testTable1.paymentCompleteFlag = 1
        testTable1.paymentAmount = 500
        try! realm.write {
            realm.add(testTable1, update: true)
        }
    }
    
    
    
    //TableView
    
    /// <#Description#>
    /// セルの個数を指定するデリゲートメソッド（必須）
    ///
    /// - Parameters:
    ///   - tableView: <#tableView description#>
    ///   - section: <#section description#>
    /// - Returns: <#return value description#>
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 通常は引数のセクションで分岐して値を返却する
        return members!.count
    }
    
    
    /// <#Description#>
    /// セルの値と背景色を設定。
    ///
    /// - Parameters:
    ///   - tableView: <#tableView description#>
    ///   - indexPath: <#indexPath description#>
    /// - Returns: <#return value description#>
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomMemberCell", for: indexPath) as! CustomMemberCell
        // Configure the cell...
        var paymentAmount: Int = 0
        var finishFlg: Int = 0
        cell.name.text = members?[indexPath.row].memberName
        paymentAmount = members![indexPath.row].paymentAmount
        cell.price.text = String(paymentAmount)
        finishFlg = members![indexPath.row].paymentCompleteFlag
        if finishFlg == 1 {
            cell.backgroundColor = UIColor.white
            cell.sw.isOn = false
        } else {
            cell.backgroundColor = UIColor.gray
            cell.sw.isOn = true
        }
        
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }



    /// <#Description#>
    /// 精算者選択画面へ遷移
    func editMember() {
        let vc = MemberSelectViewController()
        let nc = UINavigationController(rootViewController: vc)
        present(nc, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /// <#Description#>
    /// 通知ボタン押下時のダイアログ
    ///
    /// - Parameter sender: <#sender description#>
    @IBAction func alertPush(_ sender: UIButton) {
        let alertController = UIAlertController(title: "確認!", message: "未払い者に一斉通知します。よろしければOKを選んでください。", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        let cancelAction = UIAlertAction(title: "CANCEL", style: .default, handler: nil)
        
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    /// <#Description#>
    /// ワリカンボタン押下時のダイアログ
    ///
    /// - Parameter sender: <#sender description#>
    @IBAction func warikanPush(_ sender: Any) {
        let alertController = UIAlertController(title: "確認!", message: "金額が自動的に割り勘で再計算されます。よろしければOKを選んでください。", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        let cancelAction = UIAlertAction(title: "CANCEL", style: .default, handler: nil)
        
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


}
