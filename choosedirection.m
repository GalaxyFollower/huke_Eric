function resultindex=choosedirection(direction,loc,lr_refer)
%���ѡ������
%directionΪ��ѡ�ķ�������
%locΪ����Ȩ�ķ���
%lr_referָ�������ϵ�Ȩֵ
if ismember(loc,direction)
    if lr_refer>0.5
        resultindex=loc;
    else
        direction(find(direction==loc))=[];
        if (sum(direction)~=0)
            randindex=randperm(length(direction));
            resultindex=direction(randindex(1));
        else
            resultindex=loc;
        end
    end
else
    randindex=randperm(length(direction));
    resultindex=direction(randindex(1));
end
    