//
//  ImageTrackDisplayCell.swift
//  vb
//
//  Created by 马权 on 10/8/15.
//  Copyright © 2015 maquan. All rights reserved.
//

import Kingfisher

protocol ImageTrackDisplayCellDataSource: class {
    var originImageURL: String { get }
    var thumbImageURL: String { get }
    var imageSize: CGSize { get }
}

class ImageTrackDisplayCell: MQPictureBrowserCell {
    
    weak var imageTrack: ImageTrackDisplayCellDataSource?
    
    @IBOutlet weak var progressView: UIProgressView! {
        didSet {
            progressView.tintColor = UIColor.grayColor()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func baseConfigure() {
        super.baseConfigure()
        scrollView.layer.cornerRadius = 5
        scrollView.clipsToBounds = true
        progressView.hidden = true
        bringSubviewToFront(progressView)
    }
    
    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes) {
        super.applyLayoutAttributes(layoutAttributes)
        progressView.frame = CGRect(x: 20, y: layoutAttributes.frame.height / 2, width: layoutAttributes.frame.width - 40, height: 20)
    }
    
    func configurePictureCell(imageTrack: ImageTrackDisplayCellDataSource!) {
        self.imageTrack = imageTrack
        
        let thumbImage: UIImage? = ImageCache.defaultCache.retrieveImageInDiskCacheForKey(imageTrack.thumbImageURL)
        
        //  这个urlStr 是专门让closure捕获的对比值。
        //  因为同一个imageView可以有很多个获取图片请求，那么请求回调时就要进行对比校验，只有校验正确才能设置进度
        if let url = NSURL(string: imageTrack.originImageURL) {
            imageView.mkf_setImageWithURL(url,
                                          identifier: reuseIdentifier,
                                          placeholderImage: thumbImage,
                                          optionsInfo: nil,
                                          progressBlock:
                { [weak self] (receivedSize, totalSize) in
                    
                    guard let strongSelf = self else { return }
                    guard url.absoluteString == strongSelf.imageTrack?.originImageURL else { return }
                    
                    strongSelf.progressView.hidden = false
                    strongSelf.progressView.progress = Float(receivedSize) / Float(totalSize)
                    
                }, completionHandler: { [weak self] (image, error, cacheType, imageURL) in
                    
                    guard let strongSelf = self else { return }
                    guard imageURL?.absoluteString == strongSelf.imageTrack?.originImageURL else { return }  //  回调验证
                    guard error == nil else { return }
                    
                    strongSelf.progressView.hidden = true
                })
        }
        
        self.imageSize = imageTrack.imageSize
        defaultConfigure()
    }
    
    deinit {
        print("\(self.dynamicType) deinit\n", terminator: "")
    }
    
}
