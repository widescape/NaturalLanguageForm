NaturalLanguageForm
===================

Solution for http://stackoverflow.com/questions/25952168/put-uilabel-uitextfield-on-next-line-instead-of-pushing-out-of-view

## Instructions

* Create a UITextView for the full text which will also contain the entered parameter values.
* Add a UITextField for each parameter that can be entered.
* Upon entering/changing a parameter the active UITextField will be reduced to the width of the caret and placed at the last character's position within the UITextView's dimensions.

## Benefits

* Works with AutoLayout
* Works with resizeable UITextView

## Things Still To Do

* Handle text selection
* ?
