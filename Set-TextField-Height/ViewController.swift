//
//  ViewController.swift
//  Set-TextField-Height
//
//  Created by Smith on 2015/1/09.
//  Copyright (c) 2015 Smith-Lab. All rights reserved.
//

import UIKit
import QuartzCore

class ViewController: UIViewController,UITextFieldDelegate,UIScrollViewDelegate {
    
    var fieldTitle = ["a","b","c","d","e"] //Icon Font Unicode
    var fieldPlaceholder = ["your first name","your last name","you@domain.com","maximum characters 6","cell phone number (optional)"]
    var prewMoveY : CGFloat = 0
    var scrollView: UIScrollView!
    var contentView: UIView!
    var fieldArray:Array<UITextField>!
    var changeHeight: CGFloat!
    var ChangeFieldSmallBtn:UIButton = UIButton()
    var ChangeFieldMediumBtn:UIButton = UIButton()
    var ChangeFieldLargeBtn:UIButton = UIButton()
    var BtnArray:Array<UIButton> = []
    var smithLabel:UILabel!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.bounds.size = UIScreen.mainScreen().bounds.size
        self.view.backgroundColor = UIColor.whiteColor()
        
        // Position
        var elementMargin :CGFloat = self.view.bounds.width / 5
        var elementWidth = Int(self.view.bounds.width - elementMargin)
        var elementWidthHalf = elementWidth/2
        var viewWidthHalf = self.view.bounds.width/2
        var viewHeight = self.view.bounds.height
        var viewHeightHalf = viewHeight/2
        var elementHeight = Int(viewHeight / 10)
        var elementSpace = 0
        var elementVMargin = elementHeight + elementSpace
        var elementX = Int(viewWidthHalf) - elementWidthHalf
        var elementY = 25
        
        //Label
        smithLabel = UILabel(frame: CGRect(x:Int(viewWidthHalf) - Int(elementWidthHalf), y: elementHeight / 3, width: elementWidth, height: elementHeight))
        smithLabel.font = UIFont(name:"untitled-font-1", size:CGFloat(elementHeight / 2))
        smithLabel.text = "s"
        smithLabel.textAlignment = .Center
        self.view.addSubview(smithLabel)
        
        // TextField
        func frameTextField(heightMargin:Int) -> UITextField {
            var theTextField = UITextField(frame: CGRect(x: elementX, y: (elementY + elementVMargin * (heightMargin+2))-heightMargin, width: elementWidth, height: elementHeight))
            
            return theTextField
        }
        
        // TextField func
        var textField_firstName = frameTextField(0)
        var textField_lastName = frameTextField(1)
        var textField_email = frameTextField(2)
        var textField_password = frameTextField(3)
        var textField_phoneNum = frameTextField(4)
        
        textField_email.keyboardType = .EmailAddress
        textField_email.autocapitalizationType = .None
        textField_password.secureTextEntry = true
        textField_phoneNum.keyboardType = .NumbersAndPunctuation
        
        // Array
        fieldArray = [textField_firstName,textField_lastName,textField_email,textField_password,textField_phoneNum]
        var allElementArray = [textField_firstName,textField_lastName,textField_email,textField_password,textField_phoneNum]
        
        // Put Field Title Into Field Array
        for (index, value) in enumerate(fieldArray){
            
            value.backgroundColor = UIColor.whiteColor()
            value.textAlignment = .Left
            value.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
            value.clearButtonMode = UITextFieldViewMode.WhileEditing
            value.autocorrectionType = .No
            value.returnKeyType = .Done
            value.textColor = UIColor.applicationFieldTextColor()
            value.adjustsFontSizeToFitWidth = true
            
            //Field border line
            self.borderLine(value.frame.width,fieldHeight: value.frame.height,textField: value)
            
            //default text
            value.attributedPlaceholder = NSAttributedString(string: fieldPlaceholder[index], attributes: [NSForegroundColorAttributeName : UIColor.applicationPlaceholderTextColor()])
            value.font = UIFont(name:"AvenirNext-Regular", size:15.0)
            value.tag = index
            let currencyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: elementHeight-10, height: elementHeight-10))
            currencyLabel.font = UIFont(name:"untitled-font-1", size:CGFloat(elementHeight / 2))
            currencyLabel.text = fieldTitle[index]
            currencyLabel.textColor = UIColor.applicationMidGrayColor()
            currencyLabel.textAlignment = .Left
            value.leftView = currencyLabel
            value.leftViewMode = .Always
            value.delegate = self
            
            // ScrollView
            scrollView = UIScrollView(frame: view.bounds)
            var fieldHeight = CGFloat()
            for showView in allElementArray{
                fieldHeight += showView.bounds.size.height
                scrollView.addSubview(showView)
            }
            
            var scrollViewHeight = fieldArray[0].frame.origin.y + fieldHeight + 60
            println(scrollViewHeight)
            scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, scrollViewHeight)
            scrollView.delegate = self
            scrollView.indicatorStyle = .Default //scrollbar
            view.backgroundColor = UIColor.whiteColor()
            view.addSubview(scrollView)
            
            ///Button
            BtnArray = [ChangeFieldSmallBtn,ChangeFieldMediumBtn,ChangeFieldLargeBtn]
            var btnTitle = ["Small","Medium","Large"]
            var btnFunc = ["ChangeSmall:","ChangeMedium:","ChangeLarge:"]
            
            for (index, value) in enumerate(BtnArray){
                var btnSpace:CGFloat = 30
                var btnCount = CGFloat(BtnArray.count + 1) * btnSpace
                var btnWidth = (self.view.bounds.width - btnCount) / CGFloat(BtnArray.count)
                var btnPosX = Int(btnWidth) * index + Int(btnSpace) * (index + 1)
                let value : UIButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
                value.frame = CGRect(x: btnPosX, y: elementHeight + 20, width: Int(btnWidth), height: elementHeight / 2 )
                value.backgroundColor = UIColor.applicationLightGrayColor()
                value.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
                value.titleLabel!.font = UIFont(name:"AvenirNext-Bold", size:12.0)
                /*Define your properties as per requirement*/
                value.addTarget(self, action: Selector(btnFunc[index]), forControlEvents: UIControlEvents.TouchUpInside)
                value.setTitle(btnTitle[index], forState: UIControlState.Normal)
                view.addSubview(value)
            }
            
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField){
        textField.rightViewMode = .Never
        textField.textColor = UIColor.applicationFieldTextColor()
        
        //Keyboard
        var textFrame : CGRect  =  textField.frame;
        var textY : CGFloat = textFrame.origin.y+textFrame.size.height;
        var bottomY : CGFloat = self.view.frame.size.height-textY;
        if(bottomY<216)
        {
            var moveY : CGFloat = 216-bottomY;
            prewMoveY = moveY;
            var frame : CGRect  = self.view.frame;
            let options = UIViewAnimationOptions.CurveEaseOut
            UIView.animateWithDuration(1, delay: 0.0, usingSpringWithDamping: 0.25, initialSpringVelocity: 0.1, options: options, animations: {
                
                frame.origin.y -= moveY;
                frame.size.height += moveY;
                self.view.frame = frame;
                
                }, completion: { finished in
            })
        }
        println("1 prewMoveY=\(prewMoveY)")
        println("BeginEditing:")
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        println("ShouldEndEditing:")
        
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        let purpleImage = UIImage(named: "cancel.png")!
        let purpleImageSizeWidth = purpleImage.size.width
        let pisRightMargin = 20 as CGFloat
        let purpleImageButton = UIButton.buttonWithType(.Custom) as UIButton
        purpleImageButton.bounds = CGRect(x: 0, y: 0, width: purpleImageSizeWidth + pisRightMargin, height: purpleImage.size.height)
        purpleImageButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        purpleImageButton.setImage(purpleImage, forState: .Normal)
        let purpleImage2 = UIImage(named: "ok.png")!
        let purpleImageButton2 = UIButton.buttonWithType(.Custom) as UIButton
        purpleImageButton2.bounds = CGRect(x: 0, y: 0, width: purpleImageSizeWidth + pisRightMargin, height: purpleImage2.size.height)
        purpleImageButton2.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        purpleImageButton2.setImage(purpleImage2, forState: .Normal)
        
        //E-mail Check
        if textField.tag == 2 {
            func isValidEmail(testStr:String) -> Bool {
                println("validate calendar: \(testStr)")
                let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
                var emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
                let result = emailTest?.evaluateWithObject(testStr)
                return result!
            }
            
            if isValidEmail(textField.text) {
                textField.textColor = UIColor.applicationFieldTextColor()
                textField.rightView = purpleImageButton2
                textField.rightViewMode = .Always
                println("Email Correct O.")
            }else if isValidEmail(textField.text) == false && textField.text != ""{
                textField.textColor = UIColor.applicationRedColor()
                textField.rightView = purpleImageButton
                textField.rightViewMode = .Always
                println("Email Incorrect X.")
            }
        }else if textField.text == "" {
            textField.rightViewMode = .Never
            println("Nothing")
        }
        
        //Phone number check
        if textField.tag == 4 {
            func isMobileNumber(mobileNum: NSString) -> Bool{
                var MOBILE : NSString = "09\\d{2}(-?\\d{3}){2}"
                var regextestmobile = NSPredicate(format: "SELF MATCHES %@", MOBILE)
                let result = regextestmobile?.evaluateWithObject(mobileNum)
                return result!
            }
            if isMobileNumber(textField.text) {
                textField.textColor = UIColor.applicationFieldTextColor()
                textField.rightView = purpleImageButton2
                textField.rightViewMode = .Always
                println("phone num O")
            }else if isMobileNumber(textField.text) == false && textField.text != ""{
                textField.textColor = UIColor.applicationRedColor()
                textField.rightView = purpleImageButton
                textField.rightViewMode = .Always
                println("phone num X")
            }
        }else if textField.text == "" {
            textField.rightViewMode = .Never
            println("Nothing")
        }
    }
    
    //Password length
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool{
        
        var passLengthValid : Bool = false
        
        if textField.tag == 3 {
            let newLength = countElements(textField.text) + countElements(string) - range.length
            passLengthValid = newLength <= 6 //Bool
        }else if textField.tag != 3 {
            passLengthValid = true
        }
        
        return passLengthValid
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        var frame : CGRect  = self.view.frame;
        
        if (frame.origin.y != 0) {
            let options = UIViewAnimationOptions.CurveEaseOut
            UIView.animateWithDuration(1, delay: 0.0, usingSpringWithDamping: 0.25, initialSpringVelocity: 0.1, options: options, animations: {
                frame.origin.y += self.prewMoveY;
                frame.size.height -= self.prewMoveY;
                self.view.frame = frame;
                }, completion: { finished in
            })
        }
        return false
    }
    
    // Button Action
    func ChangeSmall (sender : UIButton!) {
        settingFieldHeight(self.view.bounds.height / 15 ,newColor: UIColor.applicationHeavyGrayColor())
    }
    
    func ChangeMedium (sender : UIButton!) {
        settingFieldHeight(self.view.bounds.height / 10, newColor: UIColor.applicationGrayColor())
    }
    
    func ChangeLarge (sender : UIButton!) {
        settingFieldHeight(self.view.bounds.height / 7, newColor: UIColor.applicationMidGrayColor())
    }
    
    func settingFieldHeight (newHeight:CGFloat ,newColor:UIColor){
        for (index, value) in enumerate(fieldArray){
            
            var changeHeight : CGFloat = newHeight
            let options = UIViewAnimationOptions.CurveEaseOut
            UIView.animateWithDuration(1, delay: 0.0, usingSpringWithDamping: 0.25, initialSpringVelocity: 0.1, options: options, animations: {
                
                var changeY = value.frame.height * CGFloat(index)
                value.frame = CGRect(x:value.frame.origin.x, y: (value.frame.origin.y + (changeHeight * CGFloat(index))) - changeY, width: value.frame.width, height:changeHeight)
                
                let currencyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: changeHeight-10, height: changeHeight-10))
                currencyLabel.font = UIFont(name:"untitled-font-1", size:(changeHeight / 2))
                currencyLabel.text = self.fieldTitle[index]
                currencyLabel.textColor = newColor
                currencyLabel.textAlignment = .Left
                value.leftView = currencyLabel
                value.leftViewMode = .Always
                value.delegate = self
                
                for layerTemp in value.layer.sublayers as [CALayer] {
                    layerTemp.frame = CGRectMake(-1, 0, layerTemp.frame.width, changeHeight)
                }
                
                }, completion: { finished in
            })
            
            
            value.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        }
    }
    
    func borderLine(fieldWidth:CGFloat,fieldHeight:CGFloat,textField:UITextField){
        var leftBorder = CALayer()
        leftBorder.borderColor = UIColor.applicationLightGrayColor().CGColor
        leftBorder.borderWidth = 1
        leftBorder.frame = CGRectMake(-1, 0, fieldWidth+50, fieldHeight);
        textField.layer.addSublayer(leftBorder)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}



