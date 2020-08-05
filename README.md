# Recording depth in TF2

This guide will go over how to capture the depth buffer when rendering out demos, which can be then used for cinematic depth of field effects. As far as I'm aware the only alternative to this is porting them to Source Film Maker.

<table>
<td><div style="text-align:center">
<img src="https://raw.githubusercontent.com/juniorsgithub/tf2-how-to-record-depth/master/guide/images/exaple-world.png"/>
</td></div>
<td><div style="text-align:center">
<img src="https://raw.githubusercontent.com/juniorsgithub/tf2-how-to-record-depth/master/guide/images/exaple-depth.png"/>
</td></div>
</table>

The catch here is that many things in TF2 are random. If record in two passes, things like ragdolls and character animations will not line up. _Solution?_ Record both standard game image and depth layer at the same time.  
This can be achieved by using _ReShade_ to display the depth buffer and recording that with a screen capture software, while using the in-game `startmovie` command to record regular image at the same time.

## Reqired Software
- ReShade
- Half-Life Advanced Effects
- MSI Afterburner
- Lagarith Lossless Video Codec
- SourceDemoRender
- StatusSpec
- ffmpeg

Some can be substituted, but I suggest you use these to avoid any unnecessary issues.

## Notes

Lossless video takes up quite a bit of space. To be safe you should have at least 50 GB of free space to work with. The bottleneck while recording is usually write speed, so if you have an SSD you might want to consider using that.

Sometimes TF2 crashes for no apparent reason, it that happens, just try again.

I edit in Premiere and After Effects. If you use something else, you may have to reencode the footage to make it compatible.

If you have any suggestions on how to improve this process, please do share.

# The Guide

[Installation and Setup](https://github.com/juniorsgithub/tf2-how-to-record-depth/blob/master/guide/Installation-and-Setup.md) - things you only have to do the first time

[Recording and Processing the Output](https://github.com/juniorsgithub/tf2-how-to-record-depth/blob/master/guide/Recording-and-Processing-Video.md) - the (almost) fun part

---
# Changelog

### 5. 8. 2020
- Restructured the guide
- Fixed color loss during video encoding
- Fixed Steam messing up ReShade

### 3. 8. 2020
- First release
