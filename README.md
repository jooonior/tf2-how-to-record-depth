# How to record depth in TF2

The catch with recording depth is that many things in TF2 are random. If record in two passes, things like ragdolls and character animations will not line up. _Solution?_ Record both standard game image and depth layer at the same time.  
This can be achieved by using _ReShade_ to draw the depth layer and recording that with a screen capture software, while using in-game `startmovie` to record the regular image.

Many problems had to be solved on the path from this simple concept to a working solution, so that's why this guide is quite long.

---

<table><tbody><tr>
<td><details><summary>Table of Contents</summary>

- [Download and Install Software](#download-and-install-software)
	- [Movie making folder](#movie-making-folder)
	- [ReShade](#reshade)
	- [Half-Life Advanced Effects (HLAE)](#half-life-advanced-effects-hlae)
	- [Lagarith Lossless Video Codec](#lagarith-lossless-video-codec)
	- [MSI Afterburner and RTSS](#msi-afterburner-and-rtss)
	- [StatusSpec plugin for TF2](#statusspec-plugin-for-tf2)
	- [SourceDemoRender](#sourcedemorender)
	- [ffmpeg](#ffmpeg)
- [Set Things Up](#set-things-up)
	- [Set up HLAE](#set-up-hlae)
	- [Set up ReShade](#set-up-reshade)
	- [Test Afterburner](#test-afterburner)
- [Prepare the Recording](#prepare-the-recording)
	- [VDM](#vdm)
	- [Commands](#commands)
	- [Sanity Check](#sanity-check)
	- [Set Resolution](#set-resolution)
- [Record!](#record)
- [Align the Footage](#align-the-footage)
- [Clean Up](#clean-up)
</details></td>
</tr></tbody></table>

---

## Download and Install Software


You might already have some of these.

### Movie making folder

Contains folders set up for the various programs on this list, scripts to process the footage, some config files, and my modified ReShade depth shader.  
Download my [tf2-moviemaking](https://github.com/juniorsgithub/tf2-how-to-record-depth/releases/latest) folder and extract it somewhere (preferably not just desktop). All file paths prefixed with `\` in this guide begin in this folder.

Once extracted, open `\tf2 custom files\cfg\sdr.cfg`, and change `sdr_outputdir` to where you want your recorded videos to go.

### ReShade

Post-processing injector that can get us the depth information.  
[Download  the installer](https://reshade.me/) and save it to the `\ReShade` folder. Run it, hold <kbd>CTRL</kbd> and click the _Click here to select a game and manage its ReShade installation_ button. It should extract its files and close.

Next, [download ReShade basic shaders](https://github.com/crosire/reshade-shaders), open the archive, and extract `reshade-shaders-master\Shaders` and `reshade-shaders-master\Textures`  folders to `\ReShade`.

<table><tbody><tr>
<td><div style="text-align:center">
<img src="https://raw.githubusercontent.com/juniorsgithub/tf2-how-to-record-depth/master/images/ReShade-installer.png"/>
<p align="center"><sub><b><kbd>CTRL</kbd> + click</b> the big button</sub></p>
</td></div>
<td><div style="text-align:center">
<img src="https://raw.githubusercontent.com/juniorsgithub/tf2-how-to-record-depth/master/images/ReShade-extracted.png"/>
<p align="center"><sub>ReShade extracted</p>
</td></div>
</tr></tbody></table>


### Half-Life Advanced Effects (HLAE)

A tool to enrich Source engine movie making. Can do many things, but here it will just inject ReShade for us.  
Head to [their website](https://www.advancedfx.org/download/) and download the **zipped version**. Extract to `\HLAE`.  

### Lagarith Lossless Video Codec

Lossless video codec that will allow us to record at maximum quality while staying at reasonable file sizes.  
[Download](https://lags.leetcode.net/codec.html)  and run the installer.

### MSI Afterburner and RTSS

Apparenlty it can also record gameplay and has proven itself as the ideal tool in this situation. Other recording software can work too, but this is the one that I used.  
[Download](https://www.msi.com/page/afterburner) and install if you don't have it already. Then open it and go to **Settings** > **Video capture** (7th tab), and change these setings:
- Assign a **video capture** hotkey
- **capture mode** to **3D application**
- **video formal** to **VFW compression**  
Click the <kbd>...</kbd> button, in the menu that pops up:  
   - **Compressor** to **Lagarith Lossless Codec**
   - Click <kbd>Configure</kbd> and tick **Enable Null Frames**
   - Hit <kbd>OK</kbd> on both dialogs, back to Video capture settings
- **Frame size** to **1/2 frame**
- **Framerate** to **120 FPS**
- **Framerate limit** to **120 FPS**
- Set your **Videos folder** wherever you want (HDD is fine)
- Set both **Audio source**s to **None**

120 FPS is a slight overkill, but if TF2 records a frame Afterburner doesn't catch, your footage will not align. Since the recorded image will be just black and white, Lagarith does great job compressing it (my 38 second 1920x1080 clip was just 280 MB at 120 FPS).

<table>
<tr>
<td rowspan="2"><div style="text-align:center">
<img src="https://raw.githubusercontent.com/juniorsgithub/tf2-how-to-record-depth/master/images/MSI-Afterburner-Video-capture.png"/>
<p align="center"><sub>Video capture options</sub></p>
</td></div>
<td><div style="text-align:center">
<img src="https://raw.githubusercontent.com/juniorsgithub/tf2-how-to-record-depth/master/images/MSI-Afterburner-Video-compression.png" align="center"/>
<p align="center"><sub>Compression options</p>
</div></td>
</tr><tr>
<td><div style="text-align:center">
<img src="https://raw.githubusercontent.com/juniorsgithub/tf2-how-to-record-depth/master/images/MSI-Afterburner-Lagarith-Configure.png"/>
<p align="center"><sub>Lagarith options</p>
</td></div>
</tr>
</table>

### StatusSpec plugin for TF2

In order for ReShade to work you have to disable anti-aliasing. But that will make your footage look like &#128169;! _Solution?_ Record at higher resolution, then downscale to get those smooth edges. TF2 doesn't let you go above native resolution, this plugin changes that.  
Download from [TFTV thread here](https://www.teamfortress.tv/17291/sourceres/?page=2#32), open the archive, and extract the `StatusSpec\addons` folder to `\tf2 custom files`.

### SourceDemoRender

A plugin that lets you record with `startmovie` straight into uncompressed video. No more gigabytes of TGAs.  
[Download version 19](https://github.com/crashfort/SourceDemoRender/releases/tag/19), open it, and extract `SDR\SourceDemoRender.Multiplayer.dll` to `\SDR`.  
Next, find your `Team Fortress 2\tf` folder, make a new `SDR` in it, and move `\SDR\gameconfig.json` there. This file just contains some SDR data and will not affect your TF2 installation in any way.

### ffmpeg

My video convertor of choice. Required if you want to use my scripts.  
[Download from here](https://ffmpeg.zeranoe.com/builds/) (keep options as they are just hit download), open the archive, and extract contents of `ffmpeg-whatever-version-win64-static\bin` to `\video processing`.

---

## Set Things Up

First, launch Afterburner so it can detect the game when it starts.

### Set up HLAE

Second, open `\HLAE\HLAE.exe`. Navigate to **Tools** > **Developer** > **Custom Loader**, in there:
- set **ProgramPath** to TF2's `hl2.exe`
- set **CommandLine** to this &#128071; and &#10071;_correct the file path_&#10071;
  ```
  -game tf -insecure -novid -window -insert_search_path "D:\Me\Documents\tf2-how-to-record-depth\tf2-moviemaking\tf2 custom files" +exec exec_on_startup
  ```
- **DLLs to inject** > **Browse** > add `tf2-moviemaking\HLAE\AfxHookSource.dll`
- **DLLs to inject** > **Browse** > add `tf2-moviemaking\ReShade\ReShade32.dll`

<td><div style="text-align:center">
<img src="https://raw.githubusercontent.com/juniorsgithub/tf2-how-to-record-depth/master/images/HLAE-Custom-Loader.png"/>
<p align="center"><sub>HLAE Custom Loader</p>
</td></div>

When all set, hit **OK** and TF2 will launch.

<table><tr>
<td><b>Tip</B>: Once you have HLAE setup, use <code>\HLAE\startTF2.cmd</code> (or a shortcut to it) to launch TF2 though HLAE directly, without having to go through all the HLAE menus.</td>
</tr></table>

### Set up ReShade

Once TF2 loads, try typing `sdr` and `statusspec` into console to check if the plugins have loaded. You should see their commands.

For ReShade to work, you need to disable anti-aliasing (`mat_antialias 0`) and UI. For the latter a keybind is preferred (`bind F9 "toggle r_drawvgui"`). Once you have these, load up a map so you can test things out.

Hide the UI with your bind, then press <kbd>HOME</kbd> to open the ReShade overlay. Under the **Settings** tab:
- Change **Overlay Key** if you want
- Set an **Effect Toggle Key**
- **Effect search paths** to the **full path** to `\ReShade\Shaders`
- **Texture search paths** to the **full path** to `\ReShade\Textures`

Go back to the **Home** tab and click **Reload** (at the bottom). Wait for effects to load, then search for `DisplayDepth_junior`. Enable the effect. You should see the depth buffer drawn.  
If your whole screen is white, you probably forgot to turn off the UI or anti-aliasing.

### Test Afterburner

If everything looks good, toggle off the effect, toggle on UI. Before going onto the next step, make sure that Afterburner is working. Press your recording key to start recording, wait a few seconds, press it again to stop recording (there is no overlay). Then check the output folder for the recorded clip.

## Prepare the Recording

Load your demo and go to the segment you want to record. Hide UI, enable DOF. You can adjust the depth in the effect's properties - **Depth Min**, **Depth Max**, and **Far Plane**. Once you're happy with how the scene looks, close the demo.

### VDM

Next step is creating a VDM file to handle the recording. Find your demo in File Explorer, create a new text file next to it, name it exactly the same as the demo but with a `.vdm` extension (e.g. `my demo.vdm` for `my demo.dem`). Open it and paste in this:

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

Change the `starttick` parameters to when you want the recording to start and end. Maybe also choose a different name than `movie.avi`.  
When you now play the demo, these commands will get automatically executed at the specified ticks.

### Commands

Set `sdr_render_framerate`  to the framerate you want to be recording at (default is 60).  
Make sure anti-aliasing is disabled (`mat_antialias 0`).  
Create a bind to pause/play the demo (`bind space demo_togglepause`).

### Sanity Check

- Afterburner is working
- ReShade filter is configured and working
- VDM is set up (with the correct ticks)
- both SDR and StatusSpec plugins are working
- SDR has the correct framerate and output directory
- TF2 is in windowed mode

Once you're sure everything is set up properly, continue.

### Set Resolution

To get smooth image even without anti-aliasing, you should record at a higher resolution, then downscale the image to "anti-alias" it yourself. I recommend doubling the resolution, so for a 1080 video, record at 4K. Use the command `statusspec_resolutions_set 3840 2160` (first number is width, second height).  
This will make the window overflow your screen (unless you have a 4K monitor), so before doing it &#10071;**move the console to the top left corner of the window**&#10071;, that way you don't lose it. Also do this with demoUI if you plan to use that.

## Record!

Load the demo, once it loads, pause it. Fast forward to about 100 ticks before the recording starts. Then:
- Enable the ReShade effect, your screen should turn white
- Press your Afterburner recording key
- Unpause the demo with your bind

When the demo reaches the start tick, the VDM will hide the UI and you should see the depth effect working.  
When the end tick is reached, UI will be enabled and the sceen will turn white again. That's when you stop the Afternurner recording. You can toggle off ReShade and close the demo.

You should now have two videos, standard world layer in your SDR output directory and depth in your Afterburner videos folder. You can open them im VirtualDub and skim through the frames to see if they're OK.

## Align the Footage

The problem now is that the depth recording isn't synced at all. To align it with the SDR footage, you need to remove all duplicate frames from it.

In File Exporer, drag and drop the video onto  `\video processing\remove-duplicate-frames.cmd`. You will be asked for for a framerate. Enter the same value you set `sdr_render_framerate` to.  
After ffmpeg finishes processing the video, you should see a `_without_duplicate_frames.mp4` version of the depth recording. That's your depth layer.

Now you can import it and the SDR output to your editing software of choice and make your sick new fragvideo.

<table><tr>
<td><b>Note</B>: After Effects doesn't seem to like the SDR output format. If you're having trouble importing it, use <code>\video processing\reencode-video.cmd</code> (drag and drop the video onto it) to quickly reencode it.</td>
</tr></table>

## Clean Up

Remember to delete the VDM, otherwise it will start recording everytime you play the demo. You may also want to delete the Afterburener recording since it's no longer needed.
