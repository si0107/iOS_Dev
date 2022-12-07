//
//  UIImageView+DownloadImage.swift
//  ToDoApp
//
//  Created by S I on 11/30/22.
//


import UIKit
extension UIImageView {
    func loadImage(url: URL) -> URLSessionDownloadTask {
        let session = URLSession.shared
        //keep file temporarily on disk
        let downloadTask = session.downloadTask(with: url) {
            [weak self] url, _, error in
            
            if error == nil, let url = url,
            //tries to find image in local file
            let data = try? Data(contentsOf: url),
            //construct image
               let image = UIImage(data: data) {
                //use weakself because you need to check if this page is still existing or not
                // before you set it
                DispatchQueue.main.async {
                    if let weakSelf = self {
                        weakSelf.image = image
                    }
                }
            }
        }
        //resume to start download tasks
        downloadTask.resume()
        //return to be able to cancel
        return downloadTask
    }
}
