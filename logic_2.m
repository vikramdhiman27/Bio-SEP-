function STATISTICS = logic_2(rmax,n,p,S2,flag_first_dead2,...
    flag_teenth_dead2,flag_all_dead2,...
    packets_TO_BS2,ETX,EDA,ERX,...
    Emp,Efs,do,allive2,...
    packets_TO_CH2)

for r=0:1:rmax     
    
  if(mod(r, round(1/p) )==0)
    for i=1:1:n
        S2(i).G=0;
        S2(i).cl=0;
    end
  end

dead2=0;
for i=1:1:n
  
    if (S2(i).E<=0)
        dead2=dead2+1; 
        
        
        if (dead2==1)
           if(flag_first_dead2==0)
              first_dead2=r;
              flag_first_dead2=1;
           end
        end
       
        if(dead2==0.1*n)
           if(flag_teenth_dead2==0)
              teenth_dead2=r;
              flag_teenth_dead2=1;
           end
        end
        if(dead2==n)
           if(flag_all_dead2==0)
              all_dead2=r;
              flag_all_dead2=1;
           end
        end
    end
    if S2(i).E>0
        S2(i).type='N';
    end
end
STATISTICS.DEAD2(r+1)=dead2;
STATISTICS.ALLIVE2(r+1)=allive2-dead2;

countCHs2=0;
cluster2=1;
for i=1:1:n
   if(S2(i).E>0)
   temp_rand=rand;     
   if ( (S2(i).G)<=0)  
     
        if(temp_rand<= (p/(1-p*mod(r,round(1/p)))))
            countCHs2=countCHs2+1;
            packets_TO_BS2=packets_TO_BS2+1;
            PACKETS_TO_BS2(r+1)=packets_TO_BS2;
             S2(i).type='C';
            S2(i).G=round(1/p)-1;
            C2(cluster2).xd=S2(i).xd;
            C2(cluster2).yd=S2(i).yd;
           distance=sqrt( (S2(i).xd-(S2(n+1).xd) )^2 + (S2(i).yd-(S2(n+1).yd) )^2 );
            C2(cluster2).distance=distance;
            C2(cluster2).id=i;
            X2(cluster2)=S2(i).xd;
            Y2(cluster2)=S2(i).yd;
            cluster2=cluster2+1;
           
           distance;
            if (distance>do)
                S2(i).E=S2(i).E- ( (ETX+EDA)*(4000) + Emp*4000*( distance*distance*distance*distance )); 
            end
            if (distance<=do)
                S2(i).E=S2(i).E- ( (ETX+EDA)*(4000)  + Efs*4000*( distance * distance )); 
            end
        end     
    
    end
    % S2(i).G=S2(i).G-1;  
   
 end 
end
STATISTICS.COUNTCHS2(r+1)=countCHs2;

for c=1:1:cluster2-1
    x2(c)=0;
end
y2=0;
z2=0;
for i=1:1:n
   if ( S2(i).type=='N' && S2(i).E>0 )
     if(cluster2-1>=1)
       min_dis=sqrt( (S2(i).xd-S2(n+1).xd)^2 + (S2(i).yd-S2(n+1).yd)^2 );
       min_dis_cluster=0;
       for c=1:1:cluster2-1
           temp=min(min_dis,sqrt( (S2(i).xd-C2(c).xd)^2 + (S2(i).yd-C2(c).yd)^2 ) );
           if ( temp<min_dis )
               min_dis=temp;
               min_dis_cluster=c;
               x2(c)=x2(c)+1;
           end
       end
  
       if(min_dis_cluster~=0)    
            min_dis;
            if (min_dis>do)
                S2(i).E=S2(i).E- ( ETX*(4000) + Emp*4000*( min_dis * min_dis * min_dis * min_dis)); 
            end
            if (min_dis<=do)
                S2(i).E=S2(i).E- ( ETX*(4000) + Efs*4000*( min_dis * min_dis)); 
            end

            S2(C2(min_dis_cluster).id).E = S2(C2(min_dis_cluster).id).E- ( (ERX + EDA)*4000 ); 
            packets_TO_CH2=packets_TO_CH2+1;
       else 
            min_dis;
            if (min_dis>do)
                S2(i).E=S2(i).E- ( ETX*(4000) + Emp*4000*( min_dis * min_dis * min_dis * min_dis)); 
            end
            if (min_dis<=do)
                S2(i).E=S2(i).E- ( ETX*(4000) + Efs*4000*( min_dis * min_dis)); 
            end
            packets_TO_BS2=packets_TO_BS2+1;
            
       end
        S2(i).min_dis=min_dis;
        S2(i).min_dis_cluster=min_dis_cluster;
    else
        y2=y2+1;
        min_dis=sqrt( (S2(i).xd-S2(n+1).xd)^2 + (S2(i).yd-S2(n+1).yd)^2 );
            if (min_dis>do)
                S2(i).E=S2(i).E- ( ETX*(4000) + Emp*4000*( min_dis * min_dis * min_dis * min_dis)); 
            end
            if (min_dis<=do)
                S2(i).E=S2(i).E- ( ETX*(4000) + Efs*4000*( min_dis * min_dis)); 
            end
            packets_TO_BS2=packets_TO_BS2+1;
     end
  end
end
if countCHs2~=0
   u2=(n-y2)/countCHs2;
for c=1:1:cluster2-1
    z2=(x2(c)-u2)*(x2(c)-u2)+z2;
end
LBF2(r+1)=z2/countCHs2;
else  LBF2(r+1)=0;
end
STATISTICS.PACKETS_TO_CH2(r+1)=packets_TO_CH2;
STATISTICS.PACKETS_TO_BS2(r+1)=packets_TO_BS2;
end