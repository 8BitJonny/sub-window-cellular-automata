function images = loadImages(images_path, max_matches_per_pattern = 1)
	if(ischar(images_path))
		images_path = {images_path};
	endif
	images = {};
	for i = 1:length(images_path)
		full_image_paths = glob(["./images/" images_path{i} ".*"])(1:max_matches_per_pattern);
		for j = 1:length(full_image_paths)
			img = imread(full_image_paths{j});
			if (max(max(img)) > 1)
				img = im2bw(img);
			endif
			if (!isa(img, 'double'))
				img = im2double(img, "indexed");
			endif
			images{end+1} = img;
		endfor
	end
endfunction
