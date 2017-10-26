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
    var memberSerialNo: Int = 0
    var pName: String = "テスト"
    var memberName: String = "test"
    var party: [Party]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        test()
        
        // Do any additional setup after loading the view.
        
        //NavigationBarのタイトル右上に「+」を表示
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(editMember) )
        //NavigationBarのタイトル名取得
        pName = DBManager.searchPartyName(partyId: pId)
        members = DBManager.searchAllMember(partyId: pId)
        self.navigationItem.title = pName
        
        // テーブル下部の飲み会料金詳細を計算
        amountInfo()
        
        //自作セルをテーブルビューに登録する。
        let memberCell = UINib(nibName: "CustomMemberCell", bundle: nil)
        PartyDetailTable.register(memberCell, forCellReuseIdentifier: "CustomMemberCell")
        
    }
    
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
        testTable1.serialNo = 0
        testTable1.partyId = 0
        testTable1.memberName = "東洋太郎"
        testTable1.mailAddress = "test@test.co.jp"
        testTable1.paymentCompleteFlag = false
        testTable1.paymentAmount = 500
        try! realm.write {
            realm.add(testTable1, update: true)
        }
        let testTable2 = Member()
        testTable2.serialNo = 1
        testTable2.partyId = 0
        testTable2.memberName = "東洋花子"
        testTable2.mailAddress = "test@test.co.jp"
        testTable2.paymentCompleteFlag = false
        testTable2.paymentAmount = 500
        try! realm.write {
            realm.add(testTable2, update: true)
        }
        
        // Realm内の閲覧するために、保存場所をコンソール画面に出力
        print(Realm.Configuration.defaultConfiguration.fileURL!)
    }
    
    
    /// 画面下部に表示する情報の計算
    func amountInfo() {
        
        //合計金額
        var party = DBManager.searchParty(partyId: pId)
        if party.isEmpty {
            return
        }
        let totalAmount: Int = party[0].totalAmount
        sumPrice.text = String(totalAmount)
        //残り金額
        var surPlus: Int = 0
        var count: Int = 0
        let totalCount: Int = (members?.count)!
        if (members?.isEmpty)! {
            return
        } else {
            for member in members! where member.paymentCompleteFlag {
                surPlus += member.paymentAmount
                count += 1
            }
        }
        surplusPrice.text = String(totalAmount - surPlus)
        //実績金額
        collectPrice.text = String(surPlus)
        //残り人数
        remainMember.text = String(totalCount - count)
    }
    
    
    //TableView
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
        cell.delegate = self as CustomMemberCellDelegate
        var paymentAmount: Int = 0
        var finishFlg: Bool = false
        cell.name.text = members?[indexPath.row].memberName
        paymentAmount = (members?[indexPath.row].paymentAmount)!
        cell.price.text = String(paymentAmount)
        cell.memberSerialNo = members?[indexPath.row].serialNo
        finishFlg = members![indexPath.row].paymentCompleteFlag
        if finishFlg {
            cell.backgroundColor = UIColor.gray
            cell.sw.isOn = false
        } else {
            cell.backgroundColor = UIColor.white
            cell.sw.isOn = true
        }
        
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    // Override to support editing the table view
    /// セルを左にスワイプした時の処理　（※一旦、引数をidにしている）
    ///
    /// - Parameters:
    ///   - tableView: <#tableView description#>
    ///   - indexPath: <#indexPath description#>
    /// - Returns: <#return value description#>
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        // supercedes -tableView:titleForDeleteConfirmationButtonForRowAtIndexPath: if return value is non-nil
        let cell = tableView.cellForRow(at: indexPath) as! CustomMemberCell
        
        let deleteButton = UITableViewRowAction(style: .normal, title: "削除") {(_, indexPath) -> Void in
            guard let id = cell.memberSerialNo else {
                return
            }
            DBManager.deleteMember(partyId: id)
//            self.members = DBManager.searchAllMember(partyId: id)
            self.amountInfo()
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        }
        deleteButton.backgroundColor = .red
        
        let editButton = UITableViewRowAction(style: .normal, title: "編集") {(_, _) -> Void in
            guard let id = cell.memberSerialNo else {
                return
            }
//                        self.tapEditButton(serialNo: id)
        }
        editButton.backgroundColor = .blue
        return [deleteButton, editButton]
    }
    
    
    /// 編集ボタンタップ時の遷移先定義
    ///
    /// - Parameter serialNo: 編集対象の参加者ID
//    @objc private func tapEditButton(serialNo: Int) {
//        let vc = MoneyInputViewController(serialNo: serialNo)
//        let nc = UINavigationController(rootViewController: vc)
//        present(nc, animated: true, completion: nil)
//    }
    
    
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
    
    /// ワリカンボタン押下時のダイアログ
    ///
    /// - Parameter sender: sender description
    
    @IBAction func warikanPush(_ sender: Any) {
        let alertController = UIAlertController(title: "確認!", message: "金額が自動的に割り勘で再計算されます。よろしければOKを選んでください。", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        let cancelAction = UIAlertAction(title: "CANCEL", style: .default, handler: nil)
        
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
}


// MARK: - cellaction
extension PartyDetailViewController: CustomMemberCellDelegate {
    func changeCellColor(swisOn: Bool, memberCell: UIView, memberSerialNo: Int) {
        if swisOn {
            memberCell.backgroundColor = UIColor.white
            DBManager.updatePaymentCompFlg(serialNo: memberSerialNo, partyId: 0, paymentCompleteFlag: true)
            amountInfo()
        } else {
            memberCell.backgroundColor = UIColor.gray
            DBManager.updatePaymentCompFlg(serialNo: memberSerialNo, partyId: 0, paymentCompleteFlag: false)
            amountInfo()
        }
        amountInfo()
        
        
    }
    
}
