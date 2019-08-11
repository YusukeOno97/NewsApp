//
//  NewsVIewControllerViewController.swift
//  NewaApp
//
//  Created by 小野勇輔 on 2019/08/11.
//  Copyright © 2019 yo-project. All rights reserved.
//

import UIKit
import XLPagerTabStrip
//カリキュラムには書いていないがwebkitをインポートする必要がある
import WebKit

class NewsVIewController: UIViewController, IndicatorInfoProvider, UITableViewDelegate, UITableViewDataSource, XMLParserDelegate {
    
    
    // テーブルビューのインスタンスを作成
    var tableView: UITableView = UITableView()
    
   // XMLのインスタンス化(インスタンスを取得)
    var parser = XMLParser()

    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var toolBar: UIToolbar!
    
    
    
    
    
    // urlを受け取る
    var url: String = ""
    
    // itemInfoを受け取る　、値を受け取るので中身は空にする itemInfoはタブの名前
    var itemInfo: IndicatorInfo = ""
    
    // セルの数　今回は記事数
//    var articles= NSMutableArray()
    
    var articles: [Any] = []

    override func viewDidLoad() {
        super.viewDidLoad()
       
        // デリゲートとので接続
        tableView.delegate = self
        tableView.dataSource = self
        
        // perser
        parser.delegate  = self
        
        
        // テーブルビューの作成
        tableView.frame = CGRect(x: 0, y: 50, width: self.view.frame.width, height:  self.view.frame.height - 50.0)
        
        // naviationDeleegataとのせ接続
        webView.navigationDelegate = (self as! WKNavigationDelegate)
        
        
        // viewに追加
        self.view.addSubview(tableView)
// 最初は隠す　今回はテーブルビューをコードで書くため、ニューズアプリが読み込まれると邪魔くさいから今回は消す　テーブルビューの作成が完了したらコメントアウトを戻す
        webView.isHidden = true
        toolBar.isHidden = true
    }
    
    
    
    func paseUrl(){
        // webを読み込む時の決まり文句
        let urlTosend: URL = URL(string: url)!
        parser = XMLParser(contentsOf:urlTosend)!
        // 記事を初期化
        articles = []
        // 解析の実行
        parser.parse()
        // tableViewのリロード
        tableView.reloadData()
        
    }
    

    
    
    
    
        // セルの高さ
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 100
        }
        
    
        // セルの数
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            // 記事の数だけ返す
            return articles.count
        }
    
        
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        
        
        cell.backgroundColor = #colorLiteral(red: 0.8934076447, green: 0.3358240713, blue: 0.4006756273, alpha: 1)
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15.0)
        cell.textLabel?.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) // UIColor.blackでも可
        
        // 記事はurlの色ととフォント
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 13.0)
        cell.detailTextLabel?.textColor = UIColor.gray
        
        
        
        return cell
        
        
        
    }
    
    
    //セルをたっぷした時のアクション
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 後で書く
    }
        
   
    
   // ページの読み込み完了時に呼ばれるやつ
    func webView(_webView: WKWebView, didFinishnavigation: WKNavigation!){
        // tableviewを隠す
        tableView.isHidden = true
        // toolBarを表示する
        toolBar.isHidden = true
        // webViewを表示する
        webView.isHidden = false
    }
    
    
    
    // キャンセル
    @IBAction func cancel(_ sender: Any) {
        // tableviewを隠す
        tableView.isHidden = false
        // toolBarを表示する
        toolBar.isHidden = false
        // webViewを表示する
        webView.isHidden = true
    }
    
    // 戻る
    @IBAction func back(_ sender: Any) {
        
        webView.goBack()
    }
    
    
    // 次へ
    @IBAction func next(_ sender: Any) {
       
        webView.goForward()
        
    }
    
    
    // リロード
    @IBAction func refresh(_ sender: Any) {
        
        webView.reload()
        
    }
    
    
    
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
    
        return itemInfo
        
    }

}
