function [espacio,margen]=celosia2D(con,x,line,nodes,tri_num_prnt,pnt_num_prnt,titulo)

if nargin==2,line='b';nodes=1;tri_num_prnt=1;pnt_num_prnt=1;titulo='CELOSÍA';end
if nargin==3,nodes=1;tri_num_prnt=1;pnt_num_prnt=1;titulo='CELOSÍA';end
if nargin==4,tri_num_prnt=1;pnt_num_prnt=1;titulo='CELOSÍA';end
if nargin==5,pnt_num_prnt=1;titulo='CELOSÍA';end
if nargin==6,titulo='CELOSÍA';end
%Centrar en pantalla
scrsz=get(0, 'ScreenSize');
pos_act=get(gcf,'Position');
xr=scrsz(3)-pos_act(3);
xp=round(xr/2);
yr=scrsz(4)-pos_act(4);
yp=round(yr/2);
set(gcf,'Position',[xp yp pos_act(3) pos_act(4)]);
%Código de impresión
[Ne,Nne]=size(con);
[nod,ngl]=size(x);
xmax=max(x);
xmin=min(x);
espacio=max(xmax-xmin);
margen=0.1;
if ngl<=2
    axis([xmin(1)-margen*espacio,xmax(1)+margen*espacio,xmin(2)-margen*espacio,xmax(2)+margen*espacio])
end
title(titulo)
%COntinuo pintando en la misma figura
hold on
%GRAFICA LOS ELEMENTOS DE LA ARMADURA
puntos=zeros(Nne,ngl);
ceng=zeros(1,ngl);
for i=1:Ne
    for j=1:Nne
        puntos(j,:)=x(con(i,j),:);
    end
    ceng=sum(puntos(1:2,:))/(Nne-0.1);
    if ngl<=2
        plot(puntos(:,1),puntos(:,2),line,'linewidth',1.5)
        if tri_num_prnt==1
            text(ceng(1)+0.01*espacio,ceng(2)+0.01*espacio,int2str(i),'color','w','background','k')
        end
    end
end

        
% %DIBUJAR NODOS DE ESTRUCTURA
if ngl<=2
    if nodes==1
        plot(x(:,1),x(:,2),'o','MarkerFaceColor','r','MarkerSize',4.5)
    end
    if pnt_num_prnt==1
        for k=1:nod
        text(x(k,1)+0.02*espacio,x(k,2)+0.02*espacio,['(',int2str(k),')'],'color','r')
        end
    end
end

end