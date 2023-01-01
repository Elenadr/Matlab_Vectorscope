    % VECTORSCOPIO EN MATLAB
    % ELENA MAR?A DEL RIO GALERA
    % MARZO 2022

%% Vamos  crear una vetana de visualizacion del vectorscopio
% Esta es la funcion padre, todo ocurre dentro.
function Vectorscope
% Cerramos ventanas y limpiamos
close all;
clear all;
%% Definimos, nombre, titulo, posicion y color de la ventana principal
    mainTab = figure('Name','Vectorscope',... % Nombre de la ventana
        'NumberTitle','off',... % Ponemos off para que no escriba 'Figure 1'
        'Position',[140 100 1250 700],... % Tama?o y posicion [left bottom width height]
        'Color',[0.9 0.9 0.9]); % Color del fondo de la ventana padre
    
% Definimos una sub pesta?a dentro de la ventana, donde estarA el vectorscope y el histograma de la imagen
    % Contenido en main, a la izquierda tenemos la subtab donde estarA el vectorcope
    vectorscopeTab = uitabgroup(mainTab,'Position',[.04 .22 .30 .55],...,
        'TabLocation','top');
    
    % Dentro hay dos tabs hijas, una para cada formato. 
    % Tab del vectorscopio
    tabGraticule = uitab(vectorscopeTab,'Title','Vectorscope',...,
        'BackgroundColor',[0.91 0.91 0.91]);
    
    % Tab del histograma
    tabHist = uitab(vectorscopeTab,'Title','Histogram',... 
    'Units','points');

    % Por defecto al ejecutar se abre en la tab del vectorscopio
    vectorscopeTab.SelectedTab = tabGraticule;

    % Definimos el espacio para la imagen de estudio
    ax_image = axes('Units','pixels','Position',[500 80 700 550],'Parent',mainTab);

    % Definimos el espacio par ubicar el histograma
    ax_hist = axes('Parent',tabHist);

%% Pintar imagen de barras en su espacio
     % Definimos la forma en que queremos que se vea la imagen de test, en su espacio
    image = imshow(0,'Parent',ax_image,'InitialMagnification','fit');
    
    % Cargamos la imagen
    RGB = imread('bars.tif');
    
    % Calculamos tama?o de la imagen
    % En la m, n?mero de filas, en la n n?mero de filas y en la d las dimensiones
    % Si es en escala de gris son dos simensiones, en color son tres dimensiones
    [m,n,d] = size(RGB);
    set(image,'CData',RGB);
    
    % Definimos el espacio seg?n los par?metros de la imagen
    axis(ax_image,[0 n 0 m])

%% Calculamos el histograma de la imagen de barras
    % Pasamos la imagen a escala de grises

    grey = rgb2gray(RGB)
    
    % Calculamos y pintamos el histograma de la imagen en escala de grises 
    % de 0 a 256 niveles de intensidad
    imhist(grey, 256);

%% Ubicamos y ajustamos la plantilla del vectorscopio.
    % Tab Vectorscope graticule
    %%graticula [left bottom width height]
    ax_graticule = axes('Parent',tabGraticule, ... 
    'position',[0 0 1 1]);
    ax_graticule2 = axes('Parent',tabGraticule, ... %%lineas 
    'position',[-0.007 -0.01 1.01 1.02]);

    % Pintamos el esqueleto del vectorscopio en su espacio, definido con
    % axes 
    graticule = imread('graticule.png');
    imshow(graticule,[],'Parent',ax_graticule)
    hold(ax_hist,'on')
    hold(ax_graticule,'on')

    % Definimos como ser?n las l?neas que representan la crominancia.    
    s2 = plot(ax_graticule2,0,0,'g', 'LineWidth',2.5);
    s2.Color(3) = 0.9;
    axis(ax_graticule2,[-1 1 -1 1]);
    axis(ax_graticule2,'off');
    s2.XDataSource = 'y';
    s2.YDataSource = 'x';

    % Rotamos y redimensionamos las l?neas que representan el vectorscopio
    % para que encajen en el esqueleto
    camroll(ax_graticule2,33); 
    camzoom(ax_graticule2,1.6);
 

 %% Seleccionar la imagen 
    % Con selection, cogemos la imagen de barras, y la guardamos en h
    selection = [0.5 0.5 m-1 n-1];
    h = (selection);

    % Llamamos a la funci?n que calcula y pinta las l?neas.
    updatePlot(s2,selection);
    
% Esta funci?n es la que calcula puramente lo que pintamos en el
% vectorscopio. Le pasamos como argumentos la l?nea que tiene que dibujar,
% y la selecci?n de la imagen.
function updatePlot(s2,rect)

    % Con rgb2ntsc, cambiamos el espacion de color de RGB a YIQ
    YIQ = rgb2ntsc(RGB);

    % Reorganizar las dimensiones de una matriz multidimensional
    matrix = permute(YIQ,[2 1 3]);
    
    % Guardamos en map
    % remodela matrix utilizando el vector de tama?o, mxn
    % En map tenemos matriz de 307200x3 con los valores de ntsc de la imagen
    map = reshape(matrix,m*n,3); % m = 480 // n = 640

    %figure, imshow(rgb2ntsc(RGB));
  
    % Redondeamos los valores de selecci?n al entero mas cercano
    pos = round(h);
    
    % Left Top Width Height 
    L=pos(1); % Devuelve 1
    T=pos(2); % Devuelve 1
    W=pos(3); % Devuelve 639
    H=pos(4); % Devuelve 379
        
    % Matriz de ceros 
    points = zeros(W*H,3);  % zeros (639 * 379, 3) filas = 242181 x columnas = 3

    % Desde valores i = 1,2,3,4..., 376,377,378,379)
    % Bucle para ir calculando el valor desde la primera a la ?ltima fila
    % de la imagen
    %disp(points(W*(0-1)+1:W*0,:) );
    %hasta la ultima fila
        
    points = unique(map,'rows','stable');
    %disp (points);
    x = points(:,2);
    %disp('x'+ x);
    y = points(:,3);
   % disp('y'+ y);
    refreshdata(s2,'caller');   
end
 
end

        
  % for  i=1:92
        
        %disp('ATENCI?N');
        % 639 * (0-1)+1:639*0,:)=    641 +640*(0-1)+1:641+640*(0-1)+630,:);
  %      j = W*(i-1)+1;
  %      disp('j');
  %      disp(j);
  %      k = W*i;
  %      disp('k');
  %      disp(k);
  %      l = offset+n*(i-1)+1;
  %      disp('l');
  %      disp(l)
  %      q = offset+n*(i-1)+W;
  %      disp('q');
  %      disp(q)
        %points(j:k,:) = map(l:q,:);
        %i=1
        %639 :642 , : //
        %points(1:639,:) = map(642:1280,:);
  %      points(W*(i-1)+1:W*i,:) = map(offset+n*(i-1)+1:offset+n*(i-1)+W,:);
  %      x = (points(1*(i-1)+1:1*i,:));
  %      disp(x);
  %      y = (map(offset+n*(i-1)+1:offset+n*(i-1)+1,:));
  % end
