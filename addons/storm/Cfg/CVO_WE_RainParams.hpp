class CVO_Rain_Params
{
	class CVO_RainParams_Default
	{
		// Parameters for the new particle rain
		// texture of the particle (r = alpha; g = normalX; b = normalY; a = color;)
		rainDropTexture="a3\data_f\rainnormal_ca.paa";
		// dropsInTexture - the number of drops that are present in the drop texture
		texDropCount=4;
		// minimum rain strength when the effect starts to be rendered
		minRainDensity = 0.01;
		// distance of the effect
		effectRadius=15;
		// coefficient of how much the wind influences water drops
		windCoef=0.05;
		// fall speed of the drops
		dropSpeed=25.0;
		// random part of the fall speed 
		rndSpeed=0.2;
		// coefficient of how much the drop could randomly change direction
		rndDir=0.2;
		// width of the single drop
		dropWidth=0.04;
		// height of the single drop
		dropHeight=0.8;
		// color of the drop
		dropColor[]={0.101961, 0.101961, 0.101961, 0.101961};
		// luminescence of the drop facing to sun
		lumSunFront=0.1;
		// luminescence of the drop opposite to sun
		lumSunBack=0.1;
		// coefficient that tells us how much "refracted" light from the scene is added to the drop color
		refractCoef=0.5;
		// coefficient to tune color saturation of the refraction effect (0=BW, 1=original color)
		refractSaturation = 0.3;

		// SINCE Arma 3 v2.07.148385
		// rain is snow, will be used in "snow" env sound controller (optional, default is false)
		snow=0;
		// SINCE Arma 3 v2.07.148416
		// when true, the dropColor is preserved and not affected by eye accommodation (optional, default is false)
		dropColorStrong=0;	
	};

	class CVO_RainParams_Snow : CVO_RainParams_Default
	{
		// Parameters for the new particle rain
		// texture of the particle (r = alpha; g = normalX; b = normalY; a = color;)
		rainDropTexture="a3\data_f\snowflake16_ca.paa";
		// dropsInTexture - the number of drops that are present in the drop texture
		texDropCount=4;
		// minimum rain strength when the effect starts to be rendered
		minRainDensity = 0.01;
		// distance of the effect
		effectRadius=25;
		// coefficient of how much the wind influences water drops
		windCoef=0.05;
		// fall speed of the drops
		dropSpeed=2.5;
		// random part of the fall speed 
		rndSpeed=0.5;
		// coefficient of how much the drop could randomly change direction
		rndDir=0.5;
		// width of the single drop
		dropWidth=0.07;
		// height of the single drop
		dropHeight=0.7;
		// color of the drop
		dropColor[]={0.1, 0.1, 0.1, 0.5};
		// luminescence of the drop facing to sun
		lumSunFront=0.0;
		// luminescence of the drop opposite to sun
		lumSunBack=0.2;
		// coefficient that tells us how much "refracted" light from the scene is added to the drop color
		refractCoef=0.5;
		// coefficient to tune color saturation of the refraction effect (0=BW, 1=original color)
		refractSaturation = 0.5;

		// SINCE Arma 3 v2.07.148385
		// rain is snow, will be used in "snow" env sound controller (optional, default is false)
		snow=1;
		// SINCE Arma 3 v2.07.148416
		// when true, the dropColor is preserved and not affected by eye accommodation (optional, default is false)
		dropColorStrong=0;	
	};



	class CVO_RainParams_Snow_CVO : CVO_RainParams_Default
	{
		// Parameters for the new particle rain
		// texture of the particle (r = alpha; g = normalX; b = normalY; a = color;)
		rainDropTexture="z\cvo_storm\addons\storm\data\Raven_Voron_256.paa";
		// dropsInTexture - the number of drops that are present in the drop texture
		texDropCount=4;
		// minimum rain strength when the effect starts to be rendered
		minRainDensity = 0.01;
		// distance of the effect
		effectRadius=25;
		// coefficient of how much the wind influences water drops
		windCoef=0.05;
		// fall speed of the drops
		dropSpeed=2.5;
		// random part of the fall speed 
		rndSpeed=0.5;
		// coefficient of how much the drop could randomly change direction
		rndDir=0.5;
		// width of the single drop
		dropWidth=0.07;
		// height of the single drop
		dropHeight=0.7;
		// color of the drop
		dropColor[]={0.1, 0.1, 0.1, 0.5};
		// luminescence of the drop facing to sun
		lumSunFront=0.0;
		// luminescence of the drop opposite to sun
		lumSunBack=0.2;
		// coefficient that tells us how much "refracted" light from the scene is added to the drop color
		refractCoef=0.5;
		// coefficient to tune color saturation of the refraction effect (0=BW, 1=original color)
		refractSaturation = 0.5;

		// SINCE Arma 3 v2.07.148385
		// rain is snow, will be used in "snow" env sound controller (optional, default is false)
		snow=1;
		// SINCE Arma 3 v2.07.148416
		// when true, the dropColor is preserved and not affected by eye accommodation (optional, default is false)
		dropColorStrong=0;	
	};
};