% 2012.05.30    LWC
% ������ȡ����
[s, h] = sload('D:\matlabWorkspace\BFN\data\BCICIV_2a_gdf\ori\A01T.gdf');

typ_r = size(h.EVENT.TYP,1); %����

trials.count = 0 ;
trials.label = [];
trials.data = [];

for i = 1:typ_r
    if(h.EVENT.TYP(i,1)>768 && h.EVENT.TYP(i,1)<773)
        
        trials.count = trials.count + 1;
        
        if(h.ArtifactSelection(trials.count)==0)
            
            h.ArtifactSelection(trials.count)
            
            rows = size(trials.data,1);
            trials.data(rows+1:rows+h.EVENT.DUR(i),1:22) = s(h.EVENT.POS(i):h.EVENT.POS(i)+h.EVENT.DUR(i)-1,1:22);
            trials.data(rows+1:rows+h.EVENT.DUR(i),23) = (h.EVENT.TYP(i,1)-768)*ones(h.EVENT.DUR(i),1);
            trials.label(trials.count) = h.EVENT.TYP(i,1)-768;
            
            trials.ArtifactSelection(trials.count) = h.ArtifactSelection(trials.count); %�����ų�Artifact;
            
        end % of if(h.ArtifactSelection(trials.count + 1) == 0)
    end % of if(h.EVENT.TYP(i,1)>768 && h.EVENT.TYP(i,1)<773)
    
end % of for i = 1:typ_r

trials.label = trials.label';
% trials.ArtifactSelection = h.ArtifactSelection; %�����ų�Artifact;
% trials.Classlabel = h.Classlabel; %���ڼ���trial�������Ƿ���ȷ��


%2012.06.23 ����1023��ǵ�trial��ArtifactSelection��ǵ�trial�Ƿ�һ��
% �����9�������߲��Զ���һ��
index = find(trials.rejected == 1 )
if(trials.rejected==trials.ArtifactSelection)
    disp 1;
end



if(trials.rejected==trials.fixed)
    disp 1;
end
















