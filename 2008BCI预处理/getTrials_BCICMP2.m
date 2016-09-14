function [trials] = getTrials_BCICMP2(path)
%% 2012.05.30 LWC

%   ����getTrials_BCICMP�����𣺴˴�ÿ��trial�������桿
% % �Ķ���
%   2012.06.21 �������NaN���ݹ��ܣ�

%���ܣ�
%   ��BCI����ѵ�������з�����ȡtrial��ԭʼ���ݸ�ʽ��*.gdf��
%   ��������ȡ���������Artifact��trial��
%   ÿ��trial��3�����ݣ�750�У�ԭʼ���ݲ���Ƶ��250Hz����
%���룺
%   path - ԭʼ�����ļ�·��������'..\data\BCICIV_2a_gdf\ori\A01T.gdf'��
%   [s, h] = sload('..\data\BCICIV_2a_gdf\ori\A01T.gdf');
%   [trials] = getTrials_BCICMP('..\data\BCICIV_2a_gdf\ori\A01T.gdf');
%�����
%   trial - �����ֱ�洢�ĸ���trial���ݣ�

% ����������ʾ��ʼ��ǣ�
% 769 0x0301 Cue onset left (class 1)
% 770 0x0302 Cue onset right (class 2)
% 771 0x0303 Cue onset foot (class 3)
% 772 0x0304 Cue onset tongue (class 4)
% ˼·������ h.EVENT.TYP��Ѱ������4�����ݣ�ÿ����һ��trial��

%% ����
[s, h] = sload(path);

typ_r = size(h.EVENT.TYP,1); %�����ǵ���������������ѡ��Ҫ��4��
trials.text = 'dX - ��ʾһ��trial������;1 ����; 2 ����; 3 ˫��; 4 ��ͷ; Classlabel - ԭʼ�����еķ�����';
trials.count = 0 ;
trials.SampleRate = h.SampleRate; %����Ƶ��
% trials.label = [];

for i = 1:typ_r
    if(h.EVENT.TYP(i,1)>768 && h.EVENT.TYP(i,1)<773)
        trials.count = trials.count + 1;
        %��ÿ��trial������
        tmpData = s(h.EVENT.POS(i)+250:h.EVENT.POS(i)+999,1:22);
        
%         %         % 2012.06.23 ���trial�Ƿ�������Rejected Trial��
%         % % ���Է���ArtifactSelection���ֵ���������õ�trails��rejected
%         %         if(h.EVENT.TYP(i-1,1)==1023)
%         %             trials.rejected(trials.count) = 1;
%         %         else
%         %             trials.rejected(trials.count) = 0;
%         %         end
        
        %2012.06.21 �����ݵ�һ�����һ��������û��NaNֵʱ�����������������NaNֵ��
        if(isempty(find(isnan(tmpData(1,:))==1)) && isempty(find(isnan(tmpData(750,:))==1)))
            if(isempty(find(isnan(tmpData(2:749,:))==1)))
                trials.fixed(trials.count) = 0; %��������NaN
            else
                tmpData = fixNaN(tmpData);
                trials.fixed(trials.count) = 1; %��Ҫ����NaN����������
            end
        else
            disp '�����޷�����������'
            trials.fixed(trials.count) = 2; %��ĩ�д���NaNֵ���޷�������
        end
        
        eval(['trials.d',num2str(trials.count),'= tmpData;']);
        %         trials.label(trials.count) = h.EVENT.TYP(i,1)-768;
    end % of if(h.EVENT.TYP(i,1)>768 && h.EVENT.TYP(i,1)<773)
end % of for i = 1:typ_r

% trials.label = trials.label';
trials.fixed = trials.fixed';
trials.rejected = trials.rejected';
trials.ArtifactSelection = h.ArtifactSelection; %�����ų�Artifact;
trials.Classlabel = h.Classlabel; %���ڼ���trial�������Ƿ���ȷ��ѵ������(XXXT.gdf)���У���������(XXXE.gdf)��û���ṩ��

end

