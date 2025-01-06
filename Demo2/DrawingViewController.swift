import UIKit

class DrawingViewController: UIViewController {
    private lazy var canvasView: CanvasView = {
        let canvasView = CanvasView()
        canvasView.toggle()
        return canvasView
    }()
    private lazy var contentV: DrawingView = {
        let v = DrawingView()
        v.backgroundColor = .white
        v.isUserInteractionEnabled = false
        return v
    }()
    private lazy var change: UIButton = {
        let v = UIButton()
        v.backgroundColor = .blue
        v.setTitle("切换", for: .normal)
        v.addTarget(self, action: #selector(changeClick), for: .touchUpInside)
        return v
    }()
    @objc
    private func changeClick() {
        if contentV.isUserInteractionEnabled == false {
            canvasView.isUserInteractionEnabled = false
            contentV.isUserInteractionEnabled = true
        }else{
            canvasView.isUserInteractionEnabled = true
            contentV.isUserInteractionEnabled = false
        }
    }
    private lazy var back: UIButton = {
        let v = UIButton()
        v.backgroundColor = .blue
        v.setTitle("undo", for: .normal)
        v.addTarget(self, action: #selector(backClick), for: .touchUpInside)
        return v
    }()
    @objc
    private func backClick() {
        if contentV.isUserInteractionEnabled == false {
            canvasView.undo()
        }else{
            contentV.undo()
        }
    }
    private lazy var redo: UIButton = {
        let v = UIButton()
        v.backgroundColor = .blue
        v.setTitle("redo", for: .normal)
        v.addTarget(self, action: #selector(redoClick), for: .touchUpInside)
        return v
    }()
    @objc
    private func redoClick() {
        if contentV.isUserInteractionEnabled == false {
            canvasView.redo()
        }else{
            contentV.redo()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 创建矩形视图
        self.view.addSubview(contentV)
        self.view.addSubview(canvasView)
        self.view.addSubview(change)
        self.view.addSubview(back)
        self.view.addSubview(redo)
        change.snp.makeConstraints { make in
            make.left.equalTo(25)
            make.top.equalTo(100)
        }
        back.snp.makeConstraints { make in
            make.left.equalTo(25 + 100)
            make.top.equalTo(100)
        }
        redo.snp.makeConstraints { make in
            make.left.equalTo(25 + 100 + 50)
            make.top.equalTo(100)
        }
        canvasView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        contentV.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}

class DrawingView: UIView {
    private var startPoint: CGPoint = .zero
    private var rectangleView: UIView?

    private var undoStack: [UIView] = [] // 存储绘制的矩形
    private var redoStack: [UIView] = [] // 存储被撤销的矩形

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGesture()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupGesture()
    }

    private func setupGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        self.addGestureRecognizer(panGesture)
    }

    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        let currentPoint = gesture.location(in: self)

        switch gesture.state {
        case .began:
            // 手势开始，记录起点并创建矩形
            startPoint = currentPoint
            rectangleView = UIView()
            rectangleView?.backgroundColor = UIColor.red.withAlphaComponent(0.3)
            rectangleView?.layer.borderColor = UIColor.red.cgColor
            rectangleView?.layer.borderWidth = 1.0
            if let rectView = rectangleView {
                self.addSubview(rectView)
            }
        case .changed:
            // 手势变化，更新矩形的 frame
            guard let rectView = rectangleView else { return }
            let width = currentPoint.x - startPoint.x
            let height = currentPoint.y - startPoint.y
            rectView.frame = CGRect(
                x: min(startPoint.x, currentPoint.x),
                y: min(startPoint.y, currentPoint.y),
                width: abs(width),
                height: abs(height)
            )
        case .ended, .cancelled:
            // 手势结束，将矩形保存到 undoStack
            guard let rectView = rectangleView else { return }
            undoStack.append(rectView)
            rectangleView = nil
            redoStack.removeAll() // 新操作后清空 redoStack
        default:
            break
        }
    }

    // 撤销操作
    func undo() {
        guard let lastRectangle = undoStack.popLast() else { return }
        redoStack.append(lastRectangle)
        lastRectangle.removeFromSuperview()
    }

    // 重做操作
    func redo() {
        guard let lastRectangle = redoStack.popLast() else { return }
        undoStack.append(lastRectangle)
        self.addSubview(lastRectangle)
    }
}
