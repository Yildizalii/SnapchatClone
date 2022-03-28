//
//  SnapVC.swift
//  SnapchatClone
//
//  Created by Ali on 23.03.2022.
//

import UIKit
import ImageSlideshow
class SnapVC: UIViewController {

  var selectedSnap: Snap?
  var inputArray = [SDWebImageSource]()
    @IBOutlet weak var timeLabel: UILabel!

  override func viewDidLoad() {
      super.viewDidLoad()

      if let snap = selectedSnap {
        timeLabel.text = "Time Left : \(snap.timeDifference)"
        for imageUrl in snap.imageUrlArray {
          inputArray.append(SDWebImageSource(urlString: imageUrl)!)
        }
        let imageSlideShow = ImageSlideshow(frame: CGRect(x: 10, y: 10, width: self.view.frame.width * 0.95, height: self.view.frame.height * 0.90))
        imageSlideShow.backgroundColor = UIColor.white
        let pageIndicator = UIPageControl()
        pageIndicator.currentPageIndicatorTintColor = UIColor.lightGray
        pageIndicator.pageIndicatorTintColor = UIColor.black
        imageSlideShow.pageIndicator = pageIndicator
        imageSlideShow.contentScaleMode = UIViewContentMode.scaleAspectFit
        imageSlideShow.setImageInputs(inputArray)
        self.view.addSubview(imageSlideShow)
        self.view.bringSubviewToFront(timeLabel)
      }
    }
}
