function [NoneNaN] = doFix(partChannel)
% % ���ܣ�ʹ��NaN�������ǰ��������ֵȡƽ������õ����ֵ������û��NaNֵ�Ľ����
% % ���룺partChannel - ĳͨ������NaNֵ��һ�����ݣ���ĩ����ֵ�������м�ֵΪNaN��samples*1;
% % �����NoneNaN - ȥ��NaN��Ľ����samples*1��
index = find(isnan(partChannel)==1);
if(~isempty(index))
    si = index(1)-1;
    ei = index(length(index))+1;
    mid = floor((si+ei)/2);
else
    return;
end

NoneNaN = partChannel;
NoneNaN(mid) = (partChannel(si)+partChannel(ei))/2;
%����ǰ������
if(mid~=si+1)
    NoneNaN(si:mid) = doFix(NoneNaN(si:mid));
end
%�����������
if(mid~=ei-1)
    NoneNaN(mid:ei) = doFix(NoneNaN(mid:ei));
end

end