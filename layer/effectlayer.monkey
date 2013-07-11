Import mojo
Import baselayer

Class EffectLayer Extends BaseLayer

	Field drawImage:Image '現在キャンバスに描画されている内容を読み込む
	Field effectName:String
	Field effectCount:Int
	Field effectCountLimit:Int
	Field effectAlpha:Float
	Field er:Int
	Field eg:Int
	Field eb:Int
	Field isDraw:Bool
	Field buf:Int[]
	
	Method New()
		Self.Clear()
	End

	' エフェクトレイヤーではSetは何の意味も持ちません
	' そもそもエフェクトレイヤーではイメージ格納用Mapを使いません。
	Method Set:Int(key:String, align:String="left")
		Self.Clear()
	End
	
	Method SetEffect:Int(effectName:String, effectSpeed:Float, r:Int=0, g:Int=0, b:Int=0)
		Self.Clear()
		Self.effectName = effectName
		Self.effectCount = 0
		Self.effectCountLimit = effectSpeed
		Self.effectAlpha = 1.0 / effectSpeed
		Self.er = r
		Self.eg = g
		Self.eb = b
		Self.isDraw = True
	End

	Method Draw:Int()
		Local result:Int=0

		If isDraw = True
			result = 1
			If effectName = "fadeout"
				effectCount += 1
				
				SetColor er, eg, eb
				
				If effectCount > effectCountLimit
					result = 0
					SetAlpha 1.0
				Else
					effectAlpha += effectAlpha
					If effectAlpha > 1.00000
						effectAlpha = 1.0					
					Endif
					SetAlpha effectAlpha
				Endif
				
				DrawRect 0, 0, width, height
			Endif
			
			If effectName = "fadein"
				effectCount += 1
				
				SetColor er, eg, eb
				
				If effectCount > effectCountLimit
					result = 0
					SetAlpha 0.0
				Else
					effectAlpha += effectAlpha
					If effectAlpha > 1.00000
						effectAlpha = 1.0					
					Endif
					SetAlpha(1.0 - effectAlpha)
				Endif
				
				DrawRect 0, 0, width, height
			Endif
		Else
			result = 0
		Endif
		
		' エフェクト描画中は1を返し、エフェクト描画完了後は0を返す
		Return result
	End

	' エフェクトレイヤーではregionを指定する必要はありません。
	' というか指定しても何もしません。
	Method Clear:Int(region:String="all")
		drawImage = Null
		Self.effectName = ""
		Self.effectCount = 0
		Self.effectCountLimit = 0
		Self.effectAlpha = 0
		Self.er = 0
		Self.eg = 0
		Self.eb = 0
		Self.isDraw = False
	End
	
	Method Init:Void()
		Self.Clear()
	End
	
	' ARGBを簡単に指定できる	
	Method ToARGB:Int(r:Int, g:Int, b:Int, a:Int)
		If r > 255
			r = 255
		Endif
		If g > 255
			g = 255
		Endif
		If b > 255
			b = 255
		Endif
		Local argb:Int
		argb |= a Shl 24
		argb |= r Shl 16
		argb |= g Shl 8
		argb |= b
		Return argb
	End
End