function STATISTICS = logic_3(rmax,n,p,P,S3,flag_first_dead3,...
    flag_teenth_dead3,flag_all_dead3,...
    packets_TO_BS3,ETX,EDA,ERX,...
    Emp,Efs,do,allive3,packets_TO_CH3,Et,E3)

for r=0:1:rmax   
  
  if(mod(r, round(1/P) )==0)
    for i=1:1:n
        S3(i).G=0;
        S3(i).cl=0;
    end
  end
Ea=Et*(1-r/rmax)/n;

dead3=0;
for i=1:1:n
    
    if (S3(i).E<=0)
        dead3=dead3+1; 
       
        if (dead3==1)
           if(flag_first_dead3==0)
              first_dead3=r;
              flag_first_dead3=1;
           end
        end

        if(dead3==0.1*n)
           if(flag_teenth_dead3==0)
              teenth_dead3=r;
              flag_teenth_dead3=1;
           end
        end
        if(dead3==n)
           if(flag_all_dead3==0)
              all_dead3=r;
              flag_all_dead3=1;
           end
        end
    end
    if S3(i).E>0
        S3(i).type='N';
    end
end
STATISTICS.DEAD3(r+1)=dead3;
STATISTICS.ALLIVE3(r+1)=allive3-dead3;

countCHs3=0;
cluster3=1;
for i=1:1:n
 if Ea>0
 p(i)=P*n*S3(i).E*E3(i)/(Et*Ea);
 if(S3(i).E>0)
   temp_rand=rand;     
   if ( (S3(i).G)<=0)  
    
        if(temp_rand<= (p(i)/(1-p(i)*mod(r,round(1/p(i))))))
            countCHs3=countCHs3+1;
            packets_TO_BS3=packets_TO_BS3+1;
            PACKETS_TO_BS3(r+1)=packets_TO_BS3;
             S3(i).type='C';
            S3(i).G=round(1/p(i))-1;
            C3(cluster3).xd=S3(i).xd;
            C3(cluster3).yd=S3(i).yd;
           distance=sqrt( (S3(i).xd-(S3(n+1).xd) )^2 + (S3(i).yd-(S3(n+1).yd) )^2 );
            C3(cluster3).distance=distance;
            C3(cluster3).id=i;
            X3(cluster3)=S3(i).xd;
            Y3(cluster3)=S3(i).yd;
            cluster3=cluster3+1;
          
           distance;
            if (distance>do)
                S3(i).E=S3(i).E- ( (ETX+EDA)*(4000) + Emp*4000*( distance*distance*distance*distance )); 
            end
            if (distance<=do)
                S3(i).E=S3(i).E- ( (ETX+EDA)*(4000)  + Efs*4000*( distance * distance )); 
            end
        end     
    
    end
    % S3(i).G=S3(i).G-1;  
   
 end 
 end
end
STATISTICS.COUNTCHS3(r+1)=countCHs3;

for c=1:1:cluster3-1
    x3(c)=0;
end
y3=0;
z3=0;
for i=1:1:n
   if ( S3(i).type=='N' && S3(i).E>0 )
     if(cluster3-1>=1)
       min_dis=Inf;
       min_dis_cluster=0;
       for c=1:1:cluster3-1
           temp=min(min_dis,sqrt( (S3(i).xd-C3(c).xd)^2 + (S3(i).yd-C3(c).yd)^2 ) );
           if ( temp<min_dis )
               min_dis=temp;
               min_dis_cluster=c;
               x3(c)=x3(c)+1;
           end
       end
  
 
            min_dis;
            if (min_dis>do)
                S3(i).E=S3(i).E- ( ETX*(4000) + Emp*4000*( min_dis * min_dis * min_dis * min_dis)); 
            end
            if (min_dis<=do)
                S3(i).E=S3(i).E- ( ETX*(4000) + Efs*4000*( min_dis * min_dis)); 
            end
    
            S3(C3(min_dis_cluster).id).E = S3(C3(min_dis_cluster).id).E- ( (ERX + EDA)*4000 ); 
            packets_TO_CH3=packets_TO_CH3+1;

            
      
        S3(i).min_dis=min_dis;
        S3(i).min_dis_cluster=min_dis_cluster;
   else
       y3=y3+1;
            min_dis=sqrt( (S3(i).xd-S3(n+1).xd)^2 + (S3(i).yd-S3(n+1).yd)^2 );
            if (min_dis>do)
                S3(i).E=S3(i).E- ( ETX*(4000) + Emp*4000*( min_dis * min_dis * min_dis * min_dis)); 
            end
            if (min_dis<=do)
                S3(i).E=S3(i).E- ( ETX*(4000) + Efs*4000*( min_dis * min_dis)); 
            end
           packets_TO_BS3=packets_TO_BS3+1;
   end
  end
end
if countCHs3~=0
   u3=(n-y3)/countCHs3;
for c=1:1:cluster3-1
    z3=(x3(c)-u3)*(x3(c)-u3)+z3;
end
LBF3(r+1)=z3/countCHs3;
else  LBF3(r+1)=0;
end
 STATISTICS.PACKETS_TO_CH3(r+1)=packets_TO_CH3;
 STATISTICS.PACKETS_TO_BS3(r+1)=packets_TO_BS3;
end