function [label_real,trainData,testData ] = getsource2( PLVall,K,T,Tr,Te)
    %���ѵ������
    nk = 0;
    for i = 1:K
        temp = randperm(T);
        %��ȡѵ������
        for j = 1:Tr
            b = PLVall(:,(i-1)*T+temp(j));
            nk = nk + 1;
            trainData(:,nk) = b;
        end
    end
    %�õ��������ݺ���ʵ��ǩ
    
end

