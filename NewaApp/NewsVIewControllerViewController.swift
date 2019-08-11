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

class NewsVIewController: UIViewController, IndicatorInfoProvider, UITableViewDelegate, UITableViewDataSource, XMLParserDelegate , WKNavigationDelegate{
    
    
    var refreshControl: UIRefreshControl!
    
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
    
    
    // xmlに解析をかけた情報
    var elements = NSMutableDictionary()
    // XMLファイルのタグ情報
    var element: String = ""
    // XMLファイルのタイトル情報
    var titlestring: String = ""
    // XMLファイルのリンク情報
    var linkString: String = ""
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        // refreshControllのインスタンス
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
       // refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        // デリゲートとので接続
        tableView.delegate = self
        tableView.dataSource = self
        
     
        
        
        
        // テーブルビューの作成
        tableView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height:  self.view.frame.height)
        
        // naviationDeleegataとの接続
        webView.navigationDelegate = self
        
        
        // viewに追加
        self.view.addSubview(tableView)
        
        
       
        
// 最初は隠す　今回はテーブルビューをコードで書くため、ニューズアプリが読み込まれると邪魔くさいから今回は消す　テーブルビューの作成が完了したらコメントアウトを戻す
        webView.isHidden = true
        toolBar.isHidden = true
        
      
        paserUrl()
    }
    
    
    
    
    @objc func refresh() {
        // ２秒後にdelayを呼ぶ
        perform(#selector(delay), with: nil, afterDelay: 2.0)
        
    }
    
    @objc func delay() {
        
        paserUrl()
        // インジケータ終了
        refreshControl.endRefreshing()
    }
    
    
    func paserUrl(){
        // webを読み込む時の決まり文句
        let urlTosend: URL = URL(string: url)!
        parser = XMLParser(contentsOf:urlTosend)!
        // 記事を初期化
        articles = []
        // perser
        parser.delegate  = self
        // 解析の実行
        parser.parse()
        // tableViewのリロード
        tableView.reloadData()
    
        
        
    }
    
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        // elementNameにタグの名前が入ってくるのでelementに代入
        element = elementName
        // elementNameにタグの名前が入ってくるのでelementに代入
        if element == "item"{
        // 初期化　ディクショナリー型は[ : ] で初期化
        elements = [:]
        titlestring = ""
        linkString = ""
        
    }
    
}
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if element == "title" {
            // stringにタイトルが入っているのでappend
            titlestring.append(string)
        } else if element == "link" {
            linkString.append(string)
        }
    }
    
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item"{
            if titlestring != "" {
                elements.setObject(titlestring, forKey: "title" as NSCopying)
            }
            if linkString != "" {
                elements.setObject(linkString, forKey: "link" as NSCopying)
            }
            // articlesの中にelementsを入れる
            articles.append(elements)
        }
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
        
        
        cell.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15.0)
        
        cell.textLabel?.text = (articles[indexPath.row] as AnyObject).value(forKey: "title")as?String
    
        cell.textLabel?.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) // UIColor.blackでも可
        
        // 記事はurlの色ととフォント
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 13.0)
        cell.detailTextLabel?.textColor = UIColor.gray
        cell.detailTextLabel?.text = (articles[indexPath.row] as AnyObject).value(forKey: "link")as?String
        
        return cell
        
        
        
    }
    
    
    //セルをたっぷした時のアクション
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // webviewを表示する
        let linkURL = ((articles[indexPath.row] as AnyObject).value(forKey: "link") as? String)?.trimmingCharacters(in: .whitespacesAndNewlines)
                let urlStr = (linkURL?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!
        guard let url = URL(string: urlStr) else {
            return
        }
        let urlRequest = NSURLRequest(url: url)
        print(urlRequest)
        webView.load(urlRequest as URLRequest)
    }
   
    
   // ページの読み込み完了時に呼ばれるやつ
    func webView(_webView: WKWebView, didFinishnavigation: WKNavigation!){
        // tableviewを隠す
        tableView.isHidden = true
        // toolBarを表示する
        toolBar.isHidden = false
        // webViewを表示する
        webView.isHidden = false
    }
    
    
    
    // キャンセル
    @IBAction func cancel(_ sender: Any) {
        // tableviewを隠さない
        tableView.isHidden = false
        // toolBar表示しない
        toolBar.isHidden = true
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
    @IBAction func refreshpage(_ sender: Any) {
        
        webView.reload()
        
    }
    
    
    
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
    
        return itemInfo
        
    }

}























