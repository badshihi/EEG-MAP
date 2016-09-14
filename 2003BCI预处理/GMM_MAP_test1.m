function [LABELS_TEST]  = GMM_MAP_test1(X,Mu,Sigma,K)
%UNTITLED �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
% ͬһ���˲���10��
%1.����������Ĳ������ݵ���,���������ǻ��ҵ�
%2.��ÿ�����ݴ���4��ģ���м����˹�ܶ�
%3.ѡ�������Ǹ���Ϊ��������Ӧ�ı�ǩ
%4.������ǩ����ȷ��ǩ���бȽ�
    LABELS_TEST=zeros(1,size(X,2));
    for i=1:size(X,2)
        for k=1:K
            prog(k) = Gauss_pdf2(X(:,i),Mu(:,k),Sigma(:,:,k));
        end
        maxnum=max(prog);
        if(size(find(prog==maxnum),2)>1)
            LABELS_TEST(i)=0;
            continue;
        end
        LABELS_TEST(i)=find(prog==maxnum);
    end
end

