//
//  TableView+Chat.swift
//  TableView-Chat
//
//  Created by liujunbin on 16/5/17.
//  Copyright © 2016年 liujunbin. All rights reserved.
//

import UIKit


extension UIFont {

    static var FontStyleNomarl : UIFont {
        return UIFont.systemFontOfSize(18)
    }

    static var FontTextStyleSubheadline: UIFont {
        return UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
    }

}


enum Role{
    case Sender //发送者
    case Receive  //接收者
}


class ChatViewData: NSObject {

    var content:String = ""
    var icon : String = ""
    var role : Role = Role.Sender

    init(content:String,icon : String ,role:Role) {
        self.content = content
        self.icon = icon
        self.role = role
    }
    
}



class ChatTableView : UITableView ,UITableViewDataSource , UITableViewDelegate {

    var data : [[String : AnyObject]]? {
        didSet {
            print("didSet is :\(data)")
            guard let d = data where d.count > 0 else {
                return
            }
            self.reloadData()
        }
    }

    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        followInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        followInit()
    }

    func followInit(){
        self.registerClass(LKFChatViewCell.self, forCellReuseIdentifier: "CHATCELL")
        self.dataSource = self
        self.delegate = self
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.count ?? 0
    }

    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        return nil
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("CHATCELL", forIndexPath: indexPath) as! LKFChatViewCell
        if let d = data{
            let dc = d[indexPath.row] as [String : AnyObject]
            let content = dc["content"] as? String ?? ""
            let icon = dc["icon"] as? String ?? ""
            let role = (dc["role"]  as? String ?? "") == "MINE" ? Role.Sender : Role.Receive
            cell.data = ChatViewData(content:  content , icon: icon , role: role)
        }


        return cell

    }




}


class LKFChatViewCell: UITableViewCell {
    var data:ChatViewData? {
        didSet {
            self.backgroundColor = UIColor.clearColor()
            self.headerImgView.removeFromSuperview()
            self.contentLbl.removeFromSuperview()
            self.bubbleImgView.removeFromSuperview()
            self.contentView.addSubview(self.headerImgView)
            self.contentView.addSubview(self.bubbleImgView)
            self.bubbleImgView.addSubview(self.contentLbl)
            //            self.selectionStyle = .None
            //将data模型中的数据给头像、内容、气泡视图

            self.headerImgView.image = UIImage(named: data?.icon ?? "Default")
            self.bubbleImgView.image = data?.role == Role.Sender ? UIImage(named: "chatto_bg_normal") : UIImage(named: "chatfrom_bg_normal")
            self.contentLbl.text = data?.content
            self.contentLbl.font = UIFont.FontStyleNomarl
            self.contentLbl.textAlignment = data?.role == Role.Sender ? NSTextAlignment.Right : NSTextAlignment.Left

            //2.设置约束
            let vd = ["headerImgView": self.headerImgView, "content": self.contentLbl, "bubble": self.bubbleImgView]
            let header_constraint_H_Format = data?.role == Role.Sender ? "[headerImgView(50)]-5-|" : "|-5-[headerImgView(50)]"
            let header_constraint_V_Format = data?.role == Role.Sender ? "V:|-5-[headerImgView(50)]" : "V:|-5-[headerImgView(50)]"
            let bubble_constraint_H_Format = data?.role == Role.Sender ? "|-(>=5)-[bubble]-10-[headerImgView]" : "[headerImgView]-10-[bubble]-(>=5)-|"
            let bubble_constraint_V_Format = data?.role == Role.Sender ? "V:|-5-[bubble(>=50)]-5-|" : "V:|-5-[bubble(>=50)]-5-|"
            let content_constraint_H_Format = data?.role == Role.Sender ? "|-10-[content]-18-|" : "|-18-[content]-10-|"
            let content_constraint_V_Format = data?.role == Role.Sender ? "V:|-10-[content]-14-|" : "V:|-10-[content]-14-|"


            let header_constraint_H = NSLayoutConstraint.constraintsWithVisualFormat(header_constraint_H_Format, options: [], metrics: nil, views: vd)
            let header_constraint_V = NSLayoutConstraint.constraintsWithVisualFormat(header_constraint_V_Format, options: [], metrics: nil, views: vd)

            let bubble_constraint_H = NSLayoutConstraint.constraintsWithVisualFormat(bubble_constraint_H_Format, options: [], metrics: nil, views: vd)
            let bubble_constraint_V = NSLayoutConstraint.constraintsWithVisualFormat(bubble_constraint_V_Format, options: [], metrics: nil, views: vd)

            let content_constraint_H = NSLayoutConstraint.constraintsWithVisualFormat(content_constraint_H_Format, options: [], metrics: nil, views: vd)
            let content_constraint_V = NSLayoutConstraint.constraintsWithVisualFormat(content_constraint_V_Format, options: [], metrics: nil, views: vd)

            self.contentView.addConstraints(header_constraint_H)
            self.contentView.addConstraints(header_constraint_V)
            self.contentView.addConstraints(bubble_constraint_H)
            self.contentView.addConstraints(bubble_constraint_V)
            self.contentView.addConstraints(content_constraint_H)
            self.contentView.addConstraints(content_constraint_V)

        }
    }
    //头像
    lazy var headerImgView : UIImageView = {
        let v = UIImageView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.cornerRadius = 25
        v.layer.masksToBounds = true
        return v
    }()
    //内容
    lazy var contentLbl : UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.numberOfLines = 0
        return v
    }()
    //气泡
    lazy var bubbleImgView : UIImageView = {
        let v = UIImageView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()


    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        followInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        followInit()
    }
    
    func followInit(){
        self.selectionStyle = .None
    }
    
}


//额外功能 输入框

class ChatInputTool : UIView {


    var hasTxt : Bool? {
        didSet {
            senderTool.enabled = hasTxt ?? false
            senderTool.backgroundColor = (hasTxt ?? false) ? UIColor(red:0.53, green:0.85, blue:0.41, alpha:1.00) : UIColor(red:0.40, green:0.40, blue:0.40, alpha:1.00)
        }
    }

    var inputTool : UITextField = {
        let v = UITextField()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.cornerRadius = 4
        v.layer.borderColor = UIColor.lightGrayColor().CGColor
        v.layer.borderWidth = 1
        v.font = UIFont.FontTextStyleSubheadline
        v.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
        v.leftViewMode = .Always
        return v
    }()

    var senderTool : UIButton = {
        let v = UIButton()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor(red:0.40, green:0.40, blue:0.40, alpha:1.00)
        v.layer.cornerRadius = 4
        v.layer.masksToBounds = true
        v.setTitle("发送", forState: .Normal)
        v.titleLabel?.font = UIFont.FontTextStyleSubheadline
        v.titleLabel?.textAlignment = .Center
        v.enabled = false
        return v
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        followInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        followInit()
    }
    var vd : [String : AnyObject] = [String : AnyObject]()
    func followInit(){
        self.addSubview(inputTool)
        self.addSubview(senderTool)
        vd = ["inputTool" : inputTool , "senderTool" : senderTool]
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|-10-[inputTool]-20-[senderTool(70)]-10-|", options: [], metrics: nil, views: vd))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[inputTool]-|", options: [], metrics: nil, views: vd))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[senderTool]-|", options: [], metrics: nil, views: vd))
        
    }
}



extension UITableView {
    // 输入文字自动滚动至底部
    func scrollToBottom (handler : (()->())? = nil) {
        let sections = self.numberOfSections
        let rows = self.numberOfRowsInSection(sections - 1)
        let sections_rows = NSIndexPath(forRow: rows - 1, inSection: sections - 1)
        self.scrollToRowAtIndexPath(sections_rows, atScrollPosition: .Bottom, animated: true)

        if let d = handler {
            d()
        }
    }
    
}

// 键盘控制
class AtuoKeyboardManager: NSObject {

    var view: UIView
    var inputView: UIView
    var ifNotRootViewDistance : CGFloat
    var cover: UIView?
    var inputVisiableHeight : CGFloat

    init(translateView: UIView, inputView: UIView , ifNotRootViewDistance : CGFloat = 0 , inputVisiableHeight : CGFloat = 0) {
        self.view = translateView
        self.inputView = inputView
        self.ifNotRootViewDistance = ifNotRootViewDistance
        self.inputVisiableHeight = inputVisiableHeight
        super.init()
    }

    func addObserver() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }

    func removeObserver() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)

        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }


    func keyboardShow(notification: NSNotification) {
        let userInfo = notification.userInfo! as NSDictionary
        let keyboardHeight = userInfo.objectForKey(UIKeyboardFrameEndUserInfoKey)?.CGRectValue().size.height ?? 0
        let duration: NSTimeInterval = userInfo.objectForKey(UIKeyboardAnimationCurveUserInfoKey)?.doubleValue ?? 0
        let options = UIViewAnimationOptions.CurveEaseInOut
        let delta = keyboardHeight - (BasicValue.screenHeight - self.inputView.frame.maxY) + ifNotRootViewDistance
        if delta > 0 {
            UIView.animateWithDuration(duration, delay: 0, options:options, animations: { [weak self] _ in
                if let strongSelf = self {
                    strongSelf.view.transform = CGAffineTransformMakeTranslation(0, -delta - BasicValue.offSet)
                }
            }) { _ in
            }

        }
        addCover()

    }
    func keyboardHide(notification: NSNotification) {
        let userInfo = notification.userInfo! as NSDictionary
        let duration: NSTimeInterval = userInfo.objectForKey(UIKeyboardAnimationCurveUserInfoKey)?.doubleValue ?? 0
        let options = UIViewAnimationOptions.CurveEaseInOut
        UIView.animateWithDuration(duration, delay: 0, options: options, animations: { [weak self] _ in
            if let strongSelf = self {
                strongSelf.view.transform = CGAffineTransformIdentity
            }
        }){ _ in
        }
        self.removeObserver()

    }

    func addCover() {
        cover = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height - inputVisiableHeight))
        self.view.addSubview(cover!)
        let tap = UITapGestureRecognizer(target: self, action: #selector(coverTapped))
        cover!.addGestureRecognizer(tap)
    }

    func removeCover() {
        cover?.removeFromSuperview()
        cover = nil
    }

    func coverTapped() {
        self.view.endEditing(true)
        removeCover()
    }

    struct BasicValue {

        static var offSet: CGFloat = 1.0
        static let screenHeight = UIScreen.mainScreen().bounds.size.height
    }
    
}




