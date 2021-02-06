# Recording and Processing the Output

<table><tbody><tr>
<td><details><summary>Table of Contents</summary>

- [Recording and Processing the Output](#recording-and-processing-the-output)
	- [Prepare the Recording](#prepare-the-recording)
		- [Launch TF2](#launch-tf2)
		- [Disconnect from the Internet](#disconnect-from-the-internet)
		- [Binds](#binds)
		- [Adjust the Shader](#adjust-the-shader)
	- [Recording](#recording)
		- [Change Resolution](#change-resolution)
		- [Afterburner Settings](#afterburner-settings)
		- [Record](#record)
	- [Process the Footage](#process-the-footage)
	- [Tips](#tips)

</details>

## Prepare the Recording

### Launch TF2
1. Make sure Steam is running.
2. Start up Afterburner if it's not already running.
3. Launch TF2 via the HLAE shortcut.

### Disconnect from the Internet

ReShade cuts off the depth buffer when it detects network traffic
to prevent people from abusing it in multiplayer games.  
What we'll do is simply unplug our Ethernet cable. No internet, no traffic.

<details><summary>Alternative solution</summary>

You can get around this restriction by building ReShade from source yourself,
with the network check disabled. The ReShade people are against this,
so if you do, please don't distribute it.

From [ReShade forums](https://reshade.me/forum/general-discussion/5349-reshade-custom-build-z-buffer-enabled):
> The reason the depth buffer is disabled in online games is because it _can_ be
> abused and used to cheat, and you don't need a lot of imagination to understand how.
>
> And the reason this is a bad thing is that if people use ReShade to cheat,
> it will be outright banned by online games both now and in the future.
> A very tiny minority of talentless cheaters will ruin it for everybody else.
>
> You really _don't_ want to compile and distribute these,
> otherwise DE _will_ ban ReShade and then you won't be able to use sharpening,
> LUTs, anti-aliasing or any other ReShade feature at all.
> You'll be forced to play the game without ReShade and all that it offers
> -- and not just you, all the thousands of others using ReShade to improve
> the look of their game.
>
> So please don't do it. 
</details>

### Binds


Because you UI has to be disabled in order for ReShade depth effects
to work, you will need to control the recording with binds.

- toggle UI on/off - `bind F11 "toggle r_drawvgui"`
- play/pause demo - `bind F9 demo_togglepause`
- plus the ReShade effect toggle key

### Adjust the Shader

Once you're in TF2, toggle ReShade off so you can see better,
and make sure anti-aliasing is disabled (`mat_antialias 0`).  
Then load up your demo and go to the part you want to record.
Hide the UI with your bind and enable the ReShade filter.

In the overlay you can adjust the effect, there's quite a few settings
for you to play with:
- **Far Plane** controls the depth distance
- **Depth Min** and **Depth Max** can squish the effect to a certain range
- **Depth Gamma** controls the depth curve
- **Present Type** is how is the depth number converted to a color
	- **Grayscale** is the standard way of displaying depth
		- 256 possible depth values
		- easy to use, supported everywhere
	- **Full RGB** uses the entire RGB spectrum 
		- &#x2757; epilepsy waring &#x2757;
		- 16.7 million possible depth values
		- larger file sizes
		- compatibility issues
		
Unless you're doing some super advanced effects that require very precise
depth information you should stick to grayscale. If you configure it correctly
you will get more than enough steps for things like depth of field.

<details><summary>How RGB depth works</summary>
The standard RGB format has 24 bits of information, 8 for each channel.
If we represent the depth as a 24 bit integer (0 being the closest
and it's max value being the furthest), we can then split it into three
8 bit parts. Those can be mapped to the red, green, and blue channels.

To extract the depth from the RGB value, use the following formula.
This will give you a decimal number between 0 (close) and 1 (far away).
```
depth = (red * 256^2 + green * 256 + blue) / (256^3 - 1)
```
I use a [plugin called tl_math](https://github.com/crazylafo/AE_tl_math) to do this
in After Effects. If you edit with something else, you're on your own.

<table>
<td><div style="text-align:center">
<img src="images/depth-fx-example.png"/>
<p><sub>Upward + full RGB depth + After Effects + tl_math</sub></p>
</td></div>
</table>
</details>

## Recording

There are two ways you can do this:
1. You don't need higher framerate/resolution than your PC can handle live
2. You need high FPS, high res footage with 100% stable framerate

For starters, I recommend trying the first one at least once,
before going for the more complex approach.

### Change Resolution

Because of how the shader works, your world and depth layers will be
half the resolution of what you record. To compensate for this,
you might want to run TF2 at a higher resolution.

For your first attempt I'd suggest recording at 2560×1440,
which translates to 1280×720 footage.  
Note that in order to run TF2 at 8K, I had to cap it at two frames per second,
otherwise it just crashed. Can't recommend.

TF2 will likely crash if you change the resolution while a map is loaded,
so make sure you're in the main menu.

The command is `statusspec_resolutions_set 2560 1440` (first width, second height).
This can make the game window overflow your screen,
but since we set Afterburner to game capture, it's not a problem.

### Afterburner Settings

Back to Afterburner's video capture settings. You can lower the recording
framerate to what you find acceptable. There's no need to record more frames
than TF2 can render.

You can experiment with limiting the framerate, either through the Afterburner
recording framerate limit, or in-game `fps_max`. All I can say is that it
works without it.

Also since the demo plays in real time, you can grab the game audio as well.
I haven't do this, so just add an audio source and see if it works.

### Record

1. Load up your demo and go to where you want to start recording.
2. Enable ReShade, hide UI, start recording.
3. Once you have what you came for, stop recording.

You can check what you recorded. Drag and drop the video onto
`\video processing\play.cmd` to open it in _ffplay_
(a very fast player).  
Note that if the FPS and resolution is too high, it might not be able to play
it at full speed.

## Process the Footage

To get your world and depth layers as two separate files,
drag and drop the recorded video onto
`\video processing\separate-layers.cmd`.

It might take a while, but after it's done, you'll find
the two layers next to the original file:
- `whatevername-world.avi` is the regular video
- `whatevername-depth.avi` is the depth buffer

The original recording is no longer needed, you can delete it.

Both layers full RGB lossless material, compressed with
the UT Video codec. I am able to import them into
both Premiere and After Effects. If it doesn't work with
your software, feel free to open an issue.

## Tips

- You can move TF2's window to the side (would be careful minimizing it though),
  so that you can see what Afterburner shows. When recording, a small icon will
	flash in the top left of it's graph area.

If you want, you can now go onto the
[more advanced recording method](guide/advanced-recording.md).
