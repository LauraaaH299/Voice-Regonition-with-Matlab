% Proyecto de Procesamiento de señales

% Universidad del Rosario
% Matemáticas Aplicadas y Ciencias de la Computación

% Por:
% Laura Valentina Hernández Cardozo
% Juan Nicolás Sepúlveda Arias

% Limpiamos todas las variables
clear

% Duración de las señales en segundos
note_length = 1;
blank_length = 1;

% Declaramos la frecuencia de muestreo
Fs = 8000;
Ts = 1/Fs;
Num_samples = Fs * (4 * note_length + 3 * blank_length);

% Función para pasar de un string a una nota en representación de señal
get_note = @(note) obtainsi(note, Fs);

% Creamos las notas como variables
blank = zeros(1, Fs);
do = get_note("do");
re = get_note("re");
mi = get_note("mi");
fa = get_note("fa");
sol = get_note("sol");
la = get_note("la");
si = get_note("si");

% Creamos diccionarios para las señales
keys = ["do" "re" "mi" "fa" "sol" "la" "si"];
values = {do  re  mi  fa  sol  la  si};
note_dict = dictionary(keys, values);

keys = ["do" "re" "mi" "fa" "sol" "la" "si"];
values = 1:7;
idx_dict = dictionary(keys, values);

% Saludamos al usuario :)
greet();

% Le pedimos al usuario que establezca una contraseña
fprintf("Please enter your password, you will be prompted to write a note one by one.\nThe password is four notes long.\n");

prompt = "\nEnter a note:";
while true
    % Inicializamos las listas para el password y para el intento de password
    p = ["" "" "" ""];
    idxs = [0 0 0 0];
    for i = 1:4
        note = "";
        while true
            note = input(prompt,"s");
            if ismember(note, keys)
                break;
            end
            fprintf("\nError: Plase enter a valid note.\nAvailable options are: [do, re, mi, fa, sol, la, si]\n")
            
        end
        p(i) = note;
        idxs(i) = idx_dict(note);
    end
    
    % Verificamos que la contraseña no tenga notas en orden
    if sum((idxs - min(idxs)) ~= 0:3) > 0
        break;
    end

    fprintf("\nNotes must not be in order! Please enter another password\n\n")

end % while true

% concatenamos todas las señales de la constraseña  en una sola señal

nota_inicial = note_dict(p(1));
nota_inicial = nota_inicial{1};

password = [nota_inicial];
for i = p(2:length(p))
    nota = note_dict(i);
    nota = nota{1};
    password = [password blank nota];
end

% Imprimimos la contraseña final para que el usuario la vea
fprintf("Your final password is: [%s]\n\n", join(string(p), ','));
% sound(password, Fs);
pause(2);

% Advertencia amigable al usuario de que recuerde su contraseña
fprintf("Remember well your password! It will self-destroy in:\n\n")
pause(1);
for i = 5:-1:1
    fprintf("%d ...\n", i)
    pause(1);
end
fprintf("Bye! :)")
pause(1);

% Fase de autodestrucción de la contraseña
fire();
clc;


% Pedimos el intento de password al user 
greet();
fprintf("The vault is currently closed. To open it, you must enter the correct password." + ...
    "\nYou will be prompted to write a note one by one.\nThe password is four notes long.\n");
fprintf("\n")

while true

    in_signal = ["" "" "" ""];

    prompt = "\nEnter a note:";
    for i = 1:4
        note = "";
        while true
            note = input(prompt,"s");
            if ismember(note, keys)
                break;
            end
            fprintf("\nError: Plase enter a valid note.\nAvailable options are: [do, re, mi, fa, sol, la, si]\n")
            
        end
        in_signal(i) = note;
    end
    
    % Sacamos la correlación entre la contraseña real y cada una de las notas de entrada
    
    % Creamos una nueva figura para graficar
    f = figure();
    j = 0;
    count = 0;
    for note = in_signal
        pause(0.5);
        
        % Obtenemos la representación en señal de la nota
        s = get_note(note);

        % Desfazamos la nota a su posición correspondiente
        k = [zeros(1, Fs*2*j) s];

        % Hallamos la correlación entre la nota y la contraseña
        [c, ~] = xcorr(password, k);

        % Hallamos el máximo de la correlación entre las señales
        [M, idx] = max(c);

        % Calculamos el tiempo de desface
        t = idx/Fs - 7;
        
        % Graficamos la correlación de la nota
        T_corr = linspace(-7, 7, 2 * Num_samples - 1);
        subplot(4, 1, j+1)
        plot(T_corr, c);
        axis([-8, 8, -5000, 5000])
        

        % Si el máximo de la correlación está por debajo de cierto umbral,
        % la nota no pertenece a la contraseña
        if M < 500
            fprintf("Note %d is not in the password\n", j+1)
        else
            
            % Si el desface es 0, la nota está en la posición correcta
            if t == 0
    
                fprintf("Note %d is in the password and in it's correct position!\n", j+1);
                count = count + 1;

            else

                % Calculamos la cantidad de posiciones que se tiene que
                % desfazar la nota para que esté en la posición correcta
                distancia = abs(t/2);
    
                % Detalles de fina coquetería
                if distancia == 1
                    plural1 = "s";
                    plural2 = "";
                else
                    plural1 = "";
                    plural2 = "";
                end
    
                if t > 0
                    fprintf("Note %d need%s to be moved %d position%s to the right\n", j+1, plural1, distancia, plural2);
                else
                     fprintf("Note %d need%s to be moved %d position%s to the left\n", j+1, plural1, distancia, plural2);
    
                end
    
            end
        end
        j = j+1;
    end % for note = in_signal

    % Si las 4 notas están en su posición correcta, la contraseña es
    % correcta!
    if count == 4
        fprintf("Access Granted")
        break;
    else
        fprintf("\nAccess Denied: Incorrect Password\n\nPlease try again\n\n")
    end

    count = 0;
end % while true


% Al ingresar correctamente la contraseña, le mostramos al usuario un buen
% meme
pause(1);
fprintf("\n\nEnjoy the meme!\n");
pause(1);
f = figure;
imshow("chihuaua_or_muffin.jpeg");