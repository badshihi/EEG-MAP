clear
clc
P=1; %�˵ĸ���
K = 4; %�˶�����ĸ���
Fs = 250; %����Ƶ��
channelnum=8; %8ͨ���Ĳ���,�����޸�ͨ����
tic
for p=1:P
%-----------------------�����ȵ����һ���˵����ݲ���һ��--------------------%
    %str_k = num2str(p);
    %filename = strcat('E:\���ѧϰ����\GMM-EEG\20120530BCI����2008������ȡ\20120530BCI����2008������ȡ\data_V1\A0XT_V1\subject',str_k,'_V1.mat');
    filename=strcat('D:\����GMM��EM�㷨\2003BCIԤ����\trials.mat');
    signal_filter_data=load (filename);%����Ԥ����������signalF
    temp_data=[];
    PLVall=[];
    length=zeros(1,K);
    subject_T=zeros(1,K);
    for k=1:K
         %-------------��������������Ǹ��������˶������һ������Ҫ�ٴ���ȡ����ǩ1����������----------------%
         idtmp = find(signal_filter_data.trials.data(:,61)==k);
         size_idtmp=size(idtmp,1);
         idtmp(size(idtmp,1)+1)=NaN;
         begin_num=idtmp(1);
         num=1;
         for i=1:size_idtmp
             if(idtmp(i)~=idtmp(i+1)-1||i==size(idtmp,1))
                 end_num=idtmp(i);
                 for j=1:end_num-begin_num+1
                    temp_data(k).trials(num).data(j,:)= signal_filter_data.trials.data(idtmp(j),:);
                 end
                 num=num+1;
                 begin_num=idtmp(i+1);
             end
         end
         %-------------------------ȡ��ÿһ��subject�������ܳ�--------------------%
         for i=1:size(temp_data(k).trials,2)
             length(k)=length(k)+size(temp_data(k).trials(i).data,1);
         end

        len=3; %3����һ��ƽ��
        T=length(k)/Fs/len; %��������
        PLVM = zeros(channelnum,channelnum,T);
        t=1;
        for w=1:size(temp_data(k).trials,2)
             %signal_filter=temp_data(k).trials(w).data(:,1:22);
            signal_filter=zeros(size(temp_data(k).trials(w).data,1),channelnum);
            signal_filter(:,1)=temp_data(k).trials(w).data(:,8);
            signal_filter(:,2)=temp_data(k).trials(w).data(:,10);
            signal_filter(:,3)=temp_data(k).trials(w).data(:,12);
            signal_filter(:,4)=temp_data(k).trials(w).data(:,15);
            signal_filter(:,5)=temp_data(k).trials(w).data(:,17);
            signal_filter(:,6)=temp_data(k).trials(w).data(:,19);
            signal_filter(:,7)=temp_data(k).trials(w).data(:,20);
            signal_filter(:,8)=temp_data(k).trials(w).data(:,21);
            for a=1:size(signal_filter,1)/Fs/len
                for i=(a-1)*len+1:len*a
                    allCH = signal_filter((i-1)*Fs+1:i*Fs,1:channelnum); %3�������ݼ���һ��PLVֵ
                    [samples,channels] = size(allCH);
                     for ch1 = 1:channels
                        for ch2 = ch1:channels
                            tmpCh1 = allCH(:,ch1);
                            tmpCh2 = allCH(:,ch2);
                            PLVch(ch1,ch2) = plv_hilbert(tmpCh1,tmpCh2); %plv_hilbert����������ͨ�������ͬ��ָ��
                        end
                     end
                     PLVM(:,:,t) = PLVM(:,:,t) + PLVch(:,:); %3s��PLVֵ����
                end
                t=t+1;
            end
        end

        for j = 1:T
            PLVMavg(:,:,j) = PLVM(:,:,j)/len; %3s��ƽ��
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
    %-----------------------------��ͬһ���˽���10�β���-----------------------%
    for a=1:10
        if mod(T,2)==0
            Tr = T*0.5; 
        else
            Tr=ceil(T/2);
        end
        Te = T - Tr; 
        %�õ�ѵ��������������������ʵ��ǩ
        [label_real,trainData,testData ] = getsource( PLVall,K,T,Tr,Te);
        %ѵ��
        [loglik_all,Pix_all,W,Mu,Sigma ] = MAP_train(trainData,K,0.35);
        %��¼Ȩ��
        all_W{p,a}=W;
        all_loglik{p,a}=loglik_all;
        all_Pix{p,a}=Pix_all;
        %����
        [LABELS_TEST] = GMM_MAP_test3( testData,Mu,Sigma,K );
        %����kapaϵ��
        [kapa_k,kapa]=get_kapa(label_real,LABELS_TEST);
        all_kapa{p,a}=kapa_k;
        kapa_P(p,a)=kapa;
        compare = (label_real == LABELS_TEST);
        MAP_accuracy2(p,a) = sum(compare)/size(label_real,2); %������ȷ��,����ͬһ���˵�10��
    end
    %end
end

accuracy=sum(MAP_accuracy2,2)/10;
figure;
plot(accuracy);
title('ÿ���˵�ƽ����ȷЧ');
figure;
plot(sum(kapa_P,2)/10);
title('ÿ���˵�ƽ��kapaϵ��');