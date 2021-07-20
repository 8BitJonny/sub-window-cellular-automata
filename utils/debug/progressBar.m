function result = progressBar(number, message)
	persistent bar;
	persistent size;
	if (isempty (bar) || !ishandle(bar))
		size = number*2;
    	bar = waitbar(0, message, "createcancelbtn", "setappdata (gcbf,'interrupt',true)");
	else
		waitbar (number / size, bar, sprintf("%s %0.1f %%", message, number / size * 100));
  	endif
  	result = bar;
endfunction
