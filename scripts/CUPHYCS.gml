
/*Return container
*/var pcol = argument0;
/*Starting and ending relative top if spinning; otherwise, use 1 (or your preference) for both
1: gravity is +y, 2: gravity is +z, 3: gravity is +x,
4: gravity is -x, 5: gravity is -z, 6: gravity is -y [ARRAY]
*/var qspin = argument1[0];
var qspin2 = argument1[1];
/*Object's facing direction (north:2,west:3,east:4,south:5), relative to the top [ARRAY]
*/var ort = argument1[2];
/*If object should spin when spinning is done [ARRAY]
*/var spa = argument1[3];
/*Camera's horizontal spin to adjust relative movement to camera;
otherwise, use "undefined" to use absolute movement
*/var cam = argument2;
/*Relative or absolute motion in x, z, and y [ARRAY]
*/if is_array(argument3)
{   var xv = argument3[0];
    var zv = argument3[1];
    var ygrav = argument3[2];
}
else
{   var xv = 0;
    var zv = 0;
    var ygrav = 0;
}
/*Top's gravity
*/var force = argument4;
/*Size of object in x, z, and y [ARRAY]
*/var sqx = argument5[0];
var sqz = argument5[1];
var sqy = argument5[2];
/*Which list of objects to check collision against [()ARRAY]
*/var cubes;
if !is_array(argument6)
    cubes[0] = argument6;
else for (var c=0;c<array_length_1d(argument6);c++)
    cubes[c] = argument6[c];
/*Hitscan box [ARRAY]
*/if is_array(argument7)
{   var pbx = argument7[0];
    var pbz = argument7[1];
    var pby = argument7[2];
    var prx = argument7[3];
    var prz = argument7[4];
    var pry = argument7[5];
}

//Relative or absolute movement of object
if !is_undefined(cam)
{   var xgrav = (-zv*dcos(-cam+270+90*(qspin==3 or qspin==6)-90*(qspin==2))
                 +xv*dcos(-cam+90*(qspin==3 or qspin==6)-90*(qspin==2)));// * sign(cam.cc);
    var zgrav = (-zv*dsin(-cam+270+90*(qspin==3 or qspin==6)-90*(qspin==2))
                 +xv*dsin(-cam+90*(qspin==3 or qspin==6)-90*(qspin==2)));// * sign(cam.cc);
    ygrav += force;
}
else
{   var xgrav = xv;
    var zgrav = zv;
}

//Object's angle direction in respect to top, given in degrees (0-360)
var aort = -darctan2(zgrav,xgrav);
if zgrav >= 0
    aort += 360;
/*if (aort!=360) switch ort
{   case 2:     if aort == 270
                    ort = 5;
                else if aort > 270
                    ort = 4;
                else if (aort<270) and (aort>180)
                    ort = 3;
                break;
    case 3:     if aort == 0
                    ort = 4;
                else if aort < 90
                    ort = 2;
                else if aort > 270
                    ort = 5;
                break;
    case 4:     if aort == 180
                    ort = 3;
                else if (aort>90) and (aort<270)
                {   if aort < 180
                        ort = 2;
                    else
                        ort = 5;
                }
                break;
    case 5:     if aort == 90
                    ort = 2;
                else if aort < 180
                {   if aort > 90
                        ort = 3;
                    else
                        ort = 4;
                }
                break;
}*/
if (aort!=360 and aort!=180) switch ort
{   case 2:     if (aort>135) and (aort<225)
                    ort = 3;
                else if (aort>=225) and (aort<=315)
                    ort = 5;
                else if (aort>315) or (aort<45)
                    ort = 4;
                break;
    case 3:     if (aort>225) and (aort<315)
                    ort = 5;
                else if (aort>=315) or (aort<=45)
                    ort = 4;
                else if (aort>45) and (aort<135)
                    ort = 2;
                break;
    case 4:     if (aort>45) and (aort<135)
                    ort = 2;
                else if (aort>=135) and (aort<=225)
                    ort = 3;
                else if (aort>225) and (aort<315)
                    ort = 5;
                break;
    case 5:     if (aort>315) or (aort<45)
                    ort = 4;
                else if (aort>=45) and (aort<=135)
                    ort = 2;
                else if (aort>135) and (aort<225)
                    ort = 3;
                break;
}

//Collision and speed setup in respect to top
var x2 = x + sqx;
var z2 = z + sqz;
var y2 = y + sqy;
var hold = 0;
var vold = 0;
var gold = 0;
switch (qspin)
{   case 1:     var hme = x2;
                var hec = 0;
                var htm = 0;
                var vme = z2;
                var vec = 1;
                var vtm = 0;
                var gme = y2;
                var gec = 2;
                var gtm = 0;
                var xspeed = xgrav;//Absolute x motion
                var zspeed = zgrav;//Absolute z motion
                var yspeed = ygrav;//Absolute y motion
                var hnew = xspeed;
                var vnew = zspeed;
                var gnew = yspeed;
                var nort = ort;//Absolute facing angle
                break;
    case 2:     var hme = x2;
                var hec = 0;
                var htm = 0;
                var vme = y;
                var vec = 2;
                var vtm = 1;
                var gme = z2;
                var gec = 1;
                var gtm = 0;
                var xspeed = xgrav;
                var zspeed = ygrav;
                var yspeed = -zgrav;
                var hnew = xspeed;
                var vnew = yspeed;
                var gnew = zspeed;
                if ort == 2
                    var nort = 6;
                else if ort == 5
                    var nort = 1;
                else
                    var nort = ort;
                break;
    case 3:     var hme = y;
                var hec = 2;
                var htm = 1;
                var vme = z2;
                var vec = 1;
                var vtm = 0;
                var gme = x2;
                var gec = 0;
                var gtm = 0;
                var xspeed = ygrav;
                var zspeed = zgrav;
                var yspeed = -xgrav;
                var hnew = yspeed;
                var vnew = zspeed;
                var gnew = xspeed;
                if ort == 3
                    var nort = 6;
                else if ort == 4
                    var nort = 1;
                else
                    var nort = ort;
                break;
    case 4:     var hme = y2;
                var hec = 2;
                var htm = 0;
                var vme = z2;
                var vec = 1;
                var vtm = 0;
                var gme = x;
                var gec = 0;
                var gtm = 1;
                var xspeed = -ygrav;
                var zspeed = zgrav;
                var yspeed = xgrav;
                var hnew = yspeed;
                var vnew = zspeed;
                var gnew = xspeed;
                if ort == 3
                    var nort = 1;
                else if ort == 4
                    var nort = 6;
                else
                    var nort = ort;
                break;
    case 5:     var hme = x2;
                var hec = 0;
                var htm = 0;
                var vme = y2;
                var vec = 2;
                var vtm = 0;
                var gme = z;
                var gec = 1;
                var gtm = 1;
                var xspeed = xgrav;
                var zspeed = -ygrav;
                var yspeed = zgrav;
                var hnew = xspeed;
                var vnew = yspeed;
                var gnew = zspeed;
                if ort == 2
                    var nort = 1;
                else if ort == 5
                    var nort = 6;
                else
                    var nort = ort;
                break;
    case 6:     var hme = x;
                var hec = 0;
                var htm = 1;
                var vme = z2;
                var vec = 1;
                var vtm = 0;
                var gme = y;
                var gec = 2;
                var gtm = 1;
                var xspeed = -xgrav;
                var zspeed = zgrav;
                var yspeed = -ygrav;
                var hnew = xspeed;
                var vnew = zspeed;
                var gnew = yspeed;
                if ort == 3
                    var nort = 4;
                else if ort == 4
                    var nort = 3;
                else
                    var nort = ort;
                break;
}

//New position during axel spin
var sq = sqx;//NEEDS TO BE MODIFIED IN cube PROJECT
if qspin2 != qspin
{   switch qspin2
    {   case 1: y += 2*(32+sq/2) * spa;
        case 6: y -= (32+sq/2) * spa;
                if (nort==2) or (nort==5)
                {   var qdiff = ((spx+96) - (x+(sq/2))) * spa;
                    x += qdiff;
                }
                else
                {   var qdiff = ((spz+96) - (z+(sq/2))) * spa;
                    z += qdiff;
                }
                if qspin2 == 6
                    qdiff *= -1;
                break;
                
        case 2: z += 2*(32+sq/2) * spa;
        case 5: z -= (32+sq/2) * spa;
                if (ort==2) or (ort==5)
                {   var qdiff = ((spx+96) - (x+sq/2)) * spa;
                    x += qdiff;
                    if qspin2 == ort
                        nort = 6;
                    else
                        nort = 1;
                }
                else
                {   var qdiff = ((spy+96) - (y+sq/2)) * spa;
                    y += qdiff;
                }
                if qspin2 == 5
                    qdiff *= -1;
                break;
                
        case 3: x += 2*(32+sq/2) * spa;
        case 4: x -= (32+sq/2) * spa;
                if (ort==3) or (ort==4)
                {   var qdiff = ((spz+96) - (z+sq/2)) * spa;
                    z += qdiff;
                    if qspin2 == ort
                        nort = 6;
                    else
                        nort = 1;
                }
                else
                {   var qdiff = ((spy+96) - (y+sq/2)) * spa;
                    y += qdiff;
                }
                if qspin2 == 4
                    qdiff *= -1;
                break;
    }
    ////
    switch qspin
    {   case 1: y -= 2*(32+sq/2) * spa;
                qdiff *= -1;
        case 6: y += (32+sq/2) * spa;
                if (nort==2) or (nort==5)
                    x -= qdiff;
                else
                    z -= qdiff;
                break;
                
        case 2: z -= 2*(32+sq/2) * spa;
                qdiff *= -1;
        case 5: z += (32+sq/2) * spa;
                if (nort==1) or (nort==6)
                {   x -= qdiff;
                    if qspin == 2
                    {   if nort == 1
                            ort = 5;
                        else
                            ort = 2;
                    }
                    else
                    {   if nort == 1
                            ort = 2;
                        else
                            ort = 5;
                    }
                }
                else
                    y -= qdiff;
                break;
                
        case 3: x -= 2*(32+sq/2) * spa;
                qdiff *= -1;
        case 4: x += (32+sq/2) * spa;
                if (nort==1) or (nort==6)
                {   z -= qdiff;
                    if qspin == 3
                    {   if nort == 1
                            ort = 4;
                        else
                            ort = 3;
                    }
                    else
                    {   if nort == 1
                            ort = 3;
                        else
                            ort = 4;
                    }
                }
                else
                    y -= qdiff;
                break;
    }
}
qspin2 = qspin;

//Collision reduction checking, from x to z to y
var cub = ds_list_create();
for (var c=0;c<array_length_1d(cubes);c++)//CUB SIZE WILL HAVE ISSUES AT 1D COLLISION
{   ds_list_clear(cub);
    ds_list_copy(cub,cubes[c]);
    ////
    if !c
        var xchk = ds_list_create();
    for (var i=0;i<ds_list_size(cub);i++)
    {   var e = cub[|i];
        if ((x+xspeed<e[0,1]) and (x2+xspeed>e[0,0]))
        or ((gec==0) and (x<e[0,1]) and (x2>e[0,0]))
            ds_list_add(xchk,e);
    }
    ////
    if !c
        var zchk = ds_list_create();
    for (i=0;i<ds_list_size(xchk);i++)
    {   e = xchk[|i];
        if ((z+zspeed<e[1,1]) and (z2+zspeed>e[1,0]))
        or ((gec==1) and (z<e[1,1]) and (z2>e[1,0]))
            ds_list_add(zchk,e);
    }
    ds_list_clear(xchk);
    ////
    if !c
        var ychk = ds_list_create();
    for (i=0;i<ds_list_size(zchk);i++)
    {   e = zchk[|i];
        if ((y+yspeed<e[2,1]) and (y2+yspeed>e[2,0]))
        or ((gec==2) and (y<e[2,1]) and (y2>e[2,0]))
            ds_list_add(ychk,e);
    }
    ds_list_clear(zchk);
}

//Extra collision detection for specific cases, add more if needed
//Hitscan in ort 6 (y up)
var hchk = ds_list_create();
if object_index == asset_get_index("hitscan")
for (i=0;i<ds_list_size(ychk);i++)
{   e = ychk[|i];
    //Midpoints and distances from it to out
    var xmid = (e[0,0]+e[0,1])/2;
    var zmid = (e[1,0]+e[1,1])/2;
    var ymid = (e[2,0]+e[2,1])/2;
    var xdist = abs(xmid-e[0,0]);
    var zdist = abs(zmid-e[1,0]);
    var ydist = abs(ymid-e[2,0]);
    
    var hfail = 0;
    var hunder = 0;
    var vecr = point_direction(pbx,pbz,prx,prz);
    //If not completely under or above target, get shifted x and z point checks
    if !(pbx<=e[0,1] and pbx>=e[0,0] and pbz<=e[1,1] and pbz>=e[1,0])
    {   //Distances of closest and furthest corner from player in x
        var spacx = sign(xmid-pbx) * (abs(xmid-pbx)-xdist);
        if xmid-pbx == 0
        {   spacx = xdist;
            var mdx = -xdist;
        }
        else
            var mdx = sign(xmid-pbx) * 2*xdist;
        //Distances of closest and furthest corner from player in z
        var spacz = sign(zmid-pbz) * (abs(zmid-pbz)-zdist);
        if zmid-pbz == 0
        {   spacz = zdist;
            var mdz = -zdist;
        }
        else
            var mdz = sign(zmid-pbz) * 2*zdist;
        //Angles toward corners and distance to closest corner in x and z
        var vec1 = point_direction(pbx,pbz,pbx+spacx,pbz+spacz+mdz);
        var vec2 = point_direction(pbx,pbz,pbx+spacx,pbz+spacz);
        var vec3 = point_direction(pbx,pbz,pbx+spacx+mdx,pbz+spacz);
        var refh = abs(angle_difference(vec2,vecr));
        var hyp = sqrt(sqr(spacx)+sqr(spacz));
        
        if (pbx<=e[0,1]) and (pbx>=e[0,0])//Inside target in x
        {   if (vecr<min(vec2,vec3)) or (vecr>max(vec2,vec3))
                hfail = 1;
            else
                var wx = sign(-spacx) * (hyp*dsin(refh)) / dsin(180-refh-abs(darcsin(spacz/hyp)));
        }
        else//Outside target in x
        {   if abs(angle_difference(vec1,vecr)) <= abs(angle_difference(vec1,vec2))
                var wx = 0;
            else
                var wx = sign(prx-pbx) * (hyp*dsin(refh)) / dsin(abs(darcsin(spacz/hyp))-refh);
        }
        
        if !hfail
        {   if (pbz<=e[1,1]) and (pbz>=e[1,0])//Inside target in z
            {   if (-spacx and (vecr<min(vec2,vec1) or vecr>max(vec2,vec1)))
                or (spacx and (vecr>min(vec2,vec1) and vecr<max(vec2,vec1)))
                    hfail = 1;
                else
                    var wz = sign(-spacz) * (hyp*dsin(refh)) / dsin(180-refh-abs(darcsin(spacx/hyp)));
            }
            else//Outside target in z
            {   if abs(angle_difference(vec3,vecr)) <= abs(angle_difference(vec3,vec2))
                    var wz = 0;
                else
                    var wz = sign(prz-pbz) * (hyp*dsin(refh)) / dsin(abs(darcsin(spacx/hyp))-refh);
            }
        }
        //Shifted x and z point checks without y adjustments
        if !hfail
        {   var shfx = wx + spacx;
            var shfz = wz + spacz;
        }
    }
    else
    {   var shfx = 0;
        var shfz = 0;
        hunder = 1;
    }
    
    //Get elevation point check and readjust x and z point checks
    if !hfail
    {   //Elevation angles for aim target, bottom of target, and top of target
        if (shfx==0) and (shfz==0)
        {   var mdx = prx - pbx;
            var mdz = prz - pbz;
        }
        else
        {   var mdx = shfx;
            var mdz = shfz;
        }
        var refh = darccos(min(1,dot_product_3d_normalised(mdx,0,mdz,
                                                           prx-pbx,pry-pby,prz-pbz)));
        var refb = darccos(min(1,dot_product_3d_normalised(mdx,0,mdz,
                                                           mdx,ymid-ydist-pby,mdz)));
        var reft = darccos(min(1,dot_product_3d_normalised(mdx,0,mdz,
                                                           mdx,ymid+ydist-pby,mdz)));
        
        if !(pby>=e[2,0] and pby<=e[2,1])//Outside of target in y
        {   if pby < e[2,0]
            {   var refa = refb;
                var refm = reft;
                var shfy = ymid-ydist-pby;
            }
            else
            {   var refa = reft;
                var refm = refb;
                var shfy = ymid+ydist-pby;
            }
            if hunder or (refh<refa)//Aiming at bottom/top of target
            {   var shfy2 = abs(shfy/dtan(refh));
                shfx = lengthdir_x(shfy2,vecr);
                shfz = lengthdir_y(shfy2,vecr);
            }
            else if refh <= refm//Aiming at sides of target
                shfy += sign(shfy) * sqrt(sqr(shfx)+sqr(shfz)+sqr(shfy)) * dsin(refh-refa) / dcos(refh);
            else
                hfail = 1;
        }
        else//Inside of target in y
        {   var shfy = sqrt(sqr(shfx)+sqr(shfz)) * dtan(refh);
            if sign(pry-pby) >= 0
            {   if refh > reft
                    hfail = 1;
            }
            else if refh <= refb
                shfy *= -1;
            else
                hfail = 1;
        }
        
        if !hfail and (shfx+pbx-0.1<e[0,1]) and (shfx+pbx+0.1>e[0,0])
        and (shfz+pbz-0.1<e[1,1]) and (shfz+pbz+0.1>e[1,0])
        {   ds_list_add(hchk,e);
            ds_list_add(hchk,shfx);
            ds_list_add(hchk,shfz);
            ds_list_add(hchk,shfy);
        }
    }
    /*if ((player.basex<=e[0,1]) and (player.basex>=e[0,0]))
    or ((player.basez<=e[1,1]) and (player.basez>=e[1,0]))
    {   if (player.basex<=e[0,1]) and (player.basex>=e[0,0])
        {   if sign(spacx) != sign(player.retix-player.basex)
            {   vec2 = vec3;
                spacx = abs(spacx) - 2*xdist;
            }
            var wx = sign(player.retix-player.basex)*abs(spacx)
                   * abs(angle_difference(point_direction(player.basex,player.basez,player.basex,
                   player.basez+sign(zmid-player.basez)),vecr))
                   / abs(angle_difference(point_direction(player.basex,player.basez,player.basex,
                   player.basez+sign(zmid-player.basez)),vec2));
            spacx = 0;
            wz = 0;
        }
        else
        {   if sign(spacz) != sign(player.retiz-player.basez)
            {   vec2 = vec1;
                spacz = abs(spacz) - 2*zdist;
            }
            var wz = sign(player.retiz-player.basez)*abs(spacz)
                   * abs(angle_difference(point_direction(player.basex,player.basez,
                   player.basex+sign(xmid-player.basex),player.basez),vecr))
                   / abs(angle_difference(point_direction(player.basex,player.basez,
                   player.basex+sign(xmid-player.basex),player.basez),vec2));
            spacz = 0;
            wx = 0;
        }
    }
    else
    {   if (abs(angle_difference(vec1,vecr)) <= abs(angle_difference(vec1,vec2)))
            var wx = 0;
        else
            var wx = sign(spacx)*2*xdist * abs(angle_difference(vec2,vecr)) / abs(angle_difference(vec2,vec3));
        if (abs(angle_difference(vec3,vecr)) <= abs(angle_difference(vec3,vec2)))
            var wz = 0;
        else
            var wz = sign(spacz)*2*zdist * abs(angle_difference(vec2,vecr)) / abs(angle_difference(vec2,vec1));
    }*/
}
////
//Slopes
var gchk = ds_list_create();
var add_to_g2 = 0;
for (i=ds_list_size(ychk);i>0;i--)
{   var add_to_g = 0;
    e = ychk[|i-1];
    if !gtm
    {   if !(gme-8 <= e[gec,gtm])
            add_to_g = 1;
    }
    else if !(gme+8 >= e[gec,gtm])
        add_to_g = 1;
    
    if !add_to_g for (var j=ds_list_size(ychk);j>0;j--)
    {   var c = ychk[|j-1];
        if (e[3]!=c[3]) and (e[gec,gtm]!=c[gec,gtm])
        and ((c[0,0]>=e[0,0] and c[0,1]<=e[0,1]) and (c[1,0]>=e[1,0] and c[1,1]<=e[1,1])
        or (c[0,0]>=e[0,0] and c[0,1]<=e[0,1]) and (c[2,0]>=e[2,0] and c[2,1]<=e[2,1])
        or (c[2,0]>=e[2,0] and c[2,1]<=e[2,1]) and (c[1,0]>=e[1,0] and c[1,1]<=e[1,1]))
        {   if (x<c[0,0]) and (x2<=c[0,0])
                var wplane = (e[0,0]==c[0,0]);
            else if (x>=c[0,1]) and (x2>c[0,1])
                var wplane = (e[0,1]==c[0,1]);
            else if (z<c[1,0]) and (z2<=c[1,0])
                var wplane = (e[1,0]==c[1,0]);
            else if (z>=c[1,1]) and (z2>c[1,1])
                var wplane = (e[1,1]==c[1,1]);
            else if (y<c[2,0]) and (y2<=c[2,0])
                var wplane = (e[2,0]==c[2,0]);
            else if (y>=c[2,1]) and (y2>c[2,1])
                var wplane = (e[2,1]==c[2,1]);
            else
                var wplane = 0;
            if wplane
            {   if !gtm
                {   if !(e[gec,gtm]-8 < c[gec,gtm+1-1])
                    {   add_to_g = 1;
                        break;
                    }
                }
                else if !(e[gec,gtm]+8 > c[gec,gtm-1+1])
                {   add_to_g = 1;
                    break;
                }
            }
        }
    }
    add_to_g2 |= add_to_g<<(i-1);
}
if add_to_g2 for (i=ds_list_size(ychk);i>0;i--)
{   if (add_to_g2>>(i-1))&1
    {   ds_list_add(gchk,ychk[|i-1]);
        ds_list_delete(ychk,i-1);
    }
}
////
//Win
var wchk = 0;
for (i=ds_list_size(gchk);i>0;i--)
{   e = gchk[|i-1];
    if e[3].object_index == asset_get_index("next_b")
    {   wchk = e;
        ds_list_delete(gchk,i-1);
        break;
    }
}

//Collision 2D detection, sides
if ds_list_size(gchk)
{   if hnew*(-2*htm+1) < 0
    {   hme = hme + sq*(2*htm-1);
        htm = 1 - htm;
    }
    if vnew*(-2*vtm+1) < 0
    {   vme = vme + sq*(2*vtm-1);
        vtm = 1 - vtm;
    }
    
    e = gchk[|0];
    var hdiff = e[hec,htm] - hme;
    var vdiff = e[vec,vtm] - vme;
    if abs(hdiff) < abs(hnew)
        hnew = hdiff;
    if abs(vdiff) < abs(vnew)
        vnew = vdiff;
    
    if ds_list_size(gchk) > 1
    {   var hplane = e[hec,htm];
        var vplane = e[vec,vtm];
        var gtplane = e[gec,gtm];
        var gbplane = e[gec,1-gtm];
        for (i=1;i<ds_list_size(gchk);i++)
        {   e = gchk[|i];
            hdiff = e[hec,htm] - hme;
            vdiff = e[vec,vtm] - vme;
            
            if !(vplane==e[vec,vtm] and (gbplane==e[gec,1-gtm] or gtplane==e[gec,gtm]))
            //and !(gbplane==e[gec,gtm] or gtplane==e[gec,1-gtm])
            {   if abs(hdiff) < abs(hnew)
                    hnew = hdiff;
                hold = -1;
            }
            else if (hold != -1)
                hold = 1;
            
            if !(hplane==e[hec,htm] and (gbplane==e[gec,1-gtm] or gtplane==e[gec,gtm]))
            //and !(gbplane==e[gec,gtm] or gtplane==e[gec,1-gtm])
            {   if abs(vdiff) < abs(vnew)
                    vnew = vdiff;
                vold = -1;
            }
            else if (vold != -1)
                vold = 1;
            
            hplane = e[hec,htm];
            vplane = e[vec,vtm];
            gtplane = e[gec,gtm];
            gbplane = e[gec,1-gtm];
        }
    }
}

//Collision 1D detection, up and down
//var spbb = 0;
//var force = 0;
var nospin = 0;
var f_type = 0;
if ds_list_size(ychk)
{   if gnew*(-2*gtm+1) < 0
    {   gme = gme + sq*(2*gtm-1);
        gtm = 1 - gtm;
    }
    
    for (i=0;i<ds_list_size(ychk);i++)
    {   e = ychk[|i];
        var gdiff = e[gec,gtm] - gme;
        if abs(gdiff) <= abs(gnew)
            gnew = gdiff;
        if gdiff*(-2*gtm+1) < gold*(-2*gtm+1)
            gold = gdiff;
        
        if (e[3].sprite_width==64) and (e[3].sprite_height==64)
        and (ds_list_size(ychk)==1)
        {   spx = e[0,0] - 64*!(nort==3 or nort==4);
            var spx2 = spx + 192 - 128*(nort==3 or nort==4);
            spz = e[1,0] - 64*!(nort==2 or nort==5);
            var spz2 = spz + 192 - 128*(nort==2 or nort==5);
            spy = e[2,0] - 64*!(nort==1 or nort==6);
            var spy2 = spy + 192 - 128*(nort==1 or nort==6);
            var spbb = 1;
            //nospin = 0;
            
            for (j=0;j<ds_list_size(cub);j++)
            {   var c = cub[|j];
                if (spx)<c[0,1]
                and (spx2)>c[0,0]
                and (e[3]!=c[3])
                    ds_list_add(xchk,c);
            }
            for (j=0;j<ds_list_size(xchk);j++)
            {   c = xchk[|j];
                if (spz)<c[1,1]
                and (spz2)>c[1,0]
                    ds_list_add(zchk,c);
            }
            for (j=0;j<ds_list_size(zchk);j++)
            {   c = zchk[|j];
                if (spy<c[2,1]) and (spy2>c[2,0])
                {   nospin = 1;
                    break;
                }
            }
            if !nospin and (x+xspeed>=spx) and (x2+xspeed<=spx2)
            and (z+zspeed>=spz) and (z2+zspeed<=spz2)
            and (y+yspeed>=spy) and (y2+yspeed<=spy2)
            {   //e[3].top = 3;
                f_type |= 3<<(4*i);
            }
            else
            {   //e[3].top = 2;
                f_type |= 2<<(4*i);
                nospin = 1;
            }
        }
        else
        {   //e[3].top = 1;
            f_type |= 1<<(4*i);
            nospin = 1;
        }
    //f = e[2,ye];
    /*if (abs(ystest)<abs(yspeed))
        ynew = ystest;
    else
        ynew = yspeed;*/
    /*if ds_list_size(ychk) > 1
    {   //e = ychk[|1];
        //ydiff = e[2,ye];
        for (i=1;i<ds_list_size(ychk);i++)
        {   e = ychk[|i];
            //e = ychk[|0];
            ystest = abs(e[2,ye] - yt);
            
            /*if !(xdiff==e[0,xe] and zdiff==e[1,ze])
            {   if ((ystest)>(ynew))
                {   ynew = ystest;
                    //yold = -1;
                    f = e[2,ye];
                }*/
                //yold = -1;
            /*}
            else if yold != -1
                yold = 1;*/
            //ydiff = e[2,ye];
        //}
    }
    //ynew *= -1;
    //yspeed = f - yt - ynew;
}
else
    force = ygrav;// + force;//ggravity += 0.2;

//Position update
switch (qspin)
{   case 1: x += (hnew*!hold)+(xspeed*(hold>0));
            z += (vnew*!vold)+(zspeed*(vold>0));
            y += gnew + gold;//*!yold);//+(yspeed);
            break;
    case 2: x += (hnew*!hold)+(xspeed*(hold>0));
            y += (vnew*!vold)+(yspeed*(vold>0));
            z += (gnew) + gold;//*!yold);//+(yspeed);
            break;
    case 3: y += (hnew*!hold)+(yspeed*(hold>0));
            z += (vnew*!vold)+(zspeed*(vold>0));
            x += (gnew) + gold;//*!yold);//+(yspeed);
            break;
    case 4: y += (hnew*!hold)+(yspeed*(hold>0));
            z += (vnew*!vold)+(zspeed*(vold>0));
            x += (gnew) + gold;//*!yold);//+(yspeed);
            break;
    case 5: x += (hnew*!hold)+(xspeed*(hold>0));
            y += (vnew*!vold)+(yspeed*(vold>0));
            z += (gnew) + gold;//*!yold);//+(yspeed);
            break;
    case 6: x += (hnew*!hold)+(xspeed*(hold>0));
            z += (vnew*!vold)+(zspeed*(vold>0));
            y += (gnew) + gold;//*!yold);//+(yspeed);
            break;
}

ds_list_destroy(cub);
ds_list_destroy(xchk);
ds_list_destroy(zchk);
pcol[?"o_angle"] = ort;
pcol[?"r_angle"] = aort;
pcol[?"n_top"] = qspin;
pcol[?"o_top"] = qspin2;
ds_map_add_list(pcol,"wall",gchk);
ds_map_add_list(pcol,"floor",ychk);
ds_map_add_list(pcol,"hit",hchk);
pcol[?"next"] = wchk;
pcol[?"spin"] = !nospin;
pcol[?"force"] = force;
pcol[?"f_type"] = f_type;
//ds_list_destroy(ychk);
//ds_list_destroy(gchk);
return pcol;

