% 2012.05.30 LWC
% ���ܣ�
% ��2008 BCI����������ȡ����trial�����ýű�getUnTrials_BCICMP��getUnTrials_BCICMP2��
% �ýű���ȡ�������ݱ������֣�

%   2012.05.30 ������ Elapsed time is 76.108145 seconds. 

%���� main4 ������������ݣ��������� main2 �������� main4
%�� path ������ѡ������Ҫѵ���Ͳ��Ե���

clear
clc

%path='../2003BCI����/l1b.mat';
%path='../2003BCI����/k6b.mat';
path='../2003BCI����/k3b.mat';

tic;

%�ļ�·������
% path1 = 'D:\matlabWorkspace\BFN\data\BCICIV_2a_gdf\ori\A01E.gdf';
% path2 = 'D:\matlabWorkspace\BFN\data\BCICIV_2a_gdf\ori\A02E.gdf';
% path3 = 'D:\matlabWorkspace\BFN\data\BCICIV_2a_gdf\ori\A03E.gdf';
% path4 = 'D:\matlabWorkspace\BFN\data\BCICIV_2a_gdf\ori\A04E.gdf';
% path5 = 'D:\matlabWorkspace\BFN\data\BCICIV_2a_gdf\ori\A05E.gdf';
% path6 = 'D:\matlabWorkspace\BFN\data\BCICIV_2a_gdf\ori\A06E.gdf';
% path7 = 'D:\matlabWorkspace\BFN\data\BCICIV_2a_gdf\ori\A07E.gdf';
% path8 = 'D:\matlabWorkspace\BFN\data\BCICIV_2a_gdf\ori\A08E.gdf';
% path9 = 'D:\matlabWorkspace\BFN\data\BCICIV_2a_gdf\ori\A09E.gdf';

%��ȡtrials
    
%%���汾1����trial�����ݷ���һ�� - data��
load(path);
trials=getTrials_BCICMP(s,HDR);
save('trials.mat');

toc
