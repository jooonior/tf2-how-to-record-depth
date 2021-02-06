# Advanced Recording

This part goes over how to record footage at 100% stable framerate,
no matter how demanding it is to render. Downsides of this method are
that it takes more time and you cannot record audio at the same time.

## Introduction

There are two main commands that will help us accomplish our goal.
- `host_framerate`
  - how many frames to render per **in-game** second (not real time second)
  - makes the demo play not in real time
  - real-time FPS no longer matters
- `host_sleep`
  - pauses the game _n_ milliseconds after each frame
  - great for limiting frame times

## Afterburner Settings

We need to make sure Afterburner will capture every single new frame TF2 renders out.
- Max out the recording framerate to 120 FPS
- Make sure frame limit is disabled
- Null frames **must be enabled** in Lagarith options

Lagarith can insert null frames instead of frames that are exactly the same as the
one before them. This means that high FPS will have minimal impact on file size.  

The only situation, where you should lower the recording framerate,
is when you're 100% sure TF2 will render not a single frame faster than
the sampling interval (that frame would not be captured).

## How To

Once you have set up Afterburner and game resolution, load the demo and go
to where you want to start, once there **pause**.

Type in `host_framerate 60` if you want the final footage at 60 FPS,
or another number for another framerate. Up to 300 is OK, above that you
might encounter issues with physics, animations, particles, everything, etc.

Next, type in `host_sleep 20`. Sampling interval at 120 FPS is  8.33 ms (_1s/120_),
so 20 ms should give Afterburner be more than enough time to pick up each frame.  
The higher you go, the slower will it be. Go too low and you start dropping frames.

TF2 can be _a bit_ unstable at high resolutions, depending on your system.
Up to 4K should be fine, but if it crashes, increasing `host_sleep` and lowering
Afterburner framerate might help (at 8K I had to use 10 FPS, 500 sleep).

Now you can hide UI, enable ReShade, start recording,
then hit your bind to resume the demo.

How slow/fast it will go depends on your framerate, resolution,
and your PC's capabilities.

When it reaches where you want it to end, you can stop the recording.
Setting both `host_framerate` and `host_sleep` to 0 will change everything
back to normal.

## Processing the Footage

Ffmpeg can remove consecutive duplicate frames. Drag and drop the outcome
of the recording onto `\tools\separate-layers+filter-frames.cmd`
to get the final two layers.  
You'll be asked for a framerate, enter **the same number** you set `host_framerate`
to when recording.

It will take a bit longer than the simple recording version,
but in the end you'll have your world and depth layers with
the correct and constant framerate and time flow.

## Notes

- If the time flow of the final footage is messed up, you need to up `host_sleep`
  or Afterburner FPS.





