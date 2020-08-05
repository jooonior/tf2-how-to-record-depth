# Recording and Processing the Output

<table><tbody><tr>
<td><details><summary>Table of Contents</summary>

- [Recording and Processing the Output](#recording-and-processing-the-output)
- [Prepare the Recording](#prepare-the-recording)
	- [Launch TF2](#launch-tf2)
	- [Create a VDM](#create-a-vdm)
	- [Enter Commands](#enter-commands)
- [Record](#record)
- [Process the Footage](#process-the-footage)
	- [Depth](#depth)
	- [World](#world)
- [Edit](#edit)

</details>

# Prepare the Recording

## Launch TF2
1. **Shut down Steam**. It can cause issues with ReShade.  
2. Start up Afterburner if it's not already running.
3. Launch TF2 with the HLAE shortcut.

Once you're in TF2, toggle ReShade off so you can see, and make sure anti-aliasing is disabled (`mat_antialias 0`). Then load up your demo and go to the part you want to record. Hide the UI with your bind and enable the ReShade filter. In the overlay you can adjust the effect, **Far Plane** changes distance, and **Depth Min** and **Depth Max** limit the effect to a specific range.

When you're happy with how it looks, close the demo.

## Create a VDM

Next step is creating a VDM file to handle the recording. Find your demo in File Explorer, create a new text file next to it, name it exactly the same as the demo but with a `.vdm` extension (e.g. `my demo.vdm` for `my demo.dem`). Open it and paste in this:

<details><summary>VDM Contents</summary>

```
demoactions
{
	"1"
	{
		factory "PlayCommands"
		name "start recording"
		starttick "1450"
		commands "r_drawvgui 0; startmovie movie.avi"
	}
	"2"
	{
		factory "PlayCommands"
		name "stop recording"
		starttick "1750"
		commands "r_drawvgui 1; endmovie"
	}
}
```
</details>

Change the `starttick` parameters to when you want the recording to start and end. Maybe also choose a different name than `movie.avi`.  
When you now play the demo, these commands will get automatically executed at the specified ticks.

## Enter Commands

Back in TF2, set `sdr_render_framerate` to the framerate you want to be recording at (default is 60).  
Make sure you have a bind to pause/play the demo (`bind space demo_togglepause`).  

Change the resolution with `statusspec_resolutions_set` to double of what you want your video to be at. So `statusspec_resolutions_set 3840 2160` if you want a 1920x1080 video. This will make the window overflow then your screen (unless you have a 4K monitor).

# Record

Load up your demo and pause it. Then:
1. Go to ~100 ticks before the recording starts.
2. Enable the ReShade filter without hiding UI (so you have a blank white screen).
3. Start recording with Afterburner and unpause the demo with your bind.

When the demo reaches the start tick, the VDM will hide UI and you should see the depth effect working.  
When the end tick is reached, UI will be enabled and the sceen will turn white again. That's when you stop the Afternurner recording. You can toggle off ReShade and close the demo.

You should now have two videos, standard world layer from SDR and depth from Afterburner. You can open them im VirtualDub and skim through the frames to see if they're OK.

# Process the Footage

## Depth

Take your depth recording and drag and drop it onto `\video processing\remove-duplicate-frames.cmd`. A console window will pop up asking you for a frame rate. Enter the number you set `sdr_render_framerate`, hit <kbd>ENTER</kbd> to and it will start with the video. This process shouldn't take very long.

Once that is finished you will find a `_without_duplicate_frames.mp4` version of your depth recording next to the original (which you can now delete).

## World

The `\video processing\scale-video.cmd` script will downscale the recording for you. Drag and drop the SDR output onto it. When asked for a resolution, enter `1920x1080` (half of the original size). Scaling the video will be probably take a couple minutes.

Once finished, you'll see a `_resized.mp4` version of your clip next to it. You can delete the probably quite larger variant.

# Edit

You can now import into After Effects. Note that the first and last frames of the depth video are blank white so you might want to remove them. Other than that you shouldn't have much trouble aligning the footage.
