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
  
    func getItem(date: String,doctor: String){
//        get the web service Url
        print(date)
        print(doctor.lowercased())
        let parameters = ["sdate":date,"hour":"","last_name":"philip"]


        guard let jsonData = try? JSONSerialization.data(withJSONObject: parameters, options: [])else{
            return
        }
        print(String(data: jsonData, encoding: .utf8)!)

        let serviceUrl = "http://192.168.144.172/test.php/"
//        Download the json data
        guard let url = URL(string:serviceUrl) else {return}
        var request = URLRequest(url: url)
        request.httpMethod="POST"
        request.setValue("application/json", forHTTPHeaderField: "content-type")

        request.httpBody = jsonData

//         Now let's encode out Post struct into JSON data...
   /// workable

  
        let task = URLSession.shared.dataTask(with: request){ data, response, error in
            if let error = error{
                print("error:\(error)")
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                      (200...299).contains(response.statusCode) else{
                        print ("server error")
                        return
            }
           
            if let mimeType = response.mimeType,
                mimeType == "application/json",
                let data = data{

                    self.parseJson(data)
                }
        }
        task.resume()
    }
        


    func parseJson(_ data:Data){
        var week_schedule = [Doctor_Schedule]()


        // Parse the data into structs
        do{
            //Parse the data into json object

            let jsonArray = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [Any]
            // loop throught each result in each array

            for jsonResult in jsonArray{
                // Cast json reuslt as a dictionary

                let jsonDict = jsonResult as! [String:String]

                //Create new schedule and set its properties
                let schedule = Doctor_Schedule(
                    hour: jsonDict["hour"]!,
                    last_name: jsonDict["last_name"]!,
                    first_name: jsonDict["first_name"]!,
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
