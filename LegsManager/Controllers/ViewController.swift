//
//  ViewController.swift
//  BluetoothTest
//
//  Created by Nicolas Nascimento on 15/12/17.
//  Copyright © 2017 Nicolas Nascimento. All rights reserved.
//

import UIKit
import Intents
import CoreBluetooth

final class ViewController: UIViewController {
    // MARK: - Private Properties
    private var communicatorLeft: ArduinoCommunicator!
    private var communicatorRight: ArduinoCommunicator!
    
    
    @IBOutlet weak var lblConnected: UILabel!
    @IBOutlet weak var btnLeftWalk: UIButton!
    @IBOutlet weak var lblConnectedLeft: UILabel!
    @IBOutlet weak var lblConnectedRight: UILabel!
    @IBOutlet weak var lblFallRight: UILabel!
    @IBOutlet weak var lblFallLeft: UILabel!
    @IBOutlet weak var swSync: UISwitch!
    @IBOutlet weak var btnOffRight: UIButton!
    @IBOutlet weak var btnOffLeft: UIButton!
    @IBOutlet weak var btnSeatRight: UIButton!
    @IBOutlet weak var btnSeatLeft: UIButton!
    @IBOutlet weak var btnWalkRight: UIButton!
    
    
    
       override func viewDidLoad() {
           super.viewDidLoad()
           
          INPreferences.requestSiriAuthorization { (status) in
              
          }
           
       }
    // MARK: - View Controller Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        self.communicatorLeft = ArduinoCommunicator(delegate: self, side: "left", expectedPeripheralUUIDString: "D7AB43CA-4BB0-759C-75F3-EB7C770365DB")
        self.communicatorRight = ArduinoCommunicator(delegate: self, side: "right"
            , expectedPeripheralUUIDString: "50B2BF09-E43E-6BDB-2F58-2D19BC4CA735")
        
        btnWalkRight.isEnabled = !swSync.isOn
         btnSeatRight.isEnabled = !swSync.isOn
         btnOffRight.isEnabled = !swSync.isOn
    }
    @IBAction func syncChanged(_ sender: Any) {
        btnWalkRight.isEnabled = !swSync.isOn
        btnSeatRight.isEnabled = !swSync.isOn
        btnOffRight.isEnabled = !swSync.isOn
    }
    
    
    @IBAction func sendLeftSeatCommand(_ sender: Any) {
        self.communicatorLeft.send(value: "M:seat*")
               if(swSync.isOn){
                 self.communicatorRight.send(value: "M:seat*")
               }
    }
    
    
    @IBAction func sendLeftOffCommand(_ sender: Any) {
        self.communicatorLeft.send(value: "M:off*")
               if(swSync.isOn){
                 self.communicatorRight.send(value: "M:off*")
               }
        
    }
    
    @IBAction func sendRightSeatCommand(_ sender: Any) {
        self.communicatorRight.send(value: "M:seat*")
    }
    
    @IBAction func sendRightOffCommand(_ sender: Any) {
          self.communicatorRight.send(value: "M:off*")
    }
    
    
    @IBAction func sendRightWalkCommand(_ sender: Any) {
         self.communicatorRight.send(value: "M:walk*")
    }
    
    // MARK: - Actions
    @IBAction func sendLeftWalkCommand(_ sender: Any) {
   
        self.communicatorLeft.send(value: "M:walk*")
        if(swSync.isOn){
          self.communicatorRight.send(value: "M:walk*")
        }
    }

}

extension ViewController: ArduinoCommunicatorDelegate {
    func communicatorDidConnect(_ communicator: ArduinoCommunicator) {
        if( communicator.side == "left" )
        {lblConnectedLeft.isHidden = false}
        if( communicator.side == "right" )
        {lblConnectedRight.isHidden = false}
    }
    
    func communicatorDidDisconnect(_ communicator: ArduinoCommunicator) {
           if( communicator.side == "left" )
           {lblConnectedLeft.isHidden = true}
           if( communicator.side == "right" )
           {lblConnectedRight.isHidden = true}
       }
       
    
    
    func communicator(_ communicator: ArduinoCommunicator, didRead data: Data) {
        print(#function)
        print("read")
        var command = String(data: data, encoding: .ascii)
        var value = command?.split(separator: "*")
        var parts = value?[0].split(separator: ":")
        switch parts?[0] {
        case "mode":
            if ( communicator.side == "left" ){
                
               lblFallLeft.isHidden = parts?[1] != "fall";
            }
            else{
               lblFallRight.isHidden = parts?[1] != "fall";
            }
              if ( communicator.side == "left" ){
            
                if ( parts?[1] == "walk" ){
                    btnLeftWalk.backgroundColor = UIColor.green
                    
                }
                else
                {
                       btnLeftWalk.backgroundColor = UIColor.white
                }
            
            if ( parts?[1] == "seat" ){
                   btnSeatLeft.backgroundColor = UIColor.green
                   
               }
               else
               {
                    btnSeatLeft.backgroundColor = UIColor.white
               }
            if ( parts?[1] == "off" ){
                              btnOffLeft.backgroundColor = UIColor.green
                              
                          }
                          else
                          {
                               btnOffLeft.backgroundColor = UIColor.white
                          }
            }
              else{
                if ( parts?[1] == "walk" ){
                                  btnWalkRight.backgroundColor = UIColor.green
                                  
                              }
                              else
                              {
                                     btnWalkRight.backgroundColor = UIColor.white
                              }
                          
                          if ( parts?[1] == "seat" ){
                                 btnSeatRight.backgroundColor = UIColor.green
                                 
                             }
                             else
                             {
                                  btnSeatRight.backgroundColor = UIColor.white
                             }
                          if ( parts?[1] == "off" ){
                                            btnOffRight.backgroundColor = UIColor.green
                                            
                                        }
                                        else
                                        {
                                             btnOffRight.backgroundColor = UIColor.white
                                        }
            }
        default:
            print("comman \(command)")
        }
        print(String(data: data, encoding: .ascii)!)
    }
    func communicator(_ communicator: ArduinoCommunicator, didWrite data: Data) {
        print(#function)
        print("write")
        print(String(data: data, encoding: .utf8)!)
    }
}
