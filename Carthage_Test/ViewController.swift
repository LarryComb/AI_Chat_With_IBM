//
//  ViewController.swift
//  Carthage_Test
//
//  Created by LARRY COMBS on 5/22/18.
//  Copyright © 2018 LARRY COMBS. All rights reserved.
//

import UIKit
import VisualRecognitionV3
import AlamofireImage
import Alamofire


class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    let imagePicker = UIImagePickerController()
    
    
    
    let apiKey = "5ad135e71c4dba7962d2293bf9e960c973f8ebfc"
    let version = "2018-06-02"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
        
    }

    @IBAction func getImage(_ sender: Any) {
    
        
        let button = sender as! UIBarButtonItem
        button.isEnabled = false
        
        let randomNumber = Int(arc4random_uniform(1000))
        
        let url = URL(string: "https://picsum.photos/400/700?image=\(randomNumber)")!
        
        imageView.af_setImage(withURL: url)
        
        let visualRecognition = VisualRecognition(apiKey: apiKey, version: version)
        
        let failure = {(error:Error) in
            DispatchQueue.main.async {
                self.navigationItem.title = "image could not be proccessed"
                button.isEnabled = true
            }
            
            print(error)
        }
        
        let recogURL = URL(string: "https://picsum.photos/50/100?image=\(randomNumber)")
       // let imageData = try! Data(contentsOf: recogURL)
        //let image = UIImage(data: imageData)!
        //guard let image = UIImage(named: recogURL.absoluteString) else { assertionFailure(); return }
        
        visualRecognition.classify(imagesFile: recogURL, failure: failure) { classifiedImages in
            if let classifiedImage = classifiedImages.images.first {
                print(classifiedImage.classifiers)
                
                if let classification = classifiedImage.classifiers.first?.classes.first?.className {
                    DispatchQueue.main.async {
                        self.navigationItem.title = classification
                        button.isEnabled = true
                    }
                }
            
                
            }else{
                DispatchQueue.main.async {
                    self.navigationItem.title = "Could not be recognized"
                    button.isEnabled = true
                }
            }
            
        }
        
    }
    
    
    



}

