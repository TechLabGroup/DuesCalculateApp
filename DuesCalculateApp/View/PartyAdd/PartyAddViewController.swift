//
//  PartyAddViewController.swift
//  DuesCalculateApp
//
//  Copyright © 2017年 TechLab. All rights reserved.
//

import UIKit

class PartyAddViewController: UIViewController {

    // MARK: - Properties

    
    // MARK: - Initializer
    

    // MARK: - LyfeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // NavigationBarのタイトルを設定
        self.navigationItem.title = "飲み会作成"
        
//        self.inputPartyName.text = 

        // NavigationBarの左側に飲み会一覧に閉じるボタンを配置する
        let leftItem =  UIBarButtonItem(title: "閉じる", style: .plain, target: self, action: #selector(tapCloseButton))
        self.navigationItem.leftBarButtonItem = leftItem
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - private method
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
    
    @IBAction func tapRegisterButton(_ sender: Any) {
        let partyName = inputPartyName.text
        let partyDate = inputPartyDate.text
        
        // todo: 精査後要修正
        let totalAmount = Int(inputTotalAmount.text!)
        
        // todo: 精査後要修正
        let _: Bool = DBManager().createParty(partyName: partyName!, partyDate: partyDate!, totalAmount: totalAmount!)
        let _: Bool = DBManager.createParty(partyName: partyName!, partyDate: partyDate!, totalAmount: totalAmount!)
        
        // ボタンをタップしたら画面を閉じる
        dismiss(animated: true, completion: nil)
    }
}
