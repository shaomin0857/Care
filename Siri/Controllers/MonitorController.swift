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

class MonitorController: UIViewController, MKMapViewDelegate {
    var myMapView:MKMapView!
    var targetAnno:MKPointAnnotation!
    override func viewDidLoad() {
        // MARK: - MapInitialize
        super.viewDidLoad()
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
        
        // Init Floating Button
        let actionButton = JJFloatingActionButton()

        actionButton.addItem(title: "RandomMove", image: UIImage(systemName: "arrow.clockwise")?.withRenderingMode(.alwaysTemplate)) { item in
            self.updateAnnoLocation(lati: self.targetAnno.coordinate.latitude+0.01, long: self.targetAnno.coordinate.longitude+0.01)
        }

        actionButton.addItem(title: "Tracking", image: UIImage(systemName: "arrow.swap")?.withRenderingMode(.alwaysTemplate)) { item in
          // do something
        }

        actionButton.addItem(title: "Move By Step", image: UIImage(systemName: "arrow.right.to.line.alt")?.withRenderingMode(.alwaysTemplate)){ item in
          // do something
        }
        
        actionButton.display(inViewController: self)
    }
    
    func updateAnnoLocation(lati:Double,long:Double)->Void{
        targetAnno.coordinate = CLLocationCoordinate2D(latitude: lati, longitude: long)
        targetAnno.title = "\(targetAnno.coordinate.latitude)\n\(targetAnno.coordinate.longitude)"
    }
    
    func newAnno() -> Void {
        var objectAnnotation = MKPointAnnotation()
        objectAnnotation.coordinate = CLLocation(
          latitude: 25.036798,
          longitude: 121.499962).coordinate
        objectAnnotation.title = "艋舺公園"
        objectAnnotation.subtitle =
          "艋舺公園位於龍山寺旁邊，原名為「萬華十二號公園」。"
        myMapView.addAnnotation(objectAnnotation)

        // 建立另一個地點圖示 (經由委任方法設置圖示)
        objectAnnotation = MKPointAnnotation()
        objectAnnotation.coordinate = CLLocation(
          latitude: 25.063059,
          longitude: 121.533838).coordinate
        objectAnnotation.title = "行天宮"
        objectAnnotation.subtitle =
          "行天宮是北臺灣參訪香客最多的廟宇。"
        myMapView.addAnnotation(objectAnnotation)
    }


}
