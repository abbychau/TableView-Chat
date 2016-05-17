//
//  ViewController.swift
//  TableView-Chat
//
//  Created by liujunbin on 16/5/17.
//  Copyright © 2016年 liujunbin. All rights reserved.
//

import UIKit

class ViewController: UIViewController , UITextFieldDelegate {


    var keyboardManager: AtuoKeyboardManager?

    lazy var chatTable : ChatTableView = {
        let v = ChatTableView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.separatorStyle = .None
        v.backgroundColor = UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.00)
        v.estimatedRowHeight = 50
        v.rowHeight = UITableViewAutomaticDimension
        return v
    }()

    lazy var chatTool : ChatInputTool = {
        let v = ChatInputTool()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor.whiteColor()
        return v

    }()

    var vd : [String : AnyObject] = [String : AnyObject]()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        vd = ["chatTable" : chatTable , "chatTool" : chatTool]
        self.view.addSubview(chatTable)
        self.view.addSubview(chatTool)
        chatTool.inputTool.delegate = self
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|[chatTable]|", options: [], metrics: nil, views: vd))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|[chatTool]|", options: [], metrics: nil, views: vd))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-20-[chatTable][chatTool(50)]|", options: [], metrics: nil, views: vd))

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


        chatTool.senderTool.addTarget(self, action: #selector(renderTableView(_:)), forControlEvents: .TouchUpInside)

    }


    func renderTableView(sender : UIButton){

        if let txt = chatTool.inputTool.text {
            chatTable.data?.append(["content" : txt , "icon" : "mm","role" : "MINE"])
            chatTool.inputTool.text = ""

            NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: #selector(scrollTab), userInfo: nil, repeats: false)
        }

    }

    func scrollTab(){
        chatTable.scrollToBottom()
    }


}

extension ViewController {

    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {

        let input = self.chatTool.inputTool

        keyboardManager = AtuoKeyboardManager(translateView: self.view, inputView: input, ifNotRootViewDistance: UIScreen.mainScreen().bounds.height - 45 , inputVisiableHeight: 50)
        keyboardManager?.addObserver()
        return true
    }

    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {

        print("textField.text?.utf16.count  : \(chatTool.inputTool.text?.utf16.count )")

        chatTool.hasTxt = chatTool.inputTool.text?.utf16.count >= 0

        return true
    }
}



