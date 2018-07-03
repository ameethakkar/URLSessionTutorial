//
//  ViewController.swift
//  URLSessionTutorial
//
//  Created by appkoder on 17/03/2017.
//  Copyright © 2017 appkoder. All rights reserved.
//

import UIKit

class ViewController: UIViewController, URLSessionDownloadDelegate {
    
    @IBOutlet weak var photoViewer: UIImageView!
    
    @IBOutlet weak var progressBar: UIProgressView!
    
    //create the download task and download it in the background
    var downloadTask: URLSessionDownloadTask!
    var backgroundSession: URLSession!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundSessionConfig = URLSessionConfiguration.background(withIdentifier: "background")
        
        //responsible for downloading data in the background
        backgroundSession = URLSession(configuration: backgroundSessionConfig, delegate: self, delegateQueue: OperationQueue())
        
        progressBar.setProgress(0.0, animated: true)
    }

    @IBAction func start(_ sender: Any) {
        
        let url = URL(string: "http://www.johnharveyphoto.com/HongKong/FishInLargeTankHg.jpg")
        
        if let url = url{
            downloadTask = backgroundSession.downloadTask(with: url)
            
            //resume willl start the download immediately and will be calling some delegate methods as its downloading
            downloadTask.resume()
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        print("success")
        print(location)
        
        let data = try? Data(contentsOf: location)
        if let data = data {
            
            DispatchQueue.main.async {
               self.photoViewer.image = UIImage(data: data)
            }
            
        }
        
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        let progress = Float(totalBytesWritten)/Float(totalBytesExpectedToWrite)
        
        DispatchQueue.main.async {
            print("written: \(totalBytesWritten) expected:  \(totalBytesExpectedToWrite)")
            
           self.progressBar.setProgress(progress, animated: true)
        }
        
    }
    
    func urlSession(_ session: URLSession,
                    task: URLSessionTask,
                    didCompleteWithError error: Error?){
        downloadTask = nil
        progressBar.setProgress(0.0, animated: true)
        if (error != nil) {
            print(error!.localizedDescription)
        }else{
            print("The task finished transferring data successfully")
        }
    }
    
    @IBAction func stop(_ sender: Any) {
        
        if downloadTask != nil{
            downloadTask.cancel()
        }
    }
    
    @IBAction func pause(_ sender: Any) {
        if downloadTask != nil{
            downloadTask.suspend()
        }
    }
    
    @IBAction func resume(_ sender: Any) {
        
        if downloadTask != nil{
            downloadTask.resume()
        }
    }

}

