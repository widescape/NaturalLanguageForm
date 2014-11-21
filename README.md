NaturalLanguageForm
===================

Solution for http://stackoverflow.com/questions/25952168/put-uilabel-uitextfield-on-next-line-instead-of-pushing-out-of-view

## Instructions

* Create a selectable, non-editable ```UITextView``` for the full text which will also contain the entered parameter values.
* Add an editable ```UITextField``` for each parameter that can be entered.
* Upon entering/changing a parameter the active ```UITextField``` will be reduced to the width of the caret and placed at the last character's position within the ```UITextView```'s dimensions.

## Features

* Works with resizeable UITextView
* Works with AutoLayout

## Things To Do

* Handle text selection:
  * Prevent the selection of the text around the input values within the ```UITextView```
  * Allow selection of the input values within the ```UITextView```, then select that range in the ```UITextField```
* Use ```NSAttributedString``` to format the form text and the parameter values
* Display the caret at the actual position within the input value
* Support multiple parameters
