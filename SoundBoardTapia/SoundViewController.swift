//
//  SoundViewController.swift
//  SoundBoardTapia
//
//  Created by Mac 19 on 24/05/23.
//

import UIKit
import AVFoundation

class SoundViewController: UIViewController {

    //var Grabacion : [Grabacion] = []

    
    @IBOutlet weak var grabarButton: UIButton!
    
    @IBOutlet weak var reproducirButton: UIButton!
    
    @IBOutlet weak var TextField: UITextField!
    
    @IBOutlet weak var agregarButton: UIButton!
    
    
    @IBAction func grabarTapped(_ sender: Any) {
        
        if grabarAudio!.isRecording{
            grabarAudio?.stop()
            grabarButton.setTitle("GRABAR", for: .normal)
            reproducirButton.isEnabled = true
            agregarButton.isEnabled = true
        } else {
            grabarAudio?.record()
            grabarButton.setTitle("DETENER", for: .normal)
            reproducirButton.isEnabled = false

        }
        
    }
    
    @IBAction func reproducirTapped(_ sender: Any) {
        
        do{
            try reproducirAudio = AVAudioPlayer(contentsOf: audioURL!)
            reproducirAudio!.play()
            print("Reproduciendo")
        } catch{
            
        }
    }
    
    @IBAction func agregarTapped(_ sender: Any) {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let grabacion = Grabacion(context: context)
        grabacion.nombre = TextField.text
        grabacion.audio = NSData(contentsOf: audioURL!)! as Data
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        navigationController?.popViewController(animated: true)
        
    }
    
    
    var grabarAudio:AVAudioRecorder?
    var reproducirAudio: AVAudioPlayer?
    var audioURL: URL?
    
    
    func configurarGrabacion() {
        
        do{
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: [])
            try session.overrideOutputAudioPort(.speaker)
            try session.setActive(true)
            
            
            let basePath:String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let pathComponents = [basePath, "audio.m4a"]
            audioURL = NSURL.fileURL(withPathComponents: pathComponents)!
            
            print("***********")
            print(audioURL!)
            print("***********")
            
            
            var settings: [String:AnyObject] = [:]
            settings[AVFormatIDKey] = Int(kAudioFormatMPEG4AAC) as AnyObject?
            settings[AVSampleRateKey] =  44100.0 as AnyObject?
            settings[AVNumberOfChannelsKey] = 2 as AnyObject?
            
            grabarAudio = try AVAudioRecorder(url: audioURL!, settings: settings)
            grabarAudio!.prepareToRecord()


        } catch let error as NSError{
            print(error)
        }
        
    }
    
    //´´´´´´´´´´´
    override func viewDidLoad() {
        super.viewDidLoad()
        configurarGrabacion()
        reproducirButton.isEnabled = false
        agregarButton.isEnabled = false
    }
    

   

}
