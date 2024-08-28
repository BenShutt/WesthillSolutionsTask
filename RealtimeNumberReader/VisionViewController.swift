/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The Vision view controller, which recognizes and displays bounding boxes around text.
*/

import Foundation
import UIKit
import AVFoundation
import Vision

class VisionViewController: ViewController {
    
	var request: VNRecognizeTextRequest!
	
	override func viewDidLoad() {
		// Set up the Vision request before letting ViewController set up the camera
		// so it exists when the first buffer is received.
		request = VNRecognizeTextRequest(completionHandler: recognizeTextHandler)

		super.viewDidLoad()

		numberView.numberOfLines = 0
		numberView.lineBreakMode = .byWordWrapping
		numberView.font = UIFont.systemFont(ofSize: 10)
	}
	
	// MARK: - Text recognition
	
	// The Vision recognition handler.
	func recognizeTextHandler(request: VNRequest, error: Error?) {
		guard let results = request.results as? [VNRecognizedTextObservation] else { return }
        let candidates = MRZCandidate.groupLines(results: results)
        candidates.forEach { candidate in
            let string = candidate.joined(separator: "\n")
            if let validMRZ = try? MRZParser.parse(string) {
                showString(string: validMRZ)
            }
        }
	}
	
	override func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
		if let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) {
			// Configure for running in real time.
			request.recognitionLevel = .accurate
            // Language correction doesn't help in recognizing phone numbers and also
            // slows recognition.
			request.usesLanguageCorrection = false
			// Only run on the region of interest for maximum speed.
			request.regionOfInterest = regionOfInterest
			
			let requestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: textOrientation, options: [:])
			do {
				try requestHandler.perform([request])
			} catch {
				print(error)
			}
		}
	}
}
