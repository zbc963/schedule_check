//
//  FirstViewController.swift
//  Jvon
//
//  Created by Zack on 2018-11-08.
//  Copyright © 2018 jvonmedical. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, ScheduleModelDelegate,UITableViewDataSource,UITableViewDelegate{
    
    
    @IBOutlet weak var tableView: UITableView!
    var schedule = Schedule_Module()
    var week_schedule = [Doctor_Schedule]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set self as the table view's data source and delegate
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view, typically from a nib.
        // initiate calling the items download
        schedule.getItem()
        schedule.delegate = self
        
    }
    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//    }
    
    func itemsDownloaded(schedules: [Doctor_Schedule]) {
        week_schedule = schedules
        DispatchQueue.main.async { [unowned self] in
            self.tableView.reloadData()
        }
        
    }

    // Mark: UITableView delegate method
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            print(week_schedule.count)
            return week_schedule.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell", for: indexPath)
        
        cell.textLabel?.text = week_schedule[indexPath.row].sdate
        return cell
    }
}

