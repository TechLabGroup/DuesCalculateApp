//
//  PartyAddViewController.swift
//  DuesCalculateApp
//
//  Copyright © 2017年 TechLab. All rights reserved.
//

import UIKit

class PartyAddViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // NavigationBarのタイトルを設定
        self.navigationItem.title = "飲み会作成"

        // NavigationBarの左側に飲み会一覧に閉じるボタンを配置する
        let leftItem =  UIBarButtonItem(title: "閉じる", style: .plain, target: self, action: #selector(tapCloseButton))
        self.navigationItem.leftBarButtonItem = leftItem
        
    }

    func tapCloseButton() {
        dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
