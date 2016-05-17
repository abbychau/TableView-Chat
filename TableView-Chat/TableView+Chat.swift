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
