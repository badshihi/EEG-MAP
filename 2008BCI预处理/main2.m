% 2012.05.30 LWC
% ���ܣ�
% ��2008 BCI����������ȡ����trial�����ýű�getUnTrials_BCICMP��getUnTrials_BCICMP2��
% �ýű���ȡ�������ݱ������֣�

%   2012.05.30 ������ Elapsed time is 76.108145 seconds. 

clear
clc

tic;

%�ļ�·������
path1 = 'D:\matlabWorkspace\BFN\data\BCICIV_2a_gdf\ori\A01E.gdf';
path2 = 'D:\matlabWorkspace\BFN\data\BCICIV_2a_gdf\ori\A02E.gdf';
path3 = 'D:\matlabWorkspace\BFN\data\BCICIV_2a_gdf\ori\A03E.gdf';
path4 = 'D:\matlabWorkspace\BFN\data\BCICIV_2a_gdf\ori\A04E.gdf';
path5 = 'D:\matlabWorkspace\BFN\data\BCICIV_2a_gdf\ori\A05E.gdf';
path6 = 'D:\matlabWorkspace\BFN\data\BCICIV_2a_gdf\ori\A06E.gdf';
path7 = 'D:\matlabWorkspace\BFN\data\BCICIV_2a_gdf\ori\A07E.gdf';
path8 = 'D:\matlabWorkspace\BFN\data\BCICIV_2a_gdf\ori\A08E.gdf';
path9 = 'D:\matlabWorkspace\BFN\data\BCICIV_2a_gdf\ori\A09E.gdf';

%��ȡtrials
for i = 1:9
    
    %%���汾1����trial�����ݷ���һ�� - data��
    eval(['trials = getUnTrials_BCICMP(path',num2str(i),');']);
    eval(['save subject',num2str(i),'_EV1 trials;']); %�ֱ𱣴��trials
    clear trials;
    
    %%���汾2��ÿ��trial�������� - dX��
    eval(['trials = getUnTrials_BCICMP2(path',num2str(i),');']);
    eval(['save subject',num2str(i),'_EV2 trials;']); %�ֱ𱣴��trials
    clear trials;
    
end

toc
