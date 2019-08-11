//
//  NewsVIewControllerViewController.swift
//  NewaApp
//
//  Created by 小野勇輔 on 2019/08/11.
//  Copyright © 2019 yo-project. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class NewsVIewController: UIViewController, IndicatorInfoProvider {
    
    // urlを受け取る
    var url: String = ""
    
    // itemInfoを受け取る　、値を受け取るので中身は空にする itemInfoはタブの名前
    var itemInfo: IndicatorInfo = ""

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
    
        return itemInfo
        
    }

}
