To regenerate the app icon PNGs, ensure that `librsvg` is installed
and run

```sh
for size in 20 29 40 58 60 76 80 87 120 152 167 180 1024; do
	rsvg-convert --height $size --width $size AppIcon.svg >Shevek/Assets.xcassets/AppIcon.appiconset/AppIcon@${size}x${size}.png
done
```
