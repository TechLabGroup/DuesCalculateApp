//
//  PartyDetailViewController.swift
//  DuesCalculateApp
//
//  Copyright © 2017年 TechLab. All rights reserved.
//

import UIKit
import RealmSwift

private let kYen: String = "¥"
private let kBar: String = "-"
private let kNin: String = "人"
private let kComma: String = ","

/// 飲み会詳細画面
class PartyDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Properties
    fileprivate var members: [Member]
    fileprivate let pId: Int
    private var memberSerialNo: Int = 0
    private let pName: String
    private var memberName: String?
    private let totalamount: Int
    
    // MARK: - @IBOutlet
    @IBOutlet weak var PartyDetailTable: UITableView!
    @IBOutlet weak var remainMember: UILabel!
    @IBOutlet weak var collectPrice: UILabel!
    @IBOutlet weak var surplusPrice: UILabel!
    @IBOutlet weak var sumPrice: UILabel!
    
    // MARK: - IBActions
    
    /// 通知ボタン押下時のダイアログ
    ///
    /// - Parameter sender: 通知ボタン
    @IBAction func noticePush(_ sender: UIButton) {
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

    
    // MARK: - Initializer
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        // このメソッドが呼ばれることがないため、ダミー値で初期化
        pId = 0
        let party = DBManager.searchParty(partyId: pId)
        pName = party.partyName
        members = DBManager.searchAllMember(partyId: pId)
        totalamount = party.totalAmount
        super.init(nibName: nil, bundle: nil)
    }
    
    init(partyId: Int) {
        pId = partyId
        let party = DBManager.searchParty(partyId: pId)
        pName = party.partyName
        members = DBManager.searchAllMember(partyId: pId)
        // 合計金額の初期化
        totalamount = party.totalAmount
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
        
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //NavigationBarのタイトル右上に「+」を表示
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(editMember) )
        
        //NavigationBarのタイトル名取得
        navigationItem.title = pName
        
        // テーブル下部の飲み会料金詳細を計算
        amountInfo()
        
        //自作セルをテーブルビューに登録する。
        PartyDetailTable.register(UINib(nibName: "CustomMemberCell", bundle: nil), forCellReuseIdentifier: "CustomMemberCell")
    }
    

    // MARK: - public functions
    
    /// 画面下部に表示する情報の計算
    func amountInfo() {
        
        sumPrice.text = kYen + priceFormat(price: totalamount) + kBar

        /// 実績金額
        var surPlus = 0
        /// 回収実績人数
        var count = 0
        
        //残り金額
        let totalCount = members.count
        if !members.isEmpty {
            for member in members where member.paymentCompleteFlag {
                surPlus += member.paymentAmount
                count += 1
            }
        }

        // 残り金額
        surplusPrice.text = kYen + priceFormat(price: totalamount - surPlus) + kBar

        // 実績金額
        collectPrice.text = kYen + priceFormat(price: surPlus) + kBar
        
        // 残り人数
        remainMember.text = String(totalCount - count) + kNin
    }
    
    /// 精算者選択画面へ遷移
    func editMember() {
        let nc = UINavigationController(rootViewController: MemberSelectViewController())
        present(nc, animated: true, completion: nil)
    }
    
    // MARK: - Private functions
    
    /// 編集ボタンタップ時の遷移先定義
    ///
    /// - Parameter serialNo: 編集対象の参加者ID
    private func tapEditButton(serialNo: Int) {
        let vc = MoneyInputViewController(serialNo: serialNo)
        let nc = UINavigationController(rootViewController: vc)
        present(nc, animated: true, completion: nil)
    }
    
    /// 数値を３桁ごとにカンマで区切る
    ///
    /// - Parameter price: 金額
    /// - Returns: ３桁区切りの金額
    private func priceFormat(price: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.decimal
        formatter.groupingSeparator = kComma
        formatter.groupingSize = 3

        return formatter.string(from: price as NSNumber) ?? ""
    }
    
    
    // MARK: - TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomMemberCell", for: indexPath) as! CustomMemberCell
        cell.delegate = self as CustomMemberCellDelegate
        
        let member = members[indexPath.row]
        
        cell.name.text = member.memberName
        cell.price.text = priceFormat(price: member.paymentAmount)
        cell.memberSerialNo = member.serialNo
        
        let completeFlg = member.paymentCompleteFlag
        cell.backgroundColor = completeFlg ? .gray: .white
        cell.sw.isOn = completeFlg
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let cell = tableView.cellForRow(at: indexPath) as! CustomMemberCell
        
        let deleteButton = UITableViewRowAction(style: .normal, title: "削除") {(_, indexPath) -> Void in
            guard let id = cell.memberSerialNo else {
                return
            }
            DBManager.deleteMember(serialNo: id)
            // キャプチャリストでselfをweak参照する。
            self.members = DBManager.searchAllMember(partyId: self.pId)
            self.amountInfo()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        deleteButton.backgroundColor = .red
        
        let editButton = UITableViewRowAction(style: .normal, title: "編集") {(_, _) -> Void in
            guard let id = cell.memberSerialNo else {
                return
                
            }
            // キャプチャリストでselfをweak参照する。
            self.tapEditButton(serialNo: id)
        }
        editButton.backgroundColor = .blue
        return [deleteButton, editButton]
    }

}

// MARK: - cellaction
extension PartyDetailViewController: CustomMemberCellDelegate {
    func changeCellColor(swisOn: Bool, memberCell: UIView, memberSerialNo: Int) {
        
        memberCell.backgroundColor = swisOn ? .gray : .white
        DBManager.updatePaymentCompFlg(serialNo: memberSerialNo, partyId: pId, paymentCompleteFlag: swisOn)
        // Realmはデータ取得後同じインスタンスで管理しているため、データを更新すると
        // 更新前に取得したデータも値が更新される。
        // そのためデータの再取得は不要。
        // データ削除した場合は、削除データを参照しようとするとクラッシュするので要注意
        amountInfo()
    }
}
