//
//  ViewController.swift
//  Twitter_layout(swift3)
//
//  Created by 大野　佑太郎 on 2017/01/14.
//  Copyright © 2017年 yutaro. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UIScrollViewDelegate  {
    
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var headerScrollView: UIScrollView!
    var backTweetView: UIView!
    var textField: UITextField!
    var textView: UITextView!
    
    var tweetArray: Array<Dictionary<String, String>> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        headerScrollView.contentSize = CGSize(width: self.view.frame.width*2, height: headerScrollView.frame.height)
        //ImageViewの装飾
        setProfileImageView()
        //profileテキスト
        let profileLabel = makeProfileLabel()
        headerScrollView.addSubview(profileLabel)
        //profileテクストのスクロールを途中で途切れないようにする
        headerScrollView.isPagingEnabled = true
        
        tableView.delegate = self
        tableView.dataSource  = self
        
        headerScrollView.delegate = self
        
        //セルの高さを自動で計算
        self.tableView.estimatedRowHeight = 78
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //-------------TableViewの処理------------------
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweetArray.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell")!
        let tweet = tweetArray[indexPath.row]
        
        let nameLabel = cell.viewWithTag(1) as! UILabel
        nameLabel.text = tweet["name"]
        nameLabel.font = UIFont(name: "HirakakuProN-W6", size: 8)
        
        let textLabel = cell.viewWithTag(2) as! UILabel
        textLabel.text = tweet["text"]
        textLabel.font = UIFont(name: "HirakakuProN-W6", size: 10)
        
        let timeLabel = cell.viewWithTag(3) as! UILabel
        timeLabel.text = tweet["time"]
        timeLabel.font = UIFont(name: "HirakakuProN-W3", size: 8)
        timeLabel.textColor = UIColor.gray
        textLabel.numberOfLines = 0
        
        let myImageView = cell.viewWithTag(4) as! UIImageView
        myImageView.image = UIImage(named: "pug")
        myImageView.layer.cornerRadius = 3
        myImageView.layer.masksToBounds = true
        
        return cell
    }
    
    //スクロールビュー
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        headerScrollView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: headerScrollView.contentOffset.x * 0.6 / self.view.frame.width)
        //デバックエリアにScrollViewのcontentOffsetを出力
        print("contentOffset: \(headerScrollView.contentOffset)")
    }
    
    //-------------ボタンがタップされた時の処理---------

    @IBAction func tapTweetBtn(_ sender: UIButton) {
        let backTweetView = makeBackTweetView()
        self.view.addSubview(backTweetView)
        
        let tweetView = makeTweetView()
        backTweetView.addSubview(tweetView)
        
        let textField = makeTextField()
        tweetView.addSubview(textField)
        
        let textView = makeTextView()
        tweetView.addSubview(textView)
        
        let nameLabel = makeLabel(text: "名前", y: 5)
        tweetView.addSubview(nameLabel)
        
        let tweetLabel = makeLabel(text: "ツイート内容", y: 85)
        tweetView.addSubview(tweetLabel)
        
        let cancelBtn = makeCancelBtn(tweetView: tweetView)
        tweetView.addSubview(cancelBtn)
        
        let submitBtn = makeSubmitBtn()
        tweetView.addSubview(submitBtn)

        }
    
    func tappedCancelBtn(sender: AnyObject){
      backTweetView.removeFromSuperview()
    }
    
    func tappedSubmitBtn(sender :AnyObject){
        if (textField.text!.isEmpty) || (textView.text.isEmpty){
            let alertController = UIAlertController(title: "Error", message: "'name' or 'text' is empty", preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
            alertController.addAction(action)
            present(alertController, animated: true, completion: nil)
        } else {
        let name = textField.text!
        let tweet = textView.text
        print("名前:\(name)、ツイート内容:\(tweet)")
 
        var tweetDic: Dictionary<String, String> = [:]
        tweetDic["name"] = textField.text!
        tweetDic["text"] = textView.text
        tweetDic["time"] = getCurrentTime()
        tweetArray.insert(tweetDic, at: 0)
        
        backTweetView.removeFromSuperview()
        textField.text = ""
        textView.text = ""
        tableView.reloadData()
        }
    }
    
    //現在時刻を取得
    func getCurrentTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd' 'HH:mm:ss"
        let now = Date()
        return formatter.string(from: now)
    }
    
    
    //-------------部品の生成のための処理--------------
    //backTweetViewを生成してサイズや色など細かい設定をし、返り値としてbackTweetViewを返すための関数
    func makeBackTweetView() -> UIView {
        backTweetView = UIView()
        backTweetView.frame = CGRect(x:0, y:0, width: self.view.frame.width, height: self.view.frame.height)
        backTweetView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        return backTweetView
        
    }
    
    func makeTweetView() -> UIView {
        let tweetView = UIView()
        tweetView.frame.size = CGSize(width:300, height:300)
        tweetView.center.x = self.view.center.x
        tweetView.center.y = 250
        tweetView.backgroundColor = UIColor.white
        tweetView.layer.shadowOpacity = 0.3
        tweetView.layer.cornerRadius = 3
        return tweetView
    }
    
    func makeTextField() -> UITextField {
        textField = UITextField()
        textField.frame = CGRect(x:10, y:40, width:280, height:40)
        textField.font = UIFont(name: "HiraKakuProN-W6", size: 15)
        textField.borderStyle = UITextBorderStyle.roundedRect
        return textField
    }
    
    func makeTextView() -> UITextView {
        textView = UITextView()
        textView.frame = CGRect(x:10, y:120, width:280, height:110)
        textView.font = UIFont(name: "HiraKakuProN-W6", size: 15)
        textView.layer.cornerRadius = 8
        textView.layer.borderColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0).cgColor
        textView.layer.borderWidth = 1
        return textView
    }
    
    func makeLabel(text: String, y: CGFloat) -> UILabel {
        let label = UILabel(frame: CGRect(x:10, y: y, width: 280, height: 40))
        label.text = text
        label.font = UIFont(name: "HiraKakuProN-W6", size: 15)
        return label
    }
    
    func makeCancelBtn(tweetView: UIView) -> UIButton {
        let cancelBtn = UIButton()
        cancelBtn.frame.size = CGSize(width: 20, height: 20)
        cancelBtn.center.x = tweetView.frame.width-15
        cancelBtn.center.y = 15
        cancelBtn.setBackgroundImage(UIImage(named: "cancel.png"), for: .normal)
        cancelBtn.backgroundColor = UIColor(red: 0.14, green: 0.3, blue: 0.68, alpha: 1.0)
        cancelBtn.layer.cornerRadius = cancelBtn.frame.width / 2
        cancelBtn.addTarget(self, action: #selector(ViewController.tappedCancelBtn), for:.touchUpInside)
        return cancelBtn
    }
    
    func makeSubmitBtn() -> UIButton {
        let submitBtn = UIButton()
        submitBtn.frame = CGRect(x:10, y:250, width:280, height:40)
        submitBtn.setTitle("送信", for: .normal)
        submitBtn.titleLabel?.font = UIFont(name: "HiraKakuProN-W6", size: 15)
        submitBtn.backgroundColor = UIColor(red: 0.14, green: 0.3, blue: 0.68, alpha: 1.0)
        submitBtn.setTitleColor(UIColor.gray, for: UIControlState.highlighted)
        submitBtn.layer.cornerRadius = 7
        submitBtn.addTarget(self, action: #selector(ViewController.tappedSubmitBtn), for:.touchUpInside)
        return submitBtn
    }
    
    func setProfileImageView() {
        profileImageView.layer.cornerRadius = 5
        profileImageView.layer.borderWidth = 2
        profileImageView.layer.borderColor = UIColor.white.cgColor
    }
    
    func makeProfileLabel() -> UILabel {
        let profileLabel = UILabel()
        profileLabel.frame.size = CGSize(width:200, height:100)
        profileLabel.center.x = self.view.frame.width*3/2
        profileLabel.center.y = headerScrollView.center.y-64
        profileLabel.text = "きのこだよ。好きなきのこはしめじで、嫌いなきのこはアミウダケです。よろしくね。"
        profileLabel.font = UIFont(name: "HirakakuProN-W6", size: 13)
        profileLabel.textColor = UIColor.white
        profileLabel.textAlignment = NSTextAlignment.center
        profileLabel.numberOfLines = 0
        return profileLabel
    }
    
}

