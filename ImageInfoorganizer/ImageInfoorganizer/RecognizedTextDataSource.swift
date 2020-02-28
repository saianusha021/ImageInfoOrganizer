//
//  RecognizedTextDataSource.swift
//  ImageInfoorganizer
//
//  Created by Anusha Meda on 2/27/20.
//  Copyright © 2020 Anusha Meda. All rights reserved.
//


import UIKit
import Vision

protocol RecognizedTextDataSource: AnyObject {
    func addRecognizedText(recognizedText: [VNRecognizedTextObservation])
}




