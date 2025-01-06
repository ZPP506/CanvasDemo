//
//  CanvasView.swift
//  Demo2
//
//  Created by 张朋朋 on 1/6/25.
//

import UIKit
import PencilKit
import CommonBasicModule

class CanvasView: UIView {
    private lazy var canvasView: PKCanvasView = {
        let canvasView = PKCanvasView(frame: .zero)
        canvasView.allowsFingerDrawing = false
        canvasView.translatesAutoresizingMaskIntoConstraints = false
        canvasView.backgroundColor = UIColor.clear
        canvasView.tool = PKInkingTool(.pen, color: UIColor.color(0xE60000), width: 2)
        return canvasView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(canvasView)
        canvasView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func undo() {
        self.undoManager?.undo()
    }
    
    func redo() {
        self.undoManager?.redo()
    }
    
    func toggle() {
        canvasView.allowsFingerDrawing.toggle()
    }
}

