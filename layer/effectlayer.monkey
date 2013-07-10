Import mojo
Import baselayer

' TODO: SetEffectされた時にその色の画像つくって
' あとはSetAlphaでDrawImageする様に修正すること。
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
		Self.effectAlpha = Ceil(255 / effectSpeed)
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
				If drawImage = Null
					drawImage = CreateImage(width, height)
					buf = New Int[width*height]
				Endif
				
				effectCount += 1
				
				If effectCount > effectCountLimit
					result = 0
					For Local i:Int = 0 To buf.Length - 1
						buf[i] = ToARGB(er, eg, eb, 255)
					Next
				Else
					Local alpha:Int
					alpha = effectCount * effectAlpha
					If alpha > 255
						alpha = 255
					Endif
					
					For Local i:Int = 0 To buf.Length - 1
						buf[i] = ToARGB(er, eg, eb, alpha)
					Next
				Endif
				
				drawImage.WritePixels(buf,0,0,width,height)

				DrawImage drawImage, 0, 0
			Endif
			
			If effectName = "fadein"
				If drawImage = Null
					drawImage = CreateImage(width, height)
					buf = New Int[width*height]
				Endif
				
				effectCount += 1
				
				If effectCount > effectCountLimit
					result = 0
					For Local i:Int = 0 To buf.Length - 1
						buf[i] = ToARGB(er, eg, eb, 0)
					Next
				Else
					Local alpha:Int
					alpha = 255 - (effectCount * effectAlpha)
					If alpha < 0
						alpha = 0
					Endif
					
					For Local i:Int = 0 To buf.Length - 1
						buf[i] = ToARGB(er, eg, eb, alpha)
					Next
				Endif
				
				drawImage.WritePixels(buf,0,0,width,height)

				DrawImage drawImage, 0, 0
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