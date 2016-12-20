//
//  DetailBaseViewController.swift
//  vb
//
//  Created by 马权 on 6/21/15.
//  Copyright (c) 2015 maquan. All rights reserved.
//

import MMDrawerController

class DetailBaseViewController: UIViewController {
    
    var mainNavi: UINavigationController?

    class func initWithNavi() -> Self {
        let instance = self.init()
        let navi: UINavigationController = UINavigationController(rootViewController: instance)
        instance.mainNavi = navi
        return instance
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
//        println("\(self.dynamicType) \(__FUNCTION__))")
        //  主页面不出现时，如新push出了一个vc时，mm_drawerController的打开侧边手势要关闭。知道回主页面。
        self.mm_drawerController?.openDrawerGestureModeMask = MMOpenDrawerGestureMode()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        println("\(self.dynamicType) \(__FUNCTION__))")
        self.mm_drawerController?.openDrawerGestureModeMask = MMOpenDrawerGestureMode.all
    }
}
