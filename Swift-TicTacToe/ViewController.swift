//
//  ViewController.swift
//  Swift-TicTacToe
//
//  Created by GreggColeman on 7/14/15.
//  Copyright (c) 2015 GreggColeman. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    
    @IBOutlet var ticTacImg1: UIImageView!
    @IBOutlet var ticTacImg2: UIImageView!
    @IBOutlet var ticTacImg3: UIImageView!
    @IBOutlet var ticTacImg4: UIImageView!
    @IBOutlet var ticTacImg5: UIImageView!
    @IBOutlet var ticTacImg6: UIImageView!
    @IBOutlet var ticTacImg7: UIImageView!
    @IBOutlet var ticTacImg8: UIImageView!
    @IBOutlet var ticTacImg9: UIImageView!
    
    
    @IBOutlet var tickTacBtn1: UIButton!
    @IBOutlet var tickTacBtn2: UIButton!
    @IBOutlet var tickTacBtn3: UIButton!
    @IBOutlet var tickTacBtn4: UIButton!
    @IBOutlet var tickTacBtn5: UIButton!
    @IBOutlet var tickTacBtn6: UIButton!
    @IBOutlet var tickTacBtn7: UIButton!
    @IBOutlet var tickTacBtn8: UIButton!
    @IBOutlet var tickTacBtn9: UIButton!
    
    
    @IBOutlet var resetBtn: UIButton!
    @IBOutlet var userMessage: UILabel!
    
    var playsMade = Dictionary<Int,Int>()
    var aiDeciding = false
    var done = false
    
    @IBAction func  UIButtonClicked(sender:UIButton){
        
        userMessage.hidden = true
        
        if((playsMade[sender.tag]) == nil && !aiDeciding && !done){
            setImageForSpot(sender.tag, player: 1)
        }
        
        checkForWin()
        aiTurn()
    }
    
    func setImageForSpot(spot:Int, player:Int){
        var playerMark = player == 1 ? "x" : "o"
        playsMade[spot] = player
        
        switch spot{
        case 1:
            ticTacImg1.image = UIImage(named: playerMark)
        case 2:
        ticTacImg2.image = UIImage(named: playerMark)
        case 3:
        ticTacImg3.image = UIImage(named: playerMark)
        case 4:
        ticTacImg4.image = UIImage(named: playerMark)
        case 5:
        ticTacImg5.image = UIImage(named: playerMark)
        case 6:
        ticTacImg6.image = UIImage(named: playerMark)
        case 7:
        ticTacImg7.image = UIImage(named: playerMark)
        case 8:
        ticTacImg8.image = UIImage(named: playerMark)
        case 9:
        ticTacImg9.image = UIImage(named: playerMark)
        
        default:
            ticTacImg6.image = UIImage(named: playerMark)
        }
     }
    
    @IBAction func ResetBtn_Clicked(sender: UIButton) {
        resetBtn.hidden = true
        userMessage.text = ""
        userMessage.hidden = true
        done = false
        aiDeciding = false
        reset()
    }
    
    func reset(){
        playsMade = [:]
        ticTacImg1.image = nil
        ticTacImg2.image = nil
        ticTacImg3.image = nil
        ticTacImg4.image = nil
        ticTacImg5.image = nil
        ticTacImg6.image = nil
        ticTacImg7.image = nil
        ticTacImg8.image = nil
        ticTacImg9.image = nil
        
    }
    
    func checkForWin(){
        var whoWon = ["I":0,"you":1]
        
        for(key, value) in whoWon{
            // Check if any of the possible wins occured
            if((playsMade[7] == value && playsMade[8] == value && playsMade[9] == value) || // accross bottom)
                (playsMade[4] == value && playsMade[5] == value && playsMade[6] == value) || // accross middle
                (playsMade[1] == value && playsMade[2] == value && playsMade[3] == value) || // accross top
                (playsMade[1] == value && playsMade[4] == value && playsMade[7] == value) || // top left
                (playsMade[2] == value && playsMade[5] == value && playsMade[8] == value) || // top center
                (playsMade[3] == value && playsMade[6] == value && playsMade[9] == value) || // top right
                (playsMade[1] == value && playsMade[5] == value && playsMade[9] == value) || // left cross
                (playsMade[3] == value && playsMade[5] == value && playsMade[7] == value)  // right cross
                ){
                  
                    userMessage.hidden = false
                    userMessage.text = "Looks like \(key) won!"
                    resetBtn.hidden = false
                    done = true
            }
        
        }
    }
    
    func checkTop(#value:Int) -> (location:String, pattern:String){
        return ("top",checkFor(value, inList:[1,2,3]))
    }
    
    func checkBottom(#value:Int) -> (location:String, pattern:String){
        return ("bottom",checkFor(value, inList:[7,8,9]))
    }
    
    func checkLeft(#value:Int) -> (location:String, pattern:String){
        return ("left",checkFor(value, inList:[1,4,7]))
    }
    
    func checkRight(#value:Int) -> (location:String, pattern:String){
        return ("right",checkFor(value, inList:[3,6,9]))
    }
    
    func checkFor(value:Int, inList:[Int]) -> String{
        var conclusion = ""
        for cell in inList{
            if playsMade[cell] == value{
                conclusion += "1"
            }
            else{
                conclusion += "0"
            }
        }
        return conclusion
    }
    
    func rowCheck(#value:Int) -> (location:String,pattern:String)?{
        var acceptableFinds = ["011","110","101"]
        var findFuncs=[checkTop,checkBottom,checkLeft,checkRight]
        
        for algorithm in findFuncs{
            var algorithmResults = algorithm(value:value)
            if (find(acceptableFinds,algorithmResults.pattern) != nil){
                return algorithmResults
            }
        }
        return nil
    }
    
    func isOccupied (spot:Int) -> Bool{
        println(playsMade[spot])
        return Bool(playsMade[spot] != nil)
    }
    
    func firstAvailable(#isCorner:Bool) -> Int?{
        var spots = isCorner ? [1,3,7,9] : [2,4,6,8]
        
        for spot in spots{
            if !isOccupied(spot){
                return spot
            }
        }
        return nil
    }
    
    func aiTurn(){
        if done{
            return
        }
        aiDeciding = true
        
        // We (the pc) have 2 in a row go for a win
        if let result = rowCheck(value:0)
        {
            var whereToPlayResult = whereToPlay(result.location, pattern:result.pattern)
            if !isOccupied(whereToPlayResult){
                setImageForSpot(whereToPlayResult, player: 0)
                aiDeciding = false
                checkForWin()
                return
            }
        }
       
        // We (the player) have 2 in a row ai should block it
        if let result = rowCheck(value:1)
        {
            var whereToPlayResult = whereToPlay(result.location, pattern:result.pattern)
            if !isOccupied(whereToPlayResult){
                setImageForSpot(whereToPlayResult, player: 0)
                aiDeciding = false
                checkForWin()
                return
            }
        }

        // is center available
        if !isOccupied(5){
            setImageForSpot(5,  player: 0)
            aiDeciding = false
            checkForWin()
            return
        }
        
        //is corner available
        if let cornerAvailable = firstAvailable(isCorner: true){
            setImageForSpot(cornerAvailable,player: 0)
            aiDeciding = false
            checkForWin()
            return
        }
       
        //is side available
        if let sideAvailable = firstAvailable(isCorner: false){
            setImageForSpot(sideAvailable,player: 0)
            aiDeciding = false
            checkForWin()
            return
        }
        
        userMessage.hidden = false
        userMessage.text = "Looks like it was a tie!"
        reset()
        aiDeciding = false
    }
    
    func whereToPlay(location:String,pattern:String) -> Int{
        var leftPattern = "001"
        var rightPattern = "110"
        var middlePattern = "101"
        
        switch location {
            case "top":
                if(pattern == leftPattern){
                    return 1
            }else if (pattern == rightPattern){
                    return 3
                }else if pattern == middlePattern {
                    return 2
            }
            case "bottom":
            if(pattern == leftPattern){
                return 4
            }else if(pattern == rightPattern){
                return 6
            }else if pattern == middlePattern{
                return 5
            }
            case "left":
                if(pattern == leftPattern){
                    return 1
                }else if pattern == rightPattern{
                    return 7
                }else if pattern == middlePattern{
                    return 4
            }
            case "right":
                if pattern == leftPattern{
                    return 3
                }else if pattern == rightPattern{
                    return 9
                }else if pattern == middlePattern{
                    return 6
            }
            
        default:
            return 4
        }
        
        return 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

