
matproxy.Add( {
	name = "SkyPaint",

	init = function( self, mat, values )
	end,

	bind = function( self, mat, ent )

		local skyPaint = g_SkyPaint
		if ( not IsValid( skyPaint ) ) then
			local found = ents.FindByClass( 'env_skypaint' )[1]
			skyPaint = found
			g_SkyPaint = g_SkyPaint or skyPaint
		end
		if ( not IsValid( skyPaint ) ) then return end

		local top = (skyPaint.GetTopColor and skyPaint:GetTopColor()) or (skyPaint.GetDTVector and skyPaint:GetDTVector( 0 )) or vector_origin
		mat:SetVector( "$TOPCOLOR",		top )
		local bottom = (skyPaint.GetBottomColor and skyPaint:GetBottomColor()) or (skyPaint.GetDTVector and skyPaint:GetDTVector( 1 )) or vector_origin
		mat:SetVector( "$BOTTOMCOLOR",	bottom )
		local duskcol = (skyPaint.GetDuskColor and skyPaint:GetDuskColor()) or (skyPaint.GetDTVector and skyPaint:GetDTVector( 4 )) or vector_origin
		mat:SetVector( "$DUSKCOLOR",	duskcol )
		local duskscale = (skyPaint.GetDuskScale and skyPaint:GetDuskScale()) or (skyPaint.GetDTFloat and skyPaint:GetDTFloat( 2 )) or 0
		mat:SetFloat( "$DUSKSCALE",	duskscale )
		local duskin = (skyPaint.GetDuskIntensity and skyPaint:GetDuskIntensity()) or (skyPaint.GetDTFloat and skyPaint:GetDTFloat( 3 )) or 0
		mat:SetFloat( "$DUSKINTENSITY",	duskin )
		local fadebias = (skyPaint.GetFadeBias and skyPaint:GetFadeBias()) or (skyPaint.GetDTFloat and skyPaint:GetDTFloat( 0 )) or 0
		mat:SetFloat( "$FADEBIAS",	fadebias )
		local hdrscale = (skyPaint.GetHDRScale and skyPaint:GetHDRScale()) or (skyPaint.GetDTFloat and skyPaint:GetDTFloat( 1 )) or 0
		mat:SetFloat( "$HDRSCALE",	hdrscale )

		local sunn = (skyPaint.GetSunNormal and skyPaint:GetSunNormal()) or (skyPaint.GetDTVector and skyPaint:GetDTVector( 2 )) or Vector(0,0,1)
		mat:SetVector( "$SUNNORMAL",	sunn )
		local sunc = (skyPaint.GetSunColor and skyPaint:GetSunColor()) or (skyPaint.GetDTVector and skyPaint:GetDTVector( 3 )) or vector_origin
		mat:SetVector( "$SUNCOLOR",	sunc )
		local sunsize = (skyPaint.GetSunSize and skyPaint:GetSunSize()) or (skyPaint.GetDTFloat and skyPaint:GetDTFloat( 4 )) or 0
		mat:SetFloat( "$SUNSIZE",	sunsize )

		local drawStars = skyPaint.GetDrawStars and skyPaint:GetDrawStars()
		if drawStars == nil then drawStars = skyPaint.GetDTBool and skyPaint:GetDTBool( 0 ) end
		if ( not drawStars ) then
			return mat:SetInt( "$STARLAYERS", 0 )
		end

		local layers = (skyPaint.GetStarLayers and skyPaint:GetStarLayers()) or (skyPaint.GetDTInt and skyPaint:GetDTInt( 0 )) or 0
		mat:SetInt( "$STARLAYERS",	layers )

		local scale = skyPaint.GetStarScale and skyPaint:GetStarScale()
		local fade = skyPaint.GetStarFade and skyPaint:GetStarFade()
		local speed = skyPaint.GetStarSpeed and skyPaint:GetStarSpeed()
		if (not scale or not fade or not speed) and skyPaint.GetDTAngle then
			local star = skyPaint:GetDTAngle( 0 )
			if star then
				scale = scale or star.p
				fade = fade or star.y
				speed = speed or star.r
			end
		end
		mat:SetFloat( "$STARSCALE",	scale or 1 )
		mat:SetFloat( "$STARFADE",	fade or 1 )
		mat:SetFloat( "$STARPOS",	(speed or 1) * RealTime() )

		local startex = (skyPaint.GetStarTexture and skyPaint:GetStarTexture()) or (skyPaint.GetDTString and skyPaint:GetDTString( 0 )) or ""
		mat:SetTexture( "$STARTEXTURE",	startex )

	end
} )
