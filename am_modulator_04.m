% Parameters
fs = 1000;                          % Sampling frequency (Hz)

t = 0:1/fs:1;                       % Time vector (1 second duration)
w1 = 2;                             % Frequency for y(t) modulation
A1 = 1;                             % Amplitude for x(t)
A2 = 0.5;                           % Amplitude for y(t)

% Generate input signals
x = A1 * sin(2*pi*10*t);            % x(t) signal (example: sinusoidal signal with frequency 10 Hz)
y = A2 * sin(2*pi*5*t);             % y(t) signal (example: sinusoidal signal with frequency 5 Hz)

% AM modulation
carrier_freq = 100;                  % Carrier frequency
carrier_amplitude = 1;              % Carrier amplitude
m = (x + y .* cos(w1*t)) .* cos(2*pi*carrier_freq*t);

% Demodulation (extraction)
x_demod = m .* cos(2*pi*carrier_freq*t);
y_demod = m .* cos(2*pi*carrier_freq*t) .* cos(w1*t);

% Plotting
subplot(4, 1, 1);
plot(t, x);
xlabel('Time (s)');
ylabel('Amplitude');
title('x(t)');
grid on;

subplot(4, 1, 2);
plot(t, y);
xlabel('Time (s)');
ylabel('Amplitude');
title('y(t)');
grid on;

subplot(4, 1, 3);
plot(t, x + y.*cos(w1*t));
xlabel('Time (s)');
ylabel('Amplitude');
title('x(t) + y(t)*cos(w1*t)');
grid on;

subplot(4, 1, 4);
plot(t, x_demod);
hold on;
plot(t, y_demod);
hold off;
xlabel('Time (s)');
ylabel('Amplitude');
title('Demodulated x(t) and y(t)');
legend('x(t)', 'y(t)');
grid on;

% Display the plot
sgtitle('Modulation and Demodulation Process');