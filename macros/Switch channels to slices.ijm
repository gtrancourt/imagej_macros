getDimensions(width, height, channels, slices, frames)
run("Properties...", "channels="+slices+" slices="+channels+" frames=1 unit=pixel pixel_width=1.0000 pixel_height=1.0000 voxel_depth=1.0000");
run("Set pixel @ 0.1625 um");
