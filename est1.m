% CALCULO DE CELOSÍAS EN DOS DIMENSIONES
clc;
clear;
disp(' ');disp('                                               UNIVERSIDAD TÉCNICA DE AMBATO');
disp(' ');disp('                                         FACULTAD DE INGENIERÍA CIVIL Y MECÁNICA');
disp(' ');disp('                                               CARRERA DE INGENIERÍA CIVIL');
disp(' ');disp('                                                       ESTRUCTURAS I');
disp(' ');disp(' PRISCILA MEJIA');  
disp(' ');disp(' SEXTO SEMESTRE B');
disp(' ');disp('                        C Á L C U L O  D E  C E L O S Í A S  B I - D I M E N S I O N A L E S');
disp(' ');disp(' ');
nm = input('Ingrese el número de materiales a utilizar = ');
for i=1:nm;
disp(' ');disp(' ');
disp(' Propiedades del Material ( Kg - cm^2 )');disp(i);
mm(i,1)=input(' Módulo de Elástico = ');
mm(i,1)=mm(i,1);
end;
disp(' ');disp(' ');
nod=input(' Número Total de Nudos = ');disp(' ');
nnr=input(' Número de Nudos Restrigidos = ');disp(' ')
CG=ones(nod,2);
for i=1:nnr
disp(' ');disp(' ');
nr=input(' Número del Nudo Restringido # ');disp(' ');
disp(' Permitido ( 1 ) Restringido ( 0 ) ');disp(' ');
CG(nr,1)=input(' Desplazamiento en X = ');
CG(nr,2)=input(' Desplazamiento en Z = ');
end;
ngl=0;
for i=1:nod
for j=1:2
if (CG(i,j)) == 1
ngl=ngl+1;
CG(i,j)=ngl;
end
end
end
disp(' ');disp(' ');
ns=input(' Número de Secciones Tipo = ');
for i=1:ns;
disp(' ');disp('Seccion Tipo ');disp(i);
disp(' Sección Tranversal (cm)')
ar(i,1)=input(' Área = ');
end;
disp(' ');disp(' ');disp(' ');
mbr=input(' Número de Miembros de la Estructura = ');
for i=1:mbr
disp(' ');disp(' ');disp ('M I E M B R O');disp(i);
ni(i)=input(' Nudo Inicial = ');
nir(i)=ni(i);
nf(i)=input(' Nudo Final = ');
nfr(i)=nf(i);
if nm==1
me(i)=mm(1,1);
else
mt=input(' Material Tipo = ');
me(i)=mm(mt,1);
end
if ns==1
a(i)=ar(1,1);
else
st=input(' Sección Tipo = ');
a(i)=ar(st,1);
end
end
for i=1:mbr
for k=1:2;
VC(i,k)=CG(ni(i),k);
VC(i,k+2)=CG(nf(i),k);
end
end
disp(' ');disp(' ');disp('Coordenadas de los Nudos ( m )');disp(' ');
for i=1:nod;
disp(' ');disp (' N U D O');disp(i);
x(i)=input(' Coordenada en X = ');
z(i)=input(' Coordenada en Z = ');
end;
for i=1:mbr
dx(i)=x(nf(i))-x(ni(i));
dz(i)=z(nf(i))-z(ni(i));
long(i)=sqrt((dx(i))^2+(dz(i))^2);
cosx(i)=(dx(i))/(long(i));
cosz(i)=(dz(i))/(long(i));
nm(i)=i;
end;
ALM=[nm',ni',nf',long',cosx',cosz',me',a'];
KG=zeros((nod)*2);
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
for j=1:2,
for i=1:2,
KG(ni+j-2,ni+i-2)=km(j,i)+KG(ni+j-2,ni+i-2);
KG(nf+j-2,nf+i-2)=km(j+2,i+2)+KG(nf+j-2,nf+i-2);
KG(nf+j-2,ni+i-2)=km(j,i+2);
KG(ni+j-2,nf+i-2)=km(j+2,i);
end
end
end
MKG=KG;
p=0;
for i=1:nod,
for j=1:2,
if CG(i,j)> 0,
else
MKG(:,2*(i-1)+j-p)=[];
MKG(2*(i-1)+j-p,:)=[];
p=p+1;
end
end
end
disp(MKG);
for i=1:ngl
Q(i)=0;
end
disp(' ');disp(' Cargas en la Estructura ( Kg )');
disp(' ');njc=input(' Total de Nudos Cargados = ');
if njc>=0
for i=1:njc
disp(' ');jc=input(' Número del Nudo Cargado # ');disp(' ');
fx=input(' Fuerza Sentido X = ');
fz=input(' Fuerza Sentido Z = ');disp(' ');
if CG(jc,1)==0
else
    aux1=CG(jc,1);Q(aux1)=fx;
end
if CG(jc,2)==0
else
aux2=CG(jc,2);Q(aux2)=fz;end
QQ=Q';disp(QQ);
end;
des=MKG\QQ;
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
for i=1:mbr,
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
for i=1:mbr,
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
clc
disp(' ');
 %GRAFICA
disp('Opcion 1 - Graficar')
disp('Opcion 2 - continuar')
gra=input('ESCRIBA EL NUMERO DE OPCION = ')
while (gra~=2)
    for i=1:mbr
        nui=nir(i);
        nuf=nfr(i);
        xgra(i*2-1)=x(nui);
        zgra(i*2-1)=z(nui);
        xgra(i*2)=x(nuf);
        zgra(i*2)=z(nuf);
    end
    plot(xgra,zgra)
    disp('Opcion 1 : Graficar')
    disp('Opcion 2 : Continuar')
    gra=input('ESCRIBA EL NÚMERO DE OPCION = ')
end
disp(' R e p o r t e d e l C á l c u l o');
disp(' ');disp('Datos y Propiedades de los Elementos');disp(' ');
disp(' Miembro      Nudo I      Nudo F.         Longitud             Cos X               Cos Z              Modulo E.            Area ')
disp(' ');
fprintf('%5.0f \t\t %5.0f \t\t %5.0f \t\t %12.5f \t\t %12.5f \t\t %12.5f \t\t %12.5f \t\t %12.5f\n',[nm;nir;nfr;long;cosx;cosz;me;a]);
disp(' ');disp(' ');
RDN=[nu',xx',zz'];
disp(' ')
disp('Desplazamientos en los Nudos ( cm )');
disp(' ')
disp('    N U D O       dxx           dzz');
disp(' ');
fprintf('%5.0f \t %12.4g \t %12.4g\n',[nu;xx;zz]);
disp(' ');
RDR=[nu',fx',fz'];
disp(' ');disp(' ')
disp('Reacciones en los Nudos ( Kg )');
disp(' ')
disp('   N U D O     Fuerza X       Fuerza Z');
disp(' ');
fprintf('%5.0f \t %12.4g \t %12.4g\n',[nu;fx;fz]);
disp(' ');
RDM=[nm',nir',nfr',axi',esz'];
disp(' ');disp(' ')
disp('Fuerzas en los Elementos ( Kg - cm )');
disp(' ')
disp('MIEMBRO NudoI.  NudoF.       Axial        Esfuerzo');
disp(' ');
fprintf('%5.0f %5.0f %5.0f \t %12.4f \t %12.4f\n',[nm;nir;nfr;axi;esz]);
disp(' ');
disp(' ');disp(' ');
disp(' F i n d e l C á l c u l o ')