% 2012.06.21 LWC
% ���ܣ�
% ��2008 BCI����������ȡ����trial�����ýű�getTrials_BCICMP��getTrials_BCICMP2��
% �ýű�ֻ��ȡ�˾�������ѵ�����֣���������û��ʵ�ʷ����ǣ�

% Ч�ʼ�¼��
% V1 - Elapsed time is 55.475676 seconds.
% V2 - Elapsed time is 23.558761 seconds.

%����gdf��ʽ�ĺ�����ֻ�ǽ�gdfת����mat(��*BCICMP��β�ĺ���������Ҫ��ע)

clear
clc

tic;

%�ļ�·������
path1 = 'E:\517\Godec\20120530BCI����2008������ȡ\BCICIV_2a_gdf\A01T.gdf';
path2 = 'E:\517\Godec\20120530BCI����2008������ȡ\BCICIV_2a_gdf\A02T.gdf';
path3 = 'E:\517\Godec\20120530BCI����2008������ȡ\BCICIV_2a_gdf\A03T.gdf';
path4 = 'E:\517\Godec\20120530BCI����2008������ȡ\BCICIV_2a_gdf\A04T.gdf';
path5 = 'E:\517\Godec\20120530BCI����2008������ȡ\BCICIV_2a_gdf\A05T.gdf';
path6 = 'E:\517\Godec\20120530BCI����2008������ȡ\BCICIV_2a_gdf\A06T.gdf';
path7 = 'E:\517\Godec\20120530BCI����2008������ȡ\BCICIV_2a_gdf\A07T.gdf';
path8 = 'E:\517\Godec\20120530BCI����2008������ȡ\BCICIV_2a_gdf\A08T.gdf';
path9 = 'E:\517\Godec\20120530BCI����2008������ȡ\BCICIV_2a_gdf\A09T.gdf';

subs = 9;
%2012.06.21 ����������¼
fixed = zeros(300,9);

%��ȡtrials
for i = 1:subs
% for i = 4:4
    
%     %%���汾1����trial�����ݷ���һ�� - data��
%     %%V1 - Elapsed time is 55.475676 seconds.
%     eval(['trials = getTrials_BCICMP(path',num2str(i),');']);
%     eval(['save subject',num2str(i),'_V1 trials;']); %�ֱ𱣴��trials
%     clear trials;
    
    %%���汾2��ÿ��trial�������� - dX��
    %%V2 - Elapsed time is 23.558761 seconds.
    eval(['trials = getTrials_BCICMP2(path',num2str(i),');']);
    eval(['save subject',num2str(i),'_V2 trials;']); %�ֱ𱣴��trials
    
    %2012.06.21
    len = length(trials.fixed);
    fixed(1:len,i) = trials.fixed;
    
    clear trials;
    
end

toc
