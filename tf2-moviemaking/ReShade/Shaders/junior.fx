///////////////////////////////////////////////////////
// Modification of DisplayDepth.fx by junior.
// Intended for capturing the depth buffer 
// to use it in video editing.
///////////////////////////////////////////////////////

#include "ReShade.fxh"

#if (__RESHADE__ < 30101) || (__RESHADE__ >= 40600)
	#define __DISPLAYDEPTH_UI_FAR_PLANE_DEFAULT__ 1000.0
	#define __DISPLAYDEPTH_UI_UPSIDE_DOWN_DEFAULT__ 0
	#define __DISPLAYDEPTH_UI_REVERSED_DEFAULT__ 0
	#define __DISPLAYDEPTH_UI_LOGARITHMIC_DEFAULT__ 0
#else
	#define __DISPLAYDEPTH_UI_FAR_PLANE_DEFAULT__ 1000.0
	#define __DISPLAYDEPTH_UI_UPSIDE_DOWN_DEFAULT__ 0
	#define __DISPLAYDEPTH_UI_REVERSED_DEFAULT__ 1
	#define __DISPLAYDEPTH_UI_LOGARITHMIC_DEFAULT__ 0
#endif







uniform bool bUIUsePreprocessorDefs <
	ui_category = "Config";
	ui_label = "Use global preprocessor definitions";
	ui_tooltip = "Enable this to override the values from\n"
	             "'Depth Input Settings' with the\n"
	             "preprocessor definitions. If all is set\n"
	             "up correctly, no difference should be\n"
	             "noticed.";
> = false;

uniform float fUIDepthMultiplier <
	ui_category = "Config";
	ui_type = "drag";
	ui_label = "Depth Multiplier";
	ui_tooltip = "RESHADE_DEPTH_MULTIPLIER=<value>";
	ui_min = 0.0; ui_max = 1000.0;
	ui_step = 0.001;
> = 1.0;

uniform int iUIUpsideDown <
	ui_category = "Config";
	ui_type = "combo";
	ui_label = "Upside Down";
	ui_items = "RESHADE_DEPTH_INPUT_IS_UPSIDE_DOWN=0\0RESHADE_DEPTH_INPUT_IS_UPSIDE_DOWN=1\0";
> = __DISPLAYDEPTH_UI_UPSIDE_DOWN_DEFAULT__;

uniform int iUIReversed <
	ui_category = "Config";
	ui_type = "combo";
	ui_label = "Reversed";
	ui_items = "RESHADE_DEPTH_INPUT_IS_REVERSED=0\0RESHADE_DEPTH_INPUT_IS_REVERSED=1\0";
> = __DISPLAYDEPTH_UI_REVERSED_DEFAULT__;

uniform int iUILogarithmic <
	ui_category = "Config";
	ui_type = "combo";
	ui_label = "Logarithmic";
	ui_items = "RESHADE_DEPTH_INPUT_IS_LOGARITHMIC=0\0RESHADE_DEPTH_INPUT_IS_LOGARITHMIC=1\0";
	ui_tooltip = "Change this setting if the displayed surface normals have stripes in them";
> = __DISPLAYDEPTH_UI_LOGARITHMIC_DEFAULT__;

// Options

uniform float fUIFarPlane <
	ui_category = "Options";
	ui_type = "drag";
	ui_label = "Far Plane";
	ui_tooltip = "Controls the depth curve\n"
	             "RESHADE_DEPTH_LINEARIZATION_FAR_PLANE=<value>";
	ui_min = 0.0; ui_max = 100000.0;
	ui_step = 1.0;
> = __DISPLAYDEPTH_UI_FAR_PLANE_DEFAULT__;

uniform float fUIDepthStart <
	ui_category = "Options";
	ui_type = "drag";
	ui_label = "Depth Start";
	ui_tooltip = "Adjust where the depth starts";
	ui_min = 0.0; ui_max = 1.0;
	ui_step = 0.001;
> = 0.0;

uniform float fUIDepthEnd <
	ui_category = "Options";
	ui_type = "drag";
	ui_label = "Depth End";
	ui_tooltip = "Adjust where the depth reaches maximum value";
	ui_min = 0.0; ui_max = 1.0;
	ui_step = 0.001;
> = 1.0;

uniform float fUIDepthGamma <
	ui_category = "Options";
	ui_type = "drag";
	ui_label = "Depth Gamma";
	ui_tooltip = "Adjust the depth curve";
	ui_min = 0.0; ui_max = 100.0;
	ui_step = 0.01;
> = 1.0;

uniform int iUIPresentType <
	ui_category = "Options";
	ui_type = "combo";
	ui_label = "Present Type";
	ui_tooltip = "How to display the depth information";
	// ui_items = "Depth map\0Depth map RGB\0Normal map\0Show both (Vertical 50/50)\0";
	ui_items = "Grayscale\0Full RGB\0";
> = 0;

uniform bool bUIDither <
	ui_category = "Options";
	ui_type = "radio";
	ui_tooltip = "Enable dithering to simulate finer gradients";
	ui_label = "Dither";
> = false;

// Misc

uniform float2 fUIOffset <
	ui_category = "Misc";
	ui_type = "drag";
	ui_label = "Offset";
	ui_tooltip = "Best use 'Present type'->'Depth map' and enable 'Offset' in the options below to set the offset.\nUse these values for:\nRESHADE_DEPTH_INPUT_X_OFFSET=<left value>\nRESHADE_DEPTH_INPUT_Y_OFFSET=<right value>";
	ui_min = -1.0; ui_max = 1.0;
	ui_step = 0.001;
> = float2(0.0, 0.0);

uniform float2 fUIScale <
	ui_category = "Misc";
	ui_type = "drag";
	ui_label = "Scale";
	ui_tooltip = "Best use 'Present type'->'Depth map' and enable 'Offset' in the options below to set the scale.\nUse these values for:\nRESHADE_DEPTH_INPUT_X_SCALE=<left value>\nRESHADE_DEPTH_INPUT_Y_SCALE=<right value>";
	ui_min = 0.0; ui_max = 2.0;
	ui_step = 0.001;
> = float2(1.0, 1.0);

uniform bool bUIShowOffset <
	ui_category = "Misc";
	ui_type = "radio";
	ui_tooltip = "Blend depth output with original";
	ui_label = "Show Offset";
> = false;

float GetDepth(float2 texcoord)
{
	//Return the depth value as defined in the preprocessor definitions
	if(bUIUsePreprocessorDefs)
	{
		return ReShade::GetLinearizedDepth(texcoord);
	}

	//Calculate the depth value as defined by the user
	//RESHADE_DEPTH_INPUT_IS_UPSIDE_DOWN
	if(iUIUpsideDown)
	{
		texcoord.y = 1.0 - texcoord.y;
	}

	/*
	texcoord.x /= fUIScale.x;
	texcoord.y /= fUIScale.y;
	texcoord.x -= fUIOffset.x / 2.000000001;
	texcoord.y += fUIOffset.y / 2.000000001;
	*/

	float depth = tex2Dlod(ReShade::DepthBuffer, float4(texcoord, 0, 0)).x * fUIDepthMultiplier;
	//RESHADE_DEPTH_INPUT_IS_LOGARITHMIC
	if(iUILogarithmic)
	{
		const float C = 0.01;
		depth = (exp(depth * log(C + 1.0)) - 1.0) / C;
	}
	//RESHADE_DEPTH_INPUT_IS_REVERSED
	if(iUIReversed)
	{
		depth = 1.0 - depth;
	}
	const float N = 1.0;
	
	depth /= fUIFarPlane - depth * (fUIFarPlane - N);

	// Levels
	depth = max(depth - fUIDepthStart, 0) / (fUIDepthEnd - fUIDepthStart);

	depth = pow(abs(depth), fUIDepthGamma);
	
	return depth;
}

float3 NormalVector(float2 texcoord)
{
	float3 offset = float3(BUFFER_PIXEL_SIZE, 0.0);
	float2 posCenter = texcoord.xy;
	float2 posNorth  = posCenter - offset.zy;
	float2 posEast   = posCenter + offset.xz;

	float3 vertCenter = float3(posCenter - 0.5, 1) * GetDepth(posCenter);
	float3 vertNorth  = float3(posNorth - 0.5,  1) * GetDepth(posNorth);
	float3 vertEast   = float3(posEast - 0.5,   1) * GetDepth(posEast);

	return normalize(cross(vertCenter - vertNorth, vertCenter - vertEast)) * 0.5 + 0.5;
}

float3 DepthToRgb(float depth)
{
	depth *= 16777215;  // 2**24 - 1
	float b = depth % 256;
	depth = (depth - b) / 256;
	float g = depth % 256;
	depth = (depth - g) / 256;
	float r = depth;
	return float3(r, g, b) / 255;
}

float ColorToDepth(float3 rgb)
{
	float val = rgb.x * 256 * 256 + rgb.y * 256 + rgb.z;
	val /= 65535;  // 2^16 - 1
	return val;
}

// Converts output pixel coordinates to input pixel coordinates.
// Returns: In which "quadrant" of the screen the output pixel is.
int GetCoord(inout float2 texcoord)
{
	int result = 0;
	if (texcoord.x > 0.5) {
		texcoord.x -= 0.5;
		result += 1;
	}
	if (texcoord.y > 0.5) {
		texcoord.y -= 0.5;
		result += 2;
	}

	texcoord.x /= 0.5;
	texcoord.y /= 0.5;

	return result;
}


void PS_DisplayDepth(in float4 position: SV_Position, in float2 texcoord : TEXCOORD, out float3 color : SV_Target)
{


	const float dither_bit = 8.0; //Number of bits per channel. Should be 8 for most monitors.

	float depth = GetDepth(texcoord);

	// Dithering
	float3 dither_shift_RGB = 0;
	if (bUIDither) {

		//Calculate grid position
		float grid_position = frac(dot(texcoord, (BUFFER_SCREEN_SIZE * float2(1.0 / 16.0, 10.0 / 36.0)) + 0.25));

		//Calculate how big the shift should be
		float dither_shift = 0.25 * (1.0 / (pow(2, dither_bit) - 1.0));

		//Shift the individual colors differently, thus making it even harder to see the dithering pattern
		dither_shift_RGB = float3(dither_shift, -dither_shift, dither_shift); //subpixel dithering

		//modify shift acording to grid position.
		dither_shift_RGB = lerp(2.0 * dither_shift_RGB, -2.0 * dither_shift_RGB, grid_position); //shift acording to grid position.
	}

	switch (iUIPresentType)
	{
		// Standard depth map.
		case 0:
			color = depth.rrr + dither_shift_RGB;
			break;
		// Full RGB depth map.
		case 1:
			color = DepthToRgb(depth) + dither_shift_RGB;
			break;
		// Normal map.
		case 2:
			color = NormalVector(texcoord);
			break;
		// Depth and normal split screen.
		case 3:
			float3 normal_vector = NormalVector(texcoord);
			float3 normal_and_depth = lerp(normal_vector, depth.rrr + dither_shift_RGB, step(BUFFER_WIDTH * 0.5, position.x));
			color = normal_and_depth;
			break;
	}

	if(bUIShowOffset)
	{
		float3 backbuffer = tex2D(ReShade::BackBuffer, texcoord).rgb;

		//Blend depth_value and backbuffer with 'overlay' so the offset is more noticeable
		color = lerp(2*color*backbuffer, 1.0 - 2.0 * (1.0 - color) * (1.0 - backbuffer), max(color.r, max(color.g, color.b)) < 0.5 ? 0.0 : 1.0 );
	}
}

void PS_Antialias(in float4 position : SV_Position, in float2 texcoord : TEXCOORD, out float3 color : SV_Target) {
	color = tex2D(ReShade::BackBuffer, texcoord).rgb;
}

void PS_Main(in float4 position : SV_Position, in float2 texcoord : TEXCOORD, out float3 color : SV_Target) {

	switch (GetCoord(texcoord))
	{
		case 0:
			PS_Antialias(position, texcoord, color);
			break;
		case 1: 
			PS_DisplayDepth(position, texcoord, color);
			break;
		default:
			color = 0.0.rrr;
			return;
	}
}

technique DisplayDepth_junior <
	ui_label = "junior";
	ui_tooltip = "Modification of the standard DisplayDepth effect to allow for more accurate depth capture";
>
{
	pass
	{
		VertexShader = PostProcessVS;
		PixelShader = PS_Main;
	}
}
