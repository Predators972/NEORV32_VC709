% Settings
fs = 8000;  % 8 kHz sampling frequency
duration = 1;  % 1 second duration
t = 0:1/fs:duration-1/fs;

% "YES" signal - 150 Hz frequency
frequency_yes = 150;
yes_signal = sin(2*pi*frequency_yes*t);

% Add light noise for realism
yes_signal = yes_signal + 0.1*randn(size(yes_signal));

% Normalize to 0-255 (8-bit ADC)
yes_normalized = uint8((yes_signal + 1) / 2 * 255);

% Save as binary file
fid = fopen('yes.dat', 'w');
fwrite(fid, yes_normalized, 'uint8');
fclose(fid);

% "NO" signal - different frequency (250 Hz)
frequency_no = 250;
no_signal = sin(2*pi*frequency_no*t);
no_signal = no_signal + 0.1*randn(size(no_signal));
no_normalized = uint8((no_signal + 1) / 2 * 255);

fid = fopen('no.dat', 'w');
fwrite(fid, no_normalized, 'uint8');
fclose(fid);

disp('Files created: yes.dat and no.dat');