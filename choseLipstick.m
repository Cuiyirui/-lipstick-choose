%%
clear;close all;clc
%% 读取女朋友的照片
imName = input('请输入一张女朋友的照片：');
I = imread(imName);
figure,imshow(I);
patch = imcrop(I);
newPatch = imresize(patch,[256,256]);

%% 遍历口红色,构造结构体
jsonData = loadjson('lipstick.json');
brand_nums = length(jsonData.brands);
count = 0;
for i = 1:brand_nums
    brand =  jsonData.brands{i};
    brand_name = brand.name;
    series_num = length(brand.series);
    for j = 1:series_num
        serie = brand.series{j};
        serie_name = serie.name;
        lipsticks_num = length(serie.lipsticks);
        for k = 1:lipsticks_num
            lipstick = serie.lipsticks{k};
            lipstick_name = lipstick.name;
            name = strcat(brand_name,':',serie_name,':',lipstick_name);
            count=count+1;
            allLips(uint64(count)).name = name;
            allLips(uint64(count)).color = lipstick.color;
            allLips(uint64(count)).sample = transHex2im(lipstick.color);
            
        end
        
    end
end
disp(count);
%% 结构体找最相似的色号
allLips_num = length(allLips);
for i=1:allLips_num
    diff(i)=immse(newPatch,allLips(i).sample);
end
% 最小的下标并显示
[minValue,minIdx] = min(diff);
compareRes = uint8(zeros(256,512,3));
bestRes = allLips(minIdx).sample;
bestName = allLips(minIdx).name;
subplot(1,2,1);
imshow(newPatch);
title('女朋友的唇色');


subplot(1,2,2);
imshow(bestRes);
subtitle = strcat('最佳匹配：',bestName);
title(subtitle);



%% 色号转化成图片
function [im] = transHex2im(color)
r = hex2dec(color(2:3));
g = hex2dec(color(4:5));
b = hex2dec(color(6:7));
rIm = uint8(ones(256)*r);
gIm = uint8(ones(256)*g);
bIm = uint8(ones(256)*b);
im = cat(3,rIm,gIm,bIm);
end

%%
