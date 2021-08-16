//
//  CovidCollectionViewController.swift
//  GlobalDisease
//
//  Created by 姚思妤 on 2020/6/23.
//  Copyright © 2020 姚思妤. All rights reserved.
//
import Foundation
import UIKit

class CovidCollectionViewController: UICollectionViewController {

    var confirmed:Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        jsonParsingFromURL()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "covidCell")

        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 5
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "covidCell", for: indexPath) as! CovidCollectionViewCell
        cell.backgroundColor = .some(UIColor(#colorLiteral(red: 0.2274509804, green: 0.2509803922, blue: 0.2823529412, alpha: 1)))
        cell.contentView.layer.cornerRadius = 3
        
        
        //設定label寬高、位置
        cell.status.frame = CGRect(x: 30, y: 10, width: 400, height: 80)
        cell.people.frame = CGRect(x: 70, y: 30, width: 400, height: 80)
        //設定label字體大小
        cell.status.font = cell.status.font.withSize(25)
        //設定粗體、斜體
        //cell.status.font = UIFont.italicSystemFont(ofSize: 15.0)
        //cell.people.font = UIFont.boldSystemFont(ofSize: 15)
        
        if indexPath.row == 0{
            cell.status.text = "確診人數"
            cell.status.textColor = .white
            cell.people.text = "9,257,393"
            cell.people.textColor = .green
            cell.people.font = cell.people.font.withSize(50)
            cell.people.frame = CGRect(x: 100, y: 130, width: 400, height: 80)
        }
        else{
            
            cell.status.textColor = .white
            cell.status.frame = CGRect(x: 20, y: 20, width: 400, height: 80)
            cell.people.frame = CGRect(x: 70, y: 100, width: 400, height: 80)
            var r = indexPath.row
            switch r {
            case 1:
                cell.status.text = "死亡人數"
                cell.people.text = "476,474"
                cell.people.textColor = .systemRed
            case 2:
                cell.status.text = "感染人數"
                cell.people.text = "3,823,757"
                cell.people.textColor = .systemOrange
            case 3:
                cell.status.text = "康復人數"
                cell.people.text = "4,948,162"
                cell.people.textColor = UIColor(#colorLiteral(red: 0.431372549, green: 0.5897291839, blue: 0.9137254902, alpha: 1))
            case 4:
                cell.status.text = "總檢測人數"
                cell.people.text = "133,464,268"
                cell.people.textColor = .systemTeal
                cell.people.frame = CGRect(x: 40, y: 100, width: 400, height: 80)
            default:
                cell.people.textColor = .red
            }
        }
    
        // Configure the cell
    
        return cell
    }
    
    

    func jsonParsingFromURL(){
        //request會有一個URLRequest
        let request = NSMutableURLRequest(url: NSURL(string: "https://en.wikipedia.org/w/api.php?action=query&titles=Template:Cases_in_the_COVID-19_pandemic&prop=revisions&rvprop=content&format=json")! as URL)
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
        
        let dictdata:NSDictionary=(try! JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary

        let revisions:NSMutableArray = (((((dictdata.value(forKey: "query") as! NSDictionary).value(forKey: "pages") as! NSDictionary).value(forKey: "63271973") as! NSDictionary).value(forKey: "revisions") as! NSArray).value(forKey: "*") as! NSArray).mutableCopy() as! NSMutableArray
        
        let revisionString = revisions as NSArray
        let revisionString2 = revisionString[0] as! String
        print(revisionString2+"234")
        //revision[{ob1},{ob2},{ob3}]
        /*for i in 0..<(dictdata.count){
            //continentCode?.insert((dictdata[i] as! NSDictionary).value(forKey: "Continent_Code") as! String)
            Global[i] = (dictdata[i] as! NSDictionary).value(forKey: "Two_Letter_Country_Code") as! NSString
            continentCode[i] = (dictdata[i] as! NSDictionary).value(forKey: "Continent_Code") as! NSString
            
            let stringContinent = continentCode[i] as! String
            
        }
        
        //把工作self.tableView.reloadData()丟到main執行緒去做
        DispatchQueue.main.async{
            
        }*/
        
    }
    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}

extension CovidCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let fullScreenSize = UIScreen.main.bounds.size
        let covidLabel = UILabel(frame: CGRect(x: 110, y: 10, width: CGFloat(fullScreenSize.width)-30, height: 100))
        covidLabel.text = "Covid-19"
        covidLabel.textColor = .red
        covidLabel.font = UIFont.boldSystemFont(ofSize: 50.0)
        collectionView.addSubview(covidLabel)
        if indexPath.row == 0{
            return CGSize(width: CGFloat(fullScreenSize.width)-30, height: 230)
        }
        else{
            return CGSize(width: CGFloat(fullScreenSize.width)/2-28, height: 180)
        }
        
    }
}


/*extension NSRegularExpression {
    convenience init(_ pattern: String) {
        do {
            try self.init(pattern: pattern)
        } catch {
            preconditionFailure("Illegal regular expression: \(pattern).")
        }
    }
}

extension NSRegularExpression {
    func matches(_ string: String) -> Bool {
        let range = NSRange(location: 0, length: string.utf16.count)
        return firstMatch(in: string, options: [], range: range) != nil
    }
}

extension String {
    static func ~= (lhs: String, rhs: String) -> Bool {
        guard let regex = try? NSRegularExpression(pattern: rhs) else { return false }
        let range = NSRange(location: 0, length: lhs.utf16.count)
        return regex.firstMatch(in: lhs, options: [], range: range) != nil
    }
}
*/

