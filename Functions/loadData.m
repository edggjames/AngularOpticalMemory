function [im_stack, log, params] = loadData(data_file)
%Function to load in data, convert to double and normalise

load(data_file, 'im_stack', 'log', 'params')
% don't load adapter_info,info,dev_info,cam,camProps
im_stack = double(im_stack);
% normalise
im_stack = im_stack-min(im_stack(:));
im_stack = im_stack/max(im_stack(:));
end