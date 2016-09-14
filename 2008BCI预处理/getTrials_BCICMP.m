function [trials] = getTrials_BCICMP(path)
%% 2012.05.30 LWC
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
trials.text = '1 ����; 2 ����; 3 ˫��; 4 ��ͷ; Classlabel - ԭʼ�����еķ�����';
trials.count = 0 ;
trials.SampleRate = h.SampleRate; %����Ƶ��
% trials.label = [];
trials.data = [];

for i = 1:typ_r %���в��ң�Ѱ����Ҫ�ı��
    if(h.EVENT.TYP(i,1)>768 && h.EVENT.TYP(i,1)<773)
        trials.count = trials.count + 1;
        rows = size(trials.data,1); %������������
        trials.data(rows+1:rows+750,1:22) = s(h.EVENT.POS(i)+250:h.EVENT.POS(i)+999,1:22); %ǰ22��Ϊ����
        trials.data(rows+1:rows+750,23) = (h.EVENT.TYP(i,1)-768)*ones(750,1); %��23���Ǳ�ǣ�ÿ������һ��
        %         trials.label(trials.count) = h.EVENT.TYP(i,1)-768; %��������ı�ǣ�ÿ��trialһ��
    end % of if(h.EVENT.TYP(i,1)>768 && h.EVENT.TYP(i,1)<773)
end % of for i = 1:typ_r

% trials.label = trials.label';
trials.ArtifactSelection = h.ArtifactSelection; %�����ų�Artifact;
trials.Classlabel = h.Classlabel; %���ڼ���trial�������Ƿ���ȷ��ѵ������(XXXT.gdf)���У���������(XXXE.gdf)��û���ṩ��

end

