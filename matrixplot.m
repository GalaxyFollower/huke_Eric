function imh=matrixplot(matrix)
%������ת��Ϊ��ɫͼ�񣬷��ؾ��
%������Ԫ�ط�ΧΪ0��6
B(:,:,1)=ones(size(matrix))*255;
B(:,:,2)=ones(size(matrix))*255;
B(:,:,3)=ones(size(matrix))*255;      %�½���ɫ����B����ɫֵΪ(255,255,255)��ɫ
[m0,n0]=find(matrix==0);              %Ѱ��Ԫ��0������
[m1,n1]=find(matrix==1);              %Ѱ��Ԫ��1������
[m2,n2]=find(matrix==2);              %Ѱ��Ԫ��2������
[m3,n3]=find(matrix==3);              %Ѱ��Ԫ��3������
[m4,n4]=find(matrix==4);              %Ѱ��Ԫ��4������
[m5,n5]=find(matrix==5);              %Ѱ��Ԫ��5������
[m6,n6]=find(matrix==6);              %Ѱ��Ԫ��6������
for k=1:numel(m0)                     %numel��ʾ����m�Ĵ�С
    B(m0(k),n0(k),1)=0;
    B(m0(k),n0(k),2)=255;
    B(m0(k),n0(k),3)=255;             %Ĥ��Ϊů��ɫ
end
for k=1:numel(m1)                     
    B(m1(k),n1(k),1)=255;
    B(m1(k),n1(k),2)=0;
    B(m1(k),n1(k),3)=0;               %���Ϊ��ɫ
end
for k=1:numel(m2)                     
    B(m2(k),n2(k),1)=0;
    B(m2(k),n2(k),2)=0;
    B(m2(k),n2(k),3)=255;             %ˮΪ��ɫ
end
for k=1:numel(m3)                     
    B(m3(k),n3(k),1)=255;
    B(m3(k),n3(k),2)=255;
    B(m3(k),n3(k),3)=255;             %TMCΪ��ɫ
end
for k=1:numel(m4)                     
    B(m4(k),n4(k),1)=255;
    B(m4(k),n4(k),2)=255;
    B(m4(k),n4(k),3)=0;               %�����ܼ�Ϊ��ɫ
end
for k=1:numel(m5)                     
    B(m5(k),n5(k),1)=255;
    B(m5(k),n5(k),2)=0;
    B(m5(k),n5(k),3)=255;             %��ĤΪ����ɫ
end
for k=1:numel(m6)                     
    B(m6(k),n6(k),1)=0;
    B(m6(k),n6(k),2)=255;
    B(m6(k),n6(k),3)=0;               %PAΪ��ɫ
end
imh=image(B);