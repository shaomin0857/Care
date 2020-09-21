//
//  MonitorController.swift
//  Siri
//
//  Created by 曾雅芳 on 2020/9/21.
//  Copyright © 2020 Sahand Edrisian. All rights reserved.
//

import UIKit
import MapKit
import JJFloatingActionButton
import Starscream

class MonitorController: UIViewController, MKMapViewDelegate ,WebSocketDelegate{
    
    
    var myMapView:MKMapView!
    var targetAnno:MKPointAnnotation!
    // MARK: - IOT Connection Settings
    let host = "iot.cht.com.tw"
    let device = "23558832518"
    let sensor = "location"
    let apikey = "PKEE42472GRRRZ2ZAY"
    
    var socket: WebSocket!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // MARK: - Map init
        let fullSize = UIScreen.main.bounds.size

        // 建立一個 MKMapView
        myMapView = MKMapView(frame: CGRect(
          x: 0, y: 20,
          width: fullSize.width,
          height: fullSize.height - 20))

        // 設置委任對象
        myMapView.delegate = self

        // 地圖樣式
        myMapView.mapType = .standard

        // 顯示自身定位位置
        myMapView.showsUserLocation = true

        // 允許縮放地圖
        myMapView.isZoomEnabled = true

        // 地圖預設顯示的範圍大小 (數字越小越精確)
        let latDelta = 0.05
        let longDelta = 0.05
        let currentLocationSpan:MKCoordinateSpan =
            MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)

        // 設置地圖顯示的範圍與中心點座標
        let center:CLLocation = CLLocation(
          latitude: 25.05, longitude: 121.515)
        let currentRegion:MKCoordinateRegion =
          MKCoordinateRegion(
            center: center.coordinate,
            span: currentLocationSpan)
        myMapView.setRegion(currentRegion, animated: true)

        // 加入到畫面中
        self.view.addSubview(myMapView)
        
        // init Target anno
        targetAnno = MKPointAnnotation()
        myMapView.addAnnotation(targetAnno)
        updateAnnoLocation(lati: 25.063059, long: 121.533838)
        
        // MARK: - Floating Button init
        let actionButton = JJFloatingActionButton()

        actionButton.addItem(title: "RandomMove", image: UIImage(systemName: "arrow.clockwise")?.withRenderingMode(.alwaysTemplate)) { item in
            self.updateAnnoLocation(lati: self.targetAnno.coordinate.latitude+0.01, long: self.targetAnno.coordinate.longitude+0.01)
        }

        actionButton.addItem(title: "Tracking", image: UIImage(systemName: "arrow.swap")?.withRenderingMode(.alwaysTemplate)) { item in
            
            self.socket.connect()
        }

        actionButton.addItem(title: "Move By Step", image: UIImage(systemName: "arrow.right.to.line.alt")?.withRenderingMode(.alwaysTemplate)){ item in
          // do something
        }
        actionButton.display(inViewController: self)
        //MARK: - Websocket init
        socket = WebSocket(url: URL(string: "ws://\(host):80/iot/ws/rawdata")!)
        socket.delegate = self
    }
    func updateAnnoLocation(lati:Double,long:Double)->Void{
        targetAnno.coordinate = CLLocationCoordinate2D(latitude: lati, longitude: long)
        targetAnno.title = "\(targetAnno.coordinate.latitude)\n\(targetAnno.coordinate.longitude)"
    }
    // MARK: - Define WebSocket Delegate
    
    func websocketDidConnect(socket: WebSocketClient) {
        print("websocketDidConnect")
        let config:NSDictionary = [
            "ck": apikey,
            "resources": ["/v1/device/\(device)/sensor/\(sensor)/rawdata"]
        ]
        let jsonData = try? JSONSerialization.data(withJSONObject: config, options: [])
        let jsonString = String(data: jsonData!, encoding: .utf8)
        socket.write(string: jsonString!)
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print("websocketDidDisconnect", error ?? "")
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        print("websocketDidReceiveMessage", text)
        targetAnno.subtitle = text
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print("websocketDidReceiveData", data)
    }
}
