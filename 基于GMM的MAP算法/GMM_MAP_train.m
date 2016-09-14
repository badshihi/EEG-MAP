function [loglik_all,Pix_all,W,Mu,Sigma ] = GMM_MAP_train( X,K,a)
%UNTITLED �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
%   ������������ѵ��
%   W���ý��и��£�SigmaҲ���ý��и���
%   ���µ�ֻ��Mu
%   W���ص���1*K(����K�Ƿ��������)
%   Mu���ص���D*K(����D������X��ά��)
%   Sigma���ص���D*D*K
%   [ BASE, X ] = PCA_TRAIN(trainData, threshold);
%   X=X';
    [~,T]=size(X);
    T=T/K;
    threshold = 0.0001;%��������ֹ�ź�
    [W,Mu,Sigma]=GMM_MAP_init(X,K);%��ʼ��W,Mu,Sigma
    N1=zeros(T,K);
    N2=zeros(T,K);
    loglik=zeros(1,K);
    for k=1:K
        loglik_old = -realmax;
        i=1;
        while(true)
            for k1=1:K
                 N1(:,k1)=Gauss_pdf_all(X(:,(k-1)*T+1:k*T),Mu(:,k1),Sigma(:,:,k1));
            end
            Pix_tem=repmat(W(k,:),T,1).*N1;
            Pix=Pix_tem./repmat(sum(Pix_tem,2),1,K);
            Pix_all{k,i}=Pix;
            i=i+1;
            E=sum(Pix,1);
            %����W
            W(k,:)=E./sum(E);
            %����Mu
            Mu(:,k)=Mu(:,k)*a+(1-a)*X(:,(k-1)*T+1:k*T)*Pix(:,k) / E(k);%����a����[0��1]
            %����Sigma��ֻ���¶Խ����ϵ����֣�����ֹ���ϣ�
            %Data_tmp1 = X(:,(k-1)*T+1:k*T) - repmat(Mu(:,k),1,T);
            %Sigma(:,:,k) = diag(sum((repmat(Pix(:,k)',D, 1) .* Data_tmp1*Data_tmp1') / E(k)));
            %���¾���������
            for k2=1:K
                 N2(:,k2) = Gauss_pdf_all(X(:,(k-1)*T+1:k*T), Mu(:,k2), Sigma(:,:,k2));
            end
            %Compute the log likelihood
            F = repmat(W(k,:),T,1).*N2;
            for t=1:T
                if(F(t)<realmin)
                   F(t) = realmin;
                end
            end
            loglik(k)=sum(log(sum(F,2)));
            %��¼������ʵĴ�С
            loglik_all{k,i}=loglik(k);
            if abs(loglik(k)-loglik_old)<threshold
                break;
            else
                loglik_old=loglik(k);
            end
        end
    end
end

