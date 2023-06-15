% 画像の読み込みを行うmファイル

list=textread('unadonlearn.txt','%s');
%list=textread('unadoneval.txt','%s');
% テキストファイルの読み取り、上から適宜選ぶ。

OUTDIR='unadonlearn';
%OUTDIR='unadoneval';
% 画像のディレクトリを設定、ファイル名と対応している物を選択

mkdir(OUTDIR);
for i=1:size(list,1)
	fname=strcat(OUTDIR,'/',num2str(i,'%04d'),'.jpg')
	websave(fname,list{i});
end
% 画像を保存
