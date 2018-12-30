//
//  UIView+UIImage.swift
//  VisionDemo
//
//  Created by VMT on 2018/10/22.
//  Copyright © 2018 vmt. All rights reserved.
//

import UIKit
extension UIView {
    func captureImage() -> UIImage {
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(size: self.frame.size)
            return renderer.image { ctx in
                self.drawHierarchy(in: self.frame, afterScreenUpdates: true)
            }
        }
        
        UIGraphicsBeginImageContextWithOptions(self.frame.size, false, 0.0)
        UIGraphicsGetCurrentContext()
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image ?? UIImage();
    }
    
    func maskedImage() -> UIImage? {
        guard let view = self.maskedSnapshotView() else {
            return nil
        }
        return view.captureImage()
    }
    
    func maskedSnapshotView() -> UIView? {
        guard let mask = self.mask, let view = self.resizableSnapshotView(from: mask.frame, afterScreenUpdates: true, withCapInsets: .zero) else {
            print("can't mask the view")
            return nil
        }
        print("masked snappshot:", self, mask.frame)
        return view
    }
}
