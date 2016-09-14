clear
clc
P=9; %�˵ĸ���
K = 4; %�˶�����ĸ���
Fs = 250; %����Ƶ��
channelnum=8; %8ͨ���Ĳ���,�����޸�ͨ����
tic
for p=1:P
%-----------------------�����ȵ����һ���˵����ݲ���һ��--------------------%
    str_k = num2str(p);
    filename=strcat('D:\����GMM��EM�㷨\2008BCI����\A0XT_V2\subject',str_k,'_V2.mat');
    signal_filter_data=load (filename);%����Ԥ����������signalF
    %���ṹ����Ԫ������
    trials=struct2cell(signal_filter_data.trials);
    %�õ��������ݵı�ǩ
    Classlabel=signal_filter_data.trials.Classlabel;
    %�ӵ�����ѡһ���������Ϊѵ������
    [Data_length,~]=size(Classlabel);
    for k=1:K
        %�ҵ���ǩ��k������trial
        idtmp = find(Classlabel==k);
        %�ҳ�һ��ı�ǩ����ѵ��
        index=idtmp(1:size(idtmp,1));
        for i=1:size(index,1)
            data_temp((i-1)*750+1:i*750,:)=trials{index(i)+3,1};
        end
        %����ѡȡ�ض���ͨ��
        signal_filter=zeros(size(data_temp,1),channelnum);
        signal_filter(:,1)=data_temp(:,8);
        signal_filter(:,2)=data_temp(:,10);
        signal_filter(:,3)=data_temp(:,12);
        signal_filter(:,4)=data_temp(:,15);
        signal_filter(:,5)=data_temp(:,17);
        signal_filter(:,6)=data_temp(:,19);
        signal_filter(:,7)=data_temp(:,20);
        signal_filter(:,8)=data_temp(:,21);
        
        size_idtmp=size(idtmp,1);
        T=size_idtmp/2; %��������
        len=3; %3����һ��ƽ��
        PLVM = zeros(channelnum,channelnum,T);
        for j=1:T
            for i = len*(j-1)+1:len*j
                allCH = signal_filter((i-1)*Fs+1:i*Fs,1:channelnum); %һ�������ݼ���һ��PLVֵ
                [samples,channels] = size(allCH);
                for ch1 = 1:channels
                    for ch2 = ch1:channels
                        tmpCh1 = allCH(:,ch1);
                        tmpCh2 = allCH(:,ch2);
                        PLVch(ch1,ch2) = plv_hilbert(tmpCh1,tmpCh2); %plv_hilbert����������ͨ�������ͬ��ָ��
                    end
                end
                PLVM(:,:,j) = PLVM(:,:,j) + PLVch(:,:); %3s��PLVֵ����
            end
        end
        for j = 1:T
            PLVMavg(:,:,j) = PLVM(:,:,j)/len; %3s��ƽ��
        end
        [m,n,c] = size(PLVMavg);
        for i = 1:m
            for j = i+1:n
                PLVstr((i-1)*channelnum+j,:) = PLVMavg(i,j,:); %һ�����Ե��������ϳ�һ��
            end
        end
        [a,b] = find(PLVstr==0);
        PLVstr(a,:) = []; %ȥ���ظ�����
        PLVall(:,(k-1)*T+1:k*T) = PLVstr; %���б��Ե����ݷ���һ������
        PLVstr = []; %��ʼ�� 
    end
    toc
end
%---------------------------ÿ���˵õ������ݽ���10�β���---------------------%
