//
//  MeasuVC.swift
//  HeartRate
//
//  Created by GOKUL NARA on 12/29/23.
//

import UIKit
import AVFoundation

class PulseMeasureVC: UIViewController {
    
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var pulseLabel: UILabel!
    @IBOutlet weak var progressLabel: UILabel!
    
    private var previewLayer = UIView()
    private var validFrameCounter = 0
    private var heartRateManager: HeartRateManager!
    private var hueFilter = Filter()
    private var pulseDetector = PulseDetector()
    private var inputs: [CGFloat] = []
    private var measurementStartedFlag = false
    private var timer = Timer()
    private var pulseValues: [Int] = [Int]()
    private var hasPushedNextVC = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        initVideoCapture()
        
        pulseLabel.text = "--"
        progressLabel.text = ""
        
        progressBar.progress = 0.0
        progressBar.isHidden = true
        
        progressBar.layer.cornerRadius = progressBar.layer.frame.size.height / 2
        progressBar.clipsToBounds = true
        progressBar.layer.sublayers?[1].cornerRadius = progressBar.layer.frame.size.height / 2
        progressBar.subviews[1].clipsToBounds = true
    }
    
    func nextVC() {
        if !hasPushedNextVC && !pulseValues.isEmpty {
            hasPushedNextVC = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ResultVC") as! ResultVC
                let sum = self.pulseValues.reduce(0, +)
                let average = sum / self.pulseValues.count
                nextVC.resultValue = average
                print("Pulse ::::: \(average)")
                self.deinitCaptureSession()
                self.navigationController?.pushViewController(nextVC, animated: true)
            }
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initCaptureSession()
        //        nextVC()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        deinitCaptureSession()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        deinitCaptureSession()
    }
    
    // MARK: - Frames Capture Methods
    private func initVideoCapture() {
        let specs = VideoSpec(fps: 30, size: CGSize(width: 300, height: 300))
        heartRateManager = HeartRateManager(cameraType: .back, preferredSpec: specs, previewContainer: previewLayer.layer)
        heartRateManager.imageBufferHandler = { [unowned self] (imageBuffer) in
            self.handle(buffer: imageBuffer)
        }
    }
    
    // MARK: - AVCaptureSession Helpers
    private func initCaptureSession() {
        heartRateManager.startCapture()
    }
    
    private func deinitCaptureSession() {
        heartRateManager.stopCapture()
        toggleTorch(status: false)
    }
    
    private func toggleTorch(status: Bool) {
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        device.toggleTorch(on: status)
    }
    
    // MARK: - Measurement
    private func startMeasurement() {
        DispatchQueue.main.async {
            self.toggleTorch(status: true)
            self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [weak self] (timer) in
                guard let self = self else { return }
                let average = self.pulseDetector.getAverage()
                let pulse = 60.0/average
                if pulse == -60 {
                    UIView.animate(withDuration: 0.2, animations: {
                        //                        self.pulseLabel.alpha = 0
                    }) { (finished) in
                        //                        self.pulseLabel.isHidden = finished
                        self.pulseLabel.text = "--"
                    }
                } else {
                    UIView.animate(withDuration: 0.2, animations: {
                        //                        self.pulseLabel.alpha = 1.0
                    }) { (_) in
                        //                        self.pulseLabel.isHidden = false
                        self.pulseLabel.text = "\(lroundf(pulse))"
                        self.pulseValues.append(Int(self.pulseLabel.text ?? "") ?? 0)
                        print(self.pulseValues)
                        self.progressBar.isHidden = true
                        self.progressLabel.text = ""
                        self.nextVC()
                    }
                }
            })
        }
    }
}

//MARK: - Handle Image Buffer
extension PulseMeasureVC {
    fileprivate func handle(buffer: CMSampleBuffer) {
        var redmean:CGFloat = 0.0;
        var greenmean:CGFloat = 0.0;
        var bluemean:CGFloat = 0.0;
        
        let pixelBuffer = CMSampleBufferGetImageBuffer(buffer)
        let cameraImage = CIImage(cvPixelBuffer: pixelBuffer!)
        
        let extent = cameraImage.extent
        let inputExtent = CIVector(x: extent.origin.x, y: extent.origin.y, z: extent.size.width, w: extent.size.height)
        let averageFilter = CIFilter(name: "CIAreaAverage",
                                     parameters: [kCIInputImageKey: cameraImage, kCIInputExtentKey: inputExtent])!
        let outputImage = averageFilter.outputImage!
        
        let ctx = CIContext(options:nil)
        let cgImage = ctx.createCGImage(outputImage, from:outputImage.extent)!
        
        let rawData:NSData = cgImage.dataProvider!.data!
        let pixels = rawData.bytes.assumingMemoryBound(to: UInt8.self)
        let bytes = UnsafeBufferPointer<UInt8>(start:pixels, count:rawData.length)
        var BGRA_index = 0
        for pixel in UnsafeBufferPointer(start: bytes.baseAddress, count: bytes.count) {
            switch BGRA_index {
            case 0:
                bluemean = CGFloat (pixel)
            case 1:
                greenmean = CGFloat (pixel)
            case 2:
                redmean = CGFloat (pixel)
            case 3:
                break
            default:
                break
            }
            BGRA_index += 1
        }
        
        let hsv = rgb2hsv((red: redmean, green: greenmean, blue: bluemean, alpha: 1.0))
        // Do a sanity check to see if a finger is placed over the camera
        if (hsv.1 > 0.5 && hsv.2 > 0.5) {
            DispatchQueue.main.async {
                self.toggleTorch(status: true)
                if !self.measurementStartedFlag {
                    self.startMeasurement()
                    self.measurementStartedFlag = true
                    self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateProgressBar), userInfo: nil, repeats: true)
                    self.progressLabel.text = "Intialising please wait..."
                    self.progressBar.isHidden = false
                }
            }
            validFrameCounter += 1
            inputs.append(hsv.0)
            // Filter the hue value - the filter is a simple BAND PASS FILTER that removes any DC component and any high frequency noise
            let filtered = hueFilter.processValue(value: Double(hsv.0))
            if validFrameCounter > 60 {
                self.pulseDetector.addNewValue(newVal: filtered, atTime: CACurrentMediaTime())
                DispatchQueue.main.async {
                    self.progressBar.progress = 1.0
                    self.progressLabel.text = "Please wait few seconds..."
                    self.nextVC()
                }
            }
        } else {
            validFrameCounter = 0
            measurementStartedFlag = false
            pulseDetector.reset()
            DispatchQueue.main.async {
                self.progressBar.progress = 0.0
            }
        }
    }
    
    @objc func updateProgressBar(){
        self.progressBar.progress += 0.1
    }
}

