//
//  GraphView.swift
//  Graphic
//
//  Created by Екатерина Протасова on 26.12.2019.
//  Copyright © 2019 Екатерина Протасова. All rights reserved.
//

import UIKit

@IBDesignable
class GraphView: UIView {

    @IBInspectable var startColor: UIColor = .red
    @IBInspectable var endColor: UIColor = .green
    @IBInspectable var scale: CGFloat = 1.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    private let cubicCurveAlgorithm = CubicCurveAlgorithm()

    var sortedPoints: [Point] = []

    var rectGraph: CGRect?
    var xPointMin: CGFloat?
    var xPointMax: CGFloat?
    var yPointMin: CGFloat?
    var yPointMax: CGFloat?
    let margin: CGFloat = 40
    let topBorder: CGFloat = 40
    let circleDiameter: CGFloat = 5.0
    let colorAlpha: CGFloat = 0.3
    var swichGraghView: Bool = false
    var spacerX: CGFloat?
    var spacerY: CGFloat?
    var isLineGraph = true

    override func draw(_ rect: CGRect) {
        calculateParametersForGraph(sortedPoins: sortedPoints, rect: rect)
        rectGraph = rect
        drawBackground(rect: rect)
        drawGradient()
        if isLineGraph {
            drawGraphLine()

        } else {
            if sortedPoints.count > 1 {
                drawCurveGraphLine()
            }
        }
        drawSortedPoins()
        drawCoordinateAxes(rect: rect)
    }

    private func drawBackground (rect: CGRect) {
        let path = UIBezierPath(rect: rect)
        path.stroke()
    }

    private func drawGraphLine () {
        let graphPath = UIBezierPath()
        var points: [CGPoint] = []
        for point in sortedPoints {
            let newPoint: CGPoint = CGPoint(x: calculateXPoint(pointX: point.x), y: calculateYPoint(pointY: point.y))
            points.append(newPoint)
        }
        guard let firstPoint = sortedPoints.first  else {
            return
        }
        graphPath.move(to: CGPoint(x: calculateXPoint(pointX: firstPoint.x), y: calculateYPoint(pointY: firstPoint.y)))
        for i in 1..<sortedPoints.count {
            let nextPoint = CGPoint(x: calculateXPoint(pointX: sortedPoints[i].x), y: calculateYPoint(pointY: sortedPoints[i].y))
            graphPath.addLine(to: nextPoint)
        }
        UIColor.white.setFill()
        UIColor.white.setStroke()
        graphPath.stroke()
    }

    private func drawCurveGraphLine () {
        let graphPath = UIBezierPath()
        var points: [CGPoint] = []
        for point in sortedPoints {
            let newPoint: CGPoint = CGPoint(x: calculateXPoint(pointX: point.x), y: calculateYPoint(pointY: point.y))
            points.append(newPoint)
        }
        let controlPoints = cubicCurveAlgorithm.controlPointsFromPoints(dataPoints: points)
        guard let firstPoint = sortedPoints.first  else {
            return
        }
        graphPath.move(to: CGPoint(x: calculateXPoint(pointX: firstPoint.x), y: calculateYPoint(pointY: firstPoint.y)))
        for i in 1..<sortedPoints.count {
            let segment = controlPoints[i - 1]
            graphPath.addCurve(to: CGPoint(x: calculateXPoint(pointX: sortedPoints[i].x), y: calculateYPoint(pointY: sortedPoints[i].y)), controlPoint1: segment.controlPoint1, controlPoint2: segment.controlPoint2)
        }
        UIColor.white.setFill()
        UIColor.white.setStroke()
        graphPath.stroke()
    }

    private func drawSortedPoins () {
        for point in sortedPoints {
            var point = CGPoint(x: calculateXPoint(pointX: point.x), y: calculateYPoint(pointY: point.y))
            point.x -= circleDiameter / 2
            point.y -= circleDiameter / 2
            let circle = UIBezierPath(ovalIn: CGRect(origin: point, size: CGSize(width: circleDiameter, height: circleDiameter)))

            circle.fill()
        }
    }

    private func drawCoordinateAxes (rect: CGRect) {
        let linePath = UIBezierPath()
        linePath.move(to: CGPoint(x: 0, y: calculateYPoint(pointY: 0)))
        linePath.addLine(to: CGPoint(x: rect.width, y: calculateYPoint(pointY: 0)))
        linePath.move(to: CGPoint( x: calculateXPoint(pointX: 0), y: 0))
        linePath.addLine(to: CGPoint(x: calculateXPoint(pointX: 0), y: rect.height))
        let color = UIColor(white: 1.0, alpha: colorAlpha)
        color.setStroke()
        linePath.lineWidth = 2.0
        linePath.stroke()
    }

    private func drawGradient () {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        let colors = [startColor.cgColor, endColor.cgColor]
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colorLocations: [CGFloat] = [0.0, 1.0]
        guard let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: colorLocations) else {
            return
        }
        let startPoint = CGPoint.zero
        let endPoint = CGPoint(x: 0, y: self.bounds.height)
        context.drawLinearGradient(gradient,
                                   start: startPoint,
                                   end: endPoint,
                                   options: CGGradientDrawingOptions(rawValue: 0))
    }

    private func calculateParametersForGraph(sortedPoins: [Point], rect: CGRect) {
        guard let first = sortedPoins.first, let last = sortedPoins.last else {
            return
        }
        xPointMin = first.x
        xPointMax = last.x
        var min = CGFloat.greatestFiniteMagnitude
        var max = CGFloat.leastNormalMagnitude
        for point in sortedPoins {
            if min > CGFloat(point.y) {
                min = CGFloat( point.y)
            }
            if max < CGFloat(point.y) {
                max = CGFloat(point.y)
            }
        }
        yPointMin = min
        yPointMax = max

        var deltaX = last.x - first.x
        if deltaX == 0 {
            deltaX = 1
        }
        spacerX = (rect.width * scale - 2 * margin) / deltaX

        var deltaY = max - min
        if deltaY == 0 {
            deltaY = 1
        }

        spacerY = (rect.height - 2 * topBorder) / deltaY

        print(min, max)
    }

    private func calculateXPoint (pointX: CGFloat) -> CGFloat {
        guard let xPointMin = xPointMin, let spacerX = spacerX else {
            return 0.0
        }
        let x: CGFloat = (pointX - xPointMin) * spacerX + margin
        return x
    }

    private func calculateYPoint (pointY: CGFloat) -> CGFloat {
        guard let yPointMin = yPointMin, let spacerY = spacerY, let rectGraph = rectGraph else {
            return 0.0
        }
        let y: CGFloat = (rectGraph.height) - (pointY - yPointMin) * spacerY - topBorder
        return y
    }

    @objc
    func changedScale(_ gesture: UIPinchGestureRecognizer) {
        if gesture.state == .changed {
            scale *= gesture.scale
            gesture.scale = 1.0
        }
    }

    @IBAction private func switchGraph(_ sender: UISwitch) {
        isLineGraph = sender.isOn
        setNeedsDisplay()
    }
}
