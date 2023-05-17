//
//  FullScreenImageViewController.swift
//  SecureStore
//
//  Created by macSlm on 29.04.2023.
//

import UIKit

class FullScreenImageViewController: UIViewController {
    
    var image: UIImage?
    
    var scaledView = UIView()
    var imageView = UIImageView()
    var backButton = UIButton()
    
    let panGestureRecognizer = UIPanGestureRecognizer()
    let pinchGestureRecognizer = UIPinchGestureRecognizer()
    let doubleTapGestureRecognizer = UITapGestureRecognizer()
    
    var pinchGestureAnchorScale: CGFloat?
    var scale: CGFloat = 1.0 { didSet { updateImageTransform() } }
    
    private var centerYConstraint: NSLayoutConstraint!
    private var centerXConstraint: NSLayoutConstraint!
    private var panGestureAnchorPoint: CGPoint?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        backButton.layer.cornerRadius = backButton.bounds.height/2
        backButton.layer.borderWidth = 1
        backButton.layer.borderColor = ColorList.textColor.cgColor
    }
    
    
    @objc private func dissmissUI() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK:  - GESTURE Recogniser
    
    @objc func handlePinchGesture(gestureRecognizer: UIPinchGestureRecognizer) {
        guard pinchGestureRecognizer === gestureRecognizer else { assert(false); return }
        
        print("test")
        
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
            positionOfImage()
            
        case .failed, .possible:
            assert(pinchGestureAnchorScale == nil)
            break
        @unknown default:
            print("break")
            return
        }
    }
    
    @objc func handlePanGesture(gestureRecognizer: UIPanGestureRecognizer) {
        guard panGestureRecognizer === gestureRecognizer else { assert(false); return }
        
        switch gestureRecognizer.state {
        case .began:
            assert(panGestureAnchorPoint == nil)
            panGestureAnchorPoint = gestureRecognizer.location(in: view) // (2)
        case .changed:
            guard let panGestureAnchorPoint = panGestureAnchorPoint else { assert(false); return }
            
            let gesturePoint = gestureRecognizer.location(in: view)
            
            // (3)
            centerXConstraint.constant += gesturePoint.x - panGestureAnchorPoint.x
            centerYConstraint.constant += gesturePoint.y - panGestureAnchorPoint.y
            
            self.panGestureAnchorPoint = gesturePoint
            
        case .cancelled, .ended:
            panGestureAnchorPoint = nil
            
            //DISSMISS BY SWIPE
            if scaledView.frame.maxY < view.bounds.midY {
                dissmissUI()
                return
            }
            
            positionOfImage()
            
            
        case .failed, .possible:
            assert(panGestureAnchorPoint == nil)
            break
        @unknown default:
            return
        }
    }
    
    @objc func handleDoubleTapGesture(gestureRecognizer: UITapGestureRecognizer) {
        centerXConstraint.constant = 0.0
        centerYConstraint.constant = 0.0

        UIView.animate(
            withDuration: 0.3,
            delay: 0.0,
            options: [.curveEaseInOut],
            animations: {
                self.scale = 1.0
                self.view.layoutIfNeeded()
            },
            completion: nil
        )
    }

    
    // Correcting image after recognizer
    
    private func positionOfImage() {
        //Return to broder view
        
        //Scalling
        if scaledView.frame.width < view.bounds.width {
            scale = 1
        }
        
        //IF IMAGE LESS THAN VIEW - move to center
        if scaledView.frame.height <= view.bounds.height {
            centerYConstraint.constant = 0
        }
        if scaledView.frame.width <= view.bounds.width {
            centerXConstraint.constant = 0
        }
        
        //IF IMAGE MORE THAN VIEW - move border to superviews border
        
        //Y
        if scaledView.frame.height > view.bounds.height {
            if scaledView.frame.minY > view.bounds.minY {
                centerYConstraint.constant -= scaledView.frame.minY - view.bounds.minY
            }
            if scaledView.frame.maxY < view.bounds.maxY {
                centerYConstraint.constant += view.bounds.maxY - scaledView.frame.maxY
            }
        }
        
        //X
        if scaledView.frame.width > view.bounds.width {
            if scaledView.frame.minX > view.bounds.minX {
                centerXConstraint.constant -= scaledView.frame.minX - view.bounds.minX
            }
            if scaledView.frame.maxX < view.bounds.maxX {
                centerXConstraint.constant += view.bounds.maxX - scaledView.frame.maxX
            }
        }
        
    }
    
    private func updateImageTransform() {
        scaledView.transform = CGAffineTransform.identity.scaledBy(x: scale, y: scale)
    }
    
}

// MARK:  - SETUP UI

extension FullScreenImageViewController {
        
     private func setupUI(){
        view.backgroundColor = ColorList.mainBlue
        setupImageView()
        setupBackButton()
    }
    
     private func setupImageView(){
        view.addSubview(scaledView)
        scaledView.addSubview(imageView)
        scaledView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.contentMode = .scaleAspectFit

        var anchors: [NSLayoutConstraint] = []
        anchors.append(scaledView.centerYAnchor.constraint(equalTo: view.centerYAnchor))
        anchors.append(scaledView.centerXAnchor.constraint(equalTo: view.centerXAnchor))
        anchors.append(scaledView.heightAnchor.constraint(equalTo: view.widthAnchor))
        anchors.append(scaledView.widthAnchor.constraint(equalTo: imageView.heightAnchor))
        
        anchors.append(imageView.centerYAnchor.constraint(equalTo: scaledView.centerYAnchor))
        anchors.append(imageView.centerXAnchor.constraint(equalTo: scaledView.centerXAnchor))
        anchors.append(imageView.heightAnchor.constraint(equalTo: scaledView.heightAnchor))
        anchors.append(imageView.widthAnchor.constraint(equalTo: scaledView.widthAnchor))
        NSLayoutConstraint.activate(anchors)
        
        
        if image == nil {
            image = #imageLiteral(resourceName: "iconSlonik")
        }
        imageView.image = image
        
        //Recognaizer
        
        centerYConstraint = anchors[0] //Y center constraint
        centerXConstraint = anchors[1] //X center constraint
        
        panGestureRecognizer.addTarget(self, action: #selector(handlePanGesture))
        panGestureRecognizer.maximumNumberOfTouches = 1
        scaledView.addGestureRecognizer(panGestureRecognizer)
        
        pinchGestureRecognizer.addTarget(self, action: #selector(handlePinchGesture))
        scaledView.addGestureRecognizer(pinchGestureRecognizer)
        
        doubleTapGestureRecognizer.addTarget(self, action: #selector(handleDoubleTapGesture))
        scaledView.addGestureRecognizer(doubleTapGestureRecognizer)
    }
    

    
    
    
    private func setupBackButton() {
        
        view.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        
        var anchors: [NSLayoutConstraint] = []
        anchors.append(backButton.centerXAnchor.constraint(equalTo: view.centerXAnchor))
        anchors.append(backButton.centerYAnchor.constraint(equalTo: view.bottomAnchor, constant: -view.bounds.height/8))
        anchors.append(backButton.widthAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.15))
        
        NSLayoutConstraint.activate(anchors)
        
        backButton.setTitle("Back", for: .normal)
        backButton.setTitleColor(ColorList.textColor, for: .normal)
        backButton.backgroundColor = UIColor(displayP3Red: 50, green: 50, blue: 50, alpha: 0.1)
        
        backButton.layer.borderWidth = 1
        
        
        backButton.addTarget(self, action: #selector(dissmissUI), for: .touchUpInside)
        
    }
    
}
