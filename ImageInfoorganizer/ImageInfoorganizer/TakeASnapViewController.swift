//
//  ViewController.swift
//  ImageInfoorganizer
//
//  Created by Anusha Meda on 2/4/20.
//  Copyright © 2020 Anusha Meda. All rights reserved.
//

import UIKit
import Vision
import VisionKit

class TakeASnapViewController: UIViewController {

    enum ScanMode: Int {
        case businessCards
        case receipts
        case other
    }
    
    var scanMode: ScanMode = .receipts
    var textParser: (NSObject & RecognizedTextDataSource)?
    var textRecognitionRequest = VNRecognizeTextRequest()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Take A Snap"
        
        textRecognitionRequest = VNRecognizeTextRequest(completionHandler: { (request, error) in
                  
                guard let textParser = self.textParser else {
                               print("TextParser is not set")
                               return
                           }
                   if let results = request.results, !results.isEmpty {
                       if let requestResults = request.results as? [VNRecognizedTextObservation] {
                           DispatchQueue.main.async {
                            textParser.addRecognizedText(recognizedText: requestResults)
                           }
                       }
                   }
               })
        
        textRecognitionRequest.recognitionLevel = .accurate
        textRecognitionRequest.usesLanguageCorrection = true
    }
    @IBAction func snapButtonClicked(_ sender: UIControl) {
        guard let scanMode = ScanMode(rawValue: sender.tag) else { return }
        self.scanMode = scanMode
        let documentCameraViewController = VNDocumentCameraViewController()
        documentCameraViewController.delegate = self
        present(documentCameraViewController, animated: true)
    }
    
    func processImage(image: UIImage) {
           guard let cgImage = image.cgImage else {
               print("Failed to get cgimage from input image")
               return
           }
           
           let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
           do {
               try handler.perform([textRecognitionRequest])
           } catch {
               print(error)
           }
       }
    
    
}
extension TakeASnapViewController: VNDocumentCameraViewControllerDelegate {
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        
        switch scanMode {
        case .receipts:
            self.textParser = ReceiptTextParser()
        case .businessCards:
            self.textParser = BusinessCardTextParser()
        default:
            self.textParser = BusinessCardTextParser()
        }

        controller.dismiss(animated: true) {
            DispatchQueue.global(qos: .userInitiated).async {
                for pageNumber in 0 ..< scan.pageCount {
                    let image = scan.imageOfPage(at: pageNumber)
                    self.processImage(image: image)
                }
                
                }
            }
        }
    }


