//
//  PhotoPreviewController+Gestures.swift
//  VisionDemo
//
//  Created by VMT on 2018/11/3.
//  Copyright © 2018 vmt. All rights reserved.
//

import UIKit

extension PhotoPreviewerController {
    func setupGestureRecognizers() {
        let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(onPinch(_:)))
        self.view.addGestureRecognizer(pinchGestureRecognizer)
        let rotationGestureRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(onRotation(_:)))
        self.view.addGestureRecognizer(rotationGestureRecognizer)
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(onPan(_:)))
        self.view.addGestureRecognizer(panGestureRecognizer)
    }
    
    @objc func onPinch(_ recognizer: UIPinchGestureRecognizer) {
        self.backgroundImageView.transform = self.backgroundImageView.transform.scaledBy(x: recognizer.scale, y: recognizer.scale)
        recognizer.scale = 1
        self.imageView.transform = self.backgroundImageView.transform
    }
    
    @objc func onRotation(_ recognizer: UIRotationGestureRecognizer) {
        self.backgroundImageView.transform = self.backgroundImageView.transform.rotated(by: recognizer.rotation)
        recognizer.rotation = 0
        self.imageView.transform = self.backgroundImageView.transform
    }
    
    @objc func onPan(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self.view)
        self.backgroundImageView.transform = self.backgroundImageView.transform.translatedBy(x: translation.x, y: translation.y)
        recognizer.setTranslation(CGPoint.zero, in: self.view)
        self.imageView.transform = self.backgroundImageView.transform
    }
    
}
