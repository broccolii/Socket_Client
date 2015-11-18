//
//  ViewController.swift
//  Socket客户端
//
//  Created by Broccoli on 15/11/5.
//  Copyright © 2015年 Broccoli. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var client: GCDAsyncSocket!
    override func viewDidLoad() {
        super.viewDidLoad()
        client = GCDAsyncSocket(delegate: self, delegateQueue: dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0))
        do {
         try client.connectToHost("127.0.0.1", onPort: 1234)
        } catch let error as NSError {
            debugPrint(error)
        }
    }
    
    func  readDataServer() {
        client.readDataWithTimeout(3, tag: 0)
        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1), dispatch_get_main_queue()) { () -> Void in
//             self.client.readDataWithTimeout(-1, tag: 0)
//        }
    }
}

extension ViewController: GCDAsyncSocketDelegate {
    func socket(sock: GCDAsyncSocket!, didConnectToHost host: String!, port: UInt16) {
        let str = "读取到数据"
        
        client.writeData(str.dataUsingEncoding(NSUTF8StringEncoding), withTimeout: -1, tag: 0)

        let timer = NSTimer(timeInterval: 1.0, target: self, selector: Selector("readDataServer"), userInfo: nil, repeats: true)
         NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSDefaultRunLoopMode)
         self.client.readDataWithTimeout(-1, tag: 0)
    }
    
    func socket(sock: GCDAsyncSocket!, didReadData data: NSData!, withTag tag: Int) {
        let str = String(data: data, encoding: NSUTF8StringEncoding)!
        debugPrint("\(NSDate())收到消息: \(str)")
        
         readDataServer()
    }
    
    func socketDidDisconnect(sock: GCDAsyncSocket!, withError err: NSError!) {
        print("\(NSDate())断开连接")
    }
}


