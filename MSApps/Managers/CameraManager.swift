//
//  CameraManager.swift
//  MSApps
//
//  Created by Eli Mehaudy on 04/05/2021.
//

import UIKit
import Vision
import AVFoundation

protocol CameraManagerDelegate {
    func didScanValidQRCode(QRCode: String)
    func willShowAlert(withTitle title: String, message: String)
    func willRemoveSubrange()
    func willConfigurePreviewLayerFrame(camera: AVCaptureVideoPreviewLayer)
}

class CameraManager: NSObject {
    
    var captureSession = AVCaptureSession()
    var delegate: CameraManagerDelegate?
    
    lazy var detectBarcodeRequest = VNDetectBarcodesRequest { request, error in
        guard error == nil else {
            self.delegate?.willShowAlert(withTitle: "Barcode error", message: error?.localizedDescription ?? "error")
            return
        }
        self.processClassification(request)
        return
    }
    
    func checkPermissions(){
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [self] granted in
                if !granted {
                    showPermissionsAlert()
                }
            }
        case .denied, .restricted:
            showPermissionsAlert()
        default:
            return
        }
    }
    
    // MARK: - Camera
    func setupCameraLiveView(){
        captureSession.sessionPreset = .hd1280x720
        let videoDevice = AVCaptureDevice
            .default(.builtInWideAngleCamera, for: .video, position: .back)
        
        guard let device = videoDevice, let videoDeviceInput = try? AVCaptureDeviceInput(device: device),
              captureSession.canAddInput(videoDeviceInput)
        else {
            delegate?.willShowAlert(withTitle: "Cannot Find Camera", message: "There seems to be a problem with the camera on your device.")
            return
        }
        captureSession.addInput(videoDeviceInput)
        let captureOutput = AVCaptureVideoDataOutput()
        captureOutput.videoSettings =
            [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA)]
        captureOutput.setSampleBufferDelegate(
            self,
            queue: DispatchQueue.global(qos: DispatchQoS.QoSClass.default))
        
        captureSession.addOutput(captureOutput)
        configurePreviewLayer()
        captureSession.startRunning()
    }
    
    func stopCameraLiveView() {
        captureSession.stopRunning()
    }
    
    // MARK: - Vision
    func processClassification(_ request: VNRequest) {
        guard let barcodes = request.results else { return }
        DispatchQueue.main.async { [self] in
            if captureSession.isRunning {
                delegate?.willRemoveSubrange()
                for barcode in barcodes {
                    guard let potentialQRCode = barcode as? VNBarcodeObservation else { return }

                    if let qrCodeString = potentialQRCode.payloadStringValue {
                    delegate?.didScanValidQRCode(QRCode: qrCodeString)
                    }
                }
            }
        }
    }
}

// MARK: - AVCaptureDelegation
extension CameraManager: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        let imageRequestHandler = VNImageRequestHandler(
            cvPixelBuffer: pixelBuffer,
            orientation: .right)
        do {
            try imageRequestHandler.perform([detectBarcodeRequest])
        } catch {
            print(error)
        }
    }
}

// MARK: - Helper
extension CameraManager {
    func configurePreviewLayer() {
        let cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraPreviewLayer.videoGravity = .resizeAspectFill
        cameraPreviewLayer.connection?.videoOrientation = .portrait
        delegate?.willConfigurePreviewLayerFrame(camera: cameraPreviewLayer)
    }
    
    func showPermissionsAlert(){
        delegate?.willShowAlert(withTitle: "Camera Permissions",
                  message:"Please open Settings and grant permission for this app to use your camera.")
    }
}
