
global.vfps_r = 0;
var base_fps = 1000/argument0;
vfps_accumulator += abs(1000/fps_real);
while vfps_accumulator >= base_fps
{   global.vfps_r++;
    vfps_accumulator -= base_fps;
}
room_speed = max(fps_real,1);

