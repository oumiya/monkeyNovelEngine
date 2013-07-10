Import mojo
Import baselayer

Class PersonLayer Extends BaseLayer

	Field leftImage:Image
	Field centerImage:Image
	Field rightImage:Image

	' Personレイヤーではalignに left, center, right のいずれかを設定します。
	' alignが間違っていたらデフォルト値の left で設定します。
	Method Set:Int(key:String, align:String="left")
		If align = "center"
			Self.centerImage = storeMap.Get(key)
		Elseif align = "right"
			Self.rightImage = storeMap.Get(key)
		Else
			Self.leftImage = storeMap.Get(key)
		Endif
	End

	Method Draw:Int()
		Local x = 0, y = 0

		If leftImage <> Null
			y = height - leftImage.Height
			DrawImage leftImage, x, y
		Endif
		If centerImage <> Null
			y = height - centerImage.Height
			x = width - centerImage.Width
			x = x / 2
			DrawImage centerImage, x, y
		Endif
		If rightImage <> Null
			y = height - rightImage.Height
			x = width - rightImage.Width
			DrawImage rightImage, x, y
		Endif
		
		Return 0
	End

	Method Clear:Int(region:String="all")
		If region = "center"
			Self.centerImage = Null
		Elseif region = "right"
			Self.rightImage = Null
		Elseif region = "left"
			Self.leftImage = Null
		Else
			Self.centerImage = Null
			Self.rightImage = Null
			Self.leftImage = Null
		Endif
	End

	Method Init:Void()
		storeMap = New StringMap<Image>
		centerImage = Null
		rightImage = Null
		leftImage = Null
	End
End