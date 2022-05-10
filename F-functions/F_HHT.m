%HHT Hilbert Spectrum
function [imfinseHHT,imfinsfHHT] = F_HHT(imf,fs)
global nK
[a,b] = size(imf);
imfinsfHHT = zeros(nK,b);
imfinseHHT = zeros(nK,b);
for i1 = 1:b
    sig = hilbert(imf(:,i1));
    energy = abs(sig).^2;
    phaseAngle = angle(sig);
    omega = gradient(unwrap(phaseAngle));
    omega = fs/(2*pi)*omega;
    imfinsfHHT(:,i1) = omega;
    imfinseHHT(:,i1) = energy;
end

end

% switch Method
%         % for future extension
%         case 'HT'
%             sig = hilbert(IMFd(:,i));
%             energy = abs(sig).^2;
%             phaseAngle = angle(sig);
%     end
%     
%     % compute instantaneous frequency using phase angle
%     omega = gradient(unwrap(phaseAngle));
%     
%     % convert to Hz
%     omega = fs/(2*pi)*omega;
%     
%     % find out index of the frequency
%     omegaIdx = floor((omega-F(1))/FResol)+1;
%     freqIdx(i,:) = omegaIdx(:,1)';
%     
%     % generate distribution
%     insf(:,i) = omega;
%     inse(:,i) = energy;