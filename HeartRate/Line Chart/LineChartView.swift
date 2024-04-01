//
//  LineChartView.swift
//  HeartRate
//
//  Created by Haris Madhavan on 02/02/24.
//

import Foundation
import UIKit

class LineChartView: UIView {
    var datasets: [(dataPoints: [CGFloat], color: UIColor)] = [] // Array to store multiple datasets
    var showGrid = true // Property to toggle grid visibility
    var lineWidth: CGFloat = 2.0 // Property to specify line width
    var lineAnimationDuration: CFTimeInterval = 2.0 // Animation duration for drawing lines
    var xLabels: [String] = [] // X-axis labels
    var yLabels: [String] = [] // Y-axis labels

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        // Calculate points for the data
        let maxDataValue = datasets.flatMap { $0.dataPoints }.max() ?? 0
        let scale = bounds.height / maxDataValue
        let stepX = bounds.width / CGFloat(datasets.first?.dataPoints.count ?? 1 - 1)

        // Create a CAShapeLayer for drawing the lines
        let lineLayer = CAShapeLayer()
        lineLayer.lineWidth = lineWidth
        lineLayer.strokeColor = UIColor.black.cgColor
        lineLayer.fillColor = UIColor.clear.cgColor
        self.layer.addSublayer(lineLayer)

        // Draw the grid
        if showGrid {
            let numberOfGridLines = 6 // You can adjust this value
            let gridPath = UIBezierPath()

            for i in 0..<numberOfGridLines {
                let y = bounds.height - (CGFloat(i) / CGFloat(numberOfGridLines - 1)) * bounds.height
                gridPath.move(to: CGPoint(x: 0, y: y))
                gridPath.addLine(to: CGPoint(x: bounds.width, y: y))
            }

            let gridLayer = CAShapeLayer()
            gridLayer.path = gridPath.cgPath
            gridLayer.strokeColor = UIColor.lightGray.cgColor
            gridLayer.lineWidth = 0.5
            gridLayer.fillColor = UIColor.clear.cgColor
            self.layer.addSublayer(gridLayer)
        }

        // Draw the x-axis and y-axis lines
        let axisPath = UIBezierPath()

        // Draw the x-axis line
        axisPath.move(to: CGPoint(x: 0, y: bounds.height))
        axisPath.addLine(to: CGPoint(x: bounds.width, y: bounds.height))

        // Draw the y-axis line
        axisPath.move(to: CGPoint(x: 0, y: 0))
        axisPath.addLine(to: CGPoint(x: 0, y: bounds.height))

        let axisLayer = CAShapeLayer()
        axisLayer.path = axisPath.cgPath
        axisLayer.strokeColor = UIColor.black.cgColor
        axisLayer.lineWidth = 1.0
        axisLayer.fillColor = UIColor.clear.cgColor
        self.layer.addSublayer(axisLayer)

        // Draw the x-axis labels
        for (index, labelText) in xLabels.enumerated() {
            let x = CGFloat(index) * stepX
            let labelFrame = CGRect(x: x, y: bounds.height, width: stepX, height: 20)
            drawLabel(text: labelText, frame: labelFrame, alignment: .center)
        }

        // Draw the y-axis labels
        for (index, labelText) in yLabels.enumerated() {
            let y = bounds.height - (CGFloat(index) * (bounds.height / CGFloat(yLabels.count - 1)))
            let labelFrame = CGRect(x: -45, y: y - 10, width: 40, height: 20)
            drawLabel(text: labelText, frame: labelFrame, alignment: .right)
        }

        // Draw the line chart for each dataset with animation
        for dataset in datasets {
            let linePath = UIBezierPath()
            let lineLayer = CAShapeLayer()
            lineLayer.lineWidth = lineWidth
            lineLayer.strokeColor = dataset.color.cgColor
            lineLayer.fillColor = UIColor.clear.cgColor
            self.layer.addSublayer(lineLayer)

            for (index, dataPoint) in dataset.dataPoints.enumerated() {
                let x = CGFloat(index) * stepX
                let y = bounds.height - dataPoint * scale
                if index == 0 {
                    linePath.move(to: CGPoint(x: x, y: y))
                } else {
                    linePath.addLine(to: CGPoint(x: x, y: y))
                }
            }

            lineLayer.path = linePath.cgPath

            // Add animation for drawing lines
            let pathAnimation = CABasicAnimation(keyPath: "strokeEnd")
            pathAnimation.duration = lineAnimationDuration
            pathAnimation.fromValue = 0
            pathAnimation.toValue = 1
            lineLayer.add(pathAnimation, forKey: "strokeEndAnimation")
        }
    }

    func drawLabel(text: String, frame: CGRect, alignment: NSTextAlignment) {
        guard frame.origin.x.isFinite, frame.origin.y.isFinite, frame.width.isFinite, frame.height.isFinite else {
            // Skip drawing if the frame has invalid coordinates or dimensions
            return
        }

        let label = UILabel(frame: frame)
        label.text = text
        label.textAlignment = alignment
        self.addSubview(label)
    }

}


