#!/bin/bash
#
#simple one-liner script to copy pngs together in single 2-row png,
# and split them apart again into tiles of 1x2 pngs per tile, print hem out  
#
# imagemagick must be installed, 
# and firefox must be in your PATH
#
# fn="AGU-hydrogeology. Common 10,20,30,40,50 terms" ; 
fn="AGU-volcanology Common 10,20,30,40,50 terms" ; 
 montage c*-1*.png c*-2*.png -tile x2 -geometry 1024x1024\>+10+10 -gravity center -crop 2600x2600+0+400  "$fn" ; convert -rotate 90 "$fn" "$fn-90" ; convert  -crop 1x5@  +repage  +adjoin "$fn-90" -rotate -90 -gravity South -annotate +0+10 "$fn" -rotate 90  "$fn.png"
rm "$fn" "$fn-90"
ls -1 A*.png | xargs -i firefox "{}" &
#
# send to line printer 
# print them xargs -i lpr "{}" -P ICDP_color_A69_hp -T "{}"
