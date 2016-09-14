function [kapa,LABELS_TEST] = GMM_MAP_test3( X,W,Mu,Sigma,K )
%UNTITLED2 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
[~,T]=size(X);
T=T/K;
LABELS_TEST=zeros(1,size(X,2));
%���ڼ�¼����ϵ��
kapa=zeros(K+2,K+2);
for i=1:K+1
    if(i~=1)
        kapa(1,i)=i-1;
        kapa(i,1)=i-1;
    end
end
prog=zeros(T,K);
%result=zeros(T,K);
for i=1:K
    for k1=1:K
        %�����̶����ò���ȥƥ��
        prog(:,k1) = Gauss_pdf(X(:,(i-1)*T+1:i*T),Mu(:,k1),Sigma(:,:,k1));
        %F1 = prog(:,k1)*W(k1);
        %result(:,k1)=log(F1);
    end
    result=log(prog.*repmat(W(i,:),T,1));
    for t=1:T
        maxnum=max(result(t,:));
        if(size(find(result(t,:)==maxnum),2)>1)
            LABELS_TEST((i-1)*T+t)=0;
            continue;
        end
        LABELS_TEST((i-1)*T+t)=find(result(t,:)==maxnum);
    end
end
for m=2:K+1
    for j=1:K
        temp=find(LABELS_TEST((m-2)*T+1:(m-1)*T)==j);
        kapa(j+1,m)=size(temp,2);
    end
end
for j=2:K+1
    kapa(K+2,j)=sum(kapa(2:K+1,j));
    kapa(j,K+2)=sum(kapa(j,2:K+1));
end
kapa(K+2,K+2)=sum(kapa(K+2,:));

%��ʵ���
label_real = [];
for i = 1:K
    label_real = [label_real i*ones(1,T)];
end
compare = (label_real == LABELS_TEST);
MAP_accuracy = sum(compare)/(T*K); %������ȷ��
end

