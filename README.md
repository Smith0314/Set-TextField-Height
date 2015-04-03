# Set-TextField-Height
Control UITextField height and custom iconfont, built using Swift, without storyboard

* Custom Iconfont
-------------------------------------------------------------------
Icon 的部份是用 Sketch3 繪製圖形並輸出 .svg 再轉成字型檔

![image](https://raw.githubusercontent.com/Smith0314/Set-TextField-Height/master/screenshots/sketch.png)


最初我的想法是來自網頁設計常見的 webfont 中的一種基於向量格式的圖形字體，於是將其放在手機 App 裹，來解決手機螢幕多尺寸的問題，
iconfont 置入 iOS 不同於 pdf 的置入，pdf 置入的圖在開發階段是向量的， 但 publish 後會成為點陣，iconfont 在 publish 後仍是向量格式

![image](https://github.com/Smith0314/Set-TextField-Height/blob/master/screenshots/custom_font.png?raw=true)


而以 icon 的應用需求來說，用操作字型的方式也比圖形方便多了

    let currencyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: changeHeight-10, height: changeHeight-10))
    currencyLabel.font = UIFont(name:"untitled-font-1", size:(changeHeight / 2))
    currencyLabel.text = self.fieldTitle[index]
    currencyLabel.textColor = newColor
    currencyLabel.textAlignment = .Left

.


* Auto Layout
--------------------------
元件的寬高並未設固定的數值，而是對應目前的 view 的 bounds size 的比例，即依螢幕的百分比來決定尺寸

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

.


* Controll Textfield Height And Icon Size
--------------------------
以按鈕控制 Small、Medium 及 Large 三種尺寸變化


![image](https://github.com/Smith0314/Set-TextField-Height/blob/master/screenshots/main.gif?raw=true)

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


.


* Verify Input Date Format
---------------
E-mail 郵件格式、密碼長度及手機號碼格式的判斷

![image](https://github.com/Smith0314/Set-TextField-Height/blob/master/screenshots/mail_check_x.PNG?raw=true) ![image](https://github.com/Smith0314/Set-TextField-Height/blob/master/screenshots/mail_check_o.PNG?raw=true)

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
