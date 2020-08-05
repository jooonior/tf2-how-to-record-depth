# Installation and Setup

<table><tbody><tr>
<td><details><summary>Table of Contents</summary>

- [Installation and Setup](#installation-and-setup)
- [Download and Install](#download-and-install)
	- [Movie Making Folder](#movie-making-folder)
	- [ReShade](#reshade)
	- [Half-Life Advanced Effects (HLAE)](#half-life-advanced-effects-hlae)
	- [Lagarith Lossless Video Codec](#lagarith-lossless-video-codec)
	- [MSI Afterburner and RTSS](#msi-afterburner-and-rtss)
	- [StatusSpec plugin for TF2](#statusspec-plugin-for-tf2)
	- [SourceDemoRender](#sourcedemorender)
	- [ffmpeg](#ffmpeg)
- [Setup](#setup)
	- [Afterburner Capture Settings](#afterburner-capture-settings)
	- [HLAE Custom Loader](#hlae-custom-loader)
	- [ReShade](#reshade-1)
	- [Finishing Touches](#finishing-touches)

</details>

# Download and Install

## Movie Making Folder

Contains folders set up for the various programs on this list, scripts to help with ffmpeg, some config files, and my modified ReShade DisplayDepth shader.  
[Download from here](https://github.com/juniorsgithub/tf2-how-to-record-depth/releases/latest) and extract somewhere (preferably not just desktop).  

&#128204; All file paths in this guide prefixed with `\` begin in this folder.

## ReShade

Post-processing injector that will get us the depth information.  
[Download  the installer](https://reshade.me/) and save it in the `\ReShade` folder.  
Run it, hold <kbd>CTRL</kbd> and click the _Click here to select a game and manage its ReShade installation_ button. It should extract its files right there and close.

Next, [download ReShade basic shaders](https://github.com/crosire/reshade-shaders), open the archive, and extract `reshade-shaders-master\Shaders\ReShade.fxh`  to `\ReShade\Shaders`. If you want to get more shaders and textures you can, but more shaders means longer launch time.

<table><tbody><tr>
<td><div style="text-align:center">
<img src="https://raw.githubusercontent.com/juniorsgithub/tf2-how-to-record-depth/master/guide/images/ReShade-installer.png"/>
<p align="center"><sub><kbd>CTRL</kbd> + click</sub></p>
</td></div>
<td><div style="text-align:center">
<img src="https://raw.githubusercontent.com/juniorsgithub/tf2-how-to-record-depth/master/guide/images/ReShade-extracted.png"/>
<p align="center"><sub>ReShade extracted</p>
</td></div>
</tr></tbody></table>


## Half-Life Advanced Effects (HLAE)

A Source engine movie making tools. Can do many things, but here it will just inject ReShade for us.  
[Head to their website](https://www.advancedfx.org/download/) and download the **zipped version**. Extract to `\HLAE`.  

## Lagarith Lossless Video Codec

Lossless video codec that will allow us to record at maximum quality while staying at reasonable file sizes.  
[Download](https://lags.leetcode.net/codec.html)  and run the installer.

## MSI Afterburner and RTSS

It is important that the recording software captures every frame rendered. Afterburner can record at 120 FPS and prevent the game from going above that.  
If you don't have it already, [get it here](https://www.msi.com/page/afterburner) (downloads are at the bottom of the page). In the installer make sure _Rivatuner Statistics Server_ is checked.

## StatusSpec plugin for TF2

In order for ReShade to work you have to disable anti-aliasing. To get around this, we'll record at double resolution, then downscale to get a nice smooth image. TF2 doesn't let you go above native resolution, this plugin changes that.  
Download from [TFTV thread here](https://www.teamfortress.tv/17291/sourceres/?page=2#32), open the archive, and extract the `StatusSpec\addons` folder to `\tf2 files`.

Alternatives include having a 4K monitor or some fiddling with your GPU driver.

## SourceDemoRender

A plugin that lets you record with `startmovie` straight into uncompressed video. No more gigabytes of TGAs.  
[Download version 19](https://github.com/crashfort/SourceDemoRender/releases/tag/19), open it, and extract `SDR\SourceDemoRender.Multiplayer.dll` to `\tf2 files\SDR`.

Next, find your `Team Fortress 2\tf` folder, make a new folder called `SDR` in it, and move `\tf2 files\SDR\gameconfig.json` there. This file just contains some SDR data and will not affect your TF2 installation in any way.

## ffmpeg

A very powerful command line video convertor. I've included batch scripts that will handle the converting for you.  
[Download from here](https://ffmpeg.zeranoe.com/builds/) (keep options as they are just hit download), open the archive, and extract `ffmpeg.exe`, `ffplay.exe`, and `ffprobe.exe` from `ffmpeg-whatever-version-win64-static\bin` to `\video processing`.

# Setup

## Afterburner Capture Settings

Open Afterburner, click the <kbd>&#x2699;</kbd> icon to open up settings. 7th tab should be called **Video capture**, in there:
- Choose a **video capture** hotkey
- **capture mode** to **3D application**
- **video formal** to **VFW compression**  
Click the <kbd>...</kbd> button, in the menu that pops up:  
   - **Compressor** to **Lagarith Lossless Codec**
   - Click <kbd>Configure</kbd> and tick **Enable Null Frames**
   - Hit <kbd>OK</kbd> to close both dialogs, back to Video capture settings
- **Frame size** to **1/2 frame**
- **Framerate** to **120 FPS**
- **Framerate limit** to **120 FPS**
- Set your **Videos folder** to wherever you want (HDD is fine)
- Set both **Audio source**s to **None**

120 FPS is a definitely an overkill, but if TF2 records a frame Afterburner doesn't catch, your footage will not align. Since the recorded image is just black and white, Lagarith does great job compressing it (my 8 minute 1920x1080 recording was just 3 GB).

<table>
<tr>
<td rowspan="2"><div style="text-align:center">
<img src="https://raw.githubusercontent.com/juniorsgithub/tf2-how-to-record-depth/master/guide/images/MSI-Afterburner-Video-capture.png"/>
<p align="center"><sub>Video capture options</sub></p>
</td></div>
<td><div style="text-align:center">
<img src="https://raw.githubusercontent.com/juniorsgithub/tf2-how-to-record-depth/master/guide/images/MSI-Afterburner-Video-compression.png" align="center"/>
<p align="center"><sub>Compression options</p>
</div></td>
</tr><tr>
<td><div style="text-align:center">
<img src="https://raw.githubusercontent.com/juniorsgithub/tf2-how-to-record-depth/master/guide/images/MSI-Afterburner-Lagarith-Configure.png"/>
<p align="center"><sub>Lagarith options</p>
</td></div>
</tr>
</table>

## HLAE Custom Loader

Start `\HLAE\HLAE.exe` and navigate to **Tools** > **Developer** > **Custom Loader**, in there:
- set **ProgramPath** to TF2's `hl2.exe`
- set **CommandLine** to this:  
   &#x2757; Make sure the path to `\tf2 files` is correct.
  ```
  -game tf -insecure -novid -window -condebug -conclearlog -insert_search_path "D:\Me\Documents\tf2-how-to-record-depth\tf2-moviemaking\tf2 files" +exec exec_on_startup
  ```
- **DLLs to inject** > **Browse** > add `\HLAE\AfxHookSource.dll`
- **DLLs to inject** > **Browse** > add `\ReShade\ReShade32.dll`

<table>
<td><div style="text-align:center">
<img src="https://raw.githubusercontent.com/juniorsgithub/tf2-how-to-record-depth/master/guide/images/HLAE-Custom-Loader.png"/>
<p><sub>HLAE Custom Loader</sub></p>
</td></div>
</table>

When all set, press **OK** and TF2 will launch. When the game loads try typing `sdr` and `statusspec` into console to confirm both plugins have loaded successfully.

## ReShade

in order for ReShade to work, you need to disable anti-aliasing (`mat_antialias 0`) and UI. For the latter a keybind is preferred (`bind F9 "toggle r_drawvgui"`). Once you have these, load up a map so you can test things out.

Hide the UI with your bind, then press <kbd>HOME</kbd> to open the ReShade overlay. Under the **Settings** tab:
- Change **Overlay Key** if you want
- Set an **Effect Toggle Key**
- **Effect search paths** to the **full path** to `\ReShade\Shaders`

Go back to the **Home** tab and click **Reload** (at the bottom). Wait for effects to load, then check `DisplayDepth_junior`. You should see the depth buffer drawn.  
If your whole screen turned white, you probably forgot to turn off either UI or anti-aliasing.

Try recording a short clip with Afterburner to confirm that it works. There is no notification if you're recording or not, so check your videos folder to find out. When done, close TF2.

## Finishing Touches

Open `\tf2 files\cfg\sdr.cfg` in a text editor, and change `sdr_outputdir` to where you want your recorded videos to go. I recommend to choose the same folder you set in Afterburner.

Make a shortcut to `\HLAE\HLAE.exe`, and in it's properties add `-customLoader -autoStart -noGui` after the path in the **Target** field, so it looks like this:
```
"D:\tf2\movie\HLAE\HLAE.exe" -customLoader -autoStart -noGui
```
Use this shortcut to launch TF2 though HLAE directly without having to go though _HLAE > Tools > Developer > Custom Loader > OK_ every time.

And that is everything set up, you can go onto [the recording part of this guide](https://github.com/juniorsgithub/tf2-how-to-record-depth/blob/master/guide/Recording-and-Processing-Video.md).
