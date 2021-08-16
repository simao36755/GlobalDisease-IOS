//
//  detailViewController.swift
//  GlobalDisease
//
//  Created by 姚思妤 on 2020/6/14.
//  Copyright © 2020 姚思妤. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class detailViewController: UIViewController,CLLocationManagerDelegate {

    @IBOutlet weak var areaLabel: UILabel!
    @IBOutlet weak var diseaseLable: UILabel!
    @IBOutlet weak var severityLabel: UILabel!
    @IBOutlet weak var sentLabel: UILabel!
    @IBOutlet weak var descriptLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    var locationManager : CLLocationManager!
    //缺座標
    
    @IBAction func swipeR(_ sender: UISwipeGestureRecognizer) {
        if x>0{
            let removeAnn = self.mapView.annotations
            mapView.removeAnnotations(removeAnn)
            x=x-1
            viewDidLoad()
        }
    }
    @IBAction func swipeL(_ sender: UISwipeGestureRecognizer) {
        if x<area.count-1{
            let removeAnn = self.mapView.annotations
            mapView.removeAnnotations(removeAnn)
            x=x+1
            viewDidLoad()
        }
    }
    
    var area:NSMutableArray = []
    var disease:NSMutableArray = []
    var severity:NSMutableArray = []
    var sent:NSMutableArray = []
    var descript:NSMutableArray = []
    var circle:NSMutableArray = []
    var doubleLat:Double?
    var doubleLon:Double?
    var x:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        areaLabel.text = area[x] as? String
        diseaseLable.text = disease[x] as? String
        severityLabel.text = severity[x] as? String
        sentLabel.text = sent[x] as? String
        descriptLabel.text = descript[x] as? String
        
        //轉換"經度,緯度"成double
        if let latlon = circle[x] as? String{
            let latlonArr = latlon.components(separatedBy: ",")
            doubleLat = Double(latlonArr[0])
            doubleLon = Double(latlonArr[1])
        }
        else{
            doubleLat = 23.712238
            doubleLon = 120.766556
        }
        
        mapView.showsUserLocation = true //標示目前位置
        mapView.isZoomEnabled = true //地圖可以縮放大小

        // 建立CLLocationManager管理類別物件
        locationManager = CLLocationManager()
        // 設定委派
        locationManager.delegate = self
        // 設定精確度
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // 取得App定位服務授權
        locationManager.requestAlwaysAuthorization()
        // 開啟更新位置
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // 取得現在位置 let curLocation:CLLocation = locations[0]
        // 以現在位置為中心點
        let location = CLLocationCoordinate2D(latitude: doubleLat!,longitude: doubleLon!)
        
        print("經：\(doubleLat),,緯：\(doubleLon)")
        // 設定地圖顯示區域、中心點和縮放比例
        let span = MKCoordinateSpan(latitudeDelta:50.0, longitudeDelta:50.0) // 縮放比例
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        
        //可以插旗子
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: doubleLat!, longitude: doubleLon!)
        mapView.addAnnotation(annotation)
    }
    
    override func viewDidDisappear(_ animated: Bool){
        // 停止取得定位點
        locationManager.stopUpdatingLocation()
    }
}





    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


