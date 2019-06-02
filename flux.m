function [f1,f2]=flux(statusmat)
%��ͨ������
%f1Ϊ��Ĥͨ��
%f2Ϊ����Ĥͨ��
%statusmatΪ״̬����
%m1,m2,m3Ϊ�������������
%��ʱ״̬4����״̬����������
m1=22;m2=5;m3=53;
[~,n]=size(statusmat);
member=statusmat(1:m1+m2+1,:);%member��Ĥ
member=[member;4*ones(m3,n);-1*ones(1,n)];
member(find(member==1))=2;%������滻Ϊˮ����
member(find(member==6))=2;%��PA�滻Ϊˮ����

poly=statusmat;%�ۺ�֮��ľ���
poly(find(poly==3))=4;%��TMC�滻��4
poly(find(poly==1))=2;%������滻Ϊˮ����
[rm,rn]=size(member);
nextcellm=cell(rm,rn);
nextcellp=cell(rm,rn);

for i=1:rm
    for j=1:rn
        list=neighbor(i,j,member);%��ȡ�ھ�
        nextcellm{i,j}=list;
    end
end
for i=1:rm
    for j=1:rn
        list=neighbor(i,j,poly);
        nextcellp{i,j}=list;
    end
end
num=0;%��������
number=uicontrol('style','text','string','1','fontsize',12,'position',[100,400,50,20]);
%imh=matrixplot(member(2:m1+m2+m3+1,1:n));
imh=matrixplot(poly(2:m1+m2+m3+1,1:n));
while num<=50
    for i=1:rm
        for j=1:rn
            switch member(i,j)
                 case 2
                    if (nextcellm{i,j}(2)==4 || nextcellm{i,j}(2)==2) && i<=m1+m2+1
                        direction=union(find(nextcellm{i,j}==4),find(nextcellm{i,j}==2));
                        randindex=randperm(length(direction));
                        resultindex=direction(randindex(1));             %����ˮ�����˶�Ϊ�����˶�
                        [swapi,swapj]=judgedirection(resultindex,i,j,rn);
                        temp=member(swapi,swapj);
                        member(swapi,swapj)=member(i,j);
                        member(i,j)=temp;
                    elseif (ismember(4,nextcellm{i,j}) || ismember(2,nextcellm{i,j})) && i>m1+m2+1 && i<m1+m2+m3+1
                        [swapi,swapj]=judgedirection(2,i,j,rn);
                        temp=member(swapi,swapj);
                        member(swapi,swapj)=member(i,j);
                        member(i,j)=temp;                        
                    end
                    
            end
            list=neighbor(i,j,member);
            nextcellm{i,j}=list;
            
            switch poly(i,j)
                case 2            
                    if (nextcellp{i,j}(2)==4 || nextcellp{i,j}(2)==2 || nextcellp{i,j}(2)==6) && i<=m1+m2+1
                        if nextcellp{i,j}(2)==6 
                           if  i>2 && i<m1+m2+1
                               times=0;
                               while (times<3)
                                    [swapi,swapj]=judgedirection(2,i,j,rn);
                                    poly(swapi,swapj)=2;
                                    temp=poly(2*swapi-i,swapj);                            %����Ԫ��״̬
                                    poly(2*swapi-i,j)=poly(i,j);
                                    poly(i,j)=temp;
                                    times=times+1;
                               end
                           else
                               continue;
                           end                            
                        else
                            direction=union(find(nextcellp{i,j}==4),find(nextcellp{i,j}==2));
                            randindex=randperm(length(direction));
                            resultindex=direction(randindex(1));             %����ˮ�����˶�Ϊ�����˶�                       
                            [swapi,swapj]=judgedirection(resultindex,i,j,rn);
                            temp=poly(swapi,swapj);
                            poly(swapi,swapj)=poly(i,j);
                            poly(i,j)=temp;
                        end
                    elseif (ismember(4,nextcellp{i,j}) || ismember(2,nextcellp{i,j})) && i>m1+m2+1 && i<m1+m2+m3+1
                        [swapi,swapj]=judgedirection(2,i,j,rn);
                        temp=poly(swapi,swapj);
                        poly(swapi,swapj)=poly(i,j);
                        poly(i,j)=temp;
                    elseif  ismember(6,nextcellp{i,j}) && i>m1+m2+1 && i<m1+m2+m3+1
                        times=0;
                        while (times<3)
                           [swapi,swapj]=judgedirection(2,i,j,rn);
                            temp=poly(swapi,swapj);
                            poly(swapi,swapj)=poly(i,j);
                            poly(i,j)=temp; 
                            times=times+1;
                        end
                    end
                    
            
            end
                
                
        end
    end
    imh=matrixplot(poly(2:m1+m2+m3+1,1:n));
    pause(0.01);
    num=num+1;
    stepnumber = 1 + str2num(get(number,'string'));
    set(number,'string',num2str(stepnumber));
end
rest1=member(m1+m2+2:end,:);
count1=length(find(rest1==2));
f1=count1/(n*num);%��Ĥͨ��
rest2=poly(m1+m2+2:end,:);
count2=length(find(rest2==2));
f2=count2/(n*num);%����Ĥͨ��
