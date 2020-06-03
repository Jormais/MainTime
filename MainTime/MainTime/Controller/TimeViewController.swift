//
//  ViewController.swift
//  MainTime
//
//  Created by Jonay Brito Hernández on 14/02/2020.
//  Copyright © 2020 Jonay Brito Hernández. All rights reserved.
//

import UIKit

class TimeViewController: UIViewController {
    
    var time = Timer()
    var timeActive = false
    var pause = false
    var timeCount = 0
    var textLabel : [String] = []
    
    @IBOutlet var timeLabel : UILabel!
    @IBOutlet var pauseButton : UIButton!
    @IBOutlet var titleLabel : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timeLabel.text = "00:00:00"
        pauseButton.setTitle("Pause", for: UIControl.State.normal)
        titleLabel.text = EventClass.event.nameEvent
    }
    
    @IBAction func timeFired() { //funcion que activa el temporizador y contador
        if timeActive == false {
            timeActive = true
            time = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (tim) in
                self.timeCount+=1
                self.timeLabel.text = self.timeString(time: TimeInterval(self.timeCount))
//                print(tim.fireDate)
            })
        }
    }
    
    @IBAction func timePause() { //funcion para pausar y reanudar
        if pause == false && timeActive == true { //validamos si podemos pausar
            time.invalidate()
            pause = true
            timeActive = false
            pauseButton.setTitle("Reanude", for: UIControl.State.normal)
        }else if pause == true && timeCount != 0{// validamos si podemos reanudar
            timeFired()
            pause = false
            timeActive = true
            pauseButton.setTitle("Pause", for: UIControl.State.normal)
        }
    }
    
    @IBAction func timeStop(){ //paramos el timer y almacenamos los valores en 0
        time.invalidate()
        timeActive = false
        timeCount = 0
        timeLabel.text = "00:00:00"
    }
    
    func timeString(time:TimeInterval) -> String { //funcion para formatear salida de texto
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
    
}

