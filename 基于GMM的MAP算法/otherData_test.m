clear
clc
Fs = 250;
channelnum = 8; %ͨ������
K=4;
%����ָ����ͨ��
channel=[8,10,12,15,17,19,20,21];
%������Ե�����
load('2003BCI����/l1b.mat');
test_data=s(:,channel);
%��������������ǩ
load('2003BCI����/truelabell1.mat');
true_labell1=truelabell1;
Classlabel=HDR.Classlabel;
%����ÿ������ʼʱ����������
TRIG=HDR.TRIG;
%����trail�Ƿ������ı�ǩ
ArtifactSelection=HDR.ArtifactSelection;
%�����洢4�в�ͬ���������,���Ҳ������ݺ���֤���ݷֿ�
trainData_left=[];testData_left=[];
trainData_right=[];testData_right=[];
trainData_foot=[];testData_foot=[];
trainData_word=[];testData_word=[];
train_p1=1;test_p1=1;
train_p2=1;test_p2=1;
train_p3=1;test_p3=1;
train_p4=1;test_p4=1;
%��4����˶��������ݷֿ�
for i=1:length(true_labell1)
    %�õ���ǩ��
    label=true_labell1(i);
    %�õ���ʵclass
    class=Classlabel(i);
    if ArtifactSelection(i)==1
        continue;
    end
    %�õ�ʵ�����ʼ��
    line_num=TRIG(i);
    %��test_data��ȡ��Ӧ������
    temp=test_data(line_num+Fs*4+1:line_num+Fs*7,:);
    %temp=test_data(line_num:line_num+Fs*3-1,:);
    if isnan(class)==0
        %˵����ѵ������
         if label==1
            trainData_left(train_p1:train_p1+Fs*3-1,:)=temp;
            train_p1=train_p1+Fs*3;
        end
         if label==2
            trainData_right(train_p2:train_p2+Fs*3-1,:)=temp;
            train_p2=train_p2+Fs*3;
         end
         if label==3
            trainData_foot(train_p3:train_p3+Fs*3-1,:)=temp;
            train_p3=train_p3+Fs*3;
         end
         if label==4
            trainData_word(train_p4:train_p4+Fs*3-1,:)=temp;
            train_p4=train_p4+Fs*3;
         end
    else
        %˵���ǲ�������
        if label==1
            testData_left(test_p1:test_p1+Fs*3-1,:)=temp;
            test_p1=test_p1+Fs*3;
        end
         if label==2
            testData_right(test_p2:test_p2+Fs*3-1,:)=temp;
            test_p2=test_p2+Fs*3;
         end
         if label==3
            testData_foot(test_p3:test_p3+Fs*3-1,:)=temp;
            test_p3=test_p3+Fs*3;
         end
         if label==4
            testData_word(test_p4:test_p4+Fs*3-1,:)=temp;
            test_p4=test_p4+Fs*3;
         end
    end
end

for k=1:K
    if k==1
        signal_filter=trainData_left;
    end
     if k==2
        signal_filter=trainData_right;
     end
     if k==3
        signal_filter=trainData_foot;
     end
     if k==4
        signal_filter=trainData_word;
     end
 %-----------------------��������ͨ����PLVֵ----------------------%
    T=30;%��������
    len=3;%3sƽ��
    PLVM=zeros(size(signal_filter,2),size(signal_filter,2),T);
    for j = 1:T
        for i = len*(j-1)+1:len*j
            allCH = signal_filter((i-1)*Fs+1:i*Fs,1:channelnum); %3s�����ݼ���һ��PLVֵ
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
 %-----------------------�õ�ѵ������----------------------%
trainData=PLVall;

for k=1:K
    if k==1
        signal_filter=testData_left;
    end
     if k==2
        signal_filter=testData_right;
     end
     if k==3
        signal_filter=testData_foot;
     end
     if k==4
        signal_filter=testData_word;
     end
 %-----------------------��������ͨ����PLVֵ----------------------%
    T=30;%��������
    len=3;%2sƽ��
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
 %-----------------------�õ���������----------------------%
testData=PLVall;

for a=1:10
    %�õ�ѵ���Ͳ�������
    Tr = T/2; %ѵ������
    Te = T - Tr; %��������
    %[ trainData,testData ] = getsource( PLVall,K,T,Tr);
    %��ʵ���
    label_real = [];
    for i = 1:K
        label_real = [label_real i*ones(1,Te)];
    end
    %ѵ��
    [loglik,W,Mu,Sigma ] = MAP_train(trainData,K,0.22);
    all_W{a}=W;
    all_loglik{a}=loglik;
    %����
    [kapa,LABELS_TEST] = GMM_MAP_test3( testData,W,Mu,Sigma,K );
    %����kapaֵ
    Pa=(sum(diag(kapa))-kapa(K+2,K+2))/kapa(K+2,K+2);
    Pe=0;
    for j=2:K+1
        Pe=Pe+kapa(K+2,j)*kapa(j,K+2)/kapa(K+2,K+2)^2;
    end
    kapa_k(a)=(Pa-Pe)/(1-Pe);
    %������ȷ��
    compare = (label_real == LABELS_TEST);
    MAP_accuracy2(a) = sum(compare)/size(label_real,2);
end