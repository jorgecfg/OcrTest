//
//  ViewController.swift
//  OcrTest
//
//  Created by Jorge Flor, mVISE AG on 28.06.19.
//  Copyright © 2019 Jorge Flor, mVISE AG. All rights reserved.
//

import UIKit
import SwiftOCR
import TesseractOCR
import GPUImage
import YesWeScan
import TOCropViewController

class ViewController: UIViewController, G8TesseractDelegate {
    @IBOutlet private var imageView: UIImageView!
    
    var tesseract:G8Tesseract = G8Tesseract.init(language: "deu")!
    var myImage = UIImage(named: "schein_4", in: nil, compatibleWith: .none)!
    var preprocessedImage:UIImage?
    let dataService = DataService()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        loadData()
//        openScan()
//        localScanTest()
        
    }
    
    func loadData() {
        self.dataService.loadData()
    }
    
    func openScan() {
        let scanner = ScannerViewController(sessionPreset: .high, config: [.torch, .manualCapture])
        scanner.scanningQuality = .high
        scanner.delegate = self
        navigationController?.pushViewController(scanner, animated: true)
    }
    
    func localScanTest() {
        preOcr()
        runOcr()
    }
    
    func runOcr() {
        if let textDiscovered = scheinRecognizeTesseract(page: .sparseText) {
            print(textDiscovered)
            print("----------------------------------------------")
            
            let itens = textDiscovered.ocrToArray()
            for item in itens {
                if let brands = self.dataService.brands {
                    if let brand = brands.filter({
                        ($0.name!.contains(item))
                    }).first {
                        print("Found Brand: \(brand.name)");
                        for code in itens {
                            if let models = self.dataService.models {
                                if let model = models.filter({
                                    ($0.code!.contains(code)) && $0.brand == brand
                                }).first {
                                    print("Found Model Car: \(model.carName)");
                                }
                            }
                        }

                    }
                    

                }
            }
        }
    }
    
    func runOcrTest() {
        scheinRecognizeSwiftOCR()
        
        let pages:[G8PageSegmentationMode] = [.auto, .autoOnly, .circleWord, .singleBlock, .singleBlockVertText, .singleChar, .singleColumn, .singleLine, .singleWord, .sparseText]
        for page in pages {
            if let textDiscovered = scheinRecognizeTesseract(page: page) {
                print("Test \(page.rawValue) : \(textDiscovered)")
            }
        }

    }
    
    func preOcr() {
        
        self.preprocessedImage = myImage.scaledImage(1000);
        if let preprocessedImage = self.preprocessedImage {
            self.preprocessedImage = preprocessedImage.preprocessedImage()
        }
        
        
        let imageView = view.viewWithTag(1) as! UIImageView
        imageView.image = self.preprocessedImage

    }
    

    
    
    func scheinRecognizeSwiftOCR() {
        if let preprocessedImage = self.preprocessedImage {
            let swiftOCRInstance = SwiftOCR()
                swiftOCRInstance.recognize(preprocessedImage) { recognizedString in
//              print("SwiftOCR: \(recognizedString)")
            }

        }
    }
    
    
    func scheinRecognizeTesseract(page: G8PageSegmentationMode) -> String? {
        if let preprocessedImage = self.preprocessedImage {
            tesseract.delegate = self
            tesseract.image = preprocessedImage
            tesseract.pageSegmentationMode = page
            tesseract.engineMode = .tesseractOnly
            tesseract.charBlacklist = "|,-,},{,[,],*,.,:,;,@,',&,!,?,$,%,(,),‘,_,\\,“"
            tesseract.recognize()

            if let recognizedText = tesseract.recognizedText {
//                print("Tesseract: \(recognizedText)")
                return recognizedText
            }
        }
        return nil
    }
    

    
    
    
    
    func shouldCancelImageRecognitionForTesseract(tesseract: G8Tesseract!) -> Bool {
        return false // return true if you need to interrupt tesseract before it finishes
    }
    
}

extension UIImage {
    func preprocessedImage() -> UIImage? {
        // 1
        let stillImageFilter = GPUImageAdaptiveThresholdFilter()
        // 2
        stillImageFilter.blurRadiusInPixels = 15.0
        // 3
        let filteredImage = stillImageFilter.image(byFilteringImage: self)
        // 4
        return filteredImage
    }
    
    func scaledImage(_ maxDimension: CGFloat) -> UIImage? {
        // 3
        var scaledSize = CGSize(width: maxDimension, height: maxDimension)
        // 4
        if size.width > size.height {
            scaledSize.height = size.height / size.width * scaledSize.width
        } else {
            scaledSize.width = size.width / size.height * scaledSize.height
        }
        // 5
        UIGraphicsBeginImageContext(scaledSize)
        draw(in: CGRect(origin: .zero, size: scaledSize))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        // 6
        return scaledImage
    }
}


extension ViewController: ScannerViewControllerDelegate {
    func scanner(_ scanner: ScannerViewController, didCaptureImage image: UIImage) {
        myImage = image
        navigationController?.popViewController(animated: true)
        
        preOcr()
        runOcr()
    }
}





extension ViewController: TOCropViewControllerDelegate {
    func cropViewController(_ cropViewController: TOCropViewController,
                            didCropTo image: UIImage,
                            with cropRect: CGRect,
                            angle: Int) {
        
        myImage = image
        cropViewController.dismiss(animated: true, completion: nil)
    }
}

extension ViewController {
    @IBAction func scanDocument(_ sender: UIButton) {
        openDocumentScanner()
    }
    

}

extension ViewController {
    func addToSiriShortcuts() {
        if #available(iOS 12.0, *) {
            let identifier = Bundle.main.userActivityIdentifier
            let activity = NSUserActivity(activityType: identifier)
            activity.title = "Scan Document"
            activity.userInfo = ["Document Scanner": "open document scanner"]
            activity.isEligibleForSearch = true
            activity.isEligibleForPrediction = true
            activity.persistentIdentifier = NSUserActivityPersistentIdentifier(identifier)
            view.userActivity = activity
            activity.becomeCurrent()
        }
    }
    
    public func openDocumentScanner() {
        let scanner = ScannerViewController()
        scanner.delegate = self
        scanner.scanningQuality = .fast
        navigationController?.pushViewController(scanner, animated: true)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
}
