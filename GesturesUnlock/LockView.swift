//
//  LockView.swift
//  GesturesUnlock
//
//  Created by 马磊 on 2016/11/2.
//  Copyright © 2016年 MLCode.com. All rights reserved.
//

import UIKit

protocol LockViewDelegate: NSObjectProtocol {
    
    func lockViewDidFinishSelect(_ lockView: LockView, password: String)
    
}


class LockView: UIView {
    
    weak var delegate: LockViewDelegate?
    
    var lineColor: UIColor = UIColor(red: 85/255.0, green: 174/255.0, blue: 242/255.0, alpha: 1.0)
    var lineWidth: CGFloat = 2
    var lineJoinStyle: CGLineJoin = .round
    var itemSelectColor: UIColor = UIColor(red: 85/255.0, green: 174/255.0, blue: 242/255.0, alpha: 1.0)
    
    /* 选中按钮组 */
    private var selectButtons: [UIButton] = []
    private var movePoint: CGPoint = CGPoint()
    private var password: String = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        addSubButtons()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /* 遍历添加9个按钮 */
    private func addSubButtons() {
        
        for i in 0..<9 {
            let button: UIButton = UIButton(type: .custom)
            button.setImage(UIImage(named:"gesture_node_normal"), for: .normal)
            button.setImage(UIImage(named:"gesture_node_highlighted"), for: .selected)
            button.tag = i
            // 关闭交互
            button.isUserInteractionEnabled = false
            
            self.addSubview(button)
        }
    }
    
    func movedAddButton(_ touches: Set<UITouch> ) {
        /* 获取触摸点 */
        func point(_ touchs: Set<UITouch>) -> CGPoint {
            
            let touch: UITouch = touchs.first!
            
            return touch.location(in: self)
        }
        /* 获取触摸按钮 */
        func button(_ point: CGPoint) -> UIButton? {
            for button in self.subviews {
                // 判断按钮是否包含某个点
                if button.frame.contains(point) {
                    return button as? UIButton
                }
            }
            return nil
        }
        /* 拿到移动选中按钮 */
        let pos: CGPoint = point(touches)
        /**************  当前移动到的位置   */
        movePoint = pos
        let touchButton: UIButton? = button(pos)
        /* 判断按钮存在并且按钮未被选中时就添加入选中数组中 */
        if let touchButton = touchButton {
            if !touchButton.isSelected {
                touchButton.isSelected = true
                selectButtons.append(touchButton)
                password = password + "\(touchButton.tag)"
            }
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        movedAddButton(touches)
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        movedAddButton(touches)
        /* 重绘 */
        setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //1 先关闭交互
        isUserInteractionEnabled = false
        //2 将password传出
        if self.selectButtons.count > 0 {
            self.delegate?.lockViewDidFinishSelect(self, password: self.password)
        }
        // 延时
        let deadlineTime: DispatchTime = DispatchTime.now() + .milliseconds(1)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            // 重置绘图和按钮
            self.password.removeAll()
            
            for button in self.selectButtons {
                button.isSelected = false
            }
            
            self.selectButtons.removeAll()
            
            self.setNeedsDisplay()
            
            self.isUserInteractionEnabled = true
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var col: Int = 0
        var row: Int = 0
        
        let btnWH: CGFloat = 66
        var btnX: CGFloat = 0
        var btnY: CGFloat = 0
        
        let tolCol: Int = 3
        
        let margin: CGFloat = (bounds.size.width - CGFloat(tolCol) * btnWH) / (CGFloat(tolCol) + 1)
        
        /* 给按钮设置位置 */
        for i in 0..<subviews.count {
            let button: UIButton = subviews[i] as! UIButton
            col = i % tolCol
            row = i / tolCol
            
            btnX = margin + (margin + btnWH) * CGFloat(col)
            btnY = margin + (margin + btnWH) * CGFloat(row)
            
            button.frame = CGRect(x: btnX, y: btnY, width: btnWH, height: btnWH)
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
            /* 获取画笔 */
            let path: UIBezierPath = UIBezierPath()
            for i in 0..<selectButtons.count {
                let button: UIButton = selectButtons[i]
                
                if i == 0 {
                    path.move(to: button.center)
                } else {
                    path.addLine(to: button.center)
                }
            }
            
            
            if selectButtons.count > 0 {
                path.addLine(to: movePoint)
                lineColor.set()
                path.lineWidth = 2
                path.lineJoinStyle = lineJoinStyle
                path.stroke()
            }
        
    }
    
}

