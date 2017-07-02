//
//  ViewController.swift
//  RobotDemo
//
//  Created by Ebubekir Ogden on 1/23/17.
//  Copyright © 2017 Ebubekir. All rights reserved.
//

import UIKit
import SpeechToTextV1
import Alamofire

class MainVC: UIViewController {
    
    @IBOutlet weak var speechtoTextArea: UITextView!
    
    let speechToText = SpeechToText(username: speechToTextUsername, password: speechToTextPassword)

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func startButtonClick(_ sender: Any) {
        startStreaming()
    }
    
    @IBAction func stopButtonClick(_ sender: Any) {
        stopStreaming()
    }
    
    func startStreaming() {
        var settings = RecognitionSettings(contentType: .opus)
        settings.continuous = true
        settings.interimResults = true
        
        speechToText.recognizeMicrophone(settings: settings, failure: failure) { results in
            
            let url = URL(string: serverURL)
            
            let localQue: Parameters = [
                "query" : results.bestTranscript
            ]
            
            self.speechtoTextArea.text = results.bestTranscript
            
            if results.bestTranscript == " light on " || results.bestTranscript == " lights on " {
                Alamofire.request(url!, method: .post, parameters: localQue, encoding: URLEncoding.httpBody).responseJSON(){
                    response in
                    
                }
                
                self.speechToText.stopRecognizeMicrophone()
                print("Stopped!")

            }
            
            if results.bestTranscript == " light off " || results.bestTranscript == " lights off "{
                Alamofire.request(url!, method: .post, parameters: localQue, encoding: URLEncoding.httpBody).responseJSON(){
                    response in
                    
                    
                }
                
                self.speechToText.stopRecognizeMicrophone()
                print("Stopped!")
            }

            
        }
        
    }

    func stopStreaming() {
        speechToText.stopRecognizeMicrophone()
    }

}

