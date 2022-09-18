% num = match(image1, image2)
%
% Fungsi ini membaca dua gambar, menemukan fitur SIFT-nya, dan
%   menampilkan garis yang menghubungkan titik kunci yang cocok. Pencocokan diterima
%   hanya jika jaraknya kurang dari distRatio kali jarak ke
%   pencocokan terdekat kedua.
% Ini mengembalikan jumlah kecocokan yang ditampilkan.
%
% Contoh: match('scene.pgm','book.pgm');

function num = match(image1, image2)
tic
% Temukan titik kunci SIFT untuk setiap gambar
[im1, des1, loc1] = sift(image1);
[im2, des2, loc2] = sift(image2);

% Untuk efisiensi di Matlab, lebih murah untuk menghitung dot produk antara
%  vektor satuan daripada jarak Euclidean. Perhatikan bahwa rasio
%  sudut (acos perkalian titik vektor satuan) adalah pendekatan yang dekat
%  dengan rasio jarak Euclidean untuk sudut kecil.
%
% distRatio: Hanya pertahankan kecocokan di mana rasio sudut vektor dari
%   terdekat ke tetangga terdekat kedua kurang dari distRatio.
distRatio = 0.6;   

% Untuk setiap deskriptor pada gambar pertama, pilih kecocokannya dengan gambar kedua.
des2t = des2';                          % Transpos matriks prakomputasi
for i = 1 : size(des1,1)
   dotprods = des1(i,:) * des2t;        % Menghitung vektor dot produk
   [vals,indx] = sort(acos(dotprods));  % Ambil invers cosinus dan urutkan hasilnya

   % Periksa apakah tetangga terdekat memiliki sudut kurang dari distRatio kali ke-2.
   if (vals(1) < distRatio * vals(2))
      match(i) = indx(1);
   else
      match(i) = 0;
   end
end

% Buat gambar baru yang menunjukkan dua gambar berdampingan.
im3 = appendimages(im1,im2);

% Perlihatkan gambar dengan garis yang menghubungkan kecocokan yang diterima.
figure('position', [10 -10 size(im3,2) size(im3,1)]);
colormap('gray');
imagesc(im3);
hold on;
cols1 = size(im1,2);
for i = 1: size(des1,1)
  if (match(i) > 0)
    line([loc1(i,2) loc2(match(i),2)+cols1], ...
         [loc1(i,1) loc2(match(i),1)], 'Color', 'c');
  end
end
hold off;
num = sum(match > 0);
fprintf('Found %d matches.\n', num);
toc



