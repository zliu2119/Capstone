fn = fullfile (tempdir(), "sombrero.mp4");
 w = VideoWriter (fn);
 open (w);
 z = sombrero ();
 hs = surf (z);
 axis manual
 nframes = 100;
 for ii = 1:nframes
   set (hs, "zdata", z * sin (2*pi*ii/nframes + pi/5));
   drawnow
   writeVideo (w, getframe (gcf));
 endfor
 close (w)