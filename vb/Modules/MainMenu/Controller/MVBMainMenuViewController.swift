//
//  MVBMainMenuViewController.swift
//  vb
//
//  Created by 马权 on 6/21/15.
//  Copyright (c) 2015 maquan. All rights reserved.
//

enum MVBMainMenuViewControllerOperate: Int {
    case Main
    case PasswordManage
    case ImageTextTrack
    case HeroesManage
    case AccountManage
    case LogOut
}

protocol MVBMainMenuViewControllerDelegate: NSObjectProtocol {
    func mainMenuViewController(mainMenuViewController: MVBMainMenuViewController, operate: MVBMainMenuViewControllerOperate) -> Void
}

class MVBMainMenuViewController: UIViewController {
    
    weak var delegate: MVBMainMenuViewControllerDelegate?
    weak var mainMenuView: MVBMainMenuView? {
        return self.view as? MVBMainMenuView
    }
    
    override func loadView() {
        NSBundle.mainBundle().loadNibNamed("MVBMainMenuView", owner: self, options: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configurUserInfo()
    }
    
    func configurUserInfo() {
        if let userModel = MVBAppDelegate.MVBApp().userModel as MVBUserModel? {
            mainMenuView!.headBackgroundImageView.sd_setImageWithURL(NSURL(string: userModel.cover_image_phone as String!))
            mainMenuView!.headImageView.sd_setImageWithURL(NSURL(string: userModel.avatar_large as String!))
            mainMenuView!.nameLabel.text = userModel.name as? String
            mainMenuView!.describeLbel.text = userModel._description as? String
        }
        else {
            let delegate = MVBAppDelegate.MVBApp()
            delegate.getUserInfo(self, tag: "getUserInfo")  //  
        }
    }
    
    deinit {
        print("\(self.dynamicType) deinit", terminator: "")
    }
}

// MARK: buttonAction
extension MVBMainMenuViewController {
    
    @IBAction func logOutAction(sender: AnyObject) {
//        UIAlertView.bk_showAlertViewWithTitle("", message: "确定退出", cancelButtonTitle: "取消", otherButtonTitles: ["确定"]) { (alertView, index) -> Void in
//            if index == 1 {
                let appDelegate = MVBAppDelegate.MVBApp()
                WeiboSDK.logOutWithToken(appDelegate.accessToken!, delegate: self, withTag: "logOut")
                SVProgressHUD.showWithStatus("正在退出...")
                SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.Black)
//            }
//        }
    }
    
    @IBAction func clearDiskMemory(sender: AnyObject) {
        //  清理硬盘缓存
        SDImageCache.sharedImageCache().clearDisk()
        SDImageCache.sharedImageCache().clearMemory()
        SDImageCache.sharedImageCache().cleanDisk()
    }
    
    @IBAction func backMainAction(sender: AnyObject) {
        delegate!.mainMenuViewController(self, operate: MVBMainMenuViewControllerOperate.Main)
    }
    
    @IBAction func passwordManageAction(sender: AnyObject) {
        delegate!.mainMenuViewController(self, operate: MVBMainMenuViewControllerOperate.PasswordManage)
    }

    @IBAction func imageTextTrackAction(sender: AnyObject) {
        delegate!.mainMenuViewController(self, operate: MVBMainMenuViewControllerOperate.ImageTextTrack)
    }
    
    @IBAction func heroesManageAction(sender: AnyObject) {
        delegate!.mainMenuViewController(self, operate: MVBMainMenuViewControllerOperate.HeroesManage)
    }
    
    @IBAction func accountManageAction(sender: AnyObject) {
        delegate!.mainMenuViewController(self, operate: MVBMainMenuViewControllerOperate.AccountManage)
    }
    
    //  动画开关控制
    @IBAction func specialEffectsAction(sender: AnyObject) {
        if let switchBtn = sender as? UISwitch {
            if switchBtn.on {
                self.mm_drawerController.setDrawerVisualStateBlock { (drawerVc, drawerSide, percentVisible) -> Void in
                    let block: MMDrawerControllerDrawerVisualStateBlock = MMDrawerVisualState.MVBCustomDrawerVisualState()
                    block(drawerVc, drawerSide, percentVisible)
                }
            }
            else {
                self.mm_drawerController.setDrawerVisualStateBlock(nil)
            }
        }
    }
}

// MARK: UIScrollViewDelegate
extension MVBMainMenuViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            if scrollView.contentOffset.y < -80 {
                scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x, y: -80)
            }
            mainMenuView!.headBackgroundImageView.transform = CGAffineTransformMakeTranslation(0, -scrollView.contentOffset.y / 2)
        }
        else {
            mainMenuView!.headBackgroundImageView.transform = CGAffineTransformMakeTranslation(0, 0)
        }
    }
}

// MARK: WBHttpRequestDelegate
extension MVBMainMenuViewController: WBHttpRequestDelegate {
    
    func request(request: WBHttpRequest!, didFinishLoadingWithResult result: String!) {
        if request.tag == "logOut" {
            MVBAppDelegate.MVBApp().clearUserInfo()
            SVProgressHUD.dismiss()
            //  清理硬盘缓存
            SDImageCache.sharedImageCache().clearDisk()
            SDImageCache.sharedImageCache().clearMemory()
            
            self.mm_drawerController!.dismissViewControllerAnimated(false) {
                self.delegate!.mainMenuViewController(self, operate: MVBMainMenuViewControllerOperate.LogOut)
            }
        }
        if request.tag == "getUserInfo" {
            MVBAppDelegate.MVBApp().setUserInfoWithJsonString(result!)
            configurUserInfo()
        }
    }
    
}