% Parameters
% Fs = 2000;                                                                                          % Sampling frequency (Hz)
t = linspace(-0.1, 0.1, 1000);                                                                    % Time vector (1 second duration)
w1 = 4000;                                                                                              % Frequency for y(t) modulation
A1 = 3;                                                                                                   % Amplitude for x1_t
A2 = 5;                                                                                                   % Amplitude for x2_t
% Ux = 0.2;

% Frequency vector
Fs = 1 / (t(2) - t(1));                                                                                 % Sampling frequency
df = Fs / length(t);                                                                                    % Frequency resolution
f = (-Fs/2:df:Fs/2-df);                                                                               % Frequency range

% Generate input signals
x1_t = A1 * sinc(200*t);                                                                            % x1_t signal (example: sinusoidal signal with frequency 10 Hz)
x2_t = A2 * (sinc(400*t)).^2;                                                                     % x2_t signal (example: sinusoidal signal with frequency 5 Hz)
x1_f = fftshift(fft(x1_t));
x2_f = fftshift(fft(x2_t));
z1_t = x2_t .* cos(w1*t);
z_t = x1_t + z1_t ;
z_f = fftshift(fft(z_t));

subplot (3,1,1);
plot(t,x1_t);
title('x1(f)');
xlabel('Time');
ylabel('Amplitude');

subplot (3,1,2);
plot(t,x2_t);
title('x2(f)');
xlabel('Time');
ylabel('Amplitude');

subplot (3,1,3);
plot(t,z_t);
title('z(t)');
xlabel('Time');
ylabel('Amplitude');
sgtitle('Time variant inputs');

figure;

subplot (3,1,1);
plot(f,abs(x1_f));
title('x1(f)');
xlabel('Frequency');
ylabel('Magnitude');

subplot (3,1,2);
plot(f,abs(x2_f));
title('x2(f)');
xlabel('Frequency');
ylabel('Magnitude');

subplot (3,1,3);
plot(f,abs(z_f));
title('z(f)');
xlabel('Frequency');
ylabel('Magnitude');
sgtitle('Frequency double side spectrum');

% AM modulation
Ux = rand;                                                                                               % Random Ux 0 : 1

carrier_freq = 500;                                                                               % Carrier frequency
Ac = 1;                                                                                                   % Carrier amplitude
m_c = Ac*cos(2*pi*carrier_freq*t).*(1 + ( Ux * z_t  ))  ;
M_c = fftshift(fft(m_c));

figure
subplot (2,1,1);
plot(t,m_c);
title('m(t)');
xlabel('Time');
ylabel('Amplitude');

subplot (2,1,2);
plot(f,abs(M_c));
title('m(f)');
xlabel('Frequency');
ylabel('Magnitude');
sgtitle('Modulation and Demodulation Process');

% Push demodulation
Push_t = (m_c./cos(2*pi*carrier_freq*t));
Push_f = fftshift(fft(Push_t));
figure
subplot (2,1,1);
plot(t,Push_t);
title('P(t)');
xlabel('Time');
ylabel('Amplitude');

subplot (2,1,2);
plot(f,abs(Push_f));
title('P(f)');
xlabel('Frequency');
ylabel('Magnitude');
sgtitle('Demodulation and Demodulation Process');





















