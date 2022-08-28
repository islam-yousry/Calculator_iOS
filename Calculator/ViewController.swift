//
//  ViewController.swift
//  Calculator
//
//  Created by Blinkéé on 21/08/2022.
//

import UIKit
import MathParser

class ViewController: UIViewController {
    
    
    // MARK: Lifecycle
    
    @IBOutlet weak var equationTextView: UITextView!
    
    @IBOutlet weak var deleteButtonView: UIButton!
    
    
    
    private var equation = ""{
        didSet{
            equationTextView.text = equation
        }
    }
    
    let operations:[Character] = ["+","-","*","/"]
    
    private var lastNumber: String{
        return String(equationTextView.text![
            (equation.lastIndex(where: { char in
            return operations.contains(char)
        }) ?? equation.startIndex)..<equation.endIndex])
    }
    
    private var equalitybuttonClicked = false
    
    
    private var twoConsecutiveOperations: Bool {
        return !equationTextView.text!.isEmpty && operations.contains(equationTextView.text!.last!)
    }
    
    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        equationTextView.layer.borderWidth = 2
        equationTextView.layer.borderColor = UIColor.gray.cgColor
        
        

//        let oldStyle = equationTextView.defaultTextAttributes[.paragraphStyle, default: NSParagraphStyle()] as! NSParagraphStyle
//        let style = oldStyle.mutableCopy() as! NSMutableParagraphStyle
//        style.lineBreakMode = .byTruncatingHead
//        equationTextView.defaultTextAttributes[.paragraphStyle] = style
//
        
        let longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(buttonLongTapped))
        deleteButtonView.addGestureRecognizer(longTapGesture)
        
        equationTextView.textContainer.maximumNumberOfLines=1
        equationTextView.textContainer.lineBreakMode = .byTruncatingHead
    }
    
    // MARK: Layout
    override func viewDidLayoutSubviews() {
        equationTextView.centerVerticalText()
    }
    
   
    // MARK: User Interaction
    
    @IBAction func buttonClicked(_ sender: UIButton){
        let id =  sender.accessibilityIdentifier!
        let buttonTitle = sender.titleLabel!.text!
        if Int(id) != nil{
            checkEqualityButtonClicked()
            equation.append(buttonTitle)
        }else if id == "="{
            calculateExpression()
        }
        else if id == "."{
            checkEqualityButtonClicked()
            if !lastNumber.contains(buttonTitle){
                equation.append(buttonTitle)
            }
        }
        else{
            if twoConsecutiveOperations{
                return
            }
            equalitybuttonClicked = false
            equation.append(buttonTitle)
        }
        
    }
    
    @objc func buttonLongTapped(){
        equation = ""
    }
    
    
    @IBAction func deleteButtonAction(_ sender: UIButton) {
        if equationTextView.text!.isEmpty{
            return
        }
        equationTextView.text!.removeLast()
    }
    
    
    
    // MARK: Helper Methods
    
    
    private func calculateExpression(){
        if let answer = try? equation.evaluate(){
            equalitybuttonClicked = true
            equation = String(answer)
        }else{
            equation = ""
        }
    }
    
    private func checkEqualityButtonClicked(){
        if equalitybuttonClicked{
            equation = ""
            equalitybuttonClicked = false
        }
    }
    
    
    
    
}

extension UITextView {
    func centerVerticalText() {
        var topCorrect = (self.bounds.size.height - self.contentSize.height * self.zoomScale) / 2
        topCorrect = topCorrect < 0.0 ? 0.0 : topCorrect
        self.contentInset.top = topCorrect
    }
}
