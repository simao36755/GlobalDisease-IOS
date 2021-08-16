//
//  optionTableViewController.swift
//  GlobalDisease
//
//  Created by 姚思妤 on 2020/6/14.
//  Copyright © 2020 姚思妤. All rights reserved.
//

import UIKit

class optionTableViewController: UITableViewController {

    var sent:NSMutableArray = []
    var headline:NSMutableArray = []
    var descript:NSMutableArray = []
    var web:NSMutableArray = []
    var severity:NSMutableArray = []
    var disease:NSMutableArray = []
    var areaDesc:NSMutableArray = []
    var circle:NSMutableArray = []
    var selectedCon:String?
    var continent:NSMutableArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 100
        jsonParsingFromURL()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return headline.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 取得 tableView 目前使用的 cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! optionTableViewCell
        
        cell.sentLable.text = sent[indexPath.row] as? String
        cell.headlineLable.text = headline[indexPath.row] as? String
        cell.severityLable.text = severity[indexPath.row] as? String
        
        /*此方法提供cell所有元件資料 所以也可以及時調整 根據restaurantIsVisited陣列來決定是否要顯示check
         cell.accessoryType = self.restaurantIsVisited[indexPath.row] ? .checkmark : .none
         cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
         */
        return cell
    }
    //按下某欄資料後觸發
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "optionToDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //確認要轉跳的segue 可以有多個segue if判斷 分別寫上每個segue要做的事
        if segue.identifier == "optionToDetail"{
            //設定segue的終點view為想跳過去的controller dest為一個controller
            let dest = segue.destination as! detailViewController
            dest.modalPresentationStyle = .fullScreen
            //抓取被選取的row
            let selectedRow = self.tableView.indexPathForSelectedRow
            print(selectedRow)
            //設定點了哪個cell
            var cell = tableView.cellForRow(at: selectedRow!) as! optionTableViewCell
            //把點到的cell的資料assign給另個畫面的暫存變數
            
            dest.area = areaDesc
            dest.descript = descript
            dest.disease = disease
            dest.sent = sent
            dest.severity = severity
            dest.circle = circle
            dest.x = selectedRow?.row as! Int
        }
    }
    
    override func tableView(_ tableView:UITableView,editActionsForRowAt: IndexPath) -> [UITableViewRowAction]?{
        //用UITableViewRowAction是定義左滑出現的按鈕 handler內的閉包要定義按下此按鈕後出現的alert選單
        //UITableViewRowAction定義左滑出現按鈕 handler閉包內定義按下按鈕後出現的alert選單
        let deletAction = UITableViewRowAction(style:.default,title:"Delete",handler: {
            //傳入RowAction和indexpath然後刪除
            (action:UITableViewRowAction, indexPath:IndexPath) -> Void in
            self.sent.removeObject(at: indexPath.row)
            self.headline.removeObject(at: indexPath.row)
            self.descript.removeObject(at: indexPath.row)
            self.web.removeObject(at:indexPath.row)
            self.severity.removeObject(at:indexPath.row)
            self.disease.removeObject(at: indexPath.row)
            self.areaDesc.removeObject(at: indexPath.row)
            self.circle.removeObject(at: indexPath.row)
            
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            
        })
        let webLinkAction = UITableViewRowAction(style:.destructive, title: "CDC", handler: { (action:UITableViewRowAction, indexPath:IndexPath) -> Void in
            UIApplication.shared.open(URL(string: self.web[indexPath.row] as! String)!, options: [:], completionHandler: nil)
        })
        webLinkAction.backgroundColor = .link
        //要return有哪些UITableViewRowAction
        return [deletAction,webLinkAction]
    }
    
    
    func jsonParsingFromURL(){
        //request會有一個URLRequest
        let request = NSMutableURLRequest(url: NSURL(string: "https://www.cdc.gov.tw/TravelEpidemic/ExportJSON")! as URL)
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
    
    
    func startParsing(data:NSData){
        //把NSData資料解析成NSArray放到變數dictdata
        let dictdata:NSArray = (try! JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSArray
        for i in 0..<(dictdata.count){
            
            if continent.contains((dictdata[i] as! NSDictionary).value(forKey: "ISO3166") as? String){
                sent.add((dictdata[i] as! NSDictionary).value(forKey: "sent") as! NSString)
                headline.add((dictdata[i] as! NSDictionary).value(forKey: "headline") as! NSString)
                descript.add((dictdata[i] as! NSDictionary).value(forKey: "description") as! NSString)
                web.add((dictdata[i] as! NSDictionary).value(forKey: "web") as! NSString)
                severity.add((dictdata[i] as! NSDictionary).value(forKey: "severity_level") as? NSString)
                disease.add((dictdata[i] as! NSDictionary).value(forKey: "alert_disease") as? NSString)
                areaDesc.add((dictdata[i] as! NSDictionary).value(forKey: "areaDesc") as? NSString)
                circle.add((dictdata[i] as! NSDictionary).value(forKey: "circle") as? NSString)
                
            }
            
            /*sent[i] = ((dictdata[i] as! NSDictionary).value(forKey: "sent") as! NSString)
            headline[i] = ((dictdata[i] as! NSDictionary).value(forKey: "headline") as! NSString)
            descript[i] = ((dictdata[i] as! NSDictionary).value(forKey: "description") as! NSString)
            web[i] = ((dictdata[i] as! NSDictionary).value(forKey: "web") as! NSString)
            severity[i] = ((dictdata[i] as! NSDictionary).value(forKey: "severity_level") as? NSString)
            disease[i] = ((dictdata[i] as! NSDictionary).value(forKey: "alert_disease") as? NSString)
            areaDesc[i] = ((dictdata[i] as! NSDictionary).value(forKey: "areaDesc") as? NSString)
            circle[i] = ((dictdata[i] as! NSDictionary).value(forKey: "circle") as? NSString)*/
        }
        //把工作self.tableView.reloadData()丟到main執行緒去做
        DispatchQueue.main.async{
            self.tableView.reloadData()
        }
    }
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
