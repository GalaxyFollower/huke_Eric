%% --------------------------------------------------------
clc;clear;
%������
% writerObj=VideoWriter('cellautoma.avi');
% writerObj.FrameRate=2;%֡����
% open(writerObj);
number=uicontrol('style','text','string','1','fontsize',12,'position',[100,400,50,20]);
%% ����Ԫ��
%0ΪĤ�׿�϶��1Ϊ��ື��ӣ�2Ϊˮ���ӣ�3ΪTMC���ӣ�4Ϊ�����ܼ����ӣ�5Ϊ��Ĥ��6Ϊ������
m1=22;m2=5;m3=53;   %���������
n=50;               %ģ��ʱ�Ŀ��
water=2*ones(m1*n,1);  %ˮ��
membr=zeros(m2*n,1);  %�����
oil=4*ones(m3*n,1);    %����
active=zeros(m1+m2+m3,n); %PA��������
c1=0.2;c2=0.50;c3=0.02; %������������ռ�İٷֱ�
membr(ceil(rand(ceil(m2*n*c2),1)*m2*n))=5;
membr=reshape(membr,m2,n); %���л�Ĥ�Ľ������
water(ceil(rand(ceil((m1*n+m2*n*(1-c2))*c1),1)*m1*n))=1;
water=reshape(water,m1,n); %���е����ˮ�����
oil(ceil(rand(ceil(m3*n*c3),1)*m3*n))=3;
oil=reshape(oil,m3,n);    %���е�����������
allmatrix=[water;membr;oil];%���
%% ����߽�
simulation=zeros(m1+m2+m3+2,n+2); %�����һ�����߽�
simulation([1 m1+m2+m3+2],:)=-1*ones(2,n+2);%���²�߽�Ԫ����ֵΪ-1
simulation(:,1)=[-1;allmatrix(:,end);-1];
simulation(:,n+2)=[-1;allmatrix(:,1);-1];   %���Ҳ��ȡ������ԭ��ģ�����޿�����
simulation(2:m1+m2+m3+1,2:n+1)=allmatrix;
w_pip=0.8; %pip���γ��Ŵصĸ���
w_TMC=0.6; %TMC���γ��Ŵصĸ���
%% Ԫ���ھ�
%����neighbor���������ھӴ洢��ÿ��Ԫ����Ӧ��Ԫ��������
[rm,rn]=size(simulation);
nextcell=cell(rm,rn);
for i=1:rm
    for j=1:rn
        list=neighbor(i,j,simulation);
        nextcell{i,j}=list;
    end
end
%% �Ŵ�Ԫ��
grouppip=cell(rm,rn);  %%��������Ŵ�Ԫ��
for i=1:rm
    for j=1:rn
        grouppip{i,j}=zeros(1,2);
    end
end
groupTMC=cell(rm,rn);  %%����TMC�Ŵ�Ԫ��
for i=1:rm
    for j=1:rn
        groupTMC{i,j}=zeros(1,2);
    end
end
%% �ƶ�Ԫ������
num=0;%��������
imh=matrixplot(simulation(2:m1+m2+m3+1,1:n+2));
while num<=98
    %tempmatrix = simulation;                  %�����µľ��������ʱ���浱ǰ����
    for i=1:rm
        for j=1:rn
            switch simulation(i,j)
                case -1                       %�߽�Ԫ������������
                case 0                        %Ĥ��Ԫ������������
                case 1                        %���Ԫ��
                    if ismember(simulation(i,j),grouppip{i,j})
                        continue;
                    else
                        if ismember(3,nextcell{i,j})        %��Ԫ�������ھӺ���Ԫ��3����������6
                            direction=find(nextcell{i,j}==3);
                            randindex=randperm(length(direction));
                            resultindex=direction(randindex(1));             %����ˮ�����˶�Ϊ�����˶�
                            [swapi,swapj]=judgedirection(resultindex,i,j,rn);
                            simulation(i,j)=6;                               %���λ��PA���
                            simulation(swapi,swapj)=4;                          %TMCλ�������ܼ����
                            active(i,j)=2;  %����paֻ��Ӧ����
                        elseif ismember(0,nextcell{i,j}) || ismember(2,nextcell{i,j}) || ismember(4,nextcell{i,j})
                            direction=union(find(nextcell{i,j}==0),union(find(nextcell{i,j}==2),find(nextcell{i,j}==4))); %Ѱ���ĸ������к���Ԫ��0,1,2,4�ķ���
                            p_max=1;p_min=0.5;                              %���ʱ仯��Χ
                            if i<=m1    %�������ˮ��
                                p_i=p_max-(i-1)*(p_max-p_min)/m1;
                                resultindex=choosedirection(direction,2,p_i);
                                %resultindex=2;
                            elseif i>m1+m2 %�����������
                                p_i=p_min+(i-m1-m2)*(p_max-p_min)/m3;
                                resultindex=choosedirection(direction,1,p_i);
                            else           %������ڽ����У��ȸ�����ɢ
                                %p_i=p_max-(i-1)*(p_max-p_min)/m1;
                                resultindex=choosedirection(direction,2,1);
                                %resultindex=2;
                            end
                            %���ڽ���ۺϣ�ˮ������ڽ��洦�ƶ�������С�����߸�����󣬸������������𽥱仯,���ݸ���ѡ����ѷ���
                            [swapi,swapj]=judgedirection(resultindex,i,j,rn);   %���ѡ������Ԫ�������к�
                            if simulation(swapi,swapj)==0                    %�����ɢ��Ĥ��,Ĥ��Ԫ����Ϊ���Ԫ�������Ԫ�����ˮ����Ԫ��
                                simulation(swapi,swapj)=1;
                                simulation(i,j)=2;
                            elseif simulation(swapi,swapj)==4
                                if swapi<=m1+m2
                                    continue;
                                elseif swapi>m1+m2+min(size(find(simulation==1)),size(find(simulation==3)))/n+1   %���ֻ�ܻ�Ծ������ı��,�ò�Ϊ����Ĥ���
                                    continue;
                                end
                            else
                                temp=simulation(i,j);                            %����Ԫ��״̬
                                simulation(i,j)=simulation(swapi,swapj);
                                simulation(swapi,swapj)=temp;
                            end
                            
                        elseif ismember(1,nextcell{i,j})   %���ھ����������������������ӿ����γ��Ŵ�
                            if rand>=w_pip && i>2 && i<rm-1 && j>2 && j<rn-1 %������ײ
                                direction=find(nextcell{i,j}==1);
                                randindex=randperm(length(direction));
                                resultindex=direction(randindex(1));             %����ˮ�����˶�Ϊ�����˶�
                                [swapi,swapj]=judgedirection(resultindex,i,j,rn);
                                temp=simulation(2*i-swapi,2*j-swapj);                            %����Ԫ��״̬
                                simulation(2*i-swapi,2*j-swapj)=simulation(i,j);
                                simulation(i,j)=temp;
                            else             %�γ��Ŵ�
                                grouppip{i,j}=[simulation(i,j),simulation(swapi,swapj)];
                            end
                        end
                    end
                case 2                        %ˮ����Ԫ��
                    if ismember(0,nextcell{i,j})  %��ˮ������ɢ��Ĥ��
                        direction=find(nextcell{i,j}==0);
                        randindex=randperm(length(direction));
                        resultindex=direction(randindex(1));             %����ˮ�����˶�Ϊ�����˶�
                        [swapi,swapj]=judgedirection(resultindex,i,j,rn);
                        if simulation(swapi,swapj)==0
                            simulation(swapi,swapj)=2;
                        end
                    end
                case 3                        %TMCԪ��
                    if ismember(simulation(i,j),groupTMC{i,j})
                        continue;
                    else
                        if ismember(1,nextcell{i,j})        %��Ԫ���ھӺ���Ԫ��1����������6
                            direction=find(nextcell{i,j}==1);
                            randindex=randperm(length(direction));
                            resultindex=direction(randindex(1));
                            [swapi,swapj]=judgedirection(resultindex,i,j,rn);
                            simulation(i,j)=4;
                            simulation(swapi,swapj)=6; %���λ��PA���
                            active(swapi,swapj)=2;
                        elseif ismember(4,nextcell{i,j})
                            direction=find(nextcell{i,j}==4);
                            p_max=1;p_min=0.5;
                            p_i=p_min+(i-m1-m2)*(p_max-p_min)/m3;%���ڽ���ۺϣ��������Ҫ������ȥ�ĸ��ʸ��󣬼������Ϊ0.7
                            resultindex=choosedirection(direction,1,p_i);  %1��ʾ���ϣ����ݸ���ѡ����ѷ���
                            [swapi,swapj]=judgedirection(resultindex,i,j,rn);
                            if (simulation(swapi,swapj)==4 && swapi>m1+m2) || simulation(swapi,swapj)==3
                                temp=simulation(i,j);
                                simulation(i,j)=simulation(swapi,swapj);
                                simulation(swapi,swapj)=temp;
                            end
                        elseif ismember(3,nextcell{i,j})
                            if rand>=w_TMC && i>2 && i<rm-1 && j>2 && j<rn-1 %������ײ
                                direction=find(nextcell{i,j}==3);
                                randindex=randperm(length(direction));
                                resultindex=direction(randindex(1));             %����ˮ�����˶�Ϊ�����˶�
                                [swapi,swapj]=judgedirection(resultindex,i,j,rn);
                                temp=simulation(2*i-swapi,2*j-swapj);                            %����Ԫ��״̬
                                simulation(2*i-swapi,2*j-swapj)=simulation(i,j);
                                simulation(i,j)=temp;
                            else             %�γ��Ŵ�
                                groupTMC{i,j}=[simulation(i,j),simulation(swapi,swapj)];
                            end
                        end
                    end
                case 4                        %HEX�����ܼ�Ԫ��
                case 5                        %��ĤԪ��
                case 6                        %PAԪ��
                    p1=0.4286;p2=0.5714;           %�����㣬p1��ʾ6��1��Ӧ������6�ĸ��ʣ�p2��ʾ6��3��Ӧ������6�ĸ���
                    if active(i,j)>0
                        if ismember(1,nextcell{i,j}) && ismember(3,nextcell{i,j}) %�����Χ��Ȼ�е���
                            flag=(p1*rand>p2*rand);
                            if flag==1  %��1������Ӧ
                                direction=find(nextcell{i,j}==1);
                                randindex=randperm(length(direction));
                                resultindex=randindex(1);
                                [swapi,swapj]=judgedirection(resultindex,i,j,rn);
                                simulation(swapi,swapj)=6;
                                active(swapi,swapj)=1;
                                active(i,j)=active(i,j)-1;
                            else        %��3������Ӧ
                                direction=find(nextcell{i,j}==3);
                                resultindex=direction(1);
                                [swapi,swapj]=judgedirection(resultindex,i,j,rn);
                                simulation(swapi,swapj)=6;
                                active(swapi,swapj)=1;
                                active(i,j)=active(i,j)-1;
                            end
                        elseif ismember(1,nextcell{i,j}) || ismember(3,nextcell{i,j}) %��6�Ⱥ�1�ֺ�3����
                            direction=union(find(nextcell{i,j}==1),find(nextcell{i,j}==3));
                            resultindex=direction(1);
                            [swapi,swapj]=judgedirection(resultindex,i,j,rn);
                            simulation(swapi,swapj)=6;
                            active(swapi,swapj)=1;
                            active(i,j)=active(i,j)-1;
                        end
                    else
                        continue;
                    end
                    if i>m1+m2       %�����ɵ�PA���������У���Ӧ����һ���Ĺ��ɸ����ڽ���
                        direction=[1 2 3 4];
                        p_max=1;p_min=0.5;
                        p_i=p_min+(i-m1-m2)*(p_max-p_min)/m3;
                        resultindex=choosedirection(direction,1,p_i);
                        [swapi,swapj]=judgedirection(resultindex,i,j,rn);
                        temp=simulation(i,j);
                        if simulation(swapi,swapj) ==0 || simulation(swapi,swapj)==5
                            continue;
                        elseif swapi<=m1+m2 && simulation(swapi,swapj)==3
                            continue;
                        elseif swapi>=m1-1 && simulation(swapi,swapj)==2
                            continue;
                        else
                            simulation(i,j)=simulation(swapi,swapj);
                            simulation(swapi,swapj)=temp;
                        end
                        %����Ԫ�ؾ���
                    elseif i<m1
                        direction=[1 2 3 4];
                        p_max=1;p_min=0.5;
                        p_i=p_min-(i-m1)*(p_max-p_min)/m1;
                        resultindex=choosedirection(direction,2,p_i);
                        [swapi,swapj]=judgedirection(resultindex,i,j,rn);
                        temp=simulation(i,j);
                        if simulation(swapi,swapj) ==0 || simulation(swapi,swapj)==5
                            continue;
                        elseif swapi<=m1+m2 && simulation(swapi,swapj)==3
                            continue;
                        elseif swapi>=m1-1 && simulation(swapi,swapj)==2
                            continue;
                        else
                            simulation(i,j)=simulation(swapi,swapj);
                            simulation(swapi,swapj)=temp;
                        end
                    end
            end
            list=neighbor(i,j,simulation);
            nextcell{i,j}=list;
        end
    end
    [row,col]=find(simulation==6); %PA�ĵ��ЧӦ
    len=length(row);
    for i=1:len
        if row(i)>m1+m2
            active(row(i),col(i))=active(row(i),col(i))+1;
        elseif row(i)<m1
            active(row(i),col(i))=active(row(i),col(i))-1;
        end
    end

    
    imh=matrixplot(simulation(2:m1+m2+m3+1,1:n+2));
    pause(0.05);
%     frame=getframe(gcf);
%     writeVideo(writerObj,frame);
    num=num+1;
    stepnumber = 1 + str2num(get(number,'string'));
    set(number,'string',num2str(stepnumber));
    %legend('Ĥ�׿�϶','��ື���','ˮ����','TMC����','�����ܼ�����','��Ĥ','������');
end
% close(writerObj)
%% ���ӻ�����ͼ�ν���
% imh=imagesc(simulation(2:m1+m2+m3+1,2:n+1));
% plotbutton=uicontrol('style','pushbutton','string','Run','fontsize',12,'position',[150,400,50,20],'callback','run=1;');%����
% erasebutton=uicontrol('style','pushbutton','string','Stop','fontsize',12,'position',[300,400,50,20],'callback','freeze=1;');%��ֹ
% quitbutton=uicontrol('style','pushbutton','string','Quit','fontsize',12,'position',[450,400,50,20],'callback','freeze=1;');%�˳�
% number=uicontrol('style','text','string','1','fontsize',12,'position',[50,400,50,20]);

