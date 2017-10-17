//
//  MoneyInputViewController.swift
//  DuesCalculateApp
//
//  Copyright © 2017年 TechLab. All rights reserved.
//

import UIKit

class MoneyInputViewController: UIViewController {
    
    
    @IBOutlet weak var cheakMember: UILabel!
    
    // 前画面で選択されたユーザを収めるディクショナリ
    var selectMember  = [Int: String]()
    
    // 前画面で選択した人を表示するための変数
    var name: String = ""
    
    // 飲み会ID
    var selectPartyId: Int?
    
    // 編集対象のシリアルNo
    var editSerialId: Int?
    
    // MARK: - Initializer
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    init(partyId: Int, addMember: [Int: String]) {
        selectPartyId = partyId
        selectMember = addMember
        
        super.init(nibName: nil, bundle: nil)
    }
    
    init(serialNo: Int, editMember: String, amount: Int) {
        editSerialId = serialNo
        
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // NavigationBarのタイトルを設定
        self.navigationItem.title = "金額入力"
        
        
        
        
        
        
        cheakMember.numberOfLines = selectMember.count
        
        for index in selectMember.keys {
            name += selectMember[index]! + "\n"
        }
        
        cheakMember.text = name

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var inputAmount: UITextField!
    
    
    // 登録するボタン押下時の処理
    @IBAction func TapInsertButton(_ sender: Any) {
        
        let amount = Int(inputAmount.text!)
        
        for index in selectMember.keys {
            // 選択した人数分登録処理を実施
            let _: Bool = DBManager.createPartyDetail(partyId: selectPartyId!, name: selectMember[index]!, mailAddress: "test@tis.co.jp", amount: amount!)
        }
        
        let vc = PartyDetailViewController()
        let nc = UINavigationController(rootViewController: vc)
        present(nc, animated: true, completion: nil)
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
