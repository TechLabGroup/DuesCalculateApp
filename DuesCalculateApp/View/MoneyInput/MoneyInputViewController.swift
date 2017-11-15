//
//  MoneyInputViewController.swift
//  DuesCalculateApp
//
//  Copyright © 2017年 TechLab. All rights reserved.
//

import UIKit

/// 金額入力画面
class MoneyInputViewController: UIViewController {
    
    // MARK: - Properties

    // 前画面で選択されたユーザを収めるディクショナリ
    var selectMember  = [Int: String]()
    
    // 前画面で選択した人を表示するための変数
    var name: String = ""
    
    // 全画面で選択した人のメールアドレスを保持するための変数
    var memberMailAddress  = [Int: String]()
    
    // 飲み会ID
    var selectPartyId: Int?
    
    // 編集対象のシリアルNo
    private var memberSerialNo: Int?
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var chekMember: UILabel!

    @IBOutlet weak var inputAmount: UITextField!
    
    @IBOutlet weak var buttonRegister: UIButton!
    
    // MARK: - IBActions
    
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
                if let partyId = selectPartyId,
                    let name = selectMember[index],
                    let amount = amount {
                    let _: Bool = DBManager.entryMember(partyId: partyId, memberName: name, mailAddress: "test@test.co.jp", paymentCompleteFlag: false, paymentAmount: amount)
                }
            }
        }
            dismiss(animated: true, completion: nil)
    }

    // MARK: - Initializer
    
    
    /// 参加者選択画面から遷移した場合
    ///
    /// - Parameters:
    ///   - partyId: 飲み会ID
    ///   - selectedMember: 選択した参加者
    init(partyId: Int, selectedMember: [Int: String]) {
        selectPartyId = partyId
        selectMember = selectedMember
        
        super.init(nibName: nil, bundle: nil)
    }
    
    /// 飲み会詳細画面から編集ボタン押下で遷移した場合
    ///
    /// - Parameter serialNo: シリアルNo
    init(serialNo: Int) {
        self.memberSerialNo = serialNo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // NavigationBarのタイトルを設定
        self.navigationItem.title = "金額入力"
        let leftItem =  UIBarButtonItem(title: "閉じる", style: .plain, target: self, action: #selector(tapCloseButton))
        navigationItem.leftBarButtonItem = leftItem
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let toolBarBtn = UIBarButtonItem(title: "完了", style: .plain, target: self, action: #selector(doneBtn))
        toolBar.items = [toolBarBtn]
        inputAmount.inputAccessoryView = toolBar

        if let serialNo = memberSerialNo {
            // 飲み会詳細画面から遷移した場合
            let member = DBManager.searchMemberBySerialNo(serialNo: serialNo)
            chekMember.text = member.memberName
            inputAmount.text = String(member.paymentAmount)
            buttonRegister.setTitle("更新する", for: .normal)
        } else {
            // 参加者選択画面から遷移した場合
            chekMember.numberOfLines = selectMember.count
            
            for index in selectMember.keys {
                name += selectMember[index]! + "\n"
            }
            chekMember.text = name
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Private Functions
    
    /// 閉じるボタンタップ時にモーダル解除
    @objc private func tapCloseButton() {
        dismiss(animated: true, completion: nil)
    }
    
    //toolbarのdoneボタン
    @objc private func doneBtn() {
        inputAmount.resignFirstResponder()
    }
}
