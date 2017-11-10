//
//  MoneyInputViewController.swift
//  DuesCalculateApp
//
//  Copyright © 2017年 TechLab. All rights reserved.
//

import UIKit

/// 金額入力画面
class MoneyInputViewController: UIViewController {
    
    @IBOutlet weak var cheakMember: UILabel!
    
    // 前画面で選択されたユーザを収めるディクショナリ
    var selectMember  = [Int: String]()
    
    // 前画面で選択した人を表示するための変数
    var name: String = ""
    
    // 飲み会ID
    var selectPartyId: Int?
    
    // 編集対象のシリアルNo
    
    // MARK: - Properties
    
    private var memberSerialNo: Int?
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var inputAmount: UITextField!
    
    @IBOutlet weak var buttonRegister: UIButton!
    
    
    
    // 登録するボタン押下時の処理
    @IBAction func TapInsertButton(_ sender: Any) {
        
        let amount = Int(inputAmount.text!)
        
        if let no = memberSerialNo {
            // 更新するボタン押下時の挙動
            let _: Bool = DBManager.updateMember(serialNo: no, amount: amount!)
        } else {
            // 登録するボタン押下時の挙動
            for index in selectMember.keys {
                // 選択した人数分登録処理を実施
                let _: Bool = DBManager.createPartyDetail(partyId: selectPartyId!, name: selectMember[index]!, mailAddress: "test@tis.co.jp", amount: amount!)
            }
        }
        // ボタンをタップしたら飲み会詳細画面に.遷移
        let vc = PartyDetailViewController()
        let nc = UINavigationController(rootViewController: vc)
        present(nc, animated: true, completion: nil)
    }

    // MARK: - Initializer
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    init(partyId: Int, selectedMember: [Int: String]) {
        selectPartyId = partyId
        selectMember = selectedMember
        
        super.init(nibName: nil, bundle: nil)
    }
    
    init(serialNo: Int) {
        memberSerialNo = serialNo

        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
    }

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // NavigationBarのタイトルを設定
        self.navigationItem.title = "金額入力"
        
        if let no = memberSerialNo {
            // 編集ボタン押下時の挙動
            let member = DBManager.searchMember(serialNo: no)
            cheakMember.text = member[0].name
            inputAmount.text = String(member[0].paymentAmount)
            buttonRegister.setTitle("更新する", for: UIControlState.normal)
        } else {
            // 金額入力ボタン押下時の挙動
            cheakMember.numberOfLines = selectMember.count
            
            for index in selectMember.keys {
                name += selectMember[index]! + "\n"
            }
            
            cheakMember.text = name
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
