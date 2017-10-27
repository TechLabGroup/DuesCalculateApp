//
//  PartyAddViewController.swift
//  DuesCalculateApp
//
//  Copyright © 2017年 TechLab. All rights reserved.
//

import UIKit

class PartyAddViewController: UIViewController {

    // MARK: - Properties
    private var editPartyId: Int?

    
    // MARK: - Initializer
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    init(partyId: Int) {
        editPartyId = partyId

        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
    }

    
    // MARK: - LyfeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // NavigationBarのタイトルを設定
        self.navigationItem.title = "飲み会作成"
        // NavigationBarの左側に飲み会一覧に閉じるボタンを配置する
        let leftItem =  UIBarButtonItem(title: "閉じる", style: .plain, target: self, action: #selector(tapCloseButton))
        self.navigationItem.leftBarButtonItem = leftItem
        
        // 金額項目を数値入力のみに制限
        inputTotalAmount.keyboardType = UIKeyboardType.numberPad
        
        // 編集ボタン押下時の挙動
        if let id = editPartyId {
            let party = DBManager.searchParty(partyId: id)
            inputPartyName.text = party.partyName
            inputPartyDate.text = party.date
            inputTotalAmount.text = String(party.totalAmount)
            buttonRegister.setTitle("更新する", for: UIControlState.normal)
        }

    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - private method
    /// 閉じるボタンタップ時にモーダル解除
    @objc private func tapCloseButton() {
        dismiss(animated: true, completion: nil)
    }

    // todo 入力値精査
    // todo 入力値が異常な場合のボタン無効化操作

    // MARK: - IBOutlet
    @IBOutlet weak var inputPartyName: UITextField!

    @IBOutlet weak var inputPartyDate: UITextField!
    
    @IBOutlet weak var inputTotalAmount: UITextField!

    @IBOutlet weak var buttonRegister: UIButton!
    
    /// 登録ボタンタップ時の挙動
    /// 登録ボタンをタップした場合は飲み会を新規作成
    /// 更新ボタンをタップした場合は飲み会を編集
    /// - Parameter sender: begin edit
    @IBAction func tapRegisterButton(_ sender: Any) {
        let partyName = inputPartyName.text
        let partyDate = inputPartyDate.text
        
        // todo: 精査後要修正
        let totalAmount = Int(inputTotalAmount.text!)
        
        // 編集ボタン押下時の挙動
        if let id = editPartyId {
            let _: Bool = DBManager.updateParty(partyId: id, partyName: partyName!, partyDate: partyDate!, totalAmount: totalAmount!)
        } else {
            // todo: 精査後要修正
            let _: Bool = DBManager.createParty(partyName: partyName!, partyDate: partyDate!, totalAmount: totalAmount!)
        }
        // ボタンをタップしたら画面を閉じる
        dismiss(animated: true, completion: nil)
    }
}
