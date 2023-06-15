% レポート課題2のDCNN特徴量の導出を行う
% 学習用とリランキング用のリストを作成する
% alexnetを用いてDCNN特徴量を抽出する

l=0;
train_list={}; % 学習用データのリスト
eval_list={};  % 分類（リランキング）用データのリスト
nl=50; % n = 25or50 の大きい方
ns=25; % nの小さい方
ng=1000; % ネガティブ用の画像の個数
LIST={'unadonlearn' 'bgimg' 'unadoneval'};
DIR0='./';
% 学習用リストtrain_listとリランキング用リストeval_listの作成
for i=1:length(LIST)
	DIR=strcat(DIR0,LIST(i),'/');
	W=dir(DIR{:});
	for j=1:size(W)
		if (strfind(W(j).name,'.jpg'))
			fn=strcat(DIR{:},W(j).name);
			l=l+1;
			% LIST(i)='unadonlearn'かつl<=nlならば、ポジティブ用画像のディレクトリをtrain_listに入れる
			% LIST(i)='bgimg'かつnl<l<=nl+ngならば、ネガティブ画像のディレクトリをtrain_listに入れる
			% LIST(i)='unadoneval'ならば、eval_listにリランキング用の画像のディレクトリを入れる
			if strcmp(LIST(i),'unadonlearn')==1 && l<=nl 
				train_list={train_list{:} fn};
			elseif strcmp(LIST(i),'bgimg')==1 && l<=nl+ng 
				train_list={train_list{:} fn};
			elseif strcmp(LIST(i),'unadoneval')==1 
				fn=strcat(DIR{:},W(j).name);
				eval_list={eval_list{:} fn};
			end
		end
	end
end

net = alexnet; %alexnet を使用
fc = 'fc7';
% 学習データのDCNN特徴量の行列作成
IM=[]; IM1=[];
for j=1:size(train_list,2)
    img = imread(train_list{j});
    reimg = imresize(img,net.Layers(1).InputSize(1:2));
    IM=cat(4,IM,reimg);
    % 25<j<=50 の画像はn=25のとき不要のため、除外
    if ns< j && j <= nl
    else
        IM1=cat(4,IM1,reimg);
    end
end
dcnnf = activations(net,IM,fc);
dcnnf = squeeze(dcnnf).';        % 行列(ベクトル)化と、転置
train50 = normalize(dcnnf,'norm'); % L2ノルム正規化、n=50用
dcnnf = activations(net,IM1,fc);
dcnnf = squeeze(dcnnf).';        % 行列(ベクトル)化と、転置
train25 = normalize(dcnnf,'norm'); % L2ノルム正規化、n=25用

% 分類データのDCNN特徴量の行列作成
IM=[];
for j=1:size(eval_list,2)
	img = imread(eval_list{j});
	reimg = imresize(img,net.Layers(1).InputSize(1:2));
	IM=cat(4,IM,reimg);
end
dcnnf = activations(net,IM,fc);
dcnnf = squeeze(dcnnf).';       % 行列(ベクトル)化と、転置
eval = normalize(dcnnf,'norm'); % L2ノルム正規化

% dcnnf.matにtrain50とtrain25, eval, ng, nl, nsを保存する
save('dcnnf.mat', 'train50', 'train25', 'eval', 'ng', 'nl', 'ns');
