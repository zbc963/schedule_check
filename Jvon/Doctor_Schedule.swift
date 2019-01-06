//
//  Doctor_List.swift
//  Jvon
//
//  Created by Zack on 2018-11-11.
//  Copyright © 2018 jvonmedical. All rights reserved.
//

import Foundation


struct Doctor_Schedule:Decodable{
    var hour=""
    var last_name = ""
    var first_name=""
    var sdate=""
}


struct upload:Codable{
    let sdate:String
    let hour:String
    let last_name:String
    
}
