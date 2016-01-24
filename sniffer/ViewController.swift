//
//  ViewController.swift
//  sniffer
//
//  Created by Koji Ota on 2016/01/23.
//  Copyright © 2016年 Koji Ota. All rights reserved.
//

import Cocoa
import Foundation
import SwiftyJSON

class ViewController: NSViewController {

	@IBOutlet weak var snifferTable: NSTableView!
	@IBOutlet weak var snifferKey: NSTextField!
	@IBOutlet weak var snifferValue: NSTextField!
	
	var rowNumber: Int?
	var messageArr:[String] = []
	var subKeyArr:[String] = []
	override func viewDidLoad() {
		super.viewDidLoad()
		getSniffer()
		print("viwe did load")
		// Do any additional setup after loading the view.
	}

	override var representedObject: AnyObject? {
		didSet {
		// Update the view, if already loaded.
		}
	}

	func numberOfRowsInTableView(aTableView: NSTableView) -> Int
	{
		if let rowNumber = rowNumber {
			return rowNumber
		}
		return 6
	}
	
	func tableView(aTableView: NSTableView, objectValueForTableColumn aTableColumn: NSTableColumn?, row rowIndex: Int) -> AnyObject?
	{
		let columnName = aTableColumn?.identifier
//		print(aTableColumn?.identifier)
//		print(rowIndex)
		if columnName == "key" {
			return subKeyArr[rowIndex]
		} else if columnName == "value" {
			return messageArr[rowIndex]
		}
		return "hogehoge"
	}
	
	func getSniffer() {
		var task:NSTask = NSTask()
	  task.launchPath = "/usr/bin/php"
	  task.arguments = ["/Users/koji/development/sniffer/hoge.php"]
		var pipe:NSPipe = NSPipe()
		task.standardOutput = pipe
		task.launch()
		var output:NSData = pipe.fileHandleForReading.readDataToEndOfFile()
//		var outputStr:NSString = NSString(data:output,encoding:NSUTF8StringEncoding)!
//		if let dataFromString = outputStr.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
//			let json = JSON(data: dataFromString)
//		}
//		let json2 = JSON(data: output)
		let json1 = JSON(data: output)
//		print(json1)
		for (_, json3):(String, JSON) in json1 {
//			print(json3)
//			print("hoge")
			for(name, json2):(String, JSON) in json3 {
    		for (key, subJson):(String, JSON) in json2 {
    			if((subJson[1] == "addError") || (subJson[1] == "addWarning") || (subJson[1] == "addFixableError")) {
//    				subKeyArr.append(json2[Int(key)!+8][1].string!)
						let str: String = json2[Int(key)!+8][1].string!
//						print(str.substringWithRange(Range(start: str.startIndex.successor(), end: str.endIndex.predecessor())))
    				subKeyArr.append(name + "." + str.substringWithRange(str.startIndex.successor()..<str.endIndex.predecessor()))
    				if let warn_error = (json2[Int(key)!+2][1]).string {
    					if warn_error.substringToIndex(warn_error.startIndex.advancedBy(1)) == "$" {
    						for i in (0...(Int(key)!-3)).reverse() {
    							if json2[i][1].string == warn_error {
    								messageArr.append(json2[i+4][1].string!)
    								break
    							}
    						}
    					} else {
    						messageArr.append(warn_error)
    					}
    				}
    			}
    		}
			}
		}
//		print(subKeyArr);
		print(subKeyArr.count);
//		print(messageArr);
		print(messageArr.count);
		rowNumber = messageArr.count
	}
}