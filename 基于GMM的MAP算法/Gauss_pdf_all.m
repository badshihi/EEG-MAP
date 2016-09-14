function prog = Gauss_pdf_all( X,Mu,Sigma)
% ������Ϊ�˲���ʹ��,����������ļ���,���ǵ�����һ����������
% ���㹫ʽ��N(x|Mu,Sigma) = 1/((2pi)^(D/2))*(1/(abs(sigma))^0.5)*exp(-1/2*(x-Mu)'Sigma^(-1)*(x-Mu))
[D,T]=size(X);
%prog �Ǹ�˹�ܶȺ���
Xshift=X'-repmat(Mu',T,1);
inv_Sigma=inv(Sigma);
tmp=sum((Xshift*inv_Sigma).*Xshift,2);
coef=(2*pi)^(-D/2)*sqrt(abs(det(inv_Sigma)+realmin));%ά�ȵĴ�СӦ�ò���̫��
prog=coef*exp(-0.5*tmp);

end

