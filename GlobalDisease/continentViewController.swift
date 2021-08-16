//
//  continentViewController.swift
//  GlobalDisease
//
//  Created by 姚思妤 on 2020/6/14.
//  Copyright © 2020 姚思妤. All rights reserved.
//

import UIKit

class continentViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    @IBOutlet weak var continentTextField: UITextField!
    
    var Global:NSMutableArray=[]
    var continentCode:NSMutableArray=[]
    var AF:NSMutableArray=[]
    var AN:NSMutableArray=[]
    var AS:NSMutableArray = []
    var EU:NSMutableArray = []
    var NA:NSMutableArray = []
    var OC:NSMutableArray = []
    var SA:NSMutableArray = []
    
    
    let continent = ["全球","非洲","南極洲","亞洲","歐洲","北美洲","大洋洲","南美洲"]
    let continent_en = ["Global","AF","AN","AS","EU","NA","OC","SA"]
    var selectedCon:String?
    
    @IBAction func submit(_ sender: UIButton) {
        performSegue(withIdentifier: "continentToOption", sender: self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        creatPickerView()
        creatToolBar()
        jsonParsingFromURL()
        
        // Do any additional setup after loading the view.
    }

    
    func creatPickerView(){
        let continentPicker = UIPickerView()
        continentPicker.delegate = self
        
        continentTextField.inputView = continentPicker
    }
    //做toolBar加入一個doneBotton
    func creatToolBar(){
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneBtn = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(continentViewController.dismissKeyboard))
        toolBar.setItems([doneBtn], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        continentTextField.inputAccessoryView = toolBar
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    //宣告picker的橫列有幾個
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    //宣告直列顯示數量
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return continent.count
    }
    //宣告pickerView要顯示的內容
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        return continent[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCon = continent[row]
        continentTextField.text = selectedCon
    }
    
    //轉跳前做
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //確認要轉跳的segue 可以有多個segue if判斷 分別寫上每個segue要做的事
        if segue.identifier == "continentToOption"{
            //設定segue的終點view為想跳過去的controller dest為一個controller
            let dest = segue.destination as! optionTableViewController
            dest.modalPresentationStyle = .fullScreen
            
            if selectedCon == nil{
                selectedCon = "0"
            }
            else{
                dest.selectedCon = self.selectedCon
            }
            
            switch continent.firstIndex(of: selectedCon!) {
            case 0:
                dest.continent = self.Global
            case 1:
                dest.continent = self.AF
            case 2:
                dest.continent = self.AN
            case 3:
                dest.continent = self.AS
            case 4:
                dest.continent = self.EU
            case 5:
                dest.continent = self.NA
            case 6:
                dest.continent = self.OC
            case 7:
                dest.continent = self.SA
            default:
                dest.continent = self.Global
            }
            
        }
    }
    
    
    //取得資料
   func jsonParsingFromURL(){
        //request會有一個URLRequest
        let request = NSMutableURLRequest(url: NSURL(string: "https://pkgstore.datahub.io/JohnSnowLabs/country-and-continent-codes-list/country-and-continent-codes-list-csv_json/data/c218eebbf2f8545f3db9051ac893d69c/country-and-continent-codes-list-csv_json.json")! as URL) //35.194.253.42/res.php
        let session = URLSession.shared
        //request加入某些HTTP標頭
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        //真正送出request ; session.dataTask 會等伺服器回應之後才會去執行他的completionHandler:
        let task = session.dataTask(with: request as URLRequest,completionHandler:{
            data, response, error -> Void in
            self.startParsing(data: data! as NSData)
        })
        task.resume()
    }
    
    /*func jsonParsingFromURL(){
        let path: NSString = Bundle.main.path(forResource: "continent", ofType: "json")! as NSString
        let data : NSData = try! NSData(contentsOfFile: path as String, options: NSData.ReadingOptions.dataReadingMapped)
        self.startParsing(data: data)
    }*/
    
    func startParsing(data:NSData){
        //把NSData資料解析成NSArray放到變數dictdata
        
        let dictdata:NSArray = (try! JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSArray
        
        for i in 0..<(dictdata.count){
            //continentCode?.insert((dictdata[i] as! NSDictionary).value(forKey: "Continent_Code") as! String)
            Global[i] = (dictdata[i] as! NSDictionary).value(forKey: "Two_Letter_Country_Code") as! NSString
            continentCode[i] = (dictdata[i] as! NSDictionary).value(forKey: "Continent_Code") as! NSString
            
            let stringContinent = continentCode[i] as! String
            if (stringContinent == "AF"){
                AF.add(Global[i])
            }
            else if(stringContinent == "AN"){
                AN.add(Global[i])
            }
            else if(stringContinent == "AS"){
                AS.add(Global[i])
            }
            else if(stringContinent == "EU"){
                EU.add(Global[i])
            }
            else if(stringContinent == "NA"){
                NA.add(Global[i])
            }
            else if(stringContinent == "OC"){
                OC.add(Global[i])
            }
            else{
                SA.add(Global[i])
            }
        }
        
        //把工作self.tableView.reloadData()丟到main執行緒去做
        DispatchQueue.main.async{
            
        }
        
    }
    
}
