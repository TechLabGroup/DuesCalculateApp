//
//  PartyDetailViewController.swift
//  DuesCalculateApp
//
//  Copyright © 2017年 TechLab. All rights reserved.
//

import UIKit
import RealmSwift

class PartyDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
        
        //NavigationBarのタイトル右上に「+」を表示
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(editMember) )
        
        //NavigationBarのタイトル名取得
        self.navigationItem.title = "test" /*ダミー*/
    }

    //精算者選択画面へ遷移
    func editMember() {
        let vc = MemberSelectViewController()
        let nc = UINavigationController(rootViewController: vc)
        present(nc, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func alertPush(_ sender: UIButton) {
        let alertController = UIAlertController(title: "確認!", message: "未払い者に一斉通知します。よろしければOKを選んでください。", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        let cancelAction = UIAlertAction(title: "CANCEL", style: .default, handler: nil)
        
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
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
