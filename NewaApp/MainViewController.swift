//
//  ViewController.swift
//  NewaApp
//
//  Created by 小野勇輔 on 2019/08/11.
//  Copyright © 2019 yo-project. All rights reserved.
//

import UIKit
import XLPagerTabStrip

//ButtonBarPagerTabStripViewControllerはUIViewControllerを継承しているので、ここではUIViewControllerを承継させる記述をする必要はない
class MainViewController: ButtonBarPagerTabStripViewController {
    
    // 1 表示されるURLが格納された配列を定義する
    let urlList: [String] = [
        "https://news.yahoo.co.jp/pickup/domestic/rss.xml",
        "https://www.nhk.or.jp/rss/news/cat0.xml",
        "http://shukan.bunshun.jp/list/feed/rss" ]
    
    // 2 タブに表示されるタブの変数を定義する
    var itemInfo: [IndicatorInfo] = ["Yahoo", "NHK", "週間文春"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    
    //
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        // 返すViewControllerの配列
        var childViewControllers: [UIViewController] = []
        
        // 各viewcontrollerのインスタンス化　今回のurlListは3
        for i in 0 ..< urlList.count {
            
            // viewcontrollerのインスタンス化
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "News") as!NewsVIewController
            // タブにNewsVIewControllerを返している
            
            // urlListのURLを一つづつVCにあるurlに入れる
            // 値の受け渡し
            // urlとitemInfoはNewsVew~で定義されている
            vc.url = urlList[i]
            vc.itemInfo = itemInfo[i]
            // 配列にappend
            childViewControllers.append(vc)
        }
      
    // vcを返す
    return childViewControllers
        
        
    }
   

}



