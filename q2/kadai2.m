% レポート課題2の学習とリランキングを行う
% createdcnnでdcnnf.matに保存した学習データtrainと分類データevalを用いる
% trainを線形SVMで学習し、リランキングを行う
% その結果を用いてソートし、画像URLとポジティブサンプル距離をファイルに出力する

% 学習用DCNN特徴と分類用DCNN特徴、ng(ネガティブ画像の枚数)、nlおよびnsを読み込む
% 学習用DCNN特徴は、n=50（nl）のときtrain50、n=25（ns）のときtrain25。
load('dcnnf.mat'); 

% 学習用データを用いて、分類用のデータを分類
% 学習データのラベル付け、trainの使用する部分のみ抽出
train_label50=[ones(nl,1); ones(ng,1)*(-1)];
train_label25=[ones(ns,1); ones(ng,1)*(-1)];

model50 = fitcsvm(train50, train_label50,'KernelFunction','linear');
[predicted_label, scores] = predict(model50, eval);

model25 = fitcsvm(train25, train_label25,'KernelFunction','linear');
[predicted_label2, scores2] = predict(model25, eval);

% ポジティブの値が大きい順にソートする
[sorted_score,sorted_idx] = sort(scores(:,2),'descend');
[sorted_score2,sorted_idx2] = sort(scores2(:,2),'descend');

% listに分類画像のurlを入れる
list=textread('unadoneval.txt','%s');

% ファイルに出力
% n=50のデータでリランキングを行った結果をテキストファイルに出力
FID = fopen('exp50.txt','w');
for i=1:numel(sorted_idx)
	fprintf(FID,'%s %.5f\n',list{sorted_idx(i)},sorted_score(i));
end
fclose(FID);
% n=25のデータでリランキングを行った結果をテキストファイルに出力
FID = fopen('exp25.txt','w');
for i=1:numel(sorted_idx2)
	fprintf(FID,'%s %.5f\n',list{sorted_idx2(i)},sorted_score2(i));
end
fclose(FID);

