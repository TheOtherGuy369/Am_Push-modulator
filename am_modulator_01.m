% Parameters
fs = 1000;                          % Sampling frequency (Hz)
t = 0:1/fs:1;                       % Time vector (1 second duration)
w1 = 2;                             % Frequency for y(t) modulation
A1 = 1;                             % Amplitude for x(t)
A2 = 0.5;                           % Amplitude for y(t)

% Generate input signals
x = A1 * sin(2*pi*10*t);            % x(t) signal (example: sinusoidal signal with frequency 10 Hz)
y = A2 * sin(2*pi*5*t);             % y(t) signal (example: sinusoidal signal with frequency 5 Hz)

% Modulation of y(t) with cos(w1*t)
y_modulated = y .* cos(w1*t);

% AM modulation
carrier_freq = 100;                  % Carrier frequency
carrier_amplitude = 1;              % Carrier amplitude
m = (1 + x) .* cos(2*pi*carrier_freq*t) + y_modulated;

% Push detector (rectifier)
z = abs(m);

% Normalize and boost the original signals
x_normalized = (x - min(x)) / (max(x) - min(x));
y_normalized = (y - min(y)) / (max(y) - min(y));
z_boosted = z .* (max(x_normalized) - min(x_normalized)) + min(x_normalized);

% Plotting
subplot(5, 1, 1);
plot(t, x);
xlabel('Time (s)');
ylabel('Amplitude');
title('x(t)');
grid on;

subplot(5, 1, 2);
plot(t, y);
xlabel('Time (s)');
ylabel('Amplitude');
title('y(t)');
grid on;

subplot(5, 1, 3);
plot(t, y_modulated);
xlabel('Time (s)');
ylabel('Amplitude');
title('y(t) Modulated');
grid on;

subplot(5, 1, 4);
plot(t, m);
xlabel('Time (s)');
ylabel('Amplitude');
title('m(t)');
grid on;

subplot(5, 1, 5);
plot(t, z_boosted);
xlabel('Time (s)');
ylabel('Amplitude');
title('z(t) Boosted');
grid on;

% Display the plot
sgtitle('Modulation Process');