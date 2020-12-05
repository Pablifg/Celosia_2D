clc,clear,cla,close all
disp(' ***********************************************************************************************');
disp('                     CÁLCULO DE CELOSÍAS BI-DIMENSIONALES');
disp(' ***********************************************************************************************');
disp(' ');disp(' ');
nm=input('   *Ingrese el número de materiales a usar =  ');disp(' ');
for i=1:nm
    fprintf('     Propiedades del material [kg-cm²] #%d\n',i);
    mm(i,1)=input('        --> Módulo Elástico =  ');
    mm(i,1)=mm(i,1)/100;
    disp('     /------------------------------/');disp(' ');
end
disp(' ');disp(' ');
nod=input('   *Ingrese el número total de nudos =  ');
disp('   __________________________________________________');disp(' ');
nnr=input('   *Ingrese la cantidad de nudos restringidos =  ');
CG=ones(nod,2);
for i=1:nnr
  nr=input('        --> Número de nudo restringido =  ');disp(' ');
  disp('   PERMITIDO [1]     RESTRINGIDO [0]');disp(' ');
  CG(nr,1)=input('         •Desplazamiento en X =  ');
  CG(nr,2)=input('         •Desplazamiento en Z =  ');
  disp('     /------------------------------/');disp(' ');
end
ng1=0;
for i=1:nod
    for j=1:2
        if CG(i,j)==1
            ng1=ng1+1;
            CG(i,j)=ng1;
        end
    end
end
disp(' ');
ns=input('   *Ingrese la cantidad de secciones tipo =  ');
for i=1:ns
    fprintf('     Sección Tipo #%d [cm²]\n',i);
    ar(i,1)=input('        --> Área =  ');
    disp('     /------------------------------/');disp(' ');
end
disp(' ');
mbr=input('   *Ingrese el número de miembros de la estructura =  ');
for i=1:mbr
    fprintf('     Miembro #%d\n',i);
    ni(i)=input('        --> Nudo inicial =  ');
    nir(i)=ni(i);
    nf(i)=input('        --> Nudo final =  ');
    nfr(i)=nf(i);
    if nm==1
        me(i)=mm(1,1);
    else
        mt=input('        --> Material tipo =  ');
        me(i)=mm(mt,1);
    end
    if ns==1
        a(i)=ar(1,1);
    else
        st=input('        --> Sección tipo =  ');
        a(i)=ar(st,1);
    end
    disp('     /------------------------------/');disp(' ');
end
disp(' ');
disp('               Coordenadas de los Nudos [m]');
for i=1:nod
    fprintf('     Nudo #%d\n',i);
    x(i)=input('        --> Coordenada en X =  ');
    z(i)=input('        --> Coordenada en Z =  ');
    disp('     /------------------------------/');disp(' ');
end
for i=1:mbr
    dx(i)=x(nf(i))-x(ni(i));
    dz(i)=z(nf(i))-z(ni(i));
    long(i)=sqrt((dx(i))^2+(dz(i))^2);
    cosx(i)=(dx(i))/(long(i));
    cosz(i)=(dz(i))/(long(i));
    nm(i)=i;
end
ALM=[nm',ni',nf',long',cosx',cosz',me',a'];
KG=zeros(nod*2);
for k=1:mbr
    FF(k)=a(k)*me(k)/long(k);
    km(1,1)=cosx(k)^2;
    km(1,2)=cosx(k)*cosz(k);
    km(1,3)=-cosx(k)^2;
    km(1,4)=-cosx(k)*cosz(k);
    km(2,1)=cosx(k)*cosz(k);
    km(2,2)=cosz(k)^2;
    km(2,3)=-cosx(k)*cosz(k);
    km(2,4)=-cosz(k)^2;
    km(3,1)=-cosx(k)^2;
    km(3,2)=-cosx(k)*cosz(k);
    km(3,3)=cosx(k)^2;
    km(3,4)=cosx(k)*cosz(k);
    km(4,1)=-cosx(k)*cosz(k);
    km(4,2)=-cosz(k)^2;
    km(4,3)=cosx(k)*cosz(k);
    km(4,4)=cosz(k)^2;
    km=km*FF(k);
    ni=2*ALM(k,2);
    nf=2*ALM(k,3);
    for j=1:2
        for i=1:2
            KG(ni+j-2,ni+i-2)=km(j,i)+KG(ni+j-2,ni+i-2);
            KG(nf+j-2,nf+i-2)=km(j+2,i+2)+KG(nf+j-2,nf+i-2);
            KG(nf+j-2,ni+i-2)=km(j,i+2);
            KG(ni+j-2,nf+i-2)=km(j+2,i);
        end
    end
end
MKG=KG;
p=0;
for i=1:nod
    for j=1:2
        if CG(i,j)>0
        else
            MKG(:,2*(i-1)+j-p)=[];
            MKG(2*(i-1)+j-p,:)=[];
            p=p+1;
        end
    end
end
disp('          ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
disp('                                          MATRIZ GLOBAL DE RIGIDEZ');
disp('          ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
disp(MKG);
for i=1:ng1
    Q(i)=0;
end
disp(' ');
disp('             :::::::::::::::::::::::::::::::::');
disp('               CARGA DE LA ESTRUCTURA [kg]');
disp('             :::::::::::::::::::::::::::::::::');disp(' ');disp(' ');
njc=input('   *Ingrese la cantidad de nudos cargados =  ');
if njc>0
    for i=1:njc
        jc=input('        --> Número de nudo cargado =  ');disp(' ');
        fx=input('         •Fuerza sentido X =  ');
        fz=input('         •Fuerza sentido Z =  ');
        disp('     /------------------------------/');disp(' ');
        if CG(jc,1) == 0
        else
        aux1=CG(jc,1);
        Q(aux1)=fx;
        end
        if CG(jc,2)==0
        else
            aux2=CG(jc,2);
        Q(aux2)=fz;
        end
        QQ=Q';
    end
    des=(MKG)\QQ;
    U=des';
    DS=zeros(2*nod,1);
    p=0;
    for i=1:nod
        for j=1:2
            if CG(i,j)>0
                p=CG(i,j);
                DS(2*(i-1)+j,1)=des(p,1);
            end
        end
    end
    FN=KG*DS;
    t=zeros(1,4,mbr);
    d2=zeros(4,1,mbr);
    for i=1:mbr
        ALM=[nm',ni',nf',long',cosx',cosz',me',a'];
        t(1,1,i)=-ALM(i,5);
        t(1,2,i)=-ALM(i,6);
        t(1,3,i)=ALM(i,5);
        t(1,4,i)=ALM(i,6);
        ni=ALM(i,2);
        nf=ALM(i,3);
        d2(1,1,i)=DS(2*ni-1);
        d2(2,1,i)=DS(2*ni);
        d2(3,1,i)=DS(2*nf-1);
        d2(4,1,i)=DS(2*nf);
    end
    esf=zeros(1,1,mbr);
    for i=1:mbr
        esf(:,:,i)=t(:,:,i)*d2(:,:,i);
        esf(:,:,i)=FF(i)*esf(:,:,i)/ALM(i,8);
        esz(i)=esf(:,:,i);
        axi(i)=esz(i)*ALM(i,8);
    end
end
for i=1:nod
    xx(i)=DS(1+((i-1)*2),1);
    zz(i)=DS(2+((i-1)*2),1);
    nu(i)=i;
end
for i=1:nod
    fx(i)=FN(1+((i-1)*2),1);
    fz(i)=FN(2+((i-1)*2),1);
end
disp(' ');
disp(' ______________________________________________________________________________________________________');
RC=input('     ¿Desea mostrar en pantalla el REPORTE DE CÁLCULO? Y/N [Y]: ','s');
disp(' ______________________________________________________________________________________________________');
if isempty(RC)
    RC='Y';
end
if RC=='Y'
    clc
    disp('                                                *********************************************************');
    disp('                                                *                     REPORTE DE CÁLCULO                *');
    disp('                                                *********************************************************');
    disp(' ');
    disp('  ____________________________________________________________________________________________________________________________________');
    disp('                                                         DATOS Y PROPIEDADES DE LOS ELEMENTOS');
    disp('  ____________________________________________________________________________________________________________________________________');disp(' ');
    fprintf('%10s %15s %15s %15s %15s %15s %20s %15s\n','Miembro','Nudo I.','Nudo F.','Longitud (m)','Cos X','Cos Z','Módulo E.(kg-cm²)','Área (cm²)');
    disp(' ');
    for i=1:mbr
        nume(i)=ALM(i,1);
        nui(i)=ALM(i,2);
        nuf(i)=ALM(i,3);
        longi(i)=ALM(i,4);
        cosxx(i)=ALM(i,5);
        coszz(i)=ALM(i,6);
        mel(i)=ALM(i,7);
        area(i)=ALM(i,8);
    end
    for o=1:mbr
        fprintf('%10d|%15d %15d %15.5G %15.5G %15.5G %15.9G %15.5G \n',nume(o),nui(o),nuf(o),longi(o),cosxx(o),coszz(o),mel(o),area(o));
    end
    disp(' ');
    disp('          __________________________________________________________________________________');
    disp('                            DESPLAZAMIENTOS DE LOS NUDOS (cm)');
    disp('          __________________________________________________________________________________');disp(' ');
    fprintf('%30s %15s %15s \n','Nudo','Dxx','Dzz');
    disp(' ');
    for i=1:nod
        fprintf('%30d|%15.4G %15.4G\n',i,xx(i),zz(i));
    end
    disp(' ');
    disp('          __________________________________________________________________________________');
    disp('                            REACCIONES DE LOS NUDOS (kg)');
    disp('          __________________________________________________________________________________');disp(' ');
    fprintf('%30s %15s %15s \n','Nudo','Fuerza X','Fuerza Z');
    disp(' ');
    for i=1:nod
        fprintf('%30d|%15.4G %15.4G\n',i,fx(i),fz(i));
    end
    disp(' ');
    disp('          __________________________________________________________________________________');
    disp('                            FUERZA EN LOS ELEMENTOS (kg-cm)');
    disp('          __________________________________________________________________________________');disp(' ');
    fprintf('%20s %15s %15s %15s %15s \n','Miembro','Nudo I.','Nudo F.','F. Axial','Esfuerzo');
    disp(' ');
    for i=1:mbr
        fprintf('%20d|%15d %15d %15.5G %15.5G\n',i,nui(i),nuf(i),axi(i),esz(i));
    end
end
disp(' ');
disp(' ______________________________________________________________________________________________________');
mostgraf=input('     ¿Desea mostrar el gráfico de la ESTRUCTURA? Y/N [Y]: ','s');
disp(' ______________________________________________________________________________________________________');
Con=[nir' nfr'];
Nudos=[x' z'];
if isempty(mostgraf)
    mostgraf='Y';
end
if mostgraf=='Y'
    figure('Numbertitle','off','Name','Gráfica de Celosía')
    [espacio,margen]=celosia2D(Con,Nudos);
    hold off
    
end
disp(' ');
disp(' ______________________________________________________________________________________________________');
mostgraf=input('     ¿Desea mostrar el gráfico de la ESTRUCTURA DEFORMADA? Y/N [Y]: ','s');
disp(' ______________________________________________________________________________________________________');
if isempty(mostgraf)
    mostgraf='Y';
 end
 if mostgraf=='Y'
     %  Plotea la estrutura deformada
     xd(nod)=0.0;
     zd(nod)=0.0;
     escala=input('Digite la escala a ser utilizada(100):');
     if (isempty(escala)==1)
         escala=100;
     end
     figure('Numbertitle','off','Name','Gráfica de Celosía Deformada')
          %Centrar en pantalla
     scrsz=get(0, 'ScreenSize');
     pos_act=get(gcf,'Position');
     xr=scrsz(3)-pos_act(3);
     xp=round(xr/2);
     yr=scrsz(4)-pos_act(4);
     yp=round(yr/2);
     set(gcf,'Position',[xp yp pos_act(3) pos_act(4)]);
     for i=1:nod
         xd(i)=x(i)+escala*DS(2*i-1);
         zd(i)=z(i)+escala*DS(2*i);
     end
     Nudes=[xd' zd'];
     [F1,C1]=size(Con);
     [F2,C2]=size(Nudos);
    xmax=max(Nudes);
    xmin=min(Nudes);
    espacio=max(xmax-xmin);
    margen=0.1;
    axis([xmin(1)-margen*espacio,xmax(1)+margen*espacio,xmin(2)-margen*espacio,xmax(2)+margen*espacio])
    hold on
    for i=1:mbr
        linha=line([x(nir(i)) x(nfr(i))],[z(nir(i)) z(nfr(i))]);
        set(linha,'Color','blue')
        set(linha,'LineStyle','-','linewidth',1.2)
        linha=line([xd(nir(i)) xd(nfr(i))],[zd(nir(i)) zd(nfr(i))]);
        set(linha,'LineStyle','--','Color','red','linewidth',1.0)
    end
    puntos=zeros(C1,C2);
    ceng=zeros(1,C2);
    for i=1:F1
        for j=1:C1
            puntos(j,:)=Nudes(Con(i,j),:);
        end
        ceng=sum(puntos(1:2,:))/(C1-0.1);
        %plot(puntos(:,1),puntos(:,2),'-*r','linewidth',1.5)
        text(ceng(1)+0.01,ceng(2)+0.01,int2str(i),'color','g','background','w')
    end
    for k=1:nod
        text(Nudes(k,1)+0.02*espacio,Nudes(k,2)+0.02*espacio,['(',int2str(k),')'],'color','k')
    end
    title('Estructura Deformada');
xlabel('Eje X');
ylabel('Eje Z');
legend('Original','Deformada','Location','southeast')
    hold off
end