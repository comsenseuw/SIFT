% [image, descriptors, locs] = sift(imageFile)
%
% Fungsi ini membaca gambar dan mengembalikan titik kunci SIFT-nya.
%   Input parameters:
%     imageFile: nama file untuk gambar.
%
%   Returned:
%     image: array gambar dalam format double
%     descriptors: matriks K-by-128, di mana setiap baris memberikan invarian
%         deskriptor untuk salah satu keypoint K. Deskriptornya adalah vektor
%         dari 128 nilai dinormalisasi ke satuan panjang.
%     locs: Matriks K-by-4, di mana setiap baris memiliki 4 nilai untuk
%           sebuah lokasi keypoint (baris, kolom, skala, orientasi).  
%         orientasinya dalam kisaran [-PI, PI] radian.
%
% Credits: Thanks for initial version of this program to D. Alvaro and 
%          J.J. Guerrero, Universidad de Zaragoza (modified by D. Lowe)

function [image, descriptors, locs] = sift(imageFile)

% Muat gambar
image = imread(imageFile);

% Jika Anda memiliki Kotak Alat Pemrosesan Gambar, Anda dapat menghapus komentar berikut
%   baris untuk memungkinkan input gambar berwarna, yang akan diubah menjadi skala abu-abu.
if ndims(image)==3
    image = rgb2gray(image);
end

[rows, cols] = size(image); 

% Konversikan ke file gambar PGM, dapat dibaca oleh "titik kunci" yang dapat dieksekusi
f = fopen('tmp.pgm', 'w');
if f == -1
    error('Could not create file tmp.pgm.');
end
fprintf(f, 'P5\n%d\n%d\n255\n', cols, rows);
fwrite(f, image', 'uint8');
fclose(f);

% Panggil keypoint exe
if isunix
    command = '!./sift ';
else
    command = '!siftWin32 ';
end
command = [command ' <tmp.pgm >tmp.key'];
eval(command);

% Buka tmp.key dan periksa headernya
g = fopen('tmp.key', 'r');
if g == -1
    error('Could not open file tmp.key.');
end
[header, count] = fscanf(g, '%d %d', [1 2]);
if count ~= 2
    error('Invalid keypoint file beginning.');
end
num = header(1);
len = header(2);
if len ~= 128
    error('Keypoint descriptor length invalid (should be 128).');
end

% Membuat dua matriks keluaran (gunakan ukuran yang diketahui untuk efisiensi)
locs = double(zeros(num, 4));
descriptors = double(zeros(num, 128));

% Mengurai tmp.key
for i = 1:num
    [vector, count] = fscanf(g, '%f %f %f %f', [1 4]); %row col scale ori
    if count ~= 4
        error('Invalid keypoint file format');
    end
    locs(i, :) = vector(1, :);
    
    [descrip, count] = fscanf(g, '%d', [1 len]);
    if (count ~= 128)
        error('Invalid keypoint file value.');
    end
    % Normalisasikan setiap vektor input ke satuan panjang
    descrip = descrip / sqrt(sum(descrip.^2));
    descriptors(i, :) = descrip(1, :);
end
fclose(g);


