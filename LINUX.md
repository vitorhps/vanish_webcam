# Linux

Tested on Arch (Hyprland, Wayland with XWayland) with a USB webcam.

## Virtual camera

The output goes to a v4l2loopback device. Install and load it once:

```bash
sudo pacman -S --needed v4l2loopback-dkms v4l2loopback-utils
sudo modprobe v4l2loopback devices=1 video_nr=10 exclusive_caps=1 card_label="Vanish Cam"
```

To load it at boot:

```bash
echo v4l2loopback | sudo tee /etc/modules-load.d/v4l2loopback.conf
echo 'options v4l2loopback devices=1 video_nr=10 exclusive_caps=1 card_label="Vanish Cam"' | sudo tee /etc/modprobe.d/v4l2loopback.conf
```

## Run

```bash
./run.sh --mode normal   # V sign
./run.sh --mode naruto   # palms together
```

The first run creates `.venv`, installs `requirements.txt` and downloads the
MediaPipe models. Then pick **Vanish Cam** as the camera in Meet, Zoom or Teams.

Keys in the preview window: `R` reappear, `V` vanish, `SPACE` new background,
`F` fullscreen, `Q` quit.

## Notes

- `sounddevice` is blocked on Linux before MediaPipe loads: through PortAudio
  and the ALSA JACK plugin it loads PipeWire's RT module, and the process is
  killed with SIGKILL while the models are created. The audio tasks of
  MediaPipe are not used here.
- The webcam is opened with V4L2 and MJPG.
- The Naruto sound plays on the local speakers through pygame, not in the call.
