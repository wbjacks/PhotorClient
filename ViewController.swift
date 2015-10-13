//
//  ViewController.swift
//  PhotorClient
//
//  Created by Will Jackson on 8/2/15.
//  Copyright (c) 2015 Will Jackson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var label : UILabel!
    @IBOutlet var spinner : UIActivityIndicatorView!
    @IBAction func loadDataFromServer(sender:UIButton) {
        // TODO: (wbjacks) do data load
        spinner.hidden = false
        let urlString = "http://localhost:4567/"
        let url = NSURL(string: urlString)
        let request = NSMutableURLRequest(URL: url!)
        sendGetRequest(request) { (data, error) -> Void in
            self.spinner.hidden = true
            self.label.hidden = false
            if (error != nil) {
                self.label.text = error
            }
            else {
                self.label.text = data
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sendGetRequest(request:NSURLRequest!, callback:(String, String?)->Void) {
        var session = NSURLSession.sharedSession()
        var task = session.dataTaskWithRequest(request){
            (data, response, error) -> Void in
            if (error != nil) {
                callback("", (error!.localizedDescription) as String)
            }
            else {
                /*
                var result = NSString(data: data, encoding:
                    NSASCIIStringEncoding)!
                callback(result as String, nil)
                */
            }
        }
        task.resume()
    }
}

