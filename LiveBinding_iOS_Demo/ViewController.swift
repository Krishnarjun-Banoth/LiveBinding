//
//  ViewController.swift
//  LiveBinding_iOS_Demo
//
//  Created by apple on 02/08/18.
//  Copyright © 2018 efftronics. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var qustionBgView: RoundView!
    
    @IBOutlet weak var quetionLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var remainingSeconds: UILabel!
    @IBOutlet weak var yesButton: RoundedButtons!
    @IBOutlet weak var noButton: RoundedButtons!
    @IBOutlet weak var nextButton: RoundedButtons!
    @IBOutlet weak var scoreLabel: UILabel!
    
    var myScore = 0
    let operatorArray = ["+","-","*","/"]
    let manipulateResultArray = [true,false]
    let manipulationFactorsArray = [1,2,3,4,5,6,7,8,9]
    let randomQuestionViewColor = [#colorLiteral(red: 0.4620226622, green: 0.8382837176, blue: 1, alpha: 1), #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1),#colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1),#colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1), #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1),#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1),#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1),#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1),#colorLiteral(red: 0.3098039329, green: 0.2039215714, blue: 0.03921568766, alpha: 1),#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1),#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),#colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1),#colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0.9374520706),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.6),#colorLiteral(red: 1, green: 0.6704526362, blue: 0.7059452492, alpha: 1),#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1),#colorLiteral(red: 0.3041452088, green: 0.2928002346, blue: 1, alpha: 1),#colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1),#colorLiteral(red: 0.5808190107, green: 0.0884276256, blue: 0.3186392188, alpha: 1),#colorLiteral(red: 0, green: 0.5690457821, blue: 0.5746168494, alpha: 1),#colorLiteral(red: 0.476841867, green: 0.5048075914, blue: 1, alpha: 1),#colorLiteral(red: 0.5738074183, green: 0.5655357838, blue: 0, alpha: 1),#colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1),#colorLiteral(red: 0, green: 0.5628422499, blue: 0.3188166618, alpha: 1),#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1),#colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)]
    var isManipulationNeeded = false
    var isManipulated = false
    
    var seconds = 30 //timer starting value
    var timer = Timer()
    var focusTimer = Timer()
    var focusSeconds = 60
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        generateNewQuestion()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func NextButtonTapped(_ sender: Any) {
        generateNewQuestion()
        remainingSeconds.text = ""
        resetFocusTimer()
    }
    @IBAction func YesButtonTapped(_ sender: Any) {
        if isManipulated {
            resultLabel.text = "Wrong..!😔"
            myScore = myScore - 5
        }
        else {
            resultLabel.text = "Right..!💐😀"
            myScore = myScore + 5
        }
        answerBtnDidTapped()//To do final setup after answer button tapped
        
    }
    
    @IBAction func NoButtonTapped(_ sender: Any) {
        if isManipulated {
            resultLabel.text = "Right..!💐😀"
            myScore = myScore + 5
        }
        else {
            resultLabel.text = "Wrong..!😔"
            myScore = myScore - 5
        }
        answerBtnDidTapped() //To do final setup after answer button tapped
        
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        seconds -= 1
        remainingSeconds.text = "\(seconds)"
        if seconds < 0 {
            disableAnswerButtons()
            remainingSeconds.text = " "
            myScore = myScore - 1
            scoreLabel.text = String(myScore)
            timer.invalidate()
            resetFocusTimer()
            runFocusTimer()
        }
    }
    func resetTimer() {
        seconds = 30
    }
}
extension ViewController {
    func initialSetupForNewQuestion() {
        enableAnswerButtons()
        resetTimer()
        timer.invalidate()
        runTimer()
        resultLabel.text = ""
    }
    func generateNewQuestion() {
        initialSetupForNewQuestion()
        
        var finalResult = 0
        let randomNumber1 = Int(arc4random_uniform(100)) + 1
        let randomNumber2 = Int(arc4random_uniform(100)) + 1
        let randomOperator = operatorArray[Int(arc4random_uniform(UInt32(operatorArray.count)))]
        
        switch randomOperator {
        case "+":
            finalResult = randomNumber1 + randomNumber2
        case "-":
            finalResult = randomNumber1 - randomNumber2
        case "*":
            finalResult = randomNumber1 * randomNumber2
        case "/":
            finalResult = randomNumber1 / randomNumber2
        default:
            break
        }
        
        isManipulationNeeded = manipulateResultArray[Int(arc4random_uniform(UInt32(manipulateResultArray.count)))]
        if isManipulationNeeded {
            let manipulationOperators = ["+", "-"]
            let manipulationFactor = manipulationFactorsArray[Int(arc4random_uniform(UInt32(manipulationFactorsArray.count)))]
            let manipulationOperator = manipulationOperators[Int(arc4random_uniform(UInt32(manipulationOperators.count)))]
            switch manipulationOperator {
            case "+":
                finalResult = finalResult + manipulationFactor
            case "-":
                finalResult = finalResult - manipulationFactor
            default:
                break
            }
        }
        isManipulated = isManipulationNeeded
        let question = String(randomNumber1) + randomOperator + String(randomNumber2) + " = " + String(finalResult)
        qustionBgView.bgColor = randomQuestionViewColor[Int(arc4random_uniform(UInt32(randomQuestionViewColor.count)))]
        
        quetionLabel.text = question
    }
    
    func disableAnswerButtons() {
        yesButton.isEnabled = false
        noButton.isEnabled = false
        yesButton.layer.opacity = 0.4
        noButton.layer.opacity = 0.4
    }
    func enableAnswerButtons() {
        yesButton.isEnabled = true
        noButton.isEnabled = true
        yesButton.layer.opacity = 1
        noButton.layer.opacity = 1
    }
    func answerBtnDidTapped(){
        scoreLabel.text = String(myScore)
        disableAnswerButtons()
        timer.invalidate()
        resetFocusTimer()
        runFocusTimer()
    }
    func runFocusTimer() {
        focusTimer = Timer.scheduledTimer(timeInterval: 0.8, target: self, selector: (#selector(updateFocusView)), userInfo: nil, repeats: true)
    }
    
    @objc func updateFocusView() {
        focusSeconds -= 1
        if (focusSeconds % 2) == 0 {
            nextButton.borderColor = .lightText
            nextButton.borderWidth = 6
        }
        else {
            nextButton.borderColor = .lightText
            nextButton.borderWidth = 5
            
        }
        if focusSeconds < 0 {
            resetFocusTimer()
            
        }
        
    }
    func resetFocusTimer() {
        focusTimer.invalidate()
        focusSeconds = 60
    }
    
}


