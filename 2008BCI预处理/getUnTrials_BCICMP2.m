function [trials] = getUnTrials_BCICMP2(path)
%% 2012.05.30 LWC
%���ܣ�
%   ��BCI����ѵ�������з�����ȡtrial��ԭʼ���ݸ�ʽ��*.gdf��
%   ��������ȡ���������Artifact��trial��
%   ÿ��trial��3�����ݣ�750�У�ԭʼ���ݲ���Ƶ��250Hz����

%   ����getTrials_BCICMP�����𣺴˴�ÿ��trial�������桿

%���룺
%   path - ԭʼ�����ļ�·��������'..\data\BCICIV_2a_gdf\ori\A01T.gdf'��
%   [s, h] = sload('..\data\BCICIV_2a_gdf\ori\A01T.gdf');
%   [trials] = getTrials_BCICMP('..\data\BCICIV_2a_gdf\ori\A01T.gdf');
%�����
%   trial - �����ֱ�洢�ĸ���trial���ݣ�

%   ��ǣ�
%   783 0x030F Cue unknown��

%% ����
[s, h] = sload(path);

typ_r = size(h.EVENT.TYP,1); %�����ǵ���������������ѡ��Ҫ��4��
trials.text = 'dX - ��ʾһ��trial������;1 ����; 2 ����; 3 ˫��; 4 ��ͷ; Classlabel - ԭʼ�����еķ�����';
trials.count = 0 ;
trials.SampleRate = h.SampleRate; %����Ƶ��
% trials.label = [];

for i = 1:typ_r
    if(h.EVENT.TYP(i,1) == 783)
        trials.count = trials.count + 1;
        %��ÿ��trial������
        eval(['trials.d',num2str(trials.count),'= s(h.EVENT.POS(i)+250:h.EVENT.POS(i)+999,1:22);']);
        %         trials.label(trials.count) = h.EVENT.TYP(i,1)-768;
    end % of if(h.EVENT.TYP(i,1) == 783)
end % of for i = 1:typ_r

% trials.label = trials.label';
trials.ArtifactSelection = h.ArtifactSelection; %�����ų�Artifact;
trials.Classlabel = h.Classlabel; %���ڼ���trial�������Ƿ���ȷ��ѵ������(XXXT.gdf)���У���������(XXXE.gdf)��û���ṩ��

end

