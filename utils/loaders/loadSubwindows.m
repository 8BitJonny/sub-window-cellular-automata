function varargout = loadSubwindows(sub_window_paths)
	if(ischar(sub_window_paths))
		sub_window_paths = {sub_window_paths};
	endif
	varargout = {};
	for i = 1:length(sub_window_paths)
		varargout{end+1} = load(["./SubWindows/" sub_window_paths{i} ".mat"]).("sub_windows");
	end
endfunction
