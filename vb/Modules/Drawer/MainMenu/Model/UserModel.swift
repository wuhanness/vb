//
//  UserModel.swift
//  vb
//
//  Created by 马权 on 5/16/15.
//  Copyright (c) 2015 maquan. All rights reserved.
//

import MJExtension

class UserModel: NSObject, NSCoding {
    
    var id: NSString?                   //  用户ID
    var name: NSString?                 //  用户昵称
    var profile_image_url: NSString?    //  头像
    
    var followers_count: NSNumber?
    var friends_count: NSNumber?
    var statuses_count: NSNumber?
    
    var _description: NSString?
//    var province: NSString?             //  省
//    var city: NSString?                 //  市
    var location: NSString?             //  地区
    var cover_image_phone: NSString?    //  背景图片
    var gender: NSString?               //  性别
    var created_at: NSString?           //  注册时间
    
    var status: NSDictionary?           //  最近一条微博
    
    var avatar_large: NSString?         //  大图头像
    var avatar_hd: NSString?            //  高清头像
    
    //  这里这个重载的init()十分必要，否则便利构造函数无法调用。
    override init() {
    
    }
    
    //  利用MJExtension 使其可编码支持NSKeyedArchiver
    required init(coder aDecoder: NSCoder) {
        super.init()
        self.mj_decode(aDecoder)
    }
    
    //  利用MJExtension 使其可编码支持NSKeyedUnarchiver
    func encode(with aCoder: NSCoder) {
        self.mj_encode(aCoder)
    }
}

extension UserModel {
    
    internal override class func initialize() {
        struct Static {
            static var token: Int = 0
        }
        // make sure this isn't a subclass
        if self !== UserModel.self {
            return
        }
        //  处理属性和Json key不匹配情况
        UserModel.mj_setupReplacedKey { () -> [AnyHashable: Any]! in
            return ["_description": "description"]
        }
    }
}
