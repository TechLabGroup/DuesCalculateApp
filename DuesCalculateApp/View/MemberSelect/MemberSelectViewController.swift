//
//  MemberSelectViewController.swift
//  DuesCalculateApp
//
//  Copyright © 2017年 TechLab. All rights reserved.
//

import UIKit
import Contacts

/// 参加者選択画面
class MemberSelectViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Properties
    
    /// 連絡帳の1つ1つのデータを収める空の配列 people を準備
    private var people = [CNContact]()
    /// チェックされたユーザを収めるディクショナリ
    var selectedMember  = [Int: String]()
    /// 飲み会ID
    let selectPartyId: Int
    
    // MARK: - IBOutleta
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - IBActions
    
    // 金額入力ボタン押下時の遷移先定義
    @IBAction func tapMoneyInputButton(_ sender: Any) {
        let vc = MoneyInputViewController(partyId: selectPartyId, selectedMember: selectedMember)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Initializer

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        selectPartyId = 0
        super.init(nibName: nil, bundle: nil)
    }
    
    init(partyId: Int) {
        selectPartyId = partyId
        
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
    }
    
    // MARK: - LyfeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // NavigationBarのタイトルを設定
        self.navigationItem.title = "精算者選択"
        reloadPeople()
        
        //自作セルをテーブルビューに登録する。
        let memberCell = UINib(nibName: "MemberTableViewCell", bundle: nil)
        tableView.register(memberCell, forCellReuseIdentifier: "MemberCell")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Private Functions
    
    private func reloadPeople() {
        // 連絡帳アクセス可否状態を取得
        let status = CNContactStore.authorizationStatus(for: CNEntityType.contacts)
        
        let store = CNContactStore.init()
        
        switch status {
            
        // まだダイアログから選択を行っていない または　ペアレンタルコントロールや、機能制限によりアクセス不可
        case .notDetermined, .restricted:
            
            // このアプリが連絡先を使ってもいいかをユーザーが選択していない場合に、連絡先の使用を許可するか禁止するかを選択するメッセージボックスを表示
            store.requestAccess(for: CNEntityType.contacts, completionHandler: { (granted, _) in
                
                // 利用可能
                if granted {
                    // 画面に関連する処理を行う場合はメインスレッドで処理を行うようにする
                    DispatchQueue.main.async {
                    }
                    // 利用不可能
                } else {
                    // 画面に関連する処理を行う場合はメインスレッドで処理を行うようにする
                    DispatchQueue.main.async {
                    }
                }
            })
            
        // 拒否が選択されている場合の処理
        case .denied: break
        // 利用可能な場合の処理
        case .authorized: break
        }
        
        do {
            // 連絡先データベースから苗字・名前・E-mail情報を取得
            let keys = [CNContactGivenNameKey as CNKeyDescriptor,
                        CNContactFamilyNameKey as CNKeyDescriptor,
                        CNContactEmailAddressesKey as CNKeyDescriptor]
            try store.enumerateContacts(with: CNContactFetchRequest(keysToFetch: keys)) { (contact, _) -> Void  in
                // メールアドレスが保持されている連絡先だったら
                if !contact.emailAddresses.isEmpty {
                    // 取得したデータをpeople に収める
                    self.people.append(contact)
                }
            }
        } catch {
            print("連絡先データの取得に失敗しました")
        }
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        

        let cell = tableView.dequeueReusableCell(withIdentifier: "MemberCell", for: indexPath) as! MemberTableViewCell
        // アドレス帳から取得した氏名をラベルに設定する
        cell.name?.text = people[indexPath.row].familyName + people[indexPath.row].givenName
        cell.accessoryType = .none
        
        return cell
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cell = tableView.cellForRow(at: indexPath) as! MemberTableViewCell
        
        // チェックマークの状態を変更
        if cell.accessoryType == .none {
            cell.accessoryType = .checkmark
            selectedMember[indexPath.row] = people[indexPath.row].familyName+people[indexPath.row].givenName
        } else {
            cell.accessoryType = .none
            selectedMember[indexPath.row] = nil
        }
    }
    
}
