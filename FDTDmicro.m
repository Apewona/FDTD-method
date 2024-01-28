%% Czyszczenie danych i konsoli
clear;clc;
%% Parametry źródła i przestrzeni
f0 = 1e6; % Częstotliwość 
Ls = 50; % ilość jednostek na długość fali
[Lx,Ly] = deal(8,8); % Długości fali
e0 = 8.854*10^-12; % Przenikalność elektryczna próżni
u0 = 4*pi*10^-7; % Przenikalność magnetyczna próżni
c0 = 1/(e0*u0)^.5; % prędkość światła w próżni
L0 = c0/f0; % Długość fali w próżni
%% Wymiary przestrzeni
kx=Lx*Ls; % Wymiar x naszego pola
ky=Ly*Ls; % Wymiar y naszego pola
x = linspace(0,Lx,kx+1)*L0; % wektor x przestrzeni
y = linspace(0,Ly,ky+1)*L0; % wektor y przestrzeni 



%% Liczba kroków czasowych
tsteps = 1000; %360 Taki przedział czasu będzie symulowany
%% Rozmiar komórki yee 
[dx,dy] = deal(x(2),y(2));
dt = (dx^-2+dy^-2)^-.5/c0*.99; % Krok czasowy 
%% Inicjalizacja wektorów
[Hx,Hy,Ez] = deal(zeros(kx,ky)); % Zerowanie wartości macierzy pól
[Ex,Ey,Hz] = deal(zeros(kx,ky)); % Zerowanie wartości macierzy pól 
[edx,edy] = deal(dt/(e0*dx),dt/(e0*dy)); % Przenikalność 
[udx,udy] = deal(dt/(u0*dx),dt/(u0*dy));
%% Dane do wykresów
time=linspace(1,tsteps,tsteps);
Mod=zeros(1,tsteps); % Inicjalizacja punktu pomiarowego
Eod=zeros(1,tsteps); 
%% Program właściwy
fig1 = figure('Color',[1,1,1]); % Ustawienie koloru wykresu
colormap(hot(256)) % Ustawienie koloru bitmapy i zakresu barw 
for t=1:tsteps % Początek pętli czasu
tic 
 %% Aktualizacja pola magnetycznego
 Ex(1:kx-1,1:ky-1) = Ex(1:kx-1,1:ky-1)-edy*diff(Hz(1:kx-1,:),1,2);
 Ey(1:kx-1,1:ky-1) = Ey(1:kx-1,1:ky-1)+edx*diff(Hz(:,1:ky-1),1,1);
 %% Aktualizacja pola elektrycznego
 Hz(2:kx-1,2:ky-1) = Hz(2:kx-1,2:ky-1)+...
 udx*diff(Ey(1:kx-1,2:ky-1),1,1)-udy*diff(Ex(2:kx-1,1:ky-1),1,2);
 %% Źródło 
 Hz(round(kx/2),round(ky/2)) = Hz(round(kx/2),round(ky/2))+...
 sin(2*pi*f0*dt*t);
 %% Pomiary wykonywane w czasie rzeczywistym
 Mod(t)=Hz(200,200);
 Eod(t)=Ey(200,200);
 %% Rysunek
 imagesc(x,y,Hz); 
 title(["czas = " t*dt "s"]);
 colorbar; clim([-0.02 0.05]);
 drawnow;

toc
end

%% Wykresy / wizualizacja pomiarów 
hold on;
plot(917,917, 'ro', 'MarkerSize', 2,'MarkerFaceColor','r');
text(917,917,{'Rec'},'Color','red');
fig2=figure();
plot(time(1:tsteps),Mod(1:tsteps)); 
title('Hz(t)');
fig3=figure();
plot(time(1:tsteps),Eod(1:tsteps)); 
title('E(t)');
