%-----------------------���ڽ��ж����࣬���Ը��Ե������Ƿ����������------------------------%
clear
clc
K = 20; %������Ա������
Fs = 256; %����Ƶ��
channelnum = 4; %ͨ������

tic
for k=1:K
    %------------------����Ԥ�����˲���ȥ����ƽ��------------------%
    
    str_k = num2str(k);
    filename = strcat('D:\ADdata\signalF',str_k,'.mat');
    load (filename); %����Ԥ����������signalF
    
    [B,A] = butter(2,[30/(Fs/2) 40/(Fs/2)]); %�˲���gammaƵ��
    signal_filter_temp= filter(B,A,signalF(:,1:15));
    %-----------------------���ض���ͨ���л�ȡ����-------------------%
   signal_filter=zeros(size(signal_filter_temp,1),channelnum);
   signal_filter(:,1)=signal_filter_temp(:,8);
   signal_filter(:,2)=signal_filter_temp(:,10);
   signal_filter(:,3)=signal_filter_temp(:,12);
   signal_filter(:,4)=signal_filter_temp(:,15);
    
    %-----------------------��������ͨ����PLVֵ----------------------%
    T=16;%��������
    len=30;%30sƽ��
    PLVM=zeros(size(signal_filter,2),size(signal_filter,2),T);
    for j = 1:T
        for i = len*(j-1)+1:len*j
            allCH = signal_filter((i-1)*Fs+1:i*Fs,1:channelnum); %���������ݼ���һ��PLVֵ
            [samples,channels] = size(allCH);
            for ch1 = 1:channels
                for ch2 = ch1:channels
                    tmpCh1 = allCH(:,ch1);
                    tmpCh2 = allCH(:,ch2);
                    PLVch(ch1,ch2) = plv_hilbert(tmpCh1,tmpCh2); %plv_hilbert����������ͨ�������ͬ��ָ��
                end
            end
            PLVM(:,:,j) = PLVM(:,:,j) + PLVch(:,:); %1s��PLVֵ����
        end
    end
    for j = 1:T
        PLVMavg(:,:,j) = PLVM(:,:,j)/len; %4s��ƽ��
    end
    %---------------------������ֱ���ϳ�һ������--------------------%
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
%--------------------�õ�ѵ�����ݺͲ�������------------------------%
%��ʵ���
 for a=1:10
        Tr = T/2; %ѵ������
        Te = T - Tr; %��������
        [ trainData,testData ] = getsource( PLVall,K,T,Tr);
        %��ʵ���
        label_real = [];
        for i = 1:K
            label_real = [label_real i*ones(1,Te)];
        end
        [Pix_all,W,Mu,Sigma ] = MAP_train3(trainData,K,0.22);
        all_W{a}=W;
        %all_W{p,z}=W;
        all_loglik{a}=Pix_all;
        %all_loglik{p,z}=loglik;
        [LABELS_TEST] = GMM_MAP_test2( testData,W,Mu,Sigma,K );
        compare = (label_real == LABELS_TEST);
        MAP_accuracy2(a) = sum(compare)/size(label_real,2); %������ȷ��,����ͬһ���˵�10��
 end
accuracy=sum(MAP_accuracy2,2)/10;
figure;
plot(accuracy);
title('10�ε�ƽ����ȷЧ');