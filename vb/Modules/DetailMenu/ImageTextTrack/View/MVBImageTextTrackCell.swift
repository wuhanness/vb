//
//  MVBImageTextTrackCell.swift
//  vb
//
//  Created by 马权 on 9/25/15.
//  Copyright © 2015 maquan. All rights reserved.
//

import SDWebImage

protocol MVBImageTextTrackCellDelegate: NSObjectProtocol {
    func imageTextTrackCellDidLongPress(imageTextTrackCell: MVBImageTextTrackCell, gesture: UIGestureRecognizer) -> Void
}

class MVBImageTextTrackCell: UICollectionViewCell {
    
    weak var delegate: MVBImageTextTrackCellDelegate?
    weak var imageTextTrack: MVBImageTextTrackModel?
    var longPressGesture: UILongPressGestureRecognizer!
    @IBOutlet weak var longImageIcon: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            imageView.layer.cornerRadius = 2
            imageView.layer.borderWidth = 0
            imageView.clipsToBounds = true
            imageView.backgroundColor = RGBA(red: 235.0, green: 235.0, blue: 235.0, alpha: 1)
        }
    }
    
    @IBOutlet weak var progressView: UIProgressView! {
        didSet {
            progressView.layer.cornerRadius = 3
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        longPressGesture = UILongPressGestureRecognizer(target: self, action: "longpressAction:")
        addGestureRecognizer(longPressGesture)
    }
    
    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes) {
        super.applyLayoutAttributes(layoutAttributes)
        let attributes = layoutAttributes as! MVBImageTextTrackLayoutAttributes
        longImageIcon.hidden = !attributes.longImage
    }
    
    @objc private func longpressAction(sender: AnyObject) {
        delegate?.imageTextTrackCellDidLongPress(self, gesture: sender as! UIGestureRecognizer)
    }
    
    deinit {
        print("\(self.dynamicType) deinit\n", terminator: "")
    }
    
}

//  MARK: Public
extension MVBImageTextTrackCell {
    
    func configureCell(imageTextTrack: MVBImageTextTrackModel!) -> Void {
        
        self.imageTextTrack = imageTextTrack
        
        let captureUrlStr = self.imageTextTrack?.largeImageFileUrl
        
        imageView.sd_setImageWithURL(NSURL(string: imageTextTrack.thumbImageFileUrl)!, placeholderImage: nil, options: .RetryFailed, progress: { [weak self] (receivedSize, expectedSize) -> Void in
            
            guard let strongSelf = self else { return }
            guard captureUrlStr == strongSelf.imageTextTrack?.thumbImageFileUrl else { return }
            
            print("当前图片Text:\(imageTextTrack.text),进度:\(Float(receivedSize) / Float(expectedSize))")
            
            strongSelf.progressView.hidden = false
            strongSelf.progressView.progress = Float(receivedSize) / Float(expectedSize)
            
        }) { [weak self] (image, error, cacheType, url) -> Void in
            
            guard let strongSelf = self else { return }
            guard url.absoluteString == strongSelf.imageTextTrack?.thumbImageFileUrl else { return }  //  回调验证
            guard error == nil else { return }
            
            strongSelf.progressView.hidden = true
        }
        
        textLabel.text = imageTextTrack.text
    }
    
}

