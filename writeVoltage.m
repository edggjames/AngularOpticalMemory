function [flag] = writeVoltage(dq,v_write)
%Function to write voltage to DAQ

if v_write <= 6 && v_write >= -6
    write(dq,v_write)
    flag = false;
else
    disp('Warning - voltage out of range')
    flag = true;
    return % break out of script
end
end