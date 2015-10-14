//
//  MVBNoteTrackModel.swift
//  vb
//
//  Created by 马权 on 6/28/15.
//  Copyright (c) 2015 maquan. All rights reserved.
//

class MVBNoteTrackModel: AVObject {
    
    @NSManaged var title: String!
    @NSManaged var detailContent: String!
    
    convenience init(title: String?, detailContent: String?) {
        self.init()
        update(title: title, detailContent: detailContent)
    }
    
    func update(title title: String?, detailContent: String?) {
        self.title = title
        self.detailContent = detailContent
    }
}

extension MVBNoteTrackModel: AVSubclassing {
    static func parseClassName() -> String! {
        return "MVBNoteTrackModel"
    }
}