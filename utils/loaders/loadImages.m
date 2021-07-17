function images = loadImages(images_path)
	if(ischar(images_path))
		images_path = {images_path};
	endif
	for i = 1:length(images_path)
		full_image_path = glob(["./images/" images_path{i} ".*"]){1};
		img = imread(full_image_path);
		if (max(max(img)) > 1)
			img = im2bw(img);
		endif
		if (isbool(img))
			img = im2double(img, "indexed");
		endif
		images.(images_path{i}) = img;
	end
endfunction
