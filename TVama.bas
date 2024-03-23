   10 /***********************************/
   20 /*                                 */
   30 /*  TV_control AMA 68k             */
   40 /*                                 */
   50 /*     '87,10,18  Prog. by YosAwed */
   60 /***********************************/
   70 /*
   80 error off
   90 str t$[8],n$[30]
  100 int mx,my
  110 int f,pa=&H2C,pb=&H9A
  120 dim str vo(3)={" U  P "," DOWN "," NORM "," MUTE "}
  130 dim str ti(1)={"時刻設定","TimerSet"}
  140 dim str im(8)={" STILL"," MOVE "," 65535"," 256  ",
  150                "  16  ","512ﾗｲﾝ","256ﾗｲﾝ"," SAVE ",
  160                " LOAD "}
  170 screen 1,3,0,1
  180 imginit(&H0,2)
  190 mouse(0)
  200 msarea(25,25,480,480)
  210 mouse(4):mouse(1)
  220 setmspos(25,25)
  230 crt(3)
  240 while (1)
  250   f=mousechk()
  260   if f=1 then  gamen()
  270   if f=0 then  ending()
  280 endwhile
  290 end
  300 /*************************************/
  310 func ending()
  320   stilloff()
  330   crt(1)
  340   color 3:contrast(0)
  350   width 96:contrast(15)
  360   end
  370 endfunc
  380 /*************************************/
  390 func gamen()
  400   int r
  410   console ,,0
  420   v_cut(0):vpage(0)
  430   while (1)
  440     color  3:cls:locate 0,2
  450     color 13:print"■■■ Channel ■ Volume ■ 画面取り込み ■ Timer "
  460     r=mousechk()
  470     if r=0 then color 3:cls:return()
  480     if my<32 or my>48  then continue
  490     if mx>47 and mx<120 then chan()
  500     if mx>135and mx<200 then volu()
  510     if mx>215and mx<328 then gazo(28)
  520     if mx>343and mx<400 then tima()
  530   endwhile
  540 endfunc
  550 /**************************************/
  560 func mousechk()
  570  msbtn(0,1,0):msbtn(0,0,0)
  580  int l,r
  590  while (1)
  600    msstat(mx,my,l,r)
  610     if r=-1 then break
  620     if l<>-1 then continue
  630    mspos(mx,my)
  640    return(1)
  650  endwhile
  660  return(0)
  670 endfunc
  680 /**************************************/
  690 func chan()
  700   int f,i
  710   for i=1 to 12
  720      locate 6,3+i
  730      print using "###";i
  740   next
  750   while (1)
  760    f=mousechk()
  770    if f=0 then return()
  780    if mx<48 or mx>71 then continue
  790    if my<64 or my>255 then continue
  800    tv_ctrl((my-64)\16+16)
  810   endwhile
  820 endfunc
  830 /**************************************/
  840 func volu()
  850 int f,i
  860   for i=0 to 3
  870     locate 17,4+i
  880     print vo(i)
  890   next
  900   while (1)
  910     f=mousechk()
  920     if f=0 then return()
  930     if mx<135 or mx>184 then continue
  940     if my<64 or my>127 then continue
  950     if my>111 then tv_ctrl(6):continue
  960     tv_ctrl((my-64)\16+1)
  970   endwhile
  980 endfunc
  990 /***************************************/
 1000 func tima()
 1010 int e,f,i
 1020  for i=0 to 1
 1030    locate 43,4+i
 1040    print ti(i)
 1050  next
 1060  while (1)
 1070   f=mousechk()
 1080   if f=0 then return()
 1090   if mx<343  or mx>408 then continue
 1100   if my<64   or my>95  then continue
 1110   switch (my-64)\16
 1120       case 0
 1130              locate 43,7
 1140              print"時刻入力";:color 3:input t$
 1150              locate 43,7:print"                  ":color 13
 1160              break
 1170       case 1
 1180              if t$="" then {
 1190               locate 20,7:print"時刻を入れて下さい"
 1200               beep:for i=0 to 5000:next
 1210               color 3:locate 20,7:print"                  ":color 13
 1220               break
 1230               }
 1240              tv_ctrl(&HD)
 1250              while time$<>t$
 1260              endwhile
 1270              tv_ctrl(&H7)
 1280              crt(3):return()
 1290    endswitch
 1300  endwhile
 1310 endfunc
 1320 /**************************************/
 1330 func tv_ctrl(no;int)
 1340   iocs(&HC,no,0,0,0,0,0)
 1350 endfunc
 1360 /**************************************/
 1370 func gazo(gx;int)
 1380   int f,i
 1390   for i=0 to 8
 1400      locate gx,4+i
 1410      print im(i)
 1420   next
 1430   stilloff()
 1440   while (1)
 1450    f=mousechk()
 1460     if f=0 then return()
 1470     if mx<gx*8 or mx>gx*8+48 then continue
 1480     if my<64  or my>207 then continue
 1490    switch (my-64)\16
 1500      case 0:still():break
 1510      case 1:stilloff():break
 1520      case 2:imginit(&H0,2):break
 1530      case 3:imginit(&HF,1):break
 1540      case 4:imginit(&H17,0):break
 1550      case 5:scr1():return()
 1560      case 6:scr2():return()
 1570      case 7:imsave():return()
 1580      case 8:imload():return()
 1590    endswitch
 1600   endwhile
 1610   stilloff()
 1620 endfunc
 1630 /**************************************/
 1640 func imginit(gl;int,gr;int)
 1650  img_set(&H4)
 1660  img_set(&H8)
 1670  img_set(&H10)
 1680  img_set(gl)
 1690  img_set(&HFF)
 1700  img_color(gr)
 1710 endfunc
 1720 /**************************************/
 1730 func still()
 1740 int i
 1750  img_still(0)
 1760  for i=0 to 200:next
 1770  img_pos(pa)
 1780  vpage(1)
 1790 endfunc
 1800 /**************************************/
 1810 func stilloff()
 1820  v_cut(0)
 1830  vpage(0)
 1840  img_pos(pb)
 1850  img_still(1)
 1860 endfunc
 1870 /****************************************/
 1880 func scr1()
 1890  vpage(0):color 3
 1900  pa=&H2C:pb=&H9A
 1910  screen 1,3,0,1
 1920 endfunc
 1930 /****************************************/
 1940 func scr2()
 1950  vpage(0):color 3
 1960  screen 0,3,0,1:color 15
 1970  pa=&H24:pb=&HEB
 1980  vpage(1)
 1990  gazo(4)
 2000  color 3:screen 1,3,0,1
 2010  vpage(1)
 2020 endfunc
 2030 /****************************************/
 2040 func imsave()
 2050  v_cut(1)
 2060  color 3:locate 4,5  :input "ﾌｧｲﾙ名",n$
 2070  img_save(n$)
 2080  screen 1,3,0,1:v_cut(0):vpage(1)
 2090 endfunc
 2100 /****************************************/
 2110 func imload()
 2120  still()
 2130  v_cut(1)
 2140  vpage(1)
 2150  color 3:locate  4, 5:input "ﾌｧｲﾙ名",n$
 2160  img_load(n$)
 2170 endfunc
