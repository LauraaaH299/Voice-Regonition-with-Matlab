 function sg = obtainsi(x, Fs)
    Ts=1/Fs;
    t=[0:Ts:1];
    t = t(2:length(t));

    f = 0;
    if x == "do" || x=="DO"
            f = 261.60;

    elseif  x=="re" || x=="RE"
        f = 293.70;
    
    elseif x=="mi" || x=="MI"
        f = 329.6;
    
    elseif  x=="fa" || x=="FA"
        f = 349.23;

    elseif  x=="sol" || x=="SOL"
         f = 391.99;

    elseif  x=="la" || x=="LA"
        f = 440.00;

    elseif    x=="si" || x=="SI"
         f =  493.9;

    else
        disp("Inserte una nota correcta")
    end 
    
    sg = sin(2*pi*f*t);


end
 