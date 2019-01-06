//
//  FirstViewController.swift
//  Jvon
//
//  Created by Zack on 2018-11-08.
//  Copyright © 2018 jvonmedical. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, ScheduleModelDelegate,UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITextViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Doctors.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Doctors[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedDoctor = Doctors[row]
        DoctorDDL.text = selectedDoctor
    }
    var selectedDoctor:String?
    var Doctors = ["", "Dr. Philip", "Dr. Wang"]
    
    func createPickerView(){
        let pickerView = UIPickerView()
        pickerView.delegate = self
        DoctorDDL.inputView = pickerView
        
    }
    @IBOutlet weak var DoctorDDL: UITextField!
    
    
    @IBOutlet weak var DateDDL: UITextField!
    private var datePicker:UIDatePicker?
    
    @IBOutlet weak var SubmitBtn: UIButton!
    @IBAction func ButtonClick(_ sender: UIButton) {
        // Set self as the table view's data source and delegate
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view, typically from a nib.
        // initiate calling the items download
        let selectedDate = DateDDL.text as! String
        let selectedDoctor = DoctorDDL.text as! String
        schedule.getItem(date: selectedDate,doctor: selectedDoctor)
        schedule.delegate = self
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    var schedule = Schedule_Module()
    var week_schedule = [Doctor_Schedule]()
    override func viewDidLoad() {
        super.viewDidLoad()
        dateSelector()
        createPickerView()
    }
    
//define doctor view

//define dateDDL view
    func dateSelector(){
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(FirstViewController.dateChanged(datePicker:)), for: .valueChanged)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(FirstViewController.viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
        DateDDL.inputView = datePicker
        
    }

    // completehandler of datepicker when date is changed by selector
    @objc func dateChanged(datePicker:UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat="yyyy-MM-dd"
        DateDDL.text = dateFormatter.string(from: datePicker.date)
        // set always the last editting string will be the changed date
        view.endEditing(true)
    }
    
    @objc func viewTapped(gestureRecognizer:UITapGestureRecognizer){
        view.endEditing(true)
    }
    
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

