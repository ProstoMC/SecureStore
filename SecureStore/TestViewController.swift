//
//  TestViewController.swift
//  SecureStore
//
//  Created by macSlm on 09.03.2023.
//

import UIKit

class TestViewController: UIViewController {
    
    var boxView = UIView()
    
    let pinchGestureRecognizer = UIPinchGestureRecognizer()
    var pinchGestureAnchorScale: CGFloat?
    var scale: CGFloat = 1.0 { didSet { updateBoxTransform() } }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)
    
        view.addSubview(boxView)
        boxView.backgroundColor = .darkGray
        boxView.layer.cornerRadius = 10
        boxView.translatesAutoresizingMaskIntoConstraints = false
        var anchors: [NSLayoutConstraint] = []
        
        anchors.append(boxView.centerYAnchor.constraint(equalTo: view.centerYAnchor))
        anchors.append(boxView.centerXAnchor.constraint(equalTo: view.centerXAnchor))
        anchors.append(boxView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5))
        anchors.append(boxView.widthAnchor.constraint(equalTo: boxView.heightAnchor))
        NSLayoutConstraint.activate(anchors)
        
        pinchGestureRecognizer.addTarget(self, action: #selector(handlePinchGesture))
        boxView.addGestureRecognizer(pinchGestureRecognizer)
    }
    
    
    private func updateBoxTransform() {
        boxView.transform = CGAffineTransform.identity.scaledBy(x: scale, y: scale)
    }
    
    
    @objc func handlePinchGesture(gestureRecognizer: UIPinchGestureRecognizer) {
        guard pinchGestureRecognizer === gestureRecognizer else { assert(false); return }
        
        //print("test")
        
        switch gestureRecognizer.state {
        case .began:
            assert(pinchGestureAnchorScale == nil)
            pinchGestureAnchorScale = gestureRecognizer.scale

        case .changed:
            guard let pinchGestureAnchorScale = pinchGestureAnchorScale else { assert(false); return }

            let gestureScale = gestureRecognizer.scale
            scale += gestureScale - pinchGestureAnchorScale
            self.pinchGestureAnchorScale = gestureScale
            
            print("test")

        case .cancelled, .ended:
            pinchGestureAnchorScale = nil

        case .failed, .possible:
            assert(pinchGestureAnchorScale == nil)
            break
        @unknown default:
            print("break")
            return
        }
    }
    
    
    


}
