//
//  MVBUserView.swift
//  vb
//
//  Created by 马权 on 5/19/15.
//  Copyright (c) 2015 maquan. All rights reserved.
//

import UIKit

class MVBUserView: UIView {
    
    @IBOutlet var userImageView: UIImageView!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func awakeFromNib() {
        self.userImageView.clipsToBounds = true
        self.userImageView.layer.cornerRadius = self.userImageView.frame.size.height / 2
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
