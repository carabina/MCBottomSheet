//
//  BottomSheetViewController.swift
//  BottomSheetProject
//
//  Created by Marco Capano on 15/06/2018.
//  Copyright © 2018 Marco Capano. All rights reserved.
//
import UIKit

public class BottomSheetViewController: UIViewController, UIGestureRecognizerDelegate {
    
    //MARK: - Dichiarazione variabili
    var visualEffect: UIVisualEffectView?
    var bluredView: UIVisualEffectView?
    var grabber = UIImageView()
    var animator: UIDynamicAnimator!
    
    lazy var bottomPosition: CGFloat = 0.0
    lazy var topPosition: CGFloat = 0.0
    
    public weak var contentViewController: UIViewController!
    public weak var delegate: BottomSheetDelegate?
    
    init(_ contentViewController: UIViewController) {
        self.contentViewController = contentViewController
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("BottomSheetViewController should only be instantiated in code, not by storyboard")
    }
    
    //MARK: - Override metodi controller
    override public func viewDidLoad() {
        super.viewDidLoad()
    
        view.backgroundColor = .white
        view.layer.cornerRadius = 18
        
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(panGesture))
        view.addGestureRecognizer(gesture)
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        guard let parent = parent else { return }
        let statusBar = UIApplication.shared.statusBarFrame
        bottomPosition = parent.view.frame.height - 70
        topPosition = parent.view.frame.minY + statusBar.height
        
        prepareBackgroundView()
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let strongSelf = self else { return }
            let frame = strongSelf.view.frame
            strongSelf.view.frame = CGRect(x: 0, y: (strongSelf.parent!.view.frame.height - 70), width: frame.width, height: frame.height)
        }
    }
    
    //MARK: - Funzioni
    
    @objc func panGesture(recognizer: UIPanGestureRecognizer) {
        
        guard recognizer.state != .began else { return }
        
        if recognizer.state == .changed {
            let translation = recognizer.translation(in: view)
            var velocity = recognizer.velocity(in: view)
            velocity.x = 0
            
            view.frame = CGRect(x: 0, y: view.frame.minY + translation.y ,width: view.frame.width, height: view.frame.height)
            recognizer.setTranslation(CGPoint(x: 0, y: 0), in: view)
        } else {
            var snapPosition: CGFloat
            var duration = 0.3
            
            defer {
                UIView.animate(withDuration: duration, delay: 0.0, options: .curveEaseOut, animations: {
                    self.view.frame = CGRect(x: 0, y: snapPosition, width: self.view.frame.width, height: self.view.frame.width)
                }, completion: { _ in
                    snapPosition == self.bottomPosition ? self.delegate?.sheetDidReachBottom() : self.delegate?.sheetDidReachTop()
                })
            }
            
            //Fast snap
            let velocity = recognizer.velocity(in: view)
            if velocity.y > 1000 {
                snapPosition = bottomPosition
                duration = 0.2
                return
            } else if velocity.y < -1000 {
                snapPosition = topPosition
                duration = 0.2
                return
            }
            
            //Snap
            guard let parent = parent else {
                preconditionFailure("BottomSheetViewController should have a parent view controller.")
            }
            
            let location = view!.convert(view.bounds, to: parent.view)
            let distanceFromBottom = abs(location.minY - bottomPosition)
            let distanceFromTop = abs(location.minY - topPosition)
            recognizer.setTranslation(CGPoint.zero, in: view)
            
            snapPosition = min(distanceFromBottom, distanceFromTop) == distanceFromBottom ? bottomPosition : topPosition
        }

    }
    
    func prepareBackgroundView(){
        let blurEffect = UIBlurEffect.init(style: .light)
        visualEffect = UIVisualEffectView.init(effect: blurEffect)
        bluredView = UIVisualEffectView.init(effect: blurEffect)
        bluredView?.contentView.addSubview(visualEffect!)
        visualEffect?.clipsToBounds = true
        bluredView?.clipsToBounds = true
        visualEffect?.layer.cornerRadius = 18
        bluredView?.layer.cornerRadius = 18
        visualEffect?.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        bluredView?.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        
        view.insertSubview(bluredView!, at: 0)
        
        grabber = UIImageView(image: #imageLiteral(resourceName: "grabberPiatto"))
        view.addSubview(grabber)
        grabber.translatesAutoresizingMaskIntoConstraints = false
        grabber.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10).isActive = true
        grabber.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        visualEffect?.contentView.addSubview(contentViewController.view)
    }
    
}
