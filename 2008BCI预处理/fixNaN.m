%% 2012.06.20 LWC
% % ���㷽����
% %   1. ĳͨ��������������NaNֵ����1���� - ���м��һ��NaN��ʼ���㣬Ȼ��ʹ�����ֵ����ǰ����������ݣ�
% %   2. ĳͨ��������ż����NaNֵ����2���� - �����м�λ�ã���ȡ��ceil������ȡ��floor����

function [outM] = fixNaN(inM)
% % ���ܣ�
% %   ��ͨ����鴫������Ƿ���NaNֵ�����������ʹ�øò������ǰ��������ֵȡƽ����
% %   ����õ�Ĳ���ֵ��
% % ���룺
% %   inM - ������󡾵�һ�������һ�������㲻�ܺ���NaNֵ����samples*channels;
% % �����
% %   outM - ����NaNֵ��õ����������samples*channels;
[samples, channels] = size(inM);
outM = inM;

%��ͨ�����
for i=1:channels
    index = find(isnan(inM(:,i))==1);
    if(isempty(index)) %��ͨ��û��NaNֵ���˳�ѭ��
        continue; %��������ѭ�������������һͨ��
    end
    
    len = length(index);
    if(len==1) %��ͨ��ֻ��һ��NaNֵ������
        outM(index(1)-1:index(1)+1,i) = doFix(outM(index(1)-1:index(1)+1,i));
        continue; %��������ѭ�������������һͨ��
    end
    
    si = 1;
    ei = 2;
    while(ei<=len)
        sv = index(si);
        ev = index(ei);
        base = sv;
        while(ev == base + 1 && ei<len) %��ȡ������NaN����
            base = ev;
            ei = ei + 1;
            ev = index(ei);
        end % while(ev == base + 1 && ei<=len)
        
        if(ev~=base+1)
            if(ei<len) %NaN��û�е���β��ֻ����ǰ�Σ����������һѭ����
                outM(sv-1:base+1,i) = doFix(outM(sv-1:base+1,i));
                si = ei;
                ei = ei + 1;
            else %NaN���Ѿ�����β�Ҳ��������ֱ��������ѭ��
                outM(sv-1:base+1,i) = doFix(outM(sv-1:base+1,i));
                outM(ev-1:ev+1,i) = doFix( outM(ev-1:ev+1,i));
                break;
            end %if(ei<len)
        else %NaN�ε���β����������һ�δ��������ѭ��
            outM(sv-1:ev+1,i) = doFix(outM(sv-1:ev+1,i));
            break;
        end %if(ev~=base+1)
    end % while(j<len)
end % for i=1:channels
end

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % doFix: ʵ�ʶ�ĳ�����ݽ�����������
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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

