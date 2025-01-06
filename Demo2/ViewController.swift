//
//  ViewController.swift
//  Demo2
//
//  Created by 张朋朋 on 1/6/25.
//

import UIKit
import PencilKit
import CommonBasicModule

class ViewController: UIViewController {
    private lazy var canvasView: CanvasView = {
        let canvasView = CanvasView()
        return canvasView
    }()
    @IBOutlet weak var contentView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        contentView.addSubview(canvasView)
        canvasView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        canvasView.toggle()
    }
    
    @IBAction func redo(_ sender: Any) {
//        self.canvasView.redo()
        
        let vc = DrawingViewController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    @IBAction func undo(_ sender: Any) {
        self.canvasView.undo()
    }
 
}

