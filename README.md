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


* 欄位高度及 icon 尺寸變化
--------------------------
分為 Small、Medium 及 Large 尺寸，Layout Textfield 的寬高並未設固定的數值，而是對應目前的 view 的 bounds size 的比例，即依螢幕的百分比來決定尺寸


![image](https://github.com/Smith0314/Set-TextField-Height/blob/master/screenshots/main.gif?raw=true)


.


* 輸入格式判斷
---------------
E-mail 郵件格式、密碼長度及手機號碼格式的判斷

![image](https://github.com/Smith0314/Set-TextField-Height/blob/master/screenshots/mail_check_x.PNG?raw=true) ![image](https://github.com/Smith0314/Set-TextField-Height/blob/master/screenshots/mail_check_o.PNG?raw=true)
