function [swapi,swapj]=judgedirection(index,i,j,n)    %�ж��ھ�������ѡ�񽻻���Ԫ�����������ĸ���λ
%indexΪ����������±꣬i,jΪ����Ԫ�����кź��к�,nΪ����
switch index
    case 1
        swapi=i-1;swapj=j;
    case 2
        swapi=i+1;swapj=j;
    case 3
        swapi=i;swapj=j-1;
    case 4
        swapi=i;swapj=j+1;
end
if swapj==0
    swapj=swapj+n;
end
if swapj==n+1
    swapj=swapj-n;
end
end
