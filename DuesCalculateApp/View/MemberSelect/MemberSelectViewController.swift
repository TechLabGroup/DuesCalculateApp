//
//  MemberSelectViewController.swift
//  DuesCalculateApp
//
//  Copyright © 2017年 TechLab. All rights reserved.
//

import UIKit
import Contacts


class MemberSelectViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // 連絡先を取得するクラスのインスタンスを作成
    let store = CNContactStore.init()
    
    // 連絡帳の1つ1つのデータを収める空の配列 people を準備
    var people = [CNContact]()
    
    // チェックされたユーザを収めるディクショナリ
    var addMember  = [Int: String]()
    
    // 飲み会ID
    var selectPartyId: Int?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // NavigationBarのタイトルを設定
        self.navigationItem.title = "精算者選択"
        
        // 飲み会IDを仮設定
        selectPartyId = 0001

        //自作セルをテーブルビューに登録する。
        let memberCell = UINib(nibName: "MemberTableViewCell", bundle: nil)
        tableView.register(memberCell, forCellReuseIdentifier: "MemberCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let status = CNContactStore.authorizationStatus(for: CNEntityType.contacts)
        
        switch (status) {
            
        // まだダイアログから選択を行っていない または　ペアレンタルコントロールや、機能制限によりアクセス不可
        case CNAuthorizationStatus.notDetermined,CNAuthorizationStatus.restricted:
            
            // このアプリが連絡先を使ってもいいかをユーザーが選択していない場合に、連絡先の使用を許可するか禁止するかを選択するメッセージボックスを表示
            // クロージャー内、循環参照によるメモリーリークに注意！
            let store = CNContactStore.init()
            store.requestAccess(for: CNEntityType.contacts, completionHandler: { (granted, Error) in
                
                // 利用可能
                if granted {
                    
                    // クロージャー内の処理なのでメッセージを表示する等、画面に関連する処理を行う場合はメインスレッドで処理を行うようにしましょう
                    DispatchQueue.main.async {
                    }
                    
                    // 利用不可能
                } else {
                    
                    // クロージャー内の処理なのでメッセージを表示する等、画面に関連する処理を行う場合はメインスレッドで処理を行うようにしましょう
                    DispatchQueue.main.async {
                    }
                }
            })
            
        // 拒否が選択されている
        case CNAuthorizationStatus.denied: break
            
        // 利用可能
        case CNAuthorizationStatus.authorized: break
            
        }
        
        do {
            // 連絡先データベースからここでは苗字・名前・電話番号情報を取得
            try store.enumerateContacts(with: CNContactFetchRequest(keysToFetch: [CNContactGivenNameKey as CNKeyDescriptor,
                                                                                  CNContactFamilyNameKey as CNKeyDescriptor,
                                                                                  CNContactPhoneNumbersKey as CNKeyDescriptor])) {
                (contact, cursor) -> Void in
                                                                                    
                // 電話番号が保持されている連絡先だったら
                if (!contact.phoneNumbers.isEmpty){
                                                                                        
                // 取得したデータをpeople に収める
                self.people.append(contact)
                }
            }
        }
        catch {
            print("連絡先データの取得に失敗しました")
        }
        
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 金額入力ボタン押下時の遷移先定義
    @IBAction func tapMoneyInputButton(_ sender: Any) {
        let vc = MoneyInputViewController(partyId: selectPartyId!, addMember: addMember)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        // 通常は引数のセクションで分岐して値を返却する
        return people.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //TODO セルにプライベート変数を定義して、アドレス帳の情報を裏で保持するようにしておく
        
        // セルを取得する
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemberCell", for: indexPath) as! MemberTableViewCell
        
        // アドレス帳から取得した氏名をラベルに設定する
        cell.name?.text = people[indexPath.row].familyName+people[indexPath.row].givenName
        
        cell.accessoryType = .none
        
        return cell
    }
    
    // セルが選択された時に呼び出される
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cell = tableView.cellForRow(at: indexPath) as! MemberTableViewCell
        
        // チェックマークの状態を判定
        if cell.accessoryType == .none {
            // チェックマークを入れる
            cell.accessoryType = .checkmark
            
            // チェックを付けたユーザを追加
            addMember[indexPath.row] = people[indexPath.row].familyName+people[indexPath.row].givenName
            
        } else {
            // チェックマークを外す
            cell.accessoryType = .none
            
            // チェックを外したユーザを削除
            addMember[indexPath.row] = nil
        }
    }
    
}
