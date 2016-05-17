//
//  ViewController.swift
//  TableView-Chat
//
//  Created by liujunbin on 16/5/17.
//  Copyright © 2016年 liujunbin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    lazy var chatTable : ChatTableView = {
        let v = ChatTableView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.separatorStyle = .None
        v.backgroundColor = UIColor.whiteColor()
        v.estimatedRowHeight = 50
        v.rowHeight = UITableViewAutomaticDimension
        return v
    }()

    var vd : [String : AnyObject] = [String : AnyObject]()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        vd = ["chatTable" : chatTable]
        self.view.addSubview(chatTable)
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|[chatTable]|", options: [], metrics: nil, views: vd))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-20-[chatTable]|", options: [], metrics: nil, views: vd))

        //默认数据
        chatTable.data = [
            ["content" : "你好" , "icon" : "katong","role" : "SOMEONE"] ,
            ["content" : "好" , "icon" : "mm","role" : "MINE"] ,
            ["content" : "你好" , "icon" : "katong","role" : "SOMEONE"] ,
            ["content" : "精品 - 纯代码 swift 聊天 微信 qq UITableView Chat<夜黑执事 出品>" , "icon" : "katong","role" : "SOMEONE"] ,
            ["content" : "精品 - 纯代码 swift 聊天 微信 qq UITableView Chat<夜黑执事 出品>精品 - 纯代码 swift 聊天 微信 qq UITableView Chat<夜黑执事 出品>" , "icon" : "mm","role" : "MINE"] ,
            ["content" : "你好" , "icon" : "mm","role" : "MINE"] ,
            ["content" : "精品 - 纯代码 swift 聊天 微信 qq UITableView Chat<夜黑执事 出品>" , "icon" : "katong","role" : "SOMEONE"] ,
            ["content" : "我都不知道自己在干什么" , "icon" : "katong","role" : "SOMEONE"] ,
        ]

    }



}




