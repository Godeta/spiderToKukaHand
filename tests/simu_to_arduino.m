delete(instrfind)
close all
for i = 1:2
    serialObj = serial("COM10","baudRate", 9600)
    flushinput(serialObj)
    fopen(serialObj)
%     val = sim('xboxControl.slx', 10000).simout.Data
    val = input('Enter a text value: ', 's');  % 's' specifies that the input is a string
    % fwrite(serialObj, 1000)
%     val = out.simout.Data
    if(val<0)
        val = -val
    end
    fprintf(serialObj,'%s\n',char(val)); %string with new line terminator
    fclose(serialObj)
end