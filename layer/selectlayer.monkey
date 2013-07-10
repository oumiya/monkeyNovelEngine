Import mojo
Import baselayer
Import canvastext
Import optionitem

Class SelectLayer Extends BaseLayer
	Field optionList:List<OptionItem>
	
	Method New()
		Self.optionList = New List<OptionItem>
	End
	
	Method AppendOption(text:String, sceneName:String)
		Self.optionList.AddLast(New OptionItem(text, sceneName))
	End

	Method Set:Int(key:String, align:String="left")
		
	End

	Method Draw:Int()
		Local result:Int=0
		
		If Self.optionList.Count > 0
			SetAlpha 0.5
			SetColor 0, 0, 0
			DrawRect 0, 0, width, height
			SetAlpha 1
			SetColor 255, 255, 255
			Local x:Int = 20
			Local y:Int = height - Self.optionList.Count * (22 + 18)
			y = y / 2
			For Local opt:OptionItem = Eachin Self.optionList
				DrawCanvasText("> " + opt.optionName, x, y)
				y = y + 22 + 18
		    Next
		Endif
		
		Return result
	End
	
	Method TouchEvent:String(tx:Int, ty:Int)
		Local result:String = ""
		Local x:Int = 20
		Local y:Int = height - Self.optionList.Count * (22 + 18)
		y = y / 2
		For Local opt:OptionItem = Eachin Self.optionList
			If tx >= x And ty >= y And tx <= width And ty < (y + 22)
				result = opt.sceneName
				Exit
			Endif
			y = y + 22 + 18
	    Next
		Return result
	End

	Method Clear:Int(region:String="all")
		Self.optionList.Clear()
	End

	Method Init:Void()
		Self.Clear()
	End	
End