function [closedImg] = generateClosedContour5(img, method)
%Generate Closed contour 
% Method: convex hull

  % Initialize output
  closedImg = zeros(size(img));
  
  [size_img,~]=size(img);
  
  
  
  if strcmp(method,'hull')
      
   [Xcnt_int1, Ycnt_int1] = ind2sub(size(img), find(img));%coordenadas XY da máscara 1
   

%######
%step_linha=round((max(Xcnt_int1)-min(Xcnt_int1))/1);
%step_linha=round((max(Xcnt_int1)-min(Xcnt_int1))/2);
step_linha=round((max(Xcnt_int1)-min(Xcnt_int1))/3);
%step_linha=round((max(Xcnt_int1)-min(Xcnt_int1))/4);


%base=[min(Xcnt_int1) max(Xcnt_int1)];
%base=[min(Xcnt_int1) min(Xcnt_int1)+step_linha+20;min(Xcnt_int1)+step_linha-20 max(Xcnt_int1)];
base=[min(Xcnt_int1) min(Xcnt_int1)+step_linha+20; min(Xcnt_int1)+step_linha-20 min(Xcnt_int1)+2*step_linha+20; min(Xcnt_int1)+2*step_linha-20 max(Xcnt_int1)];
%base=[min(Xcnt_int1) min(Xcnt_int1)+step_linha+20; min(Xcnt_int1)+step_linha-20 min(Xcnt_int1)+2*step_linha+20; min(Xcnt_int1)+2*step_linha-20 min(Xcnt_int1)+3*step_linha+20; min(Xcnt_int1)+3*step_linha-20 max(Xcnt_int1)];


%closedImg = zeros(1000,1000);
closedImg = zeros(size_img,size_img);

[num_bases,~]=size(base);

for count_base=1:num_bases

[indx_1,~]=find(base(count_base,1)<=Xcnt_int1 & Xcnt_int1<=base(count_base,2));


Xcnt_int=Xcnt_int1(indx_1);
Ycnt_int=Ycnt_int1(indx_1);


imag=zeros(size_img,size_img);

[size_init,~]=size(Xcnt_int);



r = round(mean(Xcnt_int));%coordenada de linha do centroide
c = round(mean(Ycnt_int));%coordenada de coluna do centroide

%Aqui, determinar coordenadas polares, ordenar pelo angulo e depois achar
%as coordenadas retangulares.

 [theta_i, rho] = cart2pol(Xcnt_int-r, Ycnt_int-c);
  
  % Ording by theta
     % sort A in descending order (decreasing A values) 
     % and keep the sort index in "sortIdx"
     [theta, sortIdx] = sort(theta_i, 'descend');
 
   % sort B using the sorting index
    rho = rho(sortIdx);
            
 % Come back to cartesian instruction
     %[Xorder, Yorder] = pol2cart(A(:,1), A(:,2));
     %[Xorder, Yorder] = pol2cart(theta, rho);
     
     [Xorder_int1, Yorder_int1] = pol2cart(theta, rho);
     Xorder_int2=[Xorder_int1' Xorder_int1(1) Xorder_int1(2) Xorder_int1(3) Xorder_int1(4) Xorder_int1(5)];
     Yorder_int2=[Yorder_int1' Yorder_int1(1) Yorder_int1(2) Yorder_int1(3) Yorder_int1(4) Yorder_int1(5)];
     Xorder=Xorder_int2';
     Yorder=Yorder_int2';
   
     Xcnt = (round(Xorder + r))';
     Ycnt = (round(Yorder + c))';


 dX=max(Xcnt)-min(Xcnt);
 dY=max(Ycnt)-min(Ycnt);
 
 extp=10;
 
  oX=min(Xcnt)-extp/2;
  oY=min(Ycnt)-extp/2;
    
    
    
    if dX>=dY
        size_n=dX+extp;
    else size_n=dY+extp;
    end


masks_contour = zeros(size_n,size_n);


XYZ=[(Xcnt-oX)' (Ycnt-oY)'];

ind_1 = sub2ind(size(masks_contour),XYZ(:,1),XYZ(:,2));

masks_contour(ind_1) = 1;
        
   
    masks_full = zeros(size_n,size_n);
   
   [~,n_dados]=size(Xcnt);
  
  tic 
  
 dif_ind_2=[];
 dif_Xcnt=[];
 dif_Ycnt=[];
 coord_tri=[];
  
 delta_n=50;
 mulpt=30;
 
for kk=1:1:n_dados-1;%1528:1:1730;%1528:1:1536;%1+mulpt*delta_n:1:delta_n+mulpt*delta_n;%1:1:n_dados-1;
     masks_full_int = zeros(size_n,size_n);
     XXX_1=[r-oX Xcnt(kk)-oX Xcnt(kk+1)-oX];
     YYY_1=[c-oY Ycnt(kk)-oY Ycnt(kk+1)-oY];
            
     XYZ_1=[XXX_1' YYY_1'];
     %coord_tri=[coord_tri;XXX_1(1) YYY_1(1) XXX_1(2) YYY_1(2) XXX_1(3) YYY_1(3)];
     coord_tri=[coord_tri;r c Xcnt(kk) Ycnt(kk) Xcnt(kk+1) Ycnt(kk+1)];
     
     ind_2 = sub2ind(size(masks_full_int),XYZ_1(1:3,1),XYZ_1(1:3,2));
    
     dif_ind_2=[dif_ind_2 (ind_2(3)-ind_2(2))];
     dif_Xcnt= [dif_Xcnt (Xcnt(kk+1)-Xcnt(kk))];
     dif_Ycnt= [dif_Ycnt (Ycnt(kk+1)-Ycnt(kk))];
          
     
     masks_full_int(ind_2) = 1;
    
     masks_full=masks_full+bwconvhull(masks_full_int);
end

     masks_full(masks_full>0) = 1;
     
     
 %Gerar a imagem com o tamanho inicial
  
 
 [size_mask,~]=size(masks_full);
 closedImg_int=zeros(size_img,size_img);
 
 for countX=oX:oX+size_mask-1
    
     for countY=oY:oY+size_mask-1
         ind3=sub2ind(size(masks_full),countX-oX+1,countY-oY+1);
         ind4=sub2ind(size(closedImg),countX,countY);
         closedImg_int(ind4)=masks_full(ind3);
     end
 end
     
    closedImg = closedImg+closedImg_int;
end
      
closedImg(closedImg>0) = 1;

%###### 
     
    %figure(4)
    %imshow([masks_contour masks_full])
    
    %figure(5)
    %imshow(closedImg)
    
    
 else 
     msg = 'This method is not implemented yet, try the following: hull';
     disp(msg);
     
  end

end

