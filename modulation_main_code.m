% Parameters
Fs = 16000;                                                                                            % Sampling frequency (Hz)
t = linspace(-0.1, 0.1, 2000);                                                                    % Time vector (0.2 second duration)
w1 = 6000;                                                                                              % Frequency for y(t) modulation
A1 = 3;                                                                                                   % Amplitude for x1_t
A2 = 5;                                                                                                   % Amplitude for x2_t
Ux = 0.99;
% colors = rand(6,length(t));

% Frequency vector
% Fs = 1 / (16* (t(2) - t(1)));                                                                     % Sampling frequency
df = Fs / length(t);                                                                                    % Frequency resolution
f = (-Fs/2:df:Fs/2-df);                                                                               % Frequency range

% Generate input signals
x1_t = A1 * sinc(500*t);
x2_t = A2 * (sinc(1000*t));
% x1_t = cos(100*pi*t);                                                                                
% x2_t = sin(200*pi*t);                                                                                 
% x1_t = A1 * sinc(200*t);
% x2_t = A2 * (sinc(400*t)).^2;

x1_f = fftshift(fft(x1_t));
x2_f = fftshift(fft(x2_t));
z1_t = x2_t .* cos(w1*t);
z_t = x1_t + z1_t ;
z_f = fftshift(fft(z_t));

subplot (3,1,1); plot(t,x1_t); title('x1(t)'); xlabel('Time'); ylabel('Amplitude');
subplot (3,1,2); plot(t,x2_t); title('x2(t)'); xlabel('Time'); ylabel('Amplitude');
subplot (3,1,3); plot(t,z_t); title('z(t)'); xlabel('Time'); ylabel('Amplitude'); 
sgtitle('Time variant inputs');

figure;
subplot (3,1,1); plot(f,abs(x1_f)); title('x1(f)'); xlabel('Frequency'); ylabel('Magnitude');
subplot (3,1,2); plot(f,abs(x2_f)); title('x2(f)'); xlabel('Frequency'); ylabel('Magnitude');
subplot (3,1,3); plot(f,abs(z_f)); title('z(f)'); xlabel('Frequency'); ylabel('Magnitude');
sgtitle('Frequency double side spectrum');

% AM modulation
% Ux = rand;                                                                                           % Random Ux 0 : 1
carrier_freq = 2000;                                                                                % Carrier frequency
Ac = 3;                                                                                                   % Carrier amplitude
m_c = Ac*cos(2*pi*carrier_freq*t).*(1 + ( Ux .* z_t  ))  ;
M_c = fftshift(fft(m_c));

figure
subplot (2,1,1); plot(t,m_c); title('m(t)'); xlabel('Time'); ylabel('Amplitude');
subplot (2,1,2); plot(f,abs(M_c)); title('m(f)'); xlabel('Frequency'); ylabel('Magnitude');
sgtitle('Modulation Process');


% import functions.envelopeDemodulator.*
% analyticSignal = hilbert(m_c);
% demodulatedSignal = analyticSignal .* exp(-2j*pi*carrier_freq*t);
% Push_t =  demodulatedSignal / sqrt(2);
% Push_f = abs(fftshift(fft(Push_t)));
% Push_f1 = Push_t .*abs(fftshift(fft((4000).*sinc(4000*t))));
% Push_t  = envelopeDemodulator(m_c);


% Push demodulation
figure
R1 = 4e3;       C1 = 1e-6;      tow_0 = R1*C1;
% R1 = 1e3;       C1 = 1e-6;      tow_0 = R1*C1;
V_0 = 0;         T_0 = 0;
v_c = V_0 * exp((t(1))/tow_0);
v_o = zeros(1,length (t));
for n = 2:length(t) -1
    if m_c(n) >= v_c
        v_o(n) = m_c(n);
        T_0 = t(n);
        V_0 = m_c(n);
        v_c = V_0 * exp(-(t(n+1) -T_0)/tow_0);
    else
        v_o (n) = v_c;
        v_c = V_0 * exp(-(t(n+1) -T_0)/tow_0);
    end    
end    
Push_t = v_o;

% % Removieng Dc from signal
mean_value = mean(Push_t);
demodulated_signal = Push_t - mean_value;

Push_f = fftshift(fft(demodulated_signal));
subplot (2,1,1); plot(t,demodulated_signal,'.-r'); title('P(t)'); xlabel('Time'); ylabel('Amplitude');
hold;
subplot (2,1,1); plot(t,abs(m_c)); title('P(f)'); xlabel('Frequency'); ylabel('Magnitude');
sgtitle('Demodulation');




%Extracting enterd signals with filtering
%Design low-pass filters

flp1 = fir1(100, 0.1);
flp2 = fir1(200, 0.2);

% Apply low-pass filters
x1_filtered = filtfilt(flp1, 1, Push_t);
x2_filtered = filtfilt(flp2, 1, Push_t);
% tv =  x2_filtered ./ cos(2000*t);
figure
subplot(2,1,1);
plot(t,x1_filtered);

subplot(2,1,2)
plot(t,x2_filtered)

