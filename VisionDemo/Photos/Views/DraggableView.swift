//
//  ImageClipMask.swift
//  VisionDemo
//
//  Created by VMT on 2018/11/3.
//  Copyright © 2018 vmt. All rights reserved.
//

import UIKit

protocol DraggableViewDelegate: AnyObject {
    func draggalbeView(_ draggableView: DraggableView, shouldDragTo point: CGPoint) -> Bool
    func draggableViewIsDragging(_ draggableView: DraggableView)
}

class DraggableView: UIView {
    
    private var currentCenter = CGPoint.zero
    weak var delegate: DraggableViewDelegate?
    var xDraggable = true
    var yDraggable = true
    let anchor: UIView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(onPan(_:)))
        self.addGestureRecognizer(panGestureRecognizer)
        
        anchor.backgroundColor = UIColor.black
        anchor.layer.cornerRadius = 4
        anchor.layer.borderColor = UIColor.white.cgColor
        anchor.layer.borderWidth = 2
        anchor.alpha = 0.5
        self.addSubview(anchor)
        anchor.translatesAutoresizingMaskIntoConstraints = false
        anchor.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        anchor.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        anchor.widthAnchor.constraint(equalToConstant: 8).isActive = true
        anchor.heightAnchor.constraint(equalToConstant: 8).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func onPan(_ gestureRecognizer: UIPanGestureRecognizer) {
        guard let delegate = self.delegate else {
            return
        }
        let transition = gestureRecognizer.translation(in: self)
        let x = currentCenter.x + transition.x
        let y = currentCenter.y + transition.y
        guard delegate.draggalbeView(self, shouldDragTo: CGPoint(x: x, y: y)) else {
            return
        }
        self.center = CGPoint(x: self.xDraggable ? x : currentCenter.x, y: self.yDraggable ? y : currentCenter.y)
        
        delegate.draggableViewIsDragging(self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        currentCenter = self.center
    }
}
