function nextlist=neighbor(rindex,cindex,matrix)
%����Von Neumann�ھӹ���
%nextlistΪ�ھ���ά���飬��˳��Ϊ��������
%rindex��cindexΪԪ���ھ���matrix���кź��к�
%��Ԫ�����ھӣ�-1��Ԫ��(�߽�Ԫ��)�ھ�ȫ����Ϊinf
nextlist=zeros(4,1);
[m,n]=size(matrix);
if rindex==1 || rindex==m || cindex==1 || cindex==n
    if rindex==1 || rindex==m
        nextlist=inf*ones(4,1);
    end
    if cindex==1 && rindex~=1 && rindex~=m
       nextlist(1)=matrix(rindex-1,cindex);
       nextlist(2)=matrix(rindex+1,cindex);
       nextlist(3)=matrix(rindex,cindex+n-1);
       nextlist(4)=matrix(rindex,cindex+1);
    end
    if cindex==n && rindex~=1 && rindex~=m
       nextlist(1)=matrix(rindex-1,cindex);
       nextlist(2)=matrix(rindex+1,cindex);
       nextlist(3)=matrix(rindex,cindex-1);
       nextlist(4)=matrix(rindex,cindex-n+1);
    end
else
    nextlist(1)=matrix(rindex-1,cindex);
    nextlist(2)=matrix(rindex+1,cindex);
    nextlist(3)=matrix(rindex,cindex-1);
    nextlist(4)=matrix(rindex,cindex+1);
end
end