//
//  Schedule_Module.swift
//  Jvon
//
//  Created by Zack on 2018-11-11.
//  Copyright © 2018 jvonmedical. All rights reserved.
//

import UIKit
protocol ScheduleModelDelegate {
    func itemsDownloaded(schedules:[Doctor_Schedule])
}

class Schedule_Module:NSObject {
    
    var delegate:ScheduleModelDelegate?
    
    func getItem(){
        //get the web service Url
        let serviceUrl = "http://192.168.144.145/test.php/"
        //Download the json data
        let url = URL(string:serviceUrl)
        var req = URLRequest(url:url!)
        req.httpMethod="POST"
        let poststring = "provider = 1 && start = 2018-9-10 && end = 2018-9-15"
        req.httpBody = poststring.data(using: String.Encoding.utf8)
        
        
//        if let url = url{
            // Create a URL Session
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with:req,completionHandler:{
                (data,response,error) in
                guard let data = data, error == nil else{
                    print("error=")
                    return
                }
               // if error == nil{
                    //success
                    //call the parse json fucntion on the data
                    //Parse it out into doctor_List structs
                //print("success connection")
                    //                    let dataAsString = String(data:data!,encoding:.utf8)
                    //                    print(dataAsString)
                    
                self.parseJson(data:data)
                
               // }
               // else{
                    //error occurred
                    //print("error occurred in URLsession")
              //  }
            })
//        let task = URLSession.shared.dataTask(with: req){
//            (data:Data?,response:URLResponse?,error:Error?) in
//            if error == nil{
//                self.parseJson(data!)
//            }
//            else{
//                //error occurred
//                print("error occurred in URLsession")
//            }
//        }
        /*
        if let url = url{
            // Create a URL Session
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with:url,completionHandler:{
                (data,response,error) in
                if error == nil{
                    //success
                    //call the parse json fucntion on the data
                    //Parse it out into doctor_List structs
                    print("success connection")
//                    let dataAsString = String(data:data!,encoding:.utf8)
//                    print(dataAsString)
                    
                    self.parseJson(data!)
                }
                else{
                    //error occurred
                    print("error occurred in URLsession")
                }
            })
 */
            //start the task(need to manually type it out then the task is activated)
            // ez to forget
            task.resume()
            
            //Notify the view controller and pass the data back
//        }
    }

    func parseJson(data:Data){
        var week_schedule = [Doctor_Schedule]()
        
        
        // Parse the data into structs
        do{
            //Parse the data into json object
            //            let schedule = try JSONDecoder().decode(Doctor_Schedule.self, from: Data)
            //            print(schedule.id)
            
            let jsonArray = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [Any]
            // loop throught each result in each array
            
            for jsonResult in jsonArray{
                // Cast json reuslt as a dictionary
                
                let jsonDict = jsonResult as! [String:String]
                
                //let docId = jsonDict["id"] as? String
                //Create new schedule and set its properties
                let schedule = Doctor_Schedule(
                    id: jsonDict["id"]!,
                    sdate: jsonDict["sdate"]!)
                
                // Add it to the array
                week_schedule.append(schedule)
            }
            
            //TODO: pass the schedule back to delegate
            self.delegate?.itemsDownloaded(schedules: week_schedule)
        }
        catch let error{
            print(error)
        }
    }

    
}
