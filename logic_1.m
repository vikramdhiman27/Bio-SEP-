function STATISTICS = logic_1(rmax,n,p,S1,flag_first_dead1,...
    flag_teenth_dead1,flag_all_dead1,...
    packets_TO_BS1,ETX,EDA,ERX,...
    Emp,Efs,do,allive1,...
    packets_TO_CH1)
for r=0:1:rmax     
    
  if(mod(r, round(1/p) )==0)
    for i=1:1:n
        S1(i).G=0;
        S1(i).cl=0;
    end
  end

dead1=0;
for i=1:1:n
    
    if (S1(i).E<=0)
        dead1=dead1+1; 
        
        if (dead1==1)
           if(flag_first_dead1==0)
              first_dead1=r;
              flag_first_dead1=1;
           end
        end
        
        if(dead1==0.1*n)
           if(flag_teenth_dead1==0)
              teenth_dead1=r;
              flag_teenth_dead1=1;
           end
        end
        if(dead1==n)
           if(flag_all_dead1==0)
              all_dead1=r;
              flag_all_dead1=1;
           end
        end
    end
    if S1(i).E>0
        S1(i).type='N';
    end
end
STATISTICS.DEAD1(r+1)=dead1;
STATISTICS.ALLIVE1(r+1)=allive1-dead1;

countCHs1=0;
cluster1=1;
for i=1:1:n
   if(S1(i).E>0)
   temp_rand=rand;     
   if ( (S1(i).G)<=0)  
       
        if(temp_rand<= (p/(1-p*mod(r,round(1/p)))))
            countCHs1=countCHs1+1;
            packets_TO_BS1=packets_TO_BS1+1;
            PACKETS_TO_BS1(r+1)=packets_TO_BS1;
             S1(i).type='C';
            S1(i).G=round(1/p)-1;
            C1(cluster1).xd=S1(i).xd;
            C1(cluster1).yd=S1(i).yd;
           distance=sqrt( (S1(i).xd-(S1(n+1).xd) )^2 + ...
                     (S1(i).yd-(S1(n+1).yd) )^2 );
            C1(cluster1).distance=distance;
            C1(cluster1).id=i;
            X1(cluster1)=S1(i).xd;
            Y1(cluster1)=S1(i).yd;
            cluster1=cluster1+1;
           
           distance;
            if (distance>do)
                S1(i).E=S1(i).E- ( (ETX+EDA)*(4000) + ...
                    Emp*4000*( distance*distance*distance*distance )); 
            end
            if (distance<=do)
                S1(i).E=S1(i).E- ( (ETX+EDA)*(4000)  + ...
                    Efs*4000*( distance * distance )); 
            end
        end     
    
    end
    % S(i).G=S(i).G-1;  
   
 end 
end
STATISTICS.COUNTCHS1(r+1)=countCHs1;

for c=1:1:cluster1-1
    x1(c)=0;
end
y1=0;
z1=0;
for i=1:1:n
   if ( S1(i).type=='N' && S1(i).E>0 )
     if(cluster1-1>=1)
       min_dis=Inf;
       min_dis_cluster=0;
       for c=1:1:cluster1-1
           temp=min(min_dis,sqrt( (S1(i).xd-C1(c).xd)^2 + ...
                   (S1(i).yd-C1(c).yd)^2 ) );
           if ( temp<min_dis )
               min_dis=temp;
               min_dis_cluster=c;
               x1(c)=x1(c)+1;
           end
       end
  
       
            min_dis;
            if (min_dis>do)
                S1(i).E = S1(i).E- ( ETX*(4000) + Emp*4000* ...
                          ( min_dis * min_dis * min_dis * min_dis)); 
            end
            if (min_dis<=do)
                S1(i).E = S1(i).E- ( ETX*(4000) + Efs*4000* ...
                         ( min_dis * min_dis)); 
            end
    
            S1(C1(min_dis_cluster).id).E = S1(C1(min_dis_cluster...
                                            ).id).E- ( (ERX + EDA)*4000 ); 
            packets_TO_CH1=packets_TO_CH1+1;    
 
        S1(i).min_dis=min_dis;
        S1(i).min_dis_cluster=min_dis_cluster;
    else
        y1=y1+1;
        min_dis=sqrt( (S1(i).xd-S1(n+1).xd)^2 + (S1(i).yd-S1(n+1).yd)^2 );
            if (min_dis>do)
                S1(i).E = S1(i).E- ( ETX*(4000) + Emp*4000*...
                           ( min_dis * min_dis * min_dis * min_dis)); 
            end
            if (min_dis<=do)
                S1(i).E = S1(i).E- ( ETX*(4000) + Efs*4000*...
                           ( min_dis * min_dis)); 
            end
            packets_TO_BS1=packets_TO_BS1+1;
     end
  end
end
if countCHs1~=0
   u1=(n-y1)/countCHs1;
for c=1:1:cluster1-1
    z1=(x1(c)-u1)*(x1(c)-u1)+z1;
end
LBF1(r+1)=z1/countCHs1;
else  LBF1(r+1)=0;
end
STATISTICS.PACKETS_TO_CH1(r+1)=packets_TO_CH1;
STATISTICS.PACKETS_TO_BS1(r+1)=packets_TO_BS1;
end