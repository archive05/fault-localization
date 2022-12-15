clc
clear all


P = 'F:\Extracted Feature\';
S = dir(fullfile(P,'*.txt')); 
for k = 1:numel(S)
    F = fullfile(P,S(k).name);
    S(k).data = readtable(F);
end

for file=1:numel(S)
    file
    clearvars -except S RankingInit file P
    
    a1 = S(file).name;
    a = strcat(P,a1);
    T = S(file).data;
    Total = length(T.Var1);
    NCS = T.Var2;
    NCF = T.Var3;
    NUS = T.Var4;
    NUF = T.Var5;
    L = T.Var6;
    index = [];
    for j = 1: Total
        Score(j,1) = (((NCF(j))^2)/((NUF(j)+NCS(j))));
    end
    T.Score = Score;
    T3 = sortrows(T,"Score", 'descend');
    
    dataFault = readcell(a);
    for i = 1:dataFault{1,1}
        FaultName{:,i}= [dataFault{i+1,1}];
        FaultNum1{:,i} = dataFault{i+1,2};
        FaultNum2{:,i} = erase(FaultNum1{:,i}," T");
        FaultNum{:,i} = erase(FaultNum2{:,i}," F");
        FaultLine{:,i} = append(string(FaultName{:,i}),"#",string(FaultNum{:,i}));
        
          if ismember(string(FaultLine{1,i}),T3.Var1) == 0
                        Idx  = str2num(FaultNum{1,i}) +1; 
                        FaultLine{1,i} = append(string(FaultName{1,i}),"#",string(Idx));
                if ismember(string(FaultLine{1,i}),T3.Var1) == 0
                        Idx  = str2num(FaultNum{1,i})-1; 
                        FaultLine{1,i} = append(string(FaultName{1,i}),"#",string(Idx));
                    if ismember(string(FaultLine{1,i}),T3.Var1) == 0
                        continue
                    else
                        index(1,i) = find(T3.Var1==string(FaultLine{1,i}));
                    end
                else
                        index(1,i) = find(T3.Var1==string(FaultLine{1,i}));
                end
        else
            index(1,i) = find(T3.Var1==string(FaultLine{1,i}));
        end  
    
    end
    if isempty(index) == 1
        RankingInit(file,1)=string('There is a problem in Dataset');
    else
        maxindex = max(index);
        RankingInit(file,1) = maxindex/Total;
    end
end
Ranking = rmmissing(RankingInit);