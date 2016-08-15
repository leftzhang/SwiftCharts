//
//  InfoBubble.swift
//  SwiftCharts
//
//  Created by ischuetz on 11/04/15.
//  Copyright (c) 2015 ivanschuetz. All rights reserved.
//

import UIKit

public class InfoBubble: UIView {

    private let arrowWidth: CGFloat
    private let arrowHeight: CGFloat
    private let bgColor: UIColor
    private let arrowX: CGFloat
    
    let contentView: UIView?
    
    private let minSuperviewPadding: CGFloat = 2

    private let point: CGPoint
    
    private var inverted: Bool {
        return point.y < bounds.size.height
    }

    public convenience init(point: CGPoint, size: CGSize, superview: UIView, arrowHeight: CGFloat = 15, contentView: UIView, bgColor: UIColor = UIColor.grayColor(), minSuperviewPadding: CGFloat = 2) {
    
        let w: CGFloat = size.width
        let h: CGFloat = size.height
        
        let x = min(max(superview.bounds.minX + minSuperviewPadding, point.x - w / 2), superview.bounds.maxX  - w - minSuperviewPadding)

        let frame = point.y < h ? CGRectMake(x, point.y + 12, w, h) : CGRectMake(x, point.y - (h + 12), w, h)
        
        self.init(point: point, frame: frame, arrowWidth: 15, arrowHeight: arrowHeight, contentView: contentView, bgColor: bgColor, arrowX: point.x - x)
    }
    
    public init(point: CGPoint, frame: CGRect, arrowWidth: CGFloat, arrowHeight: CGFloat, contentView: UIView? = nil, bgColor: UIColor = UIColor.whiteColor(), arrowX: CGFloat) {
        self.point = point
        self.arrowWidth = arrowWidth
        self.arrowHeight = arrowHeight
        self.bgColor = bgColor

        let arrowHalf = arrowWidth / 2
        self.arrowX = max(arrowHalf, min(frame.size.width - arrowHalf, arrowX))
        
        self.contentView = contentView
        
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTap))
        self.addGestureRecognizer(tapRecognizer)
    }
    
    func onTap(sender: UITapGestureRecognizer) {
        close()
    }
    
    func close() {
        removeFromSuperview()
    }
    
    public override func didMoveToSuperview() {
        if let contentView = contentView {
            contentView.center = bounds.center.offset(y: inverted ? arrowHeight / 2 : -arrowHeight / 2)
            addSubview(contentView)
        }
    }

    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, bgColor.CGColor)
        CGContextSetStrokeColorWithColor(context, bgColor.CGColor)
        
        let rrect = rect.insetBy(dy: inverted ? arrowHeight : 0, dh: inverted ? 0 : arrowHeight)
        
        let minx = CGRectGetMinX(rrect), maxx = CGRectGetMaxX(rrect)
        let miny = CGRectGetMinY(rrect), maxy = CGRectGetMaxY(rrect)
        
        let outlinePath = CGPathCreateMutable()
        
        CGPathMoveToPoint(outlinePath, nil, minx, miny)
        CGPathAddLineToPoint(outlinePath, nil, maxx, miny)
        CGPathAddLineToPoint(outlinePath, nil, maxx, maxy)
        CGPathAddLineToPoint(outlinePath, nil, minx, maxy)
        CGPathCloseSubpath(outlinePath)
        CGContextAddPath(context, outlinePath)

        let arrowPath = CGPathCreateMutable()
        
        if inverted {
            CGPathMoveToPoint(arrowPath, nil, arrowX - arrowWidth / 2, miny)
            CGPathAddLineToPoint(arrowPath, nil, arrowX, miny - arrowHeight)
            CGPathAddLineToPoint(arrowPath, nil, arrowX + arrowWidth / 2, miny)
            
        } else {
            CGPathMoveToPoint(arrowPath, nil, arrowX + arrowWidth / 2, maxy)
            CGPathAddLineToPoint(arrowPath, nil, arrowX, maxy + arrowHeight)
            CGPathAddLineToPoint(arrowPath, nil, arrowX - arrowWidth / 2, maxy)
        }
        
        CGPathCloseSubpath(arrowPath)
        CGContextAddPath(context, arrowPath)
        
        CGContextFillPath(context)
    }
}


extension InfoBubble {
    
    public convenience init(point: CGPoint, size: CGSize, superview: UIView, arrowHeight: CGFloat = 15, text: String, font: UIFont, textColor: UIColor, bgColor: UIColor = UIColor.grayColor(), minSuperviewPadding: CGFloat = 2) {
        let label = UILabel()
        label.text = text
        label.font = font
        label.textColor = textColor
        label.sizeToFit()
        
        self.init(point: point, size: size, superview: superview, arrowHeight: arrowHeight, contentView: label, bgColor: bgColor)
    }
}